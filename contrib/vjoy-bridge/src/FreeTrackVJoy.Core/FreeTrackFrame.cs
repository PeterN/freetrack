using System;
using System.Runtime.InteropServices;

namespace FreeTrackVJoy.Core
{
    /// <summary>
    /// Mirror of FreeTrack 2.2's TFreeTrackData (FreetrackClient/FTTypes.pas).
    /// It is a Delphi "packed record": 1 x Cardinal, 2 x Integer, 20 x Single, no padding (92 bytes).
    /// Angles are in radians. Yaw: positive = left. Pitch: positive = up.
    /// </summary>
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct FreeTrackFrame
    {
        public uint DataId;
        public int CamWidth;
        public int CamHeight;
        // Pose after FreeTrack's own smoothing, sensitivity and curves.
        public float Yaw;
        public float Pitch;
        public float Roll;
        public float X;
        public float Y;
        public float Z;
        // Raw pose (no curves). Not used for output: we keep the user's FreeTrack curves.
        public float RawYaw;
        public float RawPitch;
        public float RawRoll;
        public float RawX;
        public float RawY;
        public float RawZ;
        public float X1, Y1, X2, Y2, X3, Y3, X4, Y4;

        /// <summary>Size of the record in bytes (must be 92).</summary>
        public static readonly int Size = Marshal.SizeOf<FreeTrackFrame>();

        /// <summary>Shared memory name used by FreeTrack 2.2.</summary>
        public const string SharedMemoryName = "FT_SharedMem";

        /// <summary>Mutex name used by FreeTrack 2.2. The typo "Mutext" is FreeTrack's own.</summary>
        public const string MutexName = "FT_Mutext";

        /// <summary>Reads one frame from a little-endian byte buffer (the start of FT_SharedMem).</summary>
        public static FreeTrackFrame FromBytes(ReadOnlySpan<byte> bytes)
        {
            if (bytes.Length < Size)
                throw new ArgumentException($"Need at least {Size} bytes, got {bytes.Length}.", nameof(bytes));
            return MemoryMarshal.Read<FreeTrackFrame>(bytes);
        }
    }
}
