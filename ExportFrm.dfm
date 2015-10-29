object frmExport: TfrmExport
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmExport'
  ClientHeight = 322
  ClientWidth = 385
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Head: TLabel
    Left = 16
    Top = 16
    Width = 87
    Height = 13
    Caption = 'Grafik exportieren'
  end
  object Label1: TLabel
    Left = 16
    Top = 48
    Width = 102
    Height = 13
    Caption = 'Aufl'#246'sung der Grafik:'
  end
  object Label2: TLabel
    Left = 16
    Top = 70
    Width = 32
    Height = 13
    Caption = '&Breite:'
    FocusControl = edtW
  end
  object Label3: TLabel
    Left = 195
    Top = 70
    Width = 29
    Height = 13
    Caption = '&H'#246'he:'
    FocusControl = edtH
  end
  object Label4: TLabel
    Left = 327
    Top = 70
    Width = 39
    Height = 13
    Caption = 'in Pixeln'
  end
  object Label5: TLabel
    Left = 16
    Top = 104
    Width = 185
    Height = 13
    Caption = '&Antialiasing (Versch'#246'nern der Kanten):'
    FocusControl = Antialiasing
  end
  object Label6: TLabel
    Left = 16
    Top = 159
    Width = 89
    Height = 13
    Caption = 'Weitere Optionen:'
  end
  object Panel: TBottomPanel
    Left = 0
    Top = 281
    Width = 385
    TabOrder = 0
    ExplicitTop = 273
    ExplicitWidth = 425
    object btnCancel: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'A&bbrechen'
      ModalResult = 2
      TabOrder = 0
    end
    object btnOK: TButton
      Left = 302
      Top = 8
      Width = 75
      Height = 25
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 1
    end
  end
  object edtW: TEdit
    Left = 56
    Top = 67
    Width = 89
    Height = 21
    Alignment = taRightJustify
    NumbersOnly = True
    TabOrder = 1
    Text = '1000'
    TextHint = 'Breite'
  end
  object edtH: TEdit
    Left = 232
    Top = 67
    Width = 89
    Height = 21
    Alignment = taRightJustify
    NumbersOnly = True
    TabOrder = 2
    Text = '700'
    TextHint = 'H'#246'he'
  end
  object Antialiasing: TComboBox
    Left = 16
    Top = 123
    Width = 225
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 3
    Text = 'Kein Antialiasing'
    Items.Strings = (
      'Kein Antialiasing'
      '2-faches Antialiasing'
      '3-faches Antialiasing'
      '4-faches Antialiasing'
      '5-faches Antialiasing'
      '6-faches Antialiasing')
  end
  object cbxShowDates: TCheckBox
    Left = 16
    Top = 178
    Width = 350
    Height = 17
    Action = MainForm.acShowDates
    State = cbChecked
    TabOrder = 4
  end
  object cbxBW: TCheckBox
    Left = 16
    Top = 201
    Width = 350
    Height = 17
    Action = MainForm.acBW
    TabOrder = 5
  end
  object cbxFramed: TCheckBox
    Left = 16
    Top = 224
    Width = 350
    Height = 17
    Action = MainForm.acDrawRects
    State = cbChecked
    TabOrder = 6
  end
  object cbxShorts: TCheckBox
    Left = 16
    Top = 247
    Width = 350
    Height = 17
    Action = MainForm.acAbbreviation
    State = cbChecked
    TabOrder = 7
  end
end
