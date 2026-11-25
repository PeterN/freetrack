# Third-party software

FreeTrack for vJoy talks to two other programs. **Neither is included in this
download**: you install them yourself from their official pages. This keeps the
download small, makes sure you get the signed, up-to-date vJoy driver, and avoids
any licensing questions.

## vJoy

- What: virtual joystick driver. We call its `vJoyInterface.dll`, which is loaded
  from your vJoy install folder (`C:\Program Files\vJoy\x64\`).
- Get it: https://github.com/BrunnerInnovation/vJoy/releases (signed v2.2.2.0)
- License: MIT. Copyright (c) 2017 Shaul Eizikovich.
  https://github.com/BrunnerInnovation/vJoy/blob/master/LICENSE.txt

If you ever choose to ship vJoy files (the installer or `vJoyInterface.dll`)
inside your own package, MIT allows it, but you must include vJoy's license text.
Paste it below this line in that case:

```
MIT License

Copyright (c) 2017 Shaul Eizikovich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## FreeTrack 2.2

- What: the head-tracking program. We only **read** the data it publishes in
  shared memory (`FT_SharedMem`). No FreeTrack code is copied into this program;
  the data layout was re-written in C# from the published interface.
- Source: https://github.com/PeterN/freetrack (mirror of FreeTrack 2.2)
- License: GNU GPL v2 (`Freetrack/gpl.txt` in the source). Some source files say
  "GNU Library General Public License". Either way it is copyleft.

FreeTrack is not bundled. If you bundle it anyway, you must include its
`gpl.txt` and say where the source is (the link above). Do **not** bundle any of
these files that some FreeTrack/TrackIR folders contain, because they belong to
other companies and are not free to share:

- `TIRViews.dll`, `NPClient.dll`, `NPClient64.dll` (NaturalPoint / TrackIR)
- `OptiTrack.dll` or other OptiTrack SDK files (NaturalPoint)
- `SimConnect.dll` (Microsoft)
- `borlndmm.dll` (Embarcadero / Borland runtime)

## .NET

The self-contained build includes the Microsoft .NET runtime, which is MIT licensed:
https://github.com/dotnet/runtime/blob/main/LICENSE.TXT
