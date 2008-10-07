object fmDemo: TfmDemo
  Left = 484
  Top = 162
  Width = 436
  Height = 503
  Caption = 'fmDemo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SideBar1: TSideBar
    Left = 8
    Top = 8
    Width = 345
    Height = 321
    PageCtrl.Left = 0
    PageCtrl.Top = 75
    PageCtrl.Width = 345
    PageCtrl.Height = 246
    PageCtrl.ActivePage = TabSheet3
    PageCtrl.Align = alCustom
    PageCtrl.Style = tsFlatButtons
    PageCtrl.TabHeight = 1
    PageCtrl.TabOrder = 0
    ButtonHeight = 25
    TabVisible = False
    object PageControl: TPageControl
      Left = 0
      Top = 75
      Width = 345
      Height = 246
      ActivePage = TabSheet3
      Align = alCustom
      Style = tsFlatButtons
      TabHeight = 1
      TabOrder = 0
      object Tabsheet1: TTabSheet
        Caption = 'Tabsheet1'
        TabVisible = False
        object Button2: TButton
          Left = 32
          Top = 48
          Width = 75
          Height = 25
          Caption = 'Button2'
          TabOrder = 0
        end
        object Button3: TButton
          Left = 32
          Top = 96
          Width = 75
          Height = 25
          Caption = 'Button3'
          TabOrder = 1
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'TabSheet2'
        ImageIndex = 1
        TabVisible = False
        object Memo1: TMemo
          Left = 48
          Top = 40
          Width = 185
          Height = 89
          Lines.Strings = (
            'Memo1')
          TabOrder = 0
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'TabSheet3'
        ImageIndex = 2
        TabVisible = False
        object RadioGroup1: TRadioGroup
          Left = 72
          Top = 40
          Width = 201
          Height = 129
          Caption = 'RadioGroup1'
          Items.Strings = (
            'A'
            'B'
            'C')
          TabOrder = 0
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 8
    Top = 336
    Width = 409
    Height = 89
    TabOrder = 1
    object HorizRS: TmkRangeSlider
      Left = 6
      Top = 16
      Width = 323
      Height = 36
      Min = 0
      Max = 300
      MinPosition = 60
      MaxPosition = 100
      Value = 0
      ThumbStyle = rsRectangle
      ColorLow = clGray
      ColorMid = 8454143
      ColorHi = 681706
      OnGetRullerLength = HorizRSGetRullerLength
      Constraints.MinHeight = 10
      Constraints.MinWidth = 50
      TabOrder = 0
      TabStop = True
    end
    object RadioGroup2: TRadioGroup
      Left = 18
      Top = 48
      Width = 191
      Height = 33
      Caption = 'Neutral zone'
      Columns = 2
      Items.Strings = (
        'Forward'
        'Central')
      TabOrder = 1
      OnClick = RadioGroup2Click
    end
    object Panel2: TPanel
      Left = 16
      Top = 8
      Width = 217
      Height = 5
      BevelOuter = bvNone
      Color = clRed
      TabOrder = 2
    end
    object ComboBox1: TComboBox
      Left = 240
      Top = 56
      Width = 65
      Height = 21
      ItemHeight = 13
      TabOrder = 3
      Text = 'ComboBox1'
    end
  end
end
