object ForceCamProp: TForceCamProp
  Left = 439
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Camera Properties'
  ClientHeight = 179
  ClientWidth = 276
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 146
    Width = 276
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel2: TPanel
      Left = 24
      Top = 0
      Width = 252
      Height = 33
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object butApply: TButton
        Left = 168
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Apply'
        Enabled = False
        TabOrder = 0
        OnClick = butApplyClick
      end
      object butCancel: TButton
        Left = 88
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Cancel'
        TabOrder = 1
        OnClick = butCancelClick
      end
      object butOK: TButton
        Left = 8
        Top = 0
        Width = 75
        Height = 25
        Caption = 'OK'
        TabOrder = 2
        OnClick = butOKClick
      end
    end
  end
  object pcPropPages: TPageControl
    Left = 5
    Top = 5
    Width = 268
    Height = 137
    TabOrder = 0
  end
  object DKLanguageController1: TDKLanguageController
    Left = 32
    Top = 32
    LangData = {
      0C00466F72636543616D50726F70010100000001000000070043617074696F6E
      01070000000B00706350726F7050616765730000060050616E656C3100000600
      50616E656C32000008006275744170706C790101000000060000000700436170
      74696F6E00090062757443616E63656C01010000000700000007004361707469
      6F6E0005006275744F4B010100000008000000070043617074696F6E000A0063
      6C69636B54696D65720000}
  end
  object clickTimer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = clickTimerTimer
    Left = 72
    Top = 32
  end
end
