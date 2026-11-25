using System;

namespace FreeTrackVJoy.Core
{
    /// <summary>
    /// Turns a FreeTrack angle (radians) into a vJoy axis value.
    /// vJoy axes go from 1 (0x0001) to 32768 (0x8000); the centre is 16384 (0x4000).
    /// </summary>
    public sealed class AxisMapper
    {
        public const int VJoyMin = 0x0001;
        public const int VJoyMax = 0x8000;
        public const int VJoyCenter = 0x4000;

        /// <summary>Head angle, in degrees, that gives full axis deflection. Must be &gt; 0.</summary>
        public double FullScaleDegrees { get; }

        /// <summary>Flip the direction of the axis.</summary>
        public bool Invert { get; }

        public AxisMapper(double fullScaleDegrees, bool invert = false)
        {
            if (!(fullScaleDegrees > 0) || double.IsInfinity(fullScaleDegrees))
                throw new ArgumentOutOfRangeException(nameof(fullScaleDegrees), "Must be a positive number.");
            FullScaleDegrees = fullScaleDegrees;
            Invert = invert;
        }

        /// <summary>
        /// Maps an angle in radians to a vJoy value. Always returns a value inside [VJoyMin, VJoyMax].
        /// NaN or infinite input returns the centre, so a bad frame can never jam the axis at full lock.
        /// </summary>
        public int Map(float radians)
        {
            if (float.IsNaN(radians) || float.IsInfinity(radians))
                return VJoyCenter;

            double degrees = radians * (180.0 / Math.PI);
            double normalized = degrees / FullScaleDegrees; // -1 .. 1 inside the useful range
            if (Invert) normalized = -normalized;
            if (normalized > 1) normalized = 1;
            if (normalized < -1) normalized = -1;

            // -1 -> VJoyMin, 0 -> VJoyCenter, +1 -> VJoyMax
            double value = normalized >= 0
                ? VJoyCenter + normalized * (VJoyMax - VJoyCenter)
                : VJoyCenter + normalized * (VJoyCenter - VJoyMin);
            return (int)Math.Round(value);
        }
    }
}
