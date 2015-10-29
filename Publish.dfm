object frmPublish: TfrmPublish
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  ClientHeight = 202
  ClientWidth = 393
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Head: TLabel
    Left = 16
    Top = 16
    Width = 73
    Height = 13
    Caption = 'Ver'#246'ffentlichen'
  end
  object Label1: TLabel
    Left = 16
    Top = 48
    Width = 119
    Height = 13
    Caption = '&Name des Stundenplans:'
    FocusControl = edtName
  end
  object Error: TLabel
    Left = 16
    Top = 94
    Width = 361
    Height = 51
    AutoSize = False
    Visible = False
    WordWrap = True
  end
  object Panel: TPanel
    Left = 0
    Top = 161
    Width = 393
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    OnResize = PanelResize
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 393
      Height = 2
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = 304
      ExplicitWidth = 50
    end
    object btnPublish: TButton
      Left = 278
      Top = 8
      Width = 107
      Height = 25
      Caption = 'Ver'#246'ffentlichen'
      Default = True
      TabOrder = 0
      OnClick = btnPublishClick
    end
    object btnCancel: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Abbrechen'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object edtName: TEdit
    Left = 16
    Top = 67
    Width = 265
    Height = 21
    TabOrder = 1
    Text = 'edtName'
    OnChange = edtNameChange
  end
end
