object NewExam: TNewExam
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 274
  ClientWidth = 321
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 47
    Width = 27
    Height = 13
    Caption = '&Fach:'
    FocusControl = Subject
  end
  object Label2: TLabel
    Left = 16
    Top = 75
    Width = 31
    Height = 13
    Caption = '&Name:'
    FocusControl = ExamName
  end
  object Label3: TLabel
    Left = 16
    Top = 102
    Width = 60
    Height = 13
    Caption = '&Info/Thema:'
    FocusControl = Info
  end
  object Label4: TLabel
    Left = 16
    Top = 169
    Width = 63
    Height = 13
    Caption = 'Pr'#252'fungs&tag:'
    FocusControl = Date
  end
  object Label5: TLabel
    Left = 16
    Top = 196
    Width = 38
    Height = 13
    Caption = '&Stunde:'
  end
  object Head: TLabel
    Left = 16
    Top = 16
    Width = 176
    Height = 13
    Caption = 'Neue Arbeit oder Klausur hinzuf'#252'gen'
  end
  object Label6: TLabel
    Left = 201
    Top = 196
    Width = 33
    Height = 13
    Caption = '&L'#228'nge:'
  end
  object Panel: TPanel
    Left = 0
    Top = 233
    Width = 321
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object Bevel: TBevel
      Left = 0
      Top = 0
      Width = 321
      Height = 2
      Align = alTop
      Shape = bsTopLine
      ExplicitWidth = 635
    end
    object btnCancel: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Abbrechen'
      ModalResult = 2
      TabOrder = 0
    end
    object btnOK: TButton
      Left = 238
      Top = 8
      Width = 75
      Height = 25
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
    object btnDelete: TButton
      Left = 89
      Top = 8
      Width = 75
      Height = 25
      Caption = '&L'#246'schen'
      ModalResult = 2
      TabOrder = 2
    end
  end
  object Subject: TComboBoxEx
    Left = 112
    Top = 44
    Width = 193
    Height = 22
    ItemsEx = <>
    Style = csExDropDownList
    TabOrder = 1
    OnChange = SubjectChange
    Images = MainForm.List2
  end
  object ExamName: TEdit
    Left = 112
    Top = 72
    Width = 193
    Height = 21
    TabOrder = 2
    Text = 'ExamName'
    TextHint = 'F'#252'gen Sie einen Namen hinzu.'
    OnChange = ExamNameChange
  end
  object Info: TMemo
    Left = 112
    Top = 99
    Width = 193
    Height = 61
    Lines.Strings = (
      'Info')
    TabOrder = 3
    WantReturns = False
  end
  object Date: TDateTimePicker
    Left = 112
    Top = 166
    Width = 193
    Height = 21
    Date = 40272.532937581020000000
    Time = 40272.532937581020000000
    TabOrder = 4
  end
  object StartLes: TSpinEdit
    Left = 112
    Top = 193
    Width = 57
    Height = 22
    MaxValue = 12
    MinValue = 1
    TabOrder = 5
    Value = 1
    OnChange = StartLesChange
  end
  object Length: TSpinEdit
    Left = 248
    Top = 193
    Width = 57
    Height = 22
    MaxValue = 12
    MinValue = 1
    TabOrder = 6
    Value = 1
  end
end
