using System;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace FreeTrackVJoy.Core
{
    /// <summary>Settings loaded from settings.json next to the exe. Bad values fall back to safe defaults and are reported.</summary>
    public sealed class BridgeSettings
    {
        /// <summary>vJoy device number (1-16).</summary>
        public uint DeviceId { get; set; } = 1;
        /// <summary>Degrees of head yaw (after FreeTrack curves) for full X axis.</summary>
        public double YawFullScaleDegrees { get; set; } = 90;
        /// <summary>Degrees of head pitch (after FreeTrack curves) for full Y axis.</summary>
        public double PitchFullScaleDegrees { get; set; } = 90;
        public bool InvertYaw { get; set; }
        public bool InvertPitch { get; set; }
        /// <summary>How often to check FreeTrack, in milliseconds (1-50).</summary>
        public int PollIntervalMs { get; set; } = 2;
        /// <summary>After this many ms with no new frame, show "holding" in the tray.</summary>
        public int StaleAfterMs { get; set; } = 250;
        /// <summary>After this many ms with no new frame, glide back to centre. 0 = hold the last position forever.</summary>
        public int ReturnToCentreAfterMs { get; set; } = 0;
        /// <summary>Path to FreeTrack.exe for the launcher. Empty = look next to this exe.</summary>
        public string FreeTrackPath { get; set; } = "";

        /// <summary>Plain-language problem with the settings file, or null if it was fine.</summary>
        [JsonIgnore]
        public string? Problem { get; private set; }

        private static readonly JsonSerializerOptions Options = new()
        {
            PropertyNameCaseInsensitive = true,
            ReadCommentHandling = JsonCommentHandling.Skip,
            AllowTrailingCommas = true,
            NumberHandling = JsonNumberHandling.AllowReadingFromString, // "DeviceId": "1" is fine too
        };

        public static BridgeSettings Parse(string? json)
        {
            var s = new BridgeSettings();
            if (!string.IsNullOrWhiteSpace(json))
            {
                try
                {
                    s = JsonSerializer.Deserialize<BridgeSettings>(json!, Options) ?? new BridgeSettings();
                }
                catch (JsonException e)
                {
                    s = new BridgeSettings();
                    s.Problem = $"settings.json could not be read (line {(e.LineNumber ?? 0) + 1}), so default settings are used. Check it in Notepad.";
                }
            }
            s.Sanitize();
            return s;
        }

        private void Sanitize()
        {
            var d = new BridgeSettings();
            string? fixedName = null;
            if (DeviceId < 1 || DeviceId > 16) { DeviceId = d.DeviceId; fixedName = nameof(DeviceId); }
            if (!(YawFullScaleDegrees > 0 && YawFullScaleDegrees <= 360)) { YawFullScaleDegrees = d.YawFullScaleDegrees; fixedName = nameof(YawFullScaleDegrees); }
            if (!(PitchFullScaleDegrees > 0 && PitchFullScaleDegrees <= 360)) { PitchFullScaleDegrees = d.PitchFullScaleDegrees; fixedName = nameof(PitchFullScaleDegrees); }
            PollIntervalMs = Math.Clamp(PollIntervalMs, 1, 50);
            StaleAfterMs = Math.Clamp(StaleAfterMs, 20, 10_000);
            ReturnToCentreAfterMs = ReturnToCentreAfterMs <= 0 ? 0 : Math.Clamp(ReturnToCentreAfterMs, 100, 60_000);
            FreeTrackPath ??= "";
            if (fixedName != null && Problem == null)
                Problem = $"settings.json: {fixedName} had a value that can't work, so the default is used for it.";
        }
    }
}
