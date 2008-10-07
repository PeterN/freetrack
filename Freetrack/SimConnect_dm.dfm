object dmSimConnect: TdmSimConnect
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Left = 1065
  Top = 421
  Height = 150
  Width = 215
  object TimerCnx: TTimer
    Enabled = False
    OnTimer = TimerCnxTimer
    Left = 72
    Top = 32
  end
end
