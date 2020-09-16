object FMsgDlg: TFMsgDlg
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FMsgDlg'
  ClientHeight = 224
  ClientWidth = 424
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Padding.Top = 32
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object im1: TImage
    Left = 392
    Top = 0
    Width = 32
    Height = 32
    AutoSize = True
    Picture.Data = {
      0954506E67496D61676589504E470D0A1A0A0000000D49484452000000200000
      00200802000000FC18EDA30000001974455874536F6674776172650041646F62
      6520496D616765526561647971C9653C0000031869545874584D4C3A636F6D2E
      61646F62652E786D7000000000003C3F787061636B657420626567696E3D22EF
      BBBF222069643D2257354D304D7043656869487A7265537A4E54637A6B633964
      223F3E203C783A786D706D65746120786D6C6E733A783D2261646F62653A6E73
      3A6D6574612F2220783A786D70746B3D2241646F626520584D5020436F726520
      352E302D633036302036312E3133343334322C20323031302F30312F31302D31
      383A30363A34332020202020202020223E203C7264663A52444620786D6C6E73
      3A7264663D22687474703A2F2F7777772E77332E6F72672F313939392F30322F
      32322D7264662D73796E7461782D6E7323223E203C7264663A44657363726970
      74696F6E207264663A61626F75743D222220786D6C6E733A786D703D22687474
      703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F2220786D6C6E73
      3A786D704D4D3D22687474703A2F2F6E732E61646F62652E636F6D2F7861702F
      312E302F6D6D2F2220786D6C6E733A73745265663D22687474703A2F2F6E732E
      61646F62652E636F6D2F7861702F312E302F73547970652F5265736F75726365
      526566232220786D703A43726561746F72546F6F6C3D2241646F62652050686F
      746F73686F70204353352220786D704D4D3A496E7374616E636549443D22786D
      702E6969643A3939333338373832463630433131454141393646454241384438
      3945393338412220786D704D4D3A446F63756D656E7449443D22786D702E6469
      643A393933333837383346363043313145414139364645424138443839453933
      3841223E203C786D704D4D3A4465726976656446726F6D2073745265663A696E
      7374616E636549443D22786D702E6969643A3939333338373830463630433131
      454141393646454241384438394539333841222073745265663A646F63756D65
      6E7449443D22786D702E6469643A393933333837383146363043313145414139
      3646454241384438394539333841222F3E203C2F7264663A4465736372697074
      696F6E3E203C2F7264663A5244463E203C2F783A786D706D6574613E203C3F78
      7061636B657420656E643D2272223F3ECD94F101000001214944415478DA63FC
      FFFF3F03CDC0C2850B19472D18C216FC07831933666664A4338201952DF8F7EF
      5F6767272F2FDFE7CF9FCACBCB999898A8690150D7C3870F7FFCF8B16BD72E37
      37370E0E0E7979794C4F9069C1E3C78FD7AE5DE7E5E5F9FBF7EFDDBBF7B8BABA
      B0B2B26EDBB63D2F2F172DACC8B4A0B9B9998787E7CB972F40361AA3BABA1A39
      ACC8B4E0D6AD5BCB972F0F0C0C04EADDBD678FAB8B0BD0D5EBD7AF8F8C8C5456
      56666666A6D482BB77EF0203E7EFDFBFC078DEB163A787873BD0D540738101A5
      A8A848051F00CD7DF4E8D1AF5FBF962C59CACDC3FDF5CBD79898683636363939
      39EAC40103522A5ABA7459747414955311DC1FF7EFDF0706143070D042863A16
      FC87014618A0B205C480510B462D18B560D482510B868A050067122030E914A1
      DA0000000049454E44AE426082}
  end
  object pnArea: TPanel
    Left = 0
    Top = 32
    Width = 424
    Height = 192
    Margins.Top = 32
    Align = alClient
    Caption = 'pnArea'
    ShowCaption = False
    TabOrder = 0
    ExplicitTop = 0
    ExplicitHeight = 224
    object pnImg: TPanel
      Left = 1
      Top = 1
      Width = 88
      Height = 190
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'pnImg'
      ShowCaption = False
      TabOrder = 0
      ExplicitHeight = 222
      object PicShow: TPicShow
        Left = 0
        Top = 0
        Width = 88
        Height = 190
        Align = alClient
        Center = True
        Color = clWhite
        Delay = 20
        ParentColor = False
        Proportional = True
        TabOrder = 0
        ExplicitLeft = 32
        ExplicitTop = 112
        ExplicitWidth = 100
        ExplicitHeight = 100
      end
    end
    object pnMsg: TPanel
      Left = 89
      Top = 1
      Width = 334
      Height = 190
      Align = alClient
      BevelOuter = bvNone
      Caption = 'pnMsg'
      ShowCaption = False
      TabOrder = 1
      ExplicitHeight = 222
      object lbMsg: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 0
        Width = 37
        Height = 18
        Margins.Left = 8
        Margins.Top = 0
        Margins.Right = 16
        Margins.Bottom = 16
        Align = alClient
        Caption = 'lbMsg'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ShowAccelChar = False
        WordWrap = True
      end
      object pnBts: TPanel
        Left = 0
        Top = 146
        Width = 334
        Height = 44
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'pnBts'
        ShowCaption = False
        TabOrder = 0
        ExplicitTop = 178
        object pnOk: TPanel
          Left = 214
          Top = 0
          Width = 120
          Height = 44
          Align = alRight
          BevelOuter = bvNone
          Caption = 'pnOk'
          ShowCaption = False
          TabOrder = 0
          object btOk: TButton
            Tag = 1
            Left = 20
            Top = 8
            Width = 80
            Height = 25
            Caption = 'Ok'
            TabOrder = 0
            OnClick = btOpcaoClick
          end
        end
        object pnSim: TPanel
          Left = -6
          Top = 0
          Width = 100
          Height = 44
          Align = alRight
          BevelOuter = bvNone
          Caption = 'pOk'
          ShowCaption = False
          TabOrder = 1
          object btSim: TButton
            Tag = 2
            Left = 10
            Top = 8
            Width = 80
            Height = 25
            Caption = 'Sim'
            TabOrder = 0
            OnClick = btOpcaoClick
          end
        end
        object pnNao: TPanel
          Left = 94
          Top = 0
          Width = 120
          Height = 44
          Align = alRight
          BevelOuter = bvNone
          Caption = 'pOk'
          ShowCaption = False
          TabOrder = 2
          object btNao: TButton
            Tag = 3
            Left = 20
            Top = 8
            Width = 80
            Height = 25
            Caption = 'N'#227'o'
            TabOrder = 0
            OnClick = btOpcaoClick
          end
        end
      end
    end
  end
end
