object frmPrint: TfrmPrint
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Drucken'
  ClientHeight = 656
  ClientWidth = 649
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 438
    Top = 41
    Width = 62
    Height = 13
    Caption = 'Druckmodus:'
  end
  object Label2: TLabel
    Left = 438
    Top = 97
    Width = 52
    Height = 13
    Caption = 'Planbreite:'
  end
  object Label3: TLabel
    Left = 565
    Top = 119
    Width = 13
    Height = 13
    Caption = 'cm'
  end
  object Label4: TLabel
    Left = 438
    Top = 153
    Width = 48
    Height = 13
    Caption = 'Planh'#246'he:'
  end
  object Label5: TLabel
    Left = 565
    Top = 175
    Width = 13
    Height = 13
    Caption = 'cm'
  end
  object Head: TLabel
    Left = 16
    Top = 16
    Width = 39
    Height = 13
    Caption = 'Drucken'
  end
  object Panel: TPanel
    Left = 0
    Top = 615
    Width = 649
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    OnResize = PanelResize
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 649
      Height = 8
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = 352
      ExplicitTop = 8
      ExplicitWidth = 50
    end
    object btnOK: TButton
      Left = 565
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Drucken'
      TabOrder = 0
      OnClick = btnOKClick
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
  object Panel2: TPanel
    Left = 16
    Top = 41
    Width = 409
    Height = 100
    BevelInner = bvLowered
    BevelOuter = bvSpace
    BevelWidth = 2
    Caption = '(Vorschau)'
    Color = clBackground
    ParentBackground = False
    TabOrder = 1
    OnResize = Panel2Resize
    object Preview: TImage
      Left = 4
      Top = 4
      Width = 401
      Height = 92
      Align = alClient
      ExplicitLeft = 88
      ExplicitTop = 112
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
  end
  object Modus: TComboBox
    Left = 438
    Top = 60
    Width = 195
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 2
    Text = '2 Pl'#228'ne pro Blatt (Handheld-Modus)'
    OnChange = ModusChange
    Items.Strings = (
      '2 Pl'#228'ne pro Blatt (Handheld-Modus)')
  end
  object PWidth: TEdit
    Left = 438
    Top = 116
    Width = 121
    Height = 21
    Alignment = taRightJustify
    TabOrder = 3
    Text = '15,0'
    OnExit = PWidthExit
    OnKeyPress = PWidthKeyPress
  end
  object PHeight: TEdit
    Left = 438
    Top = 172
    Width = 121
    Height = 21
    Alignment = taRightJustify
    TabOrder = 4
    Text = '10,5'
    OnExit = PWidthExit
    OnKeyPress = PWidthKeyPress
  end
  object BW: TCheckBox
    Left = 438
    Top = 207
    Width = 97
    Height = 17
    Caption = 'Schwarzwei'#223
    TabOrder = 5
    OnClick = ModusChange
  end
  object FM: TCheckBox
    Left = 438
    Top = 230
    Width = 163
    Height = 17
    Caption = 'Rahmen um Stunden'
    TabOrder = 6
    OnClick = ModusChange
  end
  object Dialog: TPrintDialog
    Left = 592
    Top = 88
  end
end
