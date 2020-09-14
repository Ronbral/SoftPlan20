object FDownHist: TFDownHist
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FDownHist'
  ClientHeight = 452
  ClientWidth = 729
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Padding.Top = 44
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lb1: TLabel
    Left = 10
    Top = 13
    Width = 242
    Height = 19
    Caption = 'Hist'#243'rico de Downloads realizados'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object p1: TPanel
    Left = 0
    Top = 408
    Width = 729
    Height = 44
    Align = alBottom
    Caption = 'pn1'
    Color = clWhite
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 540
    object pOpts: TPanel
      Left = 543
      Top = 1
      Width = 185
      Height = 42
      Align = alRight
      BevelOuter = bvNone
      Caption = 'pOpts'
      ShowCaption = False
      TabOrder = 0
      ExplicitLeft = 584
      ExplicitTop = 8
      ExplicitHeight = 41
      object btSair: TButton
        Left = 88
        Top = 5
        Width = 76
        Height = 25
        Caption = 'Voltar'
        TabOrder = 0
        TabStop = False
        OnClick = btSairClick
      end
    end
  end
  object dbg: TDBGrid
    Left = 0
    Top = 44
    Width = 729
    Height = 364
    Align = alClient
    DataSource = ds_TbHist
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'URL'
        Title.Caption = 'Link '
        Width = 500
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATAINICIO'
        Title.Caption = 'In'#237'cio'
        Width = 96
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATAFIM'
        Title.Caption = 'T'#233'rmino'
        Width = 96
        Visible = True
      end>
  end
  object ds_TbHist: TDataSource
    Left = 360
    Top = 128
  end
end
