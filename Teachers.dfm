object frmTeachers: TfrmTeachers
  Left = 0
  Top = 0
  Caption = 'Lehrerliste'
  ClientHeight = 412
  ClientWidth = 584
  Color = clBtnFace
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ScreenSnap = True
  SnapBuffer = 20
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Editor: TListView
    Left = 0
    Top = 0
    Width = 584
    Height = 371
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Columns = <
      item
        Caption = 'Fach'
        Width = 200
      end
      item
        Caption = 'Lehrer'
        Width = 300
      end>
    DragCursor = crDefault
    DragMode = dmAutomatic
    GridLines = True
    ReadOnly = True
    RowSelect = True
    SmallImages = MainForm.List2
    TabOrder = 0
    ViewStyle = vsReport
    OnCustomDrawSubItem = EditorCustomDrawSubItem
    OnDblClick = EditorDblClick
    OnEndDrag = EditorEndDrag
    OnSelectItem = EditorSelectItem
    OnStartDrag = EditorStartDrag
  end
  object Panel: TPanel
    Left = 0
    Top = 371
    Width = 584
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    OnResize = PanelResize
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 584
      Height = 2
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = 336
      ExplicitTop = 16
      ExplicitWidth = 50
    end
    object btnNew: TButton
      Left = 504
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Neues Fach'
      TabOrder = 0
      OnClick = btnNewClick
    end
    object btnDelete: TButton
      Left = 408
      Top = 8
      Width = 90
      Height = 25
      Caption = 'Fach l'#246'schen'
      Enabled = False
      TabOrder = 1
      OnClick = btnDeleteClick
    end
    object btnDock: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'An&docken'
      TabOrder = 2
      OnClick = btnDockClick
    end
  end
end
