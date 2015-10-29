object frmPacklist: TfrmPacklist
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Packliste'
  ClientHeight = 346
  ClientWidth = 633
  Color = clWindow
  Constraints.MaxHeight = 384
  Constraints.MinHeight = 384
  Constraints.MinWidth = 400
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 119
    Height = 13
    Caption = 'Packliste von %s auf %s'
  end
  object Label2: TLabel
    Left = 16
    Top = 48
    Width = 220
    Height = 13
    Caption = 'Folgende F'#228'cher m'#252'ssen ausgepackt werden:'
  end
  object BoxOut: TPaintBox
    Left = 16
    Top = 67
    Width = 601
    Height = 90
    OnPaint = BoxOutPaint
  end
  object BoxIn: TPaintBox
    Left = 16
    Top = 182
    Width = 601
    Height = 90
    OnPaint = BoxOutPaint
  end
  object Label3: TLabel
    Left = 16
    Top = 163
    Width = 217
    Height = 13
    Caption = 'Folgende F'#228'cher m'#252'ssen eingepackt werden:'
  end
  object labExams: TLabel
    Left = 16
    Top = 278
    Width = 149
    Height = 20
    AutoSize = False
    Caption = 'Folgende Klausuren stehen an:'
  end
  object Panel: TPanel
    Left = 0
    Top = 305
    Width = 633
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    OnResize = PanelResize
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 633
      Height = 2
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = 392
      ExplicitTop = 8
      ExplicitWidth = 50
    end
    object btnOK: TButton
      Left = 552
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnOther: TButton
      Left = 8
      Top = 8
      Width = 161
      Height = 25
      Caption = '%s'
      TabOrder = 1
      OnClick = btnOtherClick
    end
  end
  object Glower: TTimer
    Enabled = False
    Interval = 20
    OnTimer = GlowerTimer
    Left = 592
    Top = 256
  end
end
