object frmSubject: TfrmSubject
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Stunde bearbeiten'
  ClientHeight = 178
  ClientWidth = 337
  Color = clWindow
  Constraints.MaxHeight = 216
  Constraints.MinHeight = 206
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
  object Label3: TLabel
    Left = 16
    Top = 45
    Width = 27
    Height = 13
    Caption = 'Fach:'
  end
  object Label5: TLabel
    Left = 16
    Top = 99
    Width = 31
    Height = 13
    Caption = 'Raum:'
  end
  object btnClassR: TLabel
    Left = 167
    Top = 99
    Width = 30
    Height = 13
    Cursor = crHandPoint
    Caption = 'Klasse'
    OnClick = btnClassRClick
    OnMouseEnter = btnChangeMouseEnter
    OnMouseLeave = btnChangeMouseLeave
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 16
    Top = 72
    Width = 25
    Height = 13
    Caption = 'Kurs:'
  end
  object btnChange: TLabel
    Left = 271
    Top = 72
    Width = 50
    Height = 13
    Cursor = crHandPoint
    Caption = #196'ndern ...'
    OnClick = btnChangeClick
    OnMouseEnter = btnChangeMouseEnter
    OnMouseLeave = btnChangeMouseLeave
  end
  object Teacher: TLabel
    Left = 88
    Top = 72
    Width = 39
    Height = 13
    Caption = 'Teacher'
  end
  object Panel: TPanel
    Left = 0
    Top = 137
    Width = 337
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    OnResize = PanelResize
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 337
      Height = 8
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = 208
      ExplicitTop = 8
      ExplicitWidth = 50
    end
    object btnOK: TButton
      Left = 256
      Top = 9
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 8
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Abbrechen'
      ModalResult = 2
      TabOrder = 1
    end
    object btnClear: TButton
      Left = 192
      Top = 9
      Width = 58
      Height = 25
      Caption = 'Leeren'
      ModalResult = 6
      TabOrder = 2
      OnClick = btnClearClick
    end
  end
  object Subject: TComboBox
    Left = 88
    Top = 42
    Width = 233
    Height = 21
    Style = csDropDownList
    TabOrder = 1
    OnChange = SubjectChange
  end
  object Room: TEdit
    Left = 88
    Top = 96
    Width = 73
    Height = 21
    Alignment = taCenter
    TabOrder = 2
    TextHint = 'Kein Raum'
    OnChange = RoomChange
    OnExit = RoomExit
    OnKeyPress = RoomKeyPress
  end
  object Course: TComboBox
    Left = 88
    Top = 69
    Width = 177
    Height = 21
    Style = csDropDownList
    TabOrder = 3
  end
end
