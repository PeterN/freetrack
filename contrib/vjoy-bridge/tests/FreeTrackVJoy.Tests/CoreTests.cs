using System;
using System.Runtime.InteropServices;
using FreeTrackVJoy.Core;
using Xunit;

public class FrameTests
{
    [Fact]
    public void Layout_matches_FreeTrack_packed_record()
    {
        // 1 Cardinal + 2 Integer + 20 Single = 23 x 4 bytes
        Assert.Equal(92, FreeTrackFrame.Size);
        Assert.Equal(0, (int)Marshal.OffsetOf<FreeTrackFrame>(nameof(FreeTrackFrame.DataId)));
        Assert.Equal(12, (int)Marshal.OffsetOf<FreeTrackFrame>(nameof(FreeTrackFrame.Yaw)));
        Assert.Equal(16, (int)Marshal.OffsetOf<FreeTrackFrame>(nameof(FreeTrackFrame.Pitch)));
        Assert.Equal(36, (int)Marshal.OffsetOf<FreeTrackFrame>(nameof(FreeTrackFrame.RawYaw)));
        Assert.Equal(88, (int)Marshal.OffsetOf<FreeTrackFrame>(nameof(FreeTrackFrame.Y4)));
    }

    [Fact]
    public void FromBytes_reads_fields()
    {
        var bytes = new byte[92];
        BitConverter.GetBytes(42u).CopyTo(bytes, 0);
        BitConverter.GetBytes(0.5f).CopyTo(bytes, 12);
        BitConverter.GetBytes(-0.25f).CopyTo(bytes, 16);
        var f = FreeTrackFrame.FromBytes(bytes);
        Assert.Equal(42u, f.DataId);
        Assert.Equal(0.5f, f.Yaw);
        Assert.Equal(-0.25f, f.Pitch);
    }

    [Fact]
    public void FromBytes_rejects_short_buffer()
    {
        Assert.Throws<ArgumentException>(() => FreeTrackFrame.FromBytes(new byte[91]));
    }
}

public class AxisMapperTests
{
    private static float Deg(double d) => (float)(d * Math.PI / 180);

    [Fact]
    public void Centre_and_ends()
    {
        var m = new AxisMapper(90);
        Assert.Equal(AxisMapper.VJoyCenter, m.Map(0));
        Assert.Equal(AxisMapper.VJoyMax, m.Map(Deg(90)));
        Assert.Equal(AxisMapper.VJoyMin, m.Map(Deg(-90)));
    }

    [Fact]
    public void Clamps_past_full_scale()
    {
        var m = new AxisMapper(30);
        Assert.Equal(AxisMapper.VJoyMax, m.Map(Deg(179)));
        Assert.Equal(AxisMapper.VJoyMin, m.Map(Deg(-179)));
    }

    [Fact]
    public void Half_way_is_half_travel()
    {
        var m = new AxisMapper(90);
        Assert.InRange(m.Map(Deg(45)), 24575, 24577);
    }

    [Fact]
    public void Invert_flips()
    {
        var m = new AxisMapper(90, invert: true);
        Assert.Equal(AxisMapper.VJoyMin, m.Map(Deg(90)));
    }

    [Theory]
    [InlineData(float.NaN)]
    [InlineData(float.PositiveInfinity)]
    [InlineData(float.NegativeInfinity)]
    public void Bad_numbers_give_centre_not_full_lock(float v)
    {
        Assert.Equal(AxisMapper.VJoyCenter, new AxisMapper(90).Map(v));
    }

    [Theory]
    [InlineData(0)]
    [InlineData(-10)]
    [InlineData(double.NaN)]
    public void Rejects_bad_full_scale(double v)
    {
        Assert.Throws<ArgumentOutOfRangeException>(() => new AxisMapper(v));
    }

    [Fact]
    public void Always_in_vjoy_range()
    {
        var m = new AxisMapper(1);
        for (double d = -400; d <= 400; d += 0.37)
            Assert.InRange(m.Map(Deg(d)), AxisMapper.VJoyMin, AxisMapper.VJoyMax);
    }
}

public class BridgeLogicTests
{
    private static BridgeLogic NewLogic() =>
        new BridgeLogic(new AxisMapper(90), new AxisMapper(90), TimeSpan.FromMilliseconds(250));

    private static FreeTrackFrame Frame(uint id, double yawDeg, double pitchDeg = 0) => new FreeTrackFrame
    {
        DataId = id,
        Yaw = (float)(yawDeg * Math.PI / 180),
        Pitch = (float)(pitchDeg * Math.PI / 180),
    };

    private static TimeSpan Ms(int ms) => TimeSpan.FromMilliseconds(ms);

    [Fact]
    public void Ignores_leftover_memory_on_first_read()
    {
        var l = NewLogic();
        Assert.False(l.Update(Frame(7, 80), Ms(0)));
        Assert.Equal(AxisMapper.VJoyCenter, l.AxisX);
        Assert.Equal(BridgeState.WaitingForData, l.State);
    }

    [Fact]
    public void Follows_new_frames()
    {
        var l = NewLogic();
        l.Update(Frame(1, 0), Ms(0));
        Assert.True(l.Update(Frame(2, 90), Ms(2)));
        Assert.Equal(BridgeState.Tracking, l.State);
        // FreeTrack +yaw = head LEFT, so the stick goes fully left (low X)
        Assert.Equal(AxisMapper.VJoyMin, l.AxisX);
    }

