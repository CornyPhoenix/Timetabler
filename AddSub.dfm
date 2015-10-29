object frmAddSub: TfrmAddSub
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Neues Fach hinzuf'#252'gen'
  ClientHeight = 322
  ClientWidth = 329
  Color = clWindow
  Constraints.MaxHeight = 360
  Constraints.MinHeight = 360
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
  object Label1: TLabel
    Left = 16
    Top = 48
    Width = 119
    Height = 13
    Caption = 'Name des Fachs/der AG:'
  end
  object Label2: TLabel
    Left = 16
    Top = 104
    Width = 89
    Height = 13
    Caption = 'Lehrer/Betreuung:'
  end
  object Head: TLabel
    Left = 16
    Top = 16
    Width = 112
    Height = 13
    Caption = 'Neues Fach hinzuf'#252'gen'
  end
  object Label3: TLabel
    Left = 18
    Top = 159
    Width = 108
    Height = 13
    Caption = 'Bild der AG/des Fachs:'
  end
  object Label4: TLabel
    Left = 113
    Top = 178
    Width = 200
    Height = 13
    AutoSize = False
    Caption = '...'
  end
  object Panel: TPanel
    Left = 0
    Top = 281
    Width = 329
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 2
    OnResize = PanelResize
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 329
      Height = 2
      Align = alTop
      Shape = bsTopLine
      ExplicitWidth = 332
    end
    object btnOK: TButton
      Left = 248
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      Enabled = False
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Abbrechen'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Sub: TEdit
    Left = 16
    Top = 67
    Width = 297
    Height = 21
    TabOrder = 0
    TextHint = 'Namen eingeben ...'
    OnChange = SubChange
  end
  object Teacher: TEdit
    Left = 16
    Top = 123
    Width = 297
    Height = 21
    TabOrder = 1
    TextHint = 'Lehrkraft oder Betreuung eingeben ...'
    OnChange = SubChange
  end
  object Panel1: TPanel
    Left = 16
    Top = 176
    Width = 91
    Height = 91
    BevelWidth = 2
    Caption = '(Vorschau)'
    ParentBackground = False
    TabOrder = 3
    object Preview: TImage
      Left = 2
      Top = 2
      Width = 87
      Height = 87
      Cursor = crHandPoint
      Align = alClient
      OnClick = btnImportClick
      ExplicitLeft = 0
      ExplicitTop = 12
    end
  end
  object btnImport: TButton
    Left = 238
    Top = 242
    Width = 75
    Height = 25
    Caption = 'Importieren'
    TabOrder = 4
    OnClick = btnImportClick
  end
  object OldPic: TCheckBox
    Left = 152
    Top = 246
    Width = 80
    Height = 17
    Caption = 'Altes Bild'
    Checked = True
    State = cbChecked
    TabOrder = 5
    Visible = False
  end
  object Open: TOpenDialog
    DefaultExt = '.png'
    Filter = 'Portable Network Graphic|*.png'
    Left = 200
    Top = 224
  end
end
