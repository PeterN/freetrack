# Checklist for your own bridge

We could not see your code (it is not public), so we wrote this kit from your
description. If you want to keep your own version, these are the things we would
check first. Each one is a real problem we had to handle in this kit.

1. **Struct size.** FreeTrack's data block is 92 bytes: 1 unsigned int, 2 ints, 20 floats,
   no padding (`[StructLayout(LayoutKind.Sequential, Pack = 1)]`). Angles are in radians.
2. **FreeTrack's lock.** FreeTrack writes while holding a mutex called `FT_Mutext`
   (yes, with the typo). If you read without it you can get half-updated values now
   and then (a tiny twitch). If you take it, wait only a few ms, and catch
   `AbandonedMutexException` (that happens if FreeTrack crashed while writing).
3. **FreeTrack started late or restarted.** `OpenExisting("FT_SharedMem")` fails until
   FreeTrack has started. Retry quietly instead of crashing or giving up.
4. **Leftover data at start.** The first values you read may be old. Wait until
   `DataID` changes before moving the axis.
5. **Bad numbers.** If a value is NaN or infinity, send the centre, never full lock.
   Always clamp to 1..32768 before `SetAxis`.
6. **2 ms timing.** `Thread.Sleep(2)` really sleeps ~15 ms on Windows unless you call
   `timeBeginPeriod(1)` (and `timeEndPeriod(1)` when you stop).
7. **Device checks before Acquire.** Check that vJoy is enabled, the device exists, it
   is not owned by another program, and X and Y are switched on. Show a clear message
   for each, instead of a silent failure.
8. **Stop and exit.** Centre the axes, then `RelinquishVJD`. Also do it if the app is
   closed from the tray, so the car never keeps steering after the bridge closes.
9. **Only one copy running.** Two bridges fighting over the same vJoy device cause jitter.
   A named mutex at start-up prevents that.
10. **DLL versions.** Load `vJoyInterface.dll` from the vJoy install folder so it always
    matches the installed driver. A bundled old DLL with a newer driver can fail.
11. **Direction.** In FreeTrack, positive yaw means the head turned *left* and positive
    pitch means *up*. On a joystick, low X is left. If you map yaw straight across, head-left
    steers right unless the game inverts it. Negate yaw (and pitch) before mapping.
12. **Errors must centre.** If your loop stops because of an error, centre the axes on the
    way out, not only when the user clicks Stop.
13. **Don't bundle other people's DLLs.** See `THIRD-PARTY-NOTICES.md`.
