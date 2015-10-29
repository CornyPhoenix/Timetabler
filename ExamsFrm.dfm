object ExamForm: TExamForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Arbeits- und Klausurplaner'
  ClientHeight = 346
  ClientWidth = 641
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
  object Panel: TPanel
    Left = 0
    Top = 305
    Width = 641
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object Bevel: TBevel
      Left = 0
      Top = 0
      Width = 641
      Height = 2
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = 400
      ExplicitWidth = 50
    end
    object btnReady: TButton
      Left = 560
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Fertig'
      TabOrder = 0
      OnClick = btnReadyClick
    end
    object btnNew: TButton
      Left = 8
      Top = 8
      Width = 209
      Height = 25
      Caption = '&Neue Arbeit oder Klausur hinzuf'#252'gen'
      TabOrder = 1
      OnClick = btnNewClick
    end
    object btnChange: TButton
      Left = 223
      Top = 8
      Width = 130
      Height = 25
      Caption = '&Bearbeiten / L'#246'schen'
      Enabled = False
      TabOrder = 2
      OnClick = btnChangeClick
    end
  end
  object View: TListView
    Left = 0
    Top = 0
    Width = 641
    Height = 305
    Align = alClient
    BorderStyle = bsNone
    Columns = <
      item
        Caption = 'Name'
        Width = 160
      end
      item
        Caption = 'Fach'
        Width = 100
      end
      item
        Alignment = taCenter
        Caption = 'Datum'
        Width = 100
      end
      item
        Alignment = taCenter
        Caption = 'Stunden'
        Width = 60
      end
      item
        Caption = 'Information/Thema'
        Width = 190
      end>
    SmallImages = MainForm.List2
    TabOrder = 1
    ViewStyle = vsReport
    OnChange = ViewChange
    OnDblClick = btnChangeClick
    OnSelectItem = ViewSelectItem
    ExplicitLeft = -8
    ExplicitTop = 2
  end
end
