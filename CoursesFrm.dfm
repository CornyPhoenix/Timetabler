object frmCourses: TfrmCourses
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmCourses'
  ClientHeight = 322
  ClientWidth = 617
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
  object Head: TLabel
    Left = 16
    Top = 16
    Width = 119
    Height = 13
    Caption = 'Kurse und Lehrer '#228'ndern'
  end
  object Image: TImage
    Left = 543
    Top = 16
    Width = 58
    Height = 58
  end
  object Label1: TLabel
    Left = 16
    Top = 48
    Width = 114
    Height = 13
    Caption = '&Hauptkurs / Fachlehrer:'
    FocusControl = edtMainteacher
  end
  object Label2: TLabel
    Left = 16
    Top = 104
    Width = 92
    Height = 13
    Caption = '&Vorhandene Kurse:'
  end
  object labCCount: TLabel
    Left = 551
    Top = 104
    Width = 50
    Height = 13
    Alignment = taRightJustify
    Caption = 'labCCount'
  end
  object Panel: TPanel
    Left = 0
    Top = 281
    Width = 617
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object Bevel: TBevel
      Left = 0
      Top = 0
      Width = 617
      Height = 2
      Align = alTop
      Shape = bsTopLine
      ExplicitWidth = 645
    end
    object labHint: TLabel
      Left = 8
      Top = 14
      Width = 33
      Height = 13
      Caption = 'labHint'
    end
    object btnOK: TButton
      Left = 536
      Top = 8
      Width = 75
      Height = 25
      Caption = '&OK'
      Default = True
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  object edtMainteacher: TEdit
    Left = 16
    Top = 67
    Width = 353
    Height = 21
    Hint = #196'ndert den Hauptfachlehrer.'
    TabOrder = 1
    Text = 'edtMainteacher'
    OnChange = edtMainteacherChange
  end
  object View: TListView
    Left = 16
    Top = 123
    Width = 585
    Height = 110
    Columns = <
      item
        Caption = 'Kursname'
        Width = 250
      end
      item
        Caption = 'Lehrer'
        Width = 150
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
    OnSelectItem = ViewSelectItem
  end
  object edtCourseName: TEdit
    Left = 16
    Top = 239
    Width = 249
    Height = 21
    TabOrder = 3
    Text = 'edtCourseName'
  end
  object edtTeacher: TEdit
    Left = 271
    Top = 239
    Width = 146
    Height = 21
    TabOrder = 4
    Text = 'edtTeacher'
  end
  object btnNew: TButton
    Left = 423
    Top = 237
    Width = 43
    Height = 25
    Hint = 'F'#252'gt einen neuen Kurs mit diesen Eigenschaften hinzu.'
    Caption = '&Neu'
    TabOrder = 5
    OnClick = btnNewClick
  end
  object btnDelete: TButton
    Left = 472
    Top = 237
    Width = 65
    Height = 25
    Hint = 'L'#246'scht den markierten Kurs.'
    Caption = '&L'#246'schen'
    TabOrder = 6
    OnClick = btnDeleteClick
  end
  object btnChange: TButton
    Left = 543
    Top = 237
    Width = 58
    Height = 25
    Hint = #196'ndert den markierten Kurs.'
    Caption = '&'#196'ndern'
    TabOrder = 7
    OnClick = btnChangeClick
  end
end
