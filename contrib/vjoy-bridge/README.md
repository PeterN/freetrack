# FreeTrack for vJoy

Turns your FreeTrack head tracking into a joystick that games can see.
Turn your head left/right → joystick X axis. Tilt up/down → joystick Y axis.

It is made for people who used FreeTrack + PPJoy and can no longer use PPJoy,
because newer anti-cheat blocks PPJoy's unsigned driver. vJoy has a properly
signed driver, so this bridge uses vJoy instead.

- Your FreeTrack curves, smoothing and profiles still work. The bridge only reads what FreeTrack sends.
- It does not change FreeTrack or vJoy. It does not touch the game.
- It runs in the background with an icon near the clock.

## What you need

1. **Windows 10 or 11 (64-bit).**
2. **FreeTrack 2.2** – the program you already use.
3. **vJoy 2.2.2.0 (signed)** – download the installer from the official page:
   https://github.com/BrunnerInnovation/vJoy/releases
   (This is the maintained, signed version that works on Windows 10/11. Older 2.1.x versions may not load on Windows 11.)
4. **.NET 8 Desktop Runtime** – only if you use the small download. The "self-contained" download already includes it.
   https://dotnet.microsoft.com/download/dotnet/8.0

## Setup (one time)

1. Install vJoy using its installer. Restart if it asks.
2. Open **Configure vJoy** from the Start menu.
   - Pick device **1**.
   - Tick **X** and **Y** axes. (Others can stay off.)
   - Click **Apply**.
3. Unzip **FreeTrack for vJoy** anywhere, for example `C:\Games\FreeTrackForVJoy`.
4. Optional: put your FreeTrack folder inside it as `FreeTrack\` so the bridge can open FreeTrack for you.
   Or write the full path to `Freetrack.exe` in `settings.json`.

## Every time you play

1. Double-click **FreeTrackForVJoy.exe**. It opens FreeTrack for you if it can find it.
2. In FreeTrack, go to **Output** and make sure **FreeTrack interface** is ticked.
3. Click **Start** in FreeTrack.
4. In the game's controller settings, assign steering (or look) to the **vJoy Device X axis**. Do this once per game.

Right-click the tray icon to:
- see what it is doing ("Sending head movement", "Waiting for FreeTrack", "Holding last position"),
- **Stop output** – puts the joystick back in the centre and lets go of vJoy,
- **Start output** again,
- **Exit**.

If FreeTrack stops sending (for example the camera loses you), the joystick
**holds its last position** and carries on as soon as tracking comes back.
If you prefer it to drift back to the centre after a while, set `ReturnToCentreAfterMs`
(for example `2000` for 2 seconds).

**Test the direction slowly the first time.** Head left should steer left. If it's
backwards in a game, set `InvertYaw` to `true`.

## Settings (`settings.json`)

Open it with Notepad. Lines starting with `//` are notes.

| Setting | What it does | Default |
|---|---|---|
| `DeviceId` | Which vJoy device to use (1–16) | 1 |
| `YawFullScaleDegrees` | How far you turn (after FreeTrack's curves) for full left/right. Smaller = more sensitive | 90 |
| `PitchFullScaleDegrees` | Same for up/down | 90 |
| `InvertYaw` / `InvertPitch` | Flip a direction if it is backwards | false |
| `PollIntervalMs` | How often to check FreeTrack, in milliseconds | 2 |
| `StaleAfterMs` | When to show "holding last position" | 250 |
| `ReturnToCentreAfterMs` | If tracking is lost this long, glide the joystick back to centre. 0 = hold forever | 0 |
| `FreeTrackPath` | Full path to `Freetrack.exe` (optional) | empty |

If the file is broken or a value is silly, the bridge uses the safe default instead of crashing.

## If something is wrong

| Message near the clock | Fix |
|---|---|
| vJoy is not installed or not enabled | Install vJoy (step 1), then open Configure vJoy and make sure "Enable vJoy" is ticked |
| vJoy device 1 does not exist | Configure vJoy → add device 1 → Apply |
| needs the X and Y axes turned on | Configure vJoy → tick X and Y → Apply |
| being used by another program | Close other vJoy programs (FreePIE, Joystick Gremlin, opentrack's joystick output…) |
| Waiting for FreeTrack | Start FreeTrack and click Start; check "FreeTrack interface" is ticked in Output |

## About anti-cheat (please read)

vJoy's driver is signed, so it is not blocked the way PPJoy is. But some
anti-cheat systems also look at **virtual controllers**, signed or not. We know of
no game that bans vJoy today, but that can change. Before a ranked or online race,
test in practice mode first. If a game blocks vJoy, a real hardware device such as the
Xbox Adaptive Controller does not depend on any virtual driver.

## Build it yourself

You need the free .NET 8 SDK (https://dotnet.microsoft.com/download/dotnet/8.0). Then in PowerShell:

```powershell
.\build.ps1            # runs the tests and makes dist\FreeTrackForVJoy-<version>.zip
.\build.ps1 -SelfContained   # bigger zip that does not need .NET installed
```

The zip contains only this program, `settings.json`, this README and the license files.
It does **not** contain vJoy or FreeTrack; see `THIRD-PARTY-NOTICES.md` for why.

## License

MIT – see `LICENSE`. vJoy and FreeTrack have their own licenses; see `THIRD-PARTY-NOTICES.md`.
