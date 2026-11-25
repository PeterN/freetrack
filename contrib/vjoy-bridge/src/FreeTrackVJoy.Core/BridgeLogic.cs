using System;

namespace FreeTrackVJoy.Core
{
    public enum BridgeState
    {
        /// <summary>No frame seen yet (FreeTrack not started, or not tracking).</summary>
        WaitingForData,
        /// <summary>New frames arriving; axes follow the head.</summary>
        Tracking,
        /// <summary>Frames stopped arriving; axes hold the last good position.</summary>
        Holding,
        /// <summary>Frames stopped for a long time; axes glide back to centre (only if enabled).</summary>
        ReturningToCentre,
    }

    /// <summary>
    /// Platform-free part of the bridge, so it can be unit tested on any OS.
    /// Feed it each frame read from shared memory; it tells you what to send to vJoy.
    /// </summary>
    public sealed class BridgeLogic
    {
        private readonly AxisMapper _yaw;
        private readonly AxisMapper _pitch;
        private readonly TimeSpan _staleAfter;
        private readonly TimeSpan _returnAfter; // Zero = hold forever
        private const double ReturnUnitsPerSecond = AxisMapper.VJoyCenter; // half travel per second: gentle, not a snap

        private uint? _lastDataId;
        private TimeSpan _lastChange;
        private TimeSpan _lastTick;

        public BridgeState State { get; private set; } = BridgeState.WaitingForData;
        public int AxisX { get; private set; } = AxisMapper.VJoyCenter;
        public int AxisY { get; private set; } = AxisMapper.VJoyCenter;

        public BridgeLogic(AxisMapper yaw, AxisMapper pitch, TimeSpan staleAfter, TimeSpan returnToCentreAfter = default)
        {
            _yaw = yaw ?? throw new ArgumentNullException(nameof(yaw));
            _pitch = pitch ?? throw new ArgumentNullException(nameof(pitch));
            if (staleAfter <= TimeSpan.Zero) throw new ArgumentOutOfRangeException(nameof(staleAfter));
            if (returnToCentreAfter < TimeSpan.Zero) throw new ArgumentOutOfRangeException(nameof(returnToCentreAfter));
            _staleAfter = staleAfter;
            _returnAfter = returnToCentreAfter;
        }

        /// <summary>
        /// Process one frame. <paramref name="now"/> is a monotonic clock (e.g. Stopwatch.Elapsed).
        /// Returns true when the axis values changed and should be sent to vJoy.
        /// </summary>
        public bool Update(FreeTrackFrame frame, TimeSpan now)
        {
            TimeSpan dt = now - _lastTick;
            _lastTick = now;

            // FreeTrack bumps DataID every new camera frame. Same ID = no new data.
            if (_lastDataId == frame.DataId)
                return Idle(now, dt);

            // First ever read: remember the ID but don't treat leftover memory as live data.
            if (_lastDataId is null)
            {
                _lastDataId = frame.DataId;
                _lastChange = now;
                return false;
            }

            _lastDataId = frame.DataId;
            _lastChange = now;
            State = BridgeState.Tracking;

            // FreeTrack: positive yaw = head turned LEFT, positive pitch = head UP.
            // Joystick: low X = left, low Y = up/forward. So both are negated to feel natural.
            int x = _yaw.Map(-frame.Yaw);
            int y = _pitch.Map(-frame.Pitch);
            return Set(x, y);
        }

        private bool Idle(TimeSpan now, TimeSpan dt)
        {
            if (State == BridgeState.WaitingForData) return false;
            TimeSpan quiet = now - _lastChange;

            if (State == BridgeState.Tracking && quiet > _staleAfter)
                State = BridgeState.Holding; // keep last position, do not snap to centre

            if (_returnAfter > TimeSpan.Zero && quiet > _returnAfter && State != BridgeState.Tracking)
            {
                State = BridgeState.ReturningToCentre;
                int step = Math.Max(1, (int)(ReturnUnitsPerSecond * Math.Max(0, dt.TotalSeconds)));
                return Set(Toward(AxisX, step), Toward(AxisY, step));
            }
            return false;
        }

        private static int Toward(int value, int step)
        {
            int c = AxisMapper.VJoyCenter;
            if (value > c) return Math.Max(c, value - step);
            if (value < c) return Math.Min(c, value + step);
            return c;
        }

        private bool Set(int x, int y)
        {
            bool changed = x != AxisX || y != AxisY;
            AxisX = x;
            AxisY = y;
            return changed;
        }
    }
}
