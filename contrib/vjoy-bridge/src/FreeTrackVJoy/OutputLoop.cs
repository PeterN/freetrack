using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Threading;
using FreeTrackVJoy.Core;

namespace FreeTrackVJoy
{
    /// <summary>Background thread: FreeTrack shared memory -> vJoy. Kept off the UI thread so the tray never stalls it.</summary>
    internal sealed class OutputLoop : IDisposable
    {
        private readonly BridgeSettings _settings;
        private Thread? _thread;
        private volatile bool _running;
        private volatile string _status = "Stopped";
        private bool _acquired;

        public string Status => _status;
        public bool Running => _running;

        public OutputLoop(BridgeSettings settings) => _settings = settings;

        /// <summary>Start sending. Returns an error message for the user, or null on success.</summary>
        public string? Start()
        {
            if (_running) return null;
            if (_thread != null && _thread.IsAlive) return "Still stopping - try again in a moment.";
            string? error = TryAcquire();
            if (error != null) { _status = error; return error; }
            _acquired = true;
            _running = true;
            _thread = new Thread(Run) { IsBackground = true, Name = "FreeTrack->vJoy", Priority = ThreadPriority.AboveNormal };
            _thread.Start();
            return null;
        }

        private string? TryAcquire()
        {
            uint id = _settings.DeviceId;
            try
            {
                if (!VJoyNative.vJoyEnabled())
                    return "vJoy is not installed or not enabled. Install vJoy, then run \"Configure vJoy\".";
                var stat = VJoyNative.GetVJDStatus(id);
                if (stat == VJoyNative.VjdStat.Missing)
                    return $"vJoy device {id} does not exist. Open \"Configure vJoy\" and add device {id}.";
                if (stat == VJoyNative.VjdStat.Busy)
                    return $"vJoy device {id} is being used by another program. Close it, or pick another device in settings.json.";
                if (!VJoyNative.GetVJDAxisExist(id, VJoyNative.HID_USAGE_X) || !VJoyNative.GetVJDAxisExist(id, VJoyNative.HID_USAGE_Y))
                    return $"vJoy device {id} needs the X and Y axes turned on. Open \"Configure vJoy\", tick X and Y, click Apply.";
                if (stat != VJoyNative.VjdStat.Own && !VJoyNative.AcquireVJD(id))
                    return $"Could not take control of vJoy device {id}.";
            }
            catch (DllNotFoundException)
            {
                return "Could not find vJoyInterface.dll. Please install vJoy (see README).";
            }
            catch (EntryPointNotFoundException)
            {
                return "The vJoy DLL found is not compatible. Reinstall vJoy (see README).";
            }
            return null;
        }

        /// <summary>Stop sending, centre the axes and release the device.</summary>
        public void Stop()
        {
            _running = false;
            if (_thread != null && Thread.CurrentThread != _thread && _thread.Join(3000))
                _thread = null; // if it did not finish, Start() refuses until it has
            if (_acquired)
            {
                uint id = _settings.DeviceId;
                try
                {
                    VJoyNative.SetAxis(AxisMapper.VJoyCenter, id, VJoyNative.HID_USAGE_X);
                    VJoyNative.SetAxis(AxisMapper.VJoyCenter, id, VJoyNative.HID_USAGE_Y);
                    VJoyNative.RelinquishVJD(id);
                }
                catch (Exception) { /* driver gone; nothing left to release */ }
                _acquired = false;
            }
            _status = "Stopped";
        }

        private void Run()
        {
            uint id = _settings.DeviceId;
            var logic = new BridgeLogic(
                new AxisMapper(_settings.YawFullScaleDegrees, _settings.InvertYaw),
                new AxisMapper(_settings.PitchFullScaleDegrees, _settings.InvertPitch),
                TimeSpan.FromMilliseconds(_settings.StaleAfterMs),
                TimeSpan.FromMilliseconds(_settings.ReturnToCentreAfterMs));
            var clock = Stopwatch.StartNew();
            int failures = 0;

            timeBeginPeriod(1); // lets Sleep(1-2 ms) actually sleep that short on Windows
            try
            {
                using var reader = new FreeTrackReader();
                // Start centred so the car doesn't steer before FreeTrack sends anything.
                VJoyNative.SetAxis(AxisMapper.VJoyCenter, id, VJoyNative.HID_USAGE_X);
                VJoyNative.SetAxis(AxisMapper.VJoyCenter, id, VJoyNative.HID_USAGE_Y);

                while (_running)
                {
                    if (reader.TryRead(out var frame) && logic.Update(frame, clock.Elapsed))
                    {
                        bool ok = VJoyNative.SetAxis(logic.AxisX, id, VJoyNative.HID_USAGE_X)
                                & VJoyNative.SetAxis(logic.AxisY, id, VJoyNative.HID_USAGE_Y);
                        if (!ok && ++failures >= 500)
                        {
                            // Lost the device (e.g. another program grabbed it, or vJoy was reconfigured).
                            _status = "vJoy stopped accepting input - try Start output again";
                            _running = false;
                            break;
                        }
                        if (ok) failures = 0;
                    }

                    _status = !reader.IsOpen ? "Waiting for FreeTrack (click Start in FreeTrack)"
                        : logic.State switch
                        {
                            BridgeState.Tracking => "Sending head movement to vJoy",
                            BridgeState.Holding => "No new tracking data - holding last position",
                            BridgeState.ReturningToCentre => "No tracking data for a while - returning to centre",
                            _ => "Waiting for FreeTrack to start tracking",
                        };

                    Thread.Sleep(_settings.PollIntervalMs);
                }
            }
            catch (Exception e)
            {
                _status = "Stopped after an error: " + e.Message;
                _running = false;
            }
            finally
            {
                // However the loop ends (stop button, error, lost device), never leave the car steering.
                try
                {
                    VJoyNative.SetAxis(AxisMapper.VJoyCenter, id, VJoyNative.HID_USAGE_X);
                    VJoyNative.SetAxis(AxisMapper.VJoyCenter, id, VJoyNative.HID_USAGE_Y);
                }
                catch (Exception) { }
                timeEndPeriod(1);
            }
        }

        public void Dispose() => Stop();

        [DllImport("winmm.dll")] private static extern uint timeBeginPeriod(uint ms);
        [DllImport("winmm.dll")] private static extern uint timeEndPeriod(uint ms);
    }
}
