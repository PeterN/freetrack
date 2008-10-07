object dmOptitrack: TdmOptitrack
  OldCreateOrder = False
  Left = 382
  Top = 82
  Height = 335
  Width = 565
  object NPCameraCollection1: TNPCameraCollection
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    OnDeviceRemoval = NPCameraCollection1DeviceRemoval
    OnDeviceArrival = NPCameraCollection1DeviceArrival
    Left = 64
    Top = 64
  end
  object NPCamera1: TNPCamera
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 152
    Top = 64
  end
end
