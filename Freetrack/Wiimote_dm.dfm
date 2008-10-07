object dmwiimote: Tdmwiimote
  OldCreateOrder = False
  Left = 205
  Top = 220
  Height = 255
  Width = 264
  object HIDCtrl: TJvHidDeviceController
    OnDeviceChange = HIDCtrlDeviceChange
    OnRemoval = HIDCtrlRemoval
    Left = 64
    Top = 32
  end
  object StatusTimer: TTimer
    Enabled = False
    OnTimer = StatusTimerTimer
    Left = 128
    Top = 32
  end
  object SpeakerTimer: TTimer
    Enabled = False
    Interval = 9
    OnTimer = SpeakerTimerTimer
    Left = 128
    Top = 96
  end
end
