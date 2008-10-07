object Form1: TForm1
  Left = 943
  Top = 188
  Width = 227
  Height = 531
  Caption = 'FreeTrack Interface Test'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TLabel
    Left = 24
    Top = 136
    Width = 21
    Height = 13
    Alignment = taCenter
    Caption = 'Yaw'
  end
  object Label1: TLabel
    Left = 24
    Top = 152
    Width = 24
    Height = 13
    Alignment = taCenter
    Caption = 'Pitch'
  end
  object Label2: TLabel
    Left = 24
    Top = 168
    Width = 18
    Height = 13
    Alignment = taCenter
    Caption = 'Roll'
  end
  object Label3: TLabel
    Left = 24
    Top = 184
    Width = 7
    Height = 13
    Alignment = taCenter
    Caption = 'X'
  end
  object Label4: TLabel
    Left = 24
    Top = 200
    Width = 7
    Height = 13
    Alignment = taCenter
    Caption = 'Y'
  end
  object Label5: TLabel
    Left = 24
    Top = 216
    Width = 7
    Height = 13
    Alignment = taCenter
    Caption = 'Z'
  end
  object laYaw: TLabel
    Left = 96
    Top = 136
    Width = 9
    Height = 13
    Alignment = taRightJustify
    Caption = '...'
  end
  object laPitch: TLabel
    Left = 96
    Top = 152
    Width = 9
    Height = 13
    Alignment = taRightJustify
    Caption = '...'
  end
  object laRoll: TLabel
    Left = 96
    Top = 168
    Width = 9
    Height = 13
    Alignment = taRightJustify
    Caption = '...'
  end
  object laPanX: TLabel
    Left = 96
    Top = 184
    Width = 9
    Height = 13
    Alignment = taRightJustify
    Caption = '...'
  end
  object laPanY: TLabel
    Left = 96
    Top = 200
    Width = 9
    Height = 13
    Alignment = taRightJustify
    Caption = '...'
  end
  object laPanZ: TLabel
    Left = 96
    Top = 216
    Width = 9
    Height = 13
    Alignment = taRightJustify
    Caption = '...'
  end
  object Label6: TLabel
    Left = 24
    Top = 32
    Width = 133
    Height = 13
    Caption = 'FreeTrack interface version:'
  end
  object laVersion: TLabel
    Left = 168
    Top = 32
    Width = 9
    Height = 13
    Caption = '...'
  end
  object Label9: TLabel
    Left = 24
    Top = 96
    Width = 40
    Height = 13
    Caption = 'Data ID:'
  end
  object laDllLoaded: TLabel
    Left = 88
    Top = 8
    Width = 25
    Height = 13
    Caption = 'False'
  end
  object laDataID: TLabel
    Left = 128
    Top = 96
    Width = 9
    Height = 13
    Alignment = taRightJustify
    Caption = '...'
  end
  object Label7: TLabel
    Left = 128
    Top = 264
    Width = 15
    Height = 13
    Caption = 'rad'
  end
  object TLabel
    Left = 24
    Top = 264
    Width = 21
    Height = 13
    Alignment = taCenter
    Caption = 'Yaw'
  end
  object Label12: TLabel
    Left = 24
    Top = 280
    Width = 24
    Height = 13
    Alignment = taCenter
    Caption = 'Pitch'
  end
  object Label13: TLabel
    Left = 24
    Top = 296
    Width = 18
    Height = 13
    Alignment = taCenter
    Caption = 'Roll'
  end
  object Label14: TLabel
    Left = 24
    Top = 312
    Width = 7
    Height = 13
    Alignment = taCenter
    Caption = 'X'
  end
  object Label15: TLabel
    Left = 24
    Top = 328
    Width = 7
    Height = 13
    Alignment = taCenter
    Caption = 'Y'
  end
  object Label16: TLabel
    Left = 24
    Top = 344
    Width = 7
    Height = 13
    Alignment = taCenter
    Caption = 'Z'
  end
  object laRawYaw: TLabel
    Left = 96
    Top = 264
    Width = 9
    Height = 13
    Alignment = taRightJustify
    Caption = '...'
  end
  object laRawPitch: TLabel
    Left = 96
    Top = 280
    Width = 9
    Height = 13
    Alignment = taRightJustify
    Caption = '...'
  end
  object laRawRoll: TLabel
    Left = 96
    Top = 296
    Width = 9
    Height = 13
    Alignment = taRightJustify
    Caption = '...'
  end
  object laRawX: TLabel
    Left = 96
    Top = 312
    Width = 9
    Height = 13
    Alignment = taRightJustify
    Caption = '...'
  end
  object laRawY: TLabel
    Left = 96
    Top = 328
    Width = 9
    Height = 13
    Alignment = taRightJustify
    Caption = '...'
  end
  object laRawZ: TLabel
    Left = 96
    Top = 344
    Width = 9
    Height = 13
    Alignment = taRightJustify
    Caption = '...'
  end
  object Label23: TLabel
    Left = 16
    Top = 248
    Width = 48
    Height = 13
    Caption = 'Raw pose'
  end
  object Label24: TLabel
    Left = 16
    Top = 120
    Width = 55
    Height = 13
    Caption = 'Virtual pose'
  end
  object Label25: TLabel
    Left = 16
    Top = 408
    Width = 29
    Height = 13
    Caption = 'Points'
  end
  object Label11: TLabel
    Left = 128
    Top = 280
    Width = 15
    Height = 13
    Caption = 'rad'
  end
  object Label26: TLabel
    Left = 128
    Top = 296
    Width = 15
    Height = 13
    Caption = 'rad'
  end
  object laPoint1: TLabel
    Left = 48
    Top = 424
    Width = 9
    Height = 13
    Caption = '...'
  end
  object laPoint2: TLabel
    Left = 48
    Top = 440
    Width = 9
    Height = 13
    Caption = '...'
  end
  object laPoint3: TLabel
    Left = 48
    Top = 456
    Width = 9
    Height = 13
    Caption = '...'
  end
  object laPoint4: TLabel
    Left = 48
    Top = 472
    Width = 9
    Height = 13
    Caption = '...'
  end
  object Label18: TLabel
    Left = 16
    Top = 376
    Width = 90
    Height = 13
    Caption = 'Camera resolution: '
  end
  object laCamResolution: TLabel
    Left = 128
    Top = 376
    Width = 9
    Height = 13
    Caption = '...'
  end
  object Label19: TLabel
    Left = 24
    Top = 64
    Width = 76
    Height = 13
    Caption = 'Program Name: '
  end
  object laProgramName: TLabel
    Left = 112
    Top = 64
    Width = 9
    Height = 13
    Caption = '...'
  end
  object Label17: TLabel
    Left = 128
    Top = 136
    Width = 43
    Height = 13
    Caption = 'rad  +/-pi'
  end
  object Label22: TLabel
    Left = 24
    Top = 424
    Width = 9
    Height = 13
    Caption = '1:'
  end
  object Label27: TLabel
    Left = 24
    Top = 440
    Width = 9
    Height = 13
    Caption = '2:'
  end
  object Label28: TLabel
    Left = 24
    Top = 456
    Width = 9
    Height = 13
    Caption = '3:'
  end
  object Label29: TLabel
    Left = 24
    Top = 472
    Width = 9
    Height = 13
    Caption = '4:'
  end
  object Label8: TLabel
    Left = 24
    Top = 8
    Width = 54
    Height = 13
    Caption = 'Dll Loaded:'
  end
  object Label10: TLabel
    Left = 128
    Top = 312
    Width = 16
    Height = 13
    Caption = 'mm'
  end
  object Label30: TLabel
    Left = 128
    Top = 328
    Width = 16
    Height = 13
    Caption = 'mm'
  end
  object Label31: TLabel
    Left = 128
    Top = 344
    Width = 16
    Height = 13
    Caption = 'mm'
  end
  object Label32: TLabel
    Left = 128
    Top = 184
    Width = 54
    Height = 13
    Caption = 'mm  +/-500'
  end
  object Label20: TLabel
    Left = 128
    Top = 216
    Width = 54
    Height = 13
    Caption = 'mm  +/-500'
  end
  object Label21: TLabel
    Left = 128
    Top = 200
    Width = 54
    Height = 13
    Caption = 'mm  +/-500'
  end
  object Label33: TLabel
    Left = 128
    Top = 152
    Width = 43
    Height = 13
    Caption = 'rad  +/-pi'
  end
  object Label34: TLabel
    Left = 128
    Top = 168
    Width = 43
    Height = 13
    Caption = 'rad  +/-pi'
  end
  object timerData: TTimer
    Enabled = False
    Interval = 50
    OnTimer = timerDataTimer
    Left = 176
    Top = 8
  end
end