    [Fact]
    public void Head_right_and_up_map_to_stick_right_and_up()
    {
        var l = NewLogic();
        l.Update(Frame(1, 0), Ms(0));
        l.Update(Frame(2, -90, 90), Ms(2)); // head right, head up
        Assert.Equal(AxisMapper.VJoyMax, l.AxisX);
        Assert.Equal(AxisMapper.VJoyMin, l.AxisY);
    }

    [Fact]
    public void Holds_last_position_when_data_stops_then_resumes()
    {
        var l = NewLogic();
        l.Update(Frame(1, 0), Ms(0));
        l.Update(Frame(2, 45), Ms(10));
        int held = l.AxisX;

        Assert.False(l.Update(Frame(2, 45), Ms(100)));
        Assert.Equal(BridgeState.Tracking, l.State);
        Assert.False(l.Update(Frame(2, 45), Ms(400)));
        Assert.Equal(BridgeState.Holding, l.State);
        Assert.Equal(held, l.AxisX); // not snapped to centre

        Assert.True(l.Update(Frame(3, -45), Ms(410)));
        Assert.Equal(BridgeState.Tracking, l.State);
        Assert.True(l.AxisX > AxisMapper.VJoyCenter); // -45 = head right = stick right
    }

    [Fact]
    public void DataId_wraparound_still_counts_as_new()
    {
        var l = NewLogic();
        l.Update(Frame(uint.MaxValue, 0), Ms(0));
        Assert.True(l.Update(Frame(0, 30), Ms(2)));
    }

    [Fact]
    public void Holds_forever_by_default()
    {
        var l = NewLogic();
        l.Update(Frame(1, 0), Ms(0));
        l.Update(Frame(2, 90), Ms(2));
        for (int t = 4; t < 60_000; t += 2) l.Update(Frame(2, 90), Ms(t));
        Assert.Equal(AxisMapper.VJoyMin, l.AxisX);
        Assert.Equal(BridgeState.Holding, l.State);
    }

    [Fact]
    public void Optional_return_to_centre_glides_not_snaps()
    {
        var l = new BridgeLogic(new AxisMapper(90), new AxisMapper(90), Ms(250), Ms(1000));
        l.Update(Frame(1, 0), Ms(0));
        l.Update(Frame(2, 90), Ms(2));
        int t = 2;
        for (; t < 1000; t += 2) l.Update(Frame(2, 90), Ms(t));
        Assert.Equal(AxisMapper.VJoyMin, l.AxisX); // still holding before the timeout

        int prev = l.AxisX;
        for (t += 2; t < 1100; t += 2)
        {
            l.Update(Frame(2, 90), Ms(t));
            Assert.InRange(l.AxisX - prev, 0, 100); // small steps only
            prev = l.AxisX;
        }
        Assert.Equal(BridgeState.ReturningToCentre, l.State);
        Assert.True(l.AxisX > AxisMapper.VJoyMin && l.AxisX < AxisMapper.VJoyCenter);

        for (; t < 4000; t += 2) l.Update(Frame(2, 90), Ms(t));
        Assert.Equal(AxisMapper.VJoyCenter, l.AxisX);

        // tracking comes back: follows the head immediately
        Assert.True(l.Update(Frame(3, -90), Ms(t)));
        Assert.Equal(AxisMapper.VJoyMax, l.AxisX);
        Assert.Equal(BridgeState.Tracking, l.State);
    }
}

public class SettingsTests
{
    [Fact]
    public void Missing_file_gives_defaults()
    {
        var s = BridgeSettings.Parse(null);
        Assert.Equal(1u, s.DeviceId);
        Assert.Equal(2, s.PollIntervalMs);
    }

    [Fact]
    public void Broken_json_gives_defaults()
    {
        var s = BridgeSettings.Parse("{ this is not json");
        Assert.Equal(1u, s.DeviceId);
        Assert.NotNull(s.Problem);
    }

    [Fact]
    public void Comments_and_trailing_commas_allowed()
    {
        var s = BridgeSettings.Parse("{ // hi\n \"DeviceId\": 3, \"InvertYaw\": true, }");
        Assert.Equal(3u, s.DeviceId);
        Assert.True(s.InvertYaw);
    }

    [Fact]
    public void Out_of_range_values_are_fixed()
    {
        var s = BridgeSettings.Parse("{\"DeviceId\": 99, \"PollIntervalMs\": 0, \"YawFullScaleDegrees\": -5, \"StaleAfterMs\": 1}");
        Assert.Equal(1u, s.DeviceId);
        Assert.Equal(1, s.PollIntervalMs);
        Assert.Equal(90, s.YawFullScaleDegrees);
        Assert.Equal(20, s.StaleAfterMs);
        Assert.NotNull(s.Problem);
    }

    [Fact]
    public void Numbers_in_quotes_still_work_and_keep_other_settings()
    {
        var s = BridgeSettings.Parse("{\"DeviceId\": \"2\", \"InvertYaw\": true}");
        Assert.Equal(2u, s.DeviceId);
        Assert.True(s.InvertYaw);
        Assert.Null(s.Problem);
    }

    [Fact]
    public void Shipped_settings_file_parses()
    {
        var path = System.IO.Path.Combine(AppContext.BaseDirectory, "settings.json");
        var s = BridgeSettings.Parse(System.IO.File.ReadAllText(path));
        Assert.Equal(1u, s.DeviceId);
        Assert.Equal(90, s.YawFullScaleDegrees);
        Assert.Equal(0, s.ReturnToCentreAfterMs);
        Assert.Null(s.Problem);
    }
}
