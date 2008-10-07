object fmSettings: TfmSettings
  Left = 425
  Top = 207
  Width = 323
  Height = 184
  Caption = 'Seuil'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 96
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label2: TLabel
    Left = 232
    Top = 96
    Width = 18
    Height = 13
    Caption = '255'
  end
  object TrackBar: TTrackBar
    Left = 16
    Top = 112
    Width = 249
    Height = 45
    Max = 255
    Frequency = 10
    Position = 125
    TabOrder = 0
    OnChange = TrackBarChange
  end
  object cbActive: TCheckBox
    Left = 16
    Top = 40
    Width = 81
    Height = 17
    Caption = 'Active'
    TabOrder = 1
    OnClick = cbActiveClick
  end
  object GroupBox1: TGroupBox
    Left = 112
    Top = 8
    Width = 121
    Height = 73
    Caption = 'Point size'
    TabOrder = 2
    object Label3: TLabel
      Left = 8
      Top = 21
      Width = 41
      Height = 13
      Caption = 'Minimal :'
    end
    object Label4: TLabel
      Left = 8
      Top = 45
      Width = 44
      Height = 13
      Caption = 'Maximal :'
    end
    object spMinSize: TSpinEdit
      Left = 56
      Top = 16
      Width = 49
      Height = 22
      MaxValue = 120
      MinValue = 1
      TabOrder = 0
      Value = 1
      OnChange = spMinSizeChange
    end
    object spMaxSize: TSpinEdit
      Left = 56
      Top = 40
      Width = 49
      Height = 22
      MaxValue = 150
      MinValue = 1
      TabOrder = 1
      Value = 120
      OnChange = spMaxSizeChange
    end
  end
end
