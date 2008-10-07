object CamManager: TCamManager
  Left = 530
  Top = 133
  Align = alClient
  BorderStyle = bsNone
  ClientHeight = 480
  ClientWidth = 387
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label20: TLabel
    Left = 40
    Top = 48
    Width = 38
    Height = 13
    Caption = 'Label20'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clInfoBk
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ScrollBox2: TScrollBox
    Left = 0
    Top = 0
    Width = 387
    Height = 376
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 0
    object laDemoVideo: TLabel
      Left = 16
      Top = 304
      Width = 58
      Height = 13
      Caption = 'Demo Video'
      Visible = False
    end
    object VideoWindow1: TVideoWindow
      Left = 2
      Top = 2
      Width = 320
      Height = 240
      OnPaint = VideoWindow1Paint
      VMROptions.Mode = vmrWindowless
      VMROptions.Preferences = [vpForceMixer, vpDoNotRenderColorKeyAndBorder]
      Color = clBlack
    end
    object Panel1: TPanel
      Left = 16
      Top = 256
      Width = 113
      Height = 17
      Caption = 'Panel1'
      Color = cl3DLight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCaptionText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentBackground = True
      ParentFont = False
      TabOrder = 0
      Visible = False
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 376
    Width = 387
    Height = 104
    ActivePage = TabSheet1
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Camera'
      object laFPS: TLabel
        Left = 283
        Top = 21
        Width = 27
        Height = 20
        Caption = '000'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
      end
      object Label19: TLabel
        Left = 253
        Top = 23
        Width = 26
        Height = 16
        Hint = 'Frames per second'
        Caption = 'FPS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
      end
      object Label86: TLabel
        Left = 320
        Top = 23
        Width = 27
        Height = 16
        Hint = 'Jitters per second'
        AutoSize = False
        Caption = 'JPS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
      end
      object laJitter: TLabel
        Left = 348
        Top = 21
        Width = 27
        Height = 20
        Caption = '000'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
      end
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 64
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Threshold'
      end
      object laFreetrackFilter: TLabel
        Left = 349
        Top = 61
        Width = 27
        Height = 13
        Caption = 'SSE2'
        ParentShowHint = False
        ShowHint = True
      end
      object Label57: TLabel
        Left = -3
        Top = 24
        Width = 49
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Source'
      end
      object laBat: TLabel
        Left = 336
        Top = 49
        Width = 12
        Height = 13
        Caption = '00'
      end
      object laBatTitle: TLabel
        Left = 296
        Top = 48
        Width = 33
        Height = 13
        Caption = 'Battery'
      end
      object butCamera: TPngSpeedButton
        Left = 136
        Top = 48
        Width = 81
        Height = 22
        Caption = 'Camera'
        OnClick = butCameraProperty
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C000002B04944415478DA9593CF4BDA7118C7DF5F4D57DAC2519A
          44FE20C10EEDD40EB343879D72BB04AD7F603B8D6050A7113B0CBC445D1A7959
          AEDA8A3AB8B1200B526211341711A343452841A991A45692BF327F7CF7793EC3
          F0BB9DF6910F1FBF7EBECFEB799EF7F356104511D52B168B196432D9F372B9DC
          532C161FB18D42A1F02B9BCDFA92C9E4B7EEEEEE48F5FB4235E0FCFCBC4B1084
          370A85A2979D602010209FCF239D4E23140A2D5D5F5F8FF6F5F56DFD038846A3
          067638D56A756F4D4D0D0FDADDDDE580F6F676C8E572E472396C6E6E2EDDDCDC
          BC1E1818884800E17078B0AEAE6EBCB6B616A552094AA5120A851222FBA45329
          5C5C5CB06705028100FC7EFF90C3E1782F010483C1D5A6A6263B05331002A104
          B67EFA41F7365B174CFAFBA40FAF687A7ADAEB743A9F4A007B7B7BB19696162D
          95A96B6E86EBB31B0DC6C710656A643229BCB49B70787888FAFA7A8C8C8CC467
          66667412C0F6F676CC6C366B33990C5A5B5BF1E1D317A8CC4F5012EF21972FE2
          558F06FBFBFB2071C7C6C6E26EB75B0A585F5F5F351A8D767AD66834084793F8
          112C202F6BC0B387723C509749689A04666767BD1E8F47DAC2E2E2E2A056AB1D
          D7EBF53C93C56281C964E21A1C1F1FF3F2DBDADAB0B2B2829D9D9D219FCF2715
          716A6ACAC0CCF2B1A3A3A3879DB8BCBC240381198AFB8184A549B0C0EFB7B7B7
          2FD6D6D6A4635C5858E867F37D7B7A7A1AEAECECECA54AC83C74CFBC818D8D0D
          78BDDE2583C160B9BABAFABABCBCECB803CCCFCFF713836554B2691859AF61CA
          4A192B9E482412600633B251871B1B1B49F4770707070E0E989B9B13AD562B17
          E9E4E48497AE52A9707676066A870C443AF011EB745C9FC9C94944221181035C
          2E9768B3D9C07A036BE36E5340E53B599BEE2BBA4C4C4C50C23F80E1E161F1E8
          E888BF44BB1A52F98D82C985145C59F1785C10FEFE3BFFEFFA0D3F15BFF0C579
          924A0000000049454E44AE426082}
      end
      object butStream: TPngSpeedButton
        Left = 56
        Top = 48
        Width = 73
        Height = 22
        Caption = 'Stream'
        OnClick = butStreamProperty
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000010000000100804000000B5FA37
          EA0000000467414D410000AFC837058AE90000001974455874536F6674776172
          650041646F626520496D616765526561647971C9653C000001C34944415478DA
          4D514D48545114FEEEC31C9A37FDBC11A79B4A61D1420884878B84C0160AAE5B
          CF4A7117D1225AF8FCC1D171693B0986DC680BB111DCB431988DE84039D4A398
          4D1158D230538EDADCF14DF7BE773B3D453D97CB8573BEFB9DEF9C8F699CC5FB
          6195F421971EBC3CCBB16380DBE5EFFA3555BAD1AA91AF44B98AC9F687C55380
          9BF1875459D9AAD0C1353E97B42D0B32A116922321E0A3139BB1B0879F424539
          0BF045ABFA4DB3031FF069EC699A00EFC6FF4E71E6E1020C4804F436E8F858D3
          DEE4DC74D862337D65D4A3D40176A8DC892602D6E1CE3E73A8457E5B2594C92D
          812A36B7C4440456AAA757C344AE2A852AB30DFF8EF11B7FE86711DF069CB740
          A63FBECE8921866B980B58CEBF6DECA386087E6067E01101E6FB5BD6DB207011
          713C0FD8E2F6AF8465765B476886BB25272464CAEE95A468A55A13B21C8ACCA6
          AF8F2A9266E03B15DAE81E11436E76DE09F7F07A5C4E75B37D6268867732A687
          CB58D48DC917FFC77CE5F0995BC8E3AB30A27DB4A815CDEAF7CCBB58853B964D
          872D5299BD21518EDB970A835C2153F2ECA0504FC8853723A7663DE992BB576B
          91D2FD5681E58AE646ECB07DAD78CECDE3783C5C4936C096B2E7ECFE0748C2CE
          3B74ACC3980000000049454E44AE426082}
      end
      object combCam: TComboBox
        Left = 48
        Top = 21
        Width = 201
        Height = 19
        Style = csOwnerDrawFixed
        ItemHeight = 13
        TabOrder = 0
        OnChange = OnSelectCam
      end
      object tbSeuil: TTrackBar
        Left = 56
        Top = 1
        Width = 321
        Height = 14
        Align = alCustom
        Max = 255
        ParentShowHint = False
        PageSize = 10
        Position = 100
        ShowHint = True
        TabOrder = 1
        ThumbLength = 12
        TickMarks = tmBoth
        TickStyle = tsNone
        OnChange = tbSeuilChange
      end
      object cbOptitrackIRIllum: TCheckBox
        Left = 56
        Top = 48
        Width = 233
        Height = 17
        Caption = 'IR illumination while tracking'
        TabOrder = 2
        OnClick = cbOptitrackIRIllumClick
      end
    end
    object tsFrameRate: TTabSheet
      Caption = 'Frame rate'
      ImageIndex = 2
      object Label17: TLabel
        Left = 152
        Top = 8
        Width = 81
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Multiplier'
        ParentShowHint = False
        ShowHint = True
      end
      object Label96: TLabel
        Left = 8
        Top = 9
        Width = 145
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Actual webcam FPS'
      end
      object Label2: TLabel
        Left = 232
        Top = 8
        Width = 129
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Output frame rate'
      end
      object laOutputFPS: TLabel
        Left = 280
        Top = 32
        Width = 18
        Height = 20
        Caption = '00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 224
        Top = 8
        Width = 3
        Height = 13
        WordWrap = True
      end
      object Label6: TLabel
        Left = 8
        Top = 56
        Width = 178
        Height = 13
        Caption = 'Only enforced when minimized to tray.'
      end
      object edManualInterp: TEdit
        Left = 153
        Top = 31
        Width = 24
        Height = 21
        Hint = 'Number of extra frames inserted between webcam frames'
        MaxLength = 1
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        Text = '1'
      end
      object cbInterpAuto: TCheckBox
        Left = 193
        Top = 33
        Width = 58
        Height = 17
        Hint = 'Webcam fps determines multiplier'
        Caption = 'Auto'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = cbInterpAutoClick
      end
      object udInterpMultiplier: TUpDown
        Left = 177
        Top = 31
        Width = 12
        Height = 21
        Hint = 'Frame rate multiplier'
        Associate = edManualInterp
        Min = 1
        Max = 4
        ParentShowHint = False
        Position = 1
        ShowHint = True
        TabOrder = 2
        OnClick = udInterpMultiplierClick
      end
      object edInterpWebcamFPS: TEdit
        Left = 55
        Top = 29
        Width = 27
        Height = 21
        Hint = 'This must match the average webcam frame rate'
        MaxLength = 1
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 3
        Text = '1'
      end
      object udInterpWebcamFPS: TUpDown
        Left = 82
        Top = 29
        Width = 12
        Height = 21
        Hint = 'Must match the average webcam frame rate'
        Associate = edInterpWebcamFPS
        Min = 1
        Max = 120
        ParentShowHint = False
        Position = 1
        ShowHint = True
        TabOrder = 4
        OnClick = udInterpWebcamFPSClick
      end
    end
    object tsPointSize: TTabSheet
      Caption = 'Point size'
      ImageIndex = 3
      object Label4: TLabel
        Left = 40
        Top = 16
        Width = 86
        Height = 13
        Caption = 'Min point diameter'
      end
      object Label5: TLabel
        Left = 40
        Top = 48
        Width = 89
        Height = 13
        Caption = 'Max point diameter'
      end
      object Label13: TLabel
        Left = 198
        Top = 16
        Width = 26
        Height = 13
        Caption = 'pixels'
      end
      object Label14: TLabel
        Left = 198
        Top = 50
        Width = 26
        Height = 13
        Caption = 'pixels'
      end
      object edMaxPointSize: TEdit
        Left = 151
        Top = 47
        Width = 27
        Height = 21
        MaxLength = 1
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        Text = '1'
      end
      object udMaxPointSize: TUpDown
        Left = 178
        Top = 47
        Width = 12
        Height = 21
        Associate = edMaxPointSize
        Min = 1
        Max = 500
        ParentShowHint = False
        Position = 1
        ShowHint = True
        TabOrder = 1
        OnClick = udPointSizeClick
      end
      object edMinPointSize: TEdit
        Left = 151
        Top = 13
        Width = 27
        Height = 21
        MaxLength = 1
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        Text = '1'
      end
      object udMinPointSize: TUpDown
        Left = 178
        Top = 13
        Width = 12
        Height = 21
        Associate = edMinPointSize
        Min = 1
        Max = 120
        ParentShowHint = False
        Position = 1
        ShowHint = True
        TabOrder = 3
        OnClick = udPointSizeClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Wii sens'
      ImageIndex = 4
      TabVisible = False
      object laWiiSens1: TLabel
        Left = 0
        Top = 8
        Width = 18
        Height = 13
        Caption = '000'
      end
      object laWiiSens2: TLabel
        Left = 0
        Top = 24
        Width = 18
        Height = 13
        Caption = '000'
      end
      object laWiiSens3: TLabel
        Left = 0
        Top = 40
        Width = 18
        Height = 13
        Caption = '000'
      end
      object laWiiSens4: TLabel
        Left = 0
        Top = 56
        Width = 18
        Height = 13
        Caption = '000'
      end
      object laWiiSens5: TLabel
        Left = 128
        Top = 8
        Width = 18
        Height = 13
        Caption = '000'
      end
      object laWiiSens6: TLabel
        Left = 128
        Top = 24
        Width = 18
        Height = 13
        Caption = '000'
      end
      object laWiiSens7: TLabel
        Left = 128
        Top = 40
        Width = 18
        Height = 13
        Caption = '000'
      end
      object laWiiSens8: TLabel
        Left = 128
        Top = 56
        Width = 18
        Height = 13
        Caption = '000'
      end
      object laWiiSens9: TLabel
        Left = 256
        Top = 8
        Width = 18
        Height = 13
        Caption = '000'
      end
      object laWiiSens10: TLabel
        Left = 256
        Top = 40
        Width = 18
        Height = 13
        Caption = '000'
      end
      object laWiiSens11: TLabel
        Left = 256
        Top = 56
        Width = 18
        Height = 13
        Caption = '000'
      end
      object tbWiiSens1: TTrackBar
        Left = 24
        Top = 8
        Width = 97
        Height = 17
        Max = 255
        TabOrder = 0
        ThumbLength = 10
        TickStyle = tsNone
        OnChange = tbWiiSens1Change
      end
      object tbWiiSens2: TTrackBar
        Left = 24
        Top = 24
        Width = 97
        Height = 17
        Max = 255
        TabOrder = 1
        ThumbLength = 10
        TickStyle = tsNone
        OnChange = tbWiiSens1Change
      end
      object tbWiiSens3: TTrackBar
        Left = 24
        Top = 40
        Width = 97
        Height = 17
        Max = 255
        TabOrder = 2
        ThumbLength = 10
        TickStyle = tsNone
        OnChange = tbWiiSens1Change
      end
      object tbWiiSens4: TTrackBar
        Left = 24
        Top = 56
        Width = 97
        Height = 17
        Max = 255
        TabOrder = 3
        ThumbLength = 10
        TickStyle = tsNone
        OnChange = tbWiiSens1Change
      end
      object tbWiiSens5: TTrackBar
        Left = 152
        Top = 8
        Width = 97
        Height = 17
        Max = 255
        TabOrder = 4
        ThumbLength = 10
        TickStyle = tsNone
        OnChange = tbWiiSens1Change
      end
      object tbWiiSens6: TTrackBar
        Left = 152
        Top = 24
        Width = 97
        Height = 17
        Max = 255
        TabOrder = 5
        ThumbLength = 10
        TickStyle = tsNone
        OnChange = tbWiiSens1Change
      end
      object tbWiiSens7: TTrackBar
        Left = 152
        Top = 40
        Width = 97
        Height = 17
        Max = 255
        TabOrder = 6
        ThumbLength = 10
        TickStyle = tsNone
        OnChange = tbWiiSens1Change
      end
      object tbWiiSens8: TTrackBar
        Left = 152
        Top = 56
        Width = 97
        Height = 17
        Max = 255
        TabOrder = 7
        ThumbLength = 10
        TickStyle = tsNone
        OnChange = tbWiiSens1Change
      end
      object tbWiiSens9: TTrackBar
        Left = 280
        Top = 8
        Width = 97
        Height = 17
        Max = 255
        TabOrder = 8
        ThumbLength = 10
        TickStyle = tsNone
        OnChange = tbWiiSens1Change
      end
      object tbWiiSens10: TTrackBar
        Left = 280
        Top = 40
        Width = 97
        Height = 17
        Max = 255
        TabOrder = 9
        ThumbLength = 10
        TickStyle = tsNone
        OnChange = tbWiiSens1Change
      end
      object tbWiiSens11: TTrackBar
        Left = 280
        Top = 56
        Width = 97
        Height = 17
        Max = 255
        TabOrder = 10
        ThumbLength = 10
        TickStyle = tsNone
        OnChange = tbWiiSens1Change
      end
    end
    object Position: TTabSheet
      Caption = 'Orientation'
      ImageIndex = 5
      object Label8: TLabel
        Left = 112
        Top = 8
        Width = 40
        Height = 13
        Caption = 'Degrees'
      end
      object Label7: TLabel
        Left = 112
        Top = 32
        Width = 40
        Height = 13
        Caption = 'Degrees'
      end
      object Label9: TLabel
        Left = 112
        Top = 56
        Width = 40
        Height = 13
        Caption = 'Degrees'
      end
      object Label10: TLabel
        Left = 8
        Top = 8
        Width = 21
        Height = 13
        Alignment = taCenter
        Caption = 'Yaw'
      end
      object Label11: TLabel
        Left = 8
        Top = 32
        Width = 24
        Height = 13
        Alignment = taCenter
        Caption = 'Pitch'
      end
      object Label12: TLabel
        Left = 8
        Top = 56
        Width = 18
        Height = 13
        Alignment = taCenter
        Caption = 'Roll'
      end
      object Image1: TImage
        Left = 240
        Top = 56
        Width = 16
        Height = 16
        AutoSize = True
        Picture.Data = {
          0A54504E474F626A65637489504E470D0A1A0A0000000D494844520000001000
          00001008060000001FF3FF610000000467414D410000AFC837058AE900000019
          74455874536F6674776172650041646F626520496D616765526561647971C965
          3C000002284944415478DAB5934B6853411486FF346921512445C1DC484922AD
          E94A041BDD25E822502B7611C585825AA5826D44572AEA26222258A16AB01B5F
          1B5DD4458C0F8CA20941C447D0BE4C4C23C90D484004C148F3BAF370EEB55D94
          C48888070E3330331FE7FCFF191DE71CFF12BAFF02381CDB3FC408F553CA9C94
          50884C13422FDFF28D079B028EC40F581965F72493B5C7BAC40A63AB09943114
          2B45E4BECA90BFE4128490FEBBFB1E161A02FCD181B7B6A5F61EDB321BCAA402
          834E0F26CECBA40CBDCE804C2183543E99081D8CB8EA00FEE70343169374A5D3
          DC251E3154952AF2DF64513E83D42EC1A06F05E514939F2691FD9C1B8E1C8D05
          17010E3DD9F371BDC5E5341A8C98AB95109F8D31D1F759AA5010859E74AFF5B4
          104E502957107D1D4D3F3BF6A27B1160F0D16E3E2F98FA405D8FDFD9153AAF9E
          6DBBEA0D382C8ED3F6550EAD8AF0D3FB889F7AA56B6AE38E9B5BF9F8DE07DAA5
          DED1CD018755003AEC6094231C09E36520F17BC0F61B7D5CAD2234F858D73BBA
          E9B6D8EFF4B8DC2D3528A8966A88C6A3E937E726BA1B027CD7FBB864B640F40F
          B920435A6EC59AD54E212CD52C9D9A9942369B1B7E77613A5807F05DDBC2579A
          257475748288CB8C512DE79412DAF46D486766914CA612EF4766EA6DD4C41AF3
          724BFB3C80FF0250B1167F7C47569691CB8A415268FFF4A554E34152C33BE2E1
          9615A205CA90CFCBA215A2BA32235C199BB8F8A1F9282F84FBCC464DC405A5FF
          FA33A9B1E1C43A2E94FE23E027D42652F0BAFBC2940000000049454E44AE4260
          82}
      end
      object Image2: TImage
        Left = 240
        Top = 8
        Width = 16
        Height = 16
        AutoSize = True
        Picture.Data = {
          0A54504E474F626A65637489504E470D0A1A0A0000000D494844520000001000
          00001008060000001FF3FF610000000467414D410000AFC837058AE900000019
          74455874536F6674776172650041646F626520496D616765526561647971C965
          3C000001654944415478DA63FCFFFF3F032580119F01C5C7D24FFEFDF3EFF704
          BBD936241B507434EDA2189B84DEDF7F7F191EBF7F746186C76243A20C283991
          C1F6EFCFBFABA2EC622A0A3C4A0CFFFEFD63B8F1FA3AC3C3378F6EFDFEF55B77
          79D4865F780D283C9CBAFBEF9FBF36A2ECE21C0AFC8A0CFFFEFF6378FAFE29C3
          A587977E000D38B836699B07515E48DD12FDDF4ADE9AE12FD005276F9F6478FB
          E18DE5BA94ED27880E83F8B561FFAD956D812EF8CBB0E3F40E860D693B18490A
          C4C86501FF6DD4EDC0066C3FB69D615BDE3ED20C089EE7F5DF4ED781E12FD080
          AD07B632EC2D3B429A013E535DFF3B18030D0046E3963D5B180ED79D22CD00B7
          5EFBFF8E164EC068FCCBB071FB6686536DE74933C0BED5F2BFB3AD0B380C366C
          DCC870A1EF2A690658D61AFF777576031BB07ECD0686AB536F91668071A9EE7F
          770F77867F40B86EC506865BB3EF9166806E9EC6FF3FBFFF32FCF9FD87019832
          19EE2D78449A01C40200E3CDD6E1230A89BB0000000049454E44AE426082}
      end
      object Image3: TImage
        Left = 240
        Top = 32
        Width = 16
        Height = 16
        AutoSize = True
        Picture.Data = {
          0A54504E474F626A65637489504E470D0A1A0A0000000D494844520000001000
          00001008060000001FF3FF610000000467414D410000AFC837058AE900000019
          74455874536F6674776172650041646F626520496D616765526561647971C965
          3C000000FD4944415478DA63FCFFFF3F032580718419E03FD37DF7AF1FBFBCB7
          E7EFFF4596019E131DBFFFFCFEEBC9BE8AA3AA2806949CC8009BF2F7F75F863F
          BFFF30FCFEF587E1D7CFDF0CBF7E80F02F869F400CA2258524197EFDFACD70F3
          F6AD4BA73B2EEAA31860256CCBF0F71FD0807F7FE0F8F7DFBF40FC9BE1F73F20
          FE0B14FBFB074C9F3B7F96E1E68DDBA7AE4FBF6D0E36A0F070EA7F0B516B8466
          9042B001BF21F41FA80150B973E7CE33DCBA7EE7E89DB9F76DC006E4EE4BFC8F
          CBD9403F83D95C1C5C0C9292520CAF5FBD66B87DE3EE05A06643920251BF40CB
          0268C17EA0458F809AD5C98A059564C51DC040F67BB0E83179D14871421A9C06
          0000DB7FEAE1DBB736010000000049454E44AE426082}
      end
      object edCamPosYaw: TEdit
        Left = 63
        Top = 5
        Width = 27
        Height = 21
        MaxLength = 1
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        Text = '0'
      end
      object udCamPosYaw: TUpDown
        Left = 90
        Top = 5
        Width = 12
        Height = 21
        Hint = 'Positive right'
        Associate = edCamPosYaw
        Min = -60
        Max = 60
        Increment = 3
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = udCamPositionClick
      end
      object cbCamPosPitchAuto: TCheckBox
        Left = 176
        Top = 32
        Width = 57
        Height = 17
        Caption = 'Auto'
        TabOrder = 2
        OnClick = cbCamPosAutoClick
      end
      object edCamPosPitch: TEdit
        Left = 63
        Top = 29
        Width = 27
        Height = 21
        MaxLength = 1
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 3
        Text = '0'
      end
      object udCamPosPitch: TUpDown
        Left = 90
        Top = 29
        Width = 12
        Height = 21
        Hint = 'Positive up'
        Associate = edCamPosPitch
        Min = -60
        Max = 60
        Increment = 3
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = udCamPositionClick
      end
      object edCamPosRoll: TEdit
        Left = 63
        Top = 53
        Width = 27
        Height = 21
        MaxLength = 1
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 5
        Text = '0'
      end
      object udCamPosRoll: TUpDown
        Left = 90
        Top = 53
        Width = 12
        Height = 21
        Hint = 'Positive clockwise'
        Associate = edCamPosRoll
        Min = -180
        Max = 180
        Increment = 3
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        OnClick = udCamPositionClick
      end
      object cbCamPosRollAuto: TCheckBox
        Left = 176
        Top = 56
        Width = 57
        Height = 17
        Caption = 'Auto '
        TabOrder = 7
        OnClick = cbCamPosAutoClick
      end
      object cbOrientMirror: TCheckBox
        Left = 264
        Top = 32
        Width = 97
        Height = 17
        Caption = 'Mirror'
        TabOrder = 8
        OnClick = OrientChange
      end
      object cbOrientFlip: TCheckBox
        Left = 264
        Top = 8
        Width = 97
        Height = 17
        Caption = 'Flip'
        TabOrder = 9
        OnClick = OrientChange
      end
      object cbOrientRotate: TCheckBox
        Left = 264
        Top = 56
        Width = 97
        Height = 17
        Caption = 'Rotate'
        TabOrder = 10
        OnClick = OrientChange
      end
      object cbShowUnscaledVid: TCheckBox
        Left = 320
        Top = 8
        Width = 97
        Height = 17
        Caption = 'Unscaled'
        TabOrder = 11
        Visible = False
      end
    end
    object tsCalibration: TTabSheet
      Caption = 'Calibration'
      ImageIndex = 5
      object laSensorWidth: TLabel
        Left = 80
        Top = 40
        Width = 61
        Height = 13
        Caption = 'Sensor width'
      end
      object laFocalLength: TLabel
        Left = 232
        Top = 40
        Width = 58
        Height = 13
        Caption = 'Focal length'
      end
      object Label15: TLabel
        Left = 192
        Top = 40
        Width = 16
        Height = 13
        Caption = 'mm'
      end
      object Label16: TLabel
        Left = 336
        Top = 40
        Width = 16
        Height = 13
        Caption = 'mm'
      end
      object Label18: TLabel
        Left = 16
        Top = 8
        Width = 203
        Height = 13
        Caption = 'Calibration scales depth to real-world units. '
        WordWrap = True
      end
      object edCamSensorWidth: TEdit
        Left = 151
        Top = 37
        Width = 26
        Height = 21
        MaxLength = 1
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        Text = '1'
      end
      object udCamSensorWidth: TUpDown
        Left = 178
        Top = 37
        Width = 13
        Height = 21
        Min = 1
        ParentShowHint = False
        Position = 1
        ShowHint = True
        TabOrder = 1
        OnClick = udCamCalibrateClick
      end
      object edCamFocalLength: TEdit
        Left = 295
        Top = 37
        Width = 26
        Height = 21
        MaxLength = 1
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        Text = '1'
      end
      object udCamFocalLength: TUpDown
        Left = 321
        Top = 37
        Width = 13
        Height = 21
        Min = 1
        Max = 1000
        ParentShowHint = False
        Position = 1
        ShowHint = True
        TabOrder = 3
        OnClick = udCamCalibrateClick
      end
      object cbAutoCalibrate: TCheckBox
        Left = 16
        Top = 38
        Width = 65
        Height = 17
        Caption = 'Auto'
        TabOrder = 4
        OnClick = cbAutoCalibrateClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Noise'
      ImageIndex = 6
      TabVisible = False
      object Label21: TLabel
        Left = 16
        Top = 8
        Width = 14
        Height = 13
        Caption = 'N1'
      end
      object Label22: TLabel
        Left = 16
        Top = 40
        Width = 14
        Height = 13
        Caption = 'N2'
      end
      object tbNoise1: TTrackBar
        Left = 40
        Top = 9
        Width = 321
        Height = 14
        Align = alCustom
        Max = 255
        ParentShowHint = False
        PageSize = 10
        Position = 100
        ShowHint = True
        TabOrder = 0
        ThumbLength = 12
        TickMarks = tmBoth
        TickStyle = tsNone
        OnChange = tbNoiseChange
      end
      object tbNoise2: TTrackBar
        Left = 40
        Top = 41
        Width = 321
        Height = 14
        Align = alCustom
        Max = 255
        ParentShowHint = False
        PageSize = 10
        Position = 100
        ShowHint = True
        TabOrder = 1
        ThumbLength = 12
        TickMarks = tmBoth
        TickStyle = tsNone
        OnChange = tbNoiseChange
      end
    end
  end
  object DKLanguageController1: TDKLanguageController
    OnLanguageChanged = DKLanguageController1LanguageChanged
    Left = 96
    Top = 296
    LangData = {
      0A0043616D4D616E616765720001670000000A005363726F6C6C426F78320000
      0B006C6144656D6F566964656F010100000001000000070043617074696F6E00
      0C0050616765436F6E74726F6C31000009005461625368656574310101000000
      02000000070043617074696F6E0005006C61465053000007004C6162656C3139
      010200000003000000070043617074696F6E3E000000040048696E740007004C
      6162656C3836010200000004000000070043617074696F6E3D00000004004869
      6E740008006C614A6974746572000006004C6162656C31010100000005000000
      070043617074696F6E0011006C6146726565747261636B46696C746572010100
      000006000000070043617074696F6E0007004C6162656C353701010000000700
      0000070043617074696F6E0005006C6142617400000A006C614261745469746C
      65010100000008000000070043617074696F6E00090062757443616D65726101
      0100000009000000070043617074696F6E00090062757453747265616D010100
      00000A000000070043617074696F6E000700636F6D6243616D00000700746253
      6575696C00000B0074734672616D655261746501010000000E00000007004361
      7074696F6E0007004C6162656C313701010000000F000000070043617074696F
      6E0007004C6162656C3936010100000010000000070043617074696F6E000600
      4C6162656C32010100000011000000070043617074696F6E000B006C614F7574
      707574465053000006004C6162656C33000006004C6162656C36010100000012
      000000070043617074696F6E000E0065644D616E75616C496E74657270010100
      000013000000040048696E74000C006362496E746572704175746F0102000000
      15000000070043617074696F6E14000000040048696E740012007564496E7465
      72704D756C7469706C696572010100000016000000040048696E740011006564
      496E7465727057656263616D465053010100000017000000040048696E740011
      007564496E7465727057656263616D465053010100000018000000040048696E
      74000B007473506F696E7453697A65010100000019000000070043617074696F
      6E0006004C6162656C3401010000001A000000070043617074696F6E0006004C
      6162656C3501010000001B000000070043617074696F6E000E0065644D617850
      6F696E7453697A6500000E0075644D6178506F696E7453697A6500000E006564
      4D696E506F696E7453697A6500000E0075644D696E506F696E7453697A650000
      090054616253686565743201010000001E000000070043617074696F6E000A00
      6C6157696953656E733100000A006C6157696953656E733200000A006C615769
      6953656E733300000A006C6157696953656E733400000A006C6157696953656E
      733500000A006C6157696953656E733600000A006C6157696953656E73370000
      0A006C6157696953656E733800000A006C6157696953656E733900000B006C61
      57696953656E73313000000B006C6157696953656E73313100000A0074625769
      6953656E733100000A00746257696953656E733200000A00746257696953656E
      733300000A00746257696953656E733400000A00746257696953656E73350000
      0A00746257696953656E733600000A00746257696953656E733700000A007462
      57696953656E733800000A00746257696953656E733900000B00746257696953
      656E73313000000B00746257696953656E73313100000800506F736974696F6E
      01010000001F000000070043617074696F6E0006004C6162656C380101000000
      20000000070043617074696F6E0006004C6162656C3701010000002100000007
      0043617074696F6E0006004C6162656C39010100000022000000070043617074
      696F6E0007004C6162656C3130010100000023000000070043617074696F6E00
      07004C6162656C3131010100000024000000070043617074696F6E0007004C61
      62656C3132010100000025000000070043617074696F6E000600496D61676531
      00000600496D6167653200000600496D6167653300000B00656443616D506F73
      59617700000B00756443616D506F73596177010100000026000000040048696E
      74001100636243616D506F7350697463684175746F0101000000270000000700
      43617074696F6E000D00656443616D506F73506974636800000D00756443616D
      506F735069746368010100000028000000040048696E74000C00656443616D50
      6F73526F6C6C00000C00756443616D506F73526F6C6C01010000002900000004
      0048696E74001000636243616D506F73526F6C6C4175746F01010000002A0000
      00070043617074696F6E000E0063624F7269656E744D6972726F720101000000
      2B000000070043617074696F6E000C0063624F7269656E74466C697001010000
      002C000000070043617074696F6E000E0063624F7269656E74526F7461746501
      010000002D000000070043617074696F6E001100636253686F77556E7363616C
      656456696401010000002F000000070043617074696F6E000D00747343616C69
      62726174696F6E010100000030000000070043617074696F6E000D006C615365
      6E736F725769647468010100000031000000070043617074696F6E000D006C61
      466F63616C4C656E677468010100000032000000070043617074696F6E000700
      4C6162656C3135010100000033000000070043617074696F6E0007004C616265
      6C3136010100000034000000070043617074696F6E001000656443616D53656E
      736F72576964746800001000756443616D53656E736F72576964746800000700
      4C6162656C3138010100000036000000070043617074696F6E00100065644361
      6D466F63616C4C656E67746800001000756443616D466F63616C4C656E677468
      0000120063624F707469747261636B4952496C6C756D01010000003700000007
      0043617074696F6E00060050616E656C31010100000038000000070043617074
      696F6E0007004C6162656C3230010100000039000000070043617074696F6E00
      0F0063624175746F43616C69627261746501010000003A000000070043617074
      696F6E000C00566964656F57696E646F7731000007004C6162656C3133010100
      00003B000000070043617074696F6E0007004C6162656C313401010000003C00
      0000070043617074696F6E00090054616253686565743301010000003F000000
      070043617074696F6E00080074624E6F697365310000080074624E6F69736532
      000007004C6162656C3231010100000040000000070043617074696F6E000700
      4C6162656C3232010100000041000000070043617074696F6E00}
  end
end
