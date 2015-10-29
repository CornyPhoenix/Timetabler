object frmProperties: TfrmProperties
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Optionen'
  ClientHeight = 330
  ClientWidth = 417
  Color = clWindow
  Constraints.MinHeight = 320
  Constraints.MinWidth = 433
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 48
    Width = 24
    Height = 13
    Caption = 'Titel:'
  end
  object Label2: TLabel
    Left = 16
    Top = 75
    Width = 34
    Height = 13
    Caption = 'Klasse:'
  end
  object Label3: TLabel
    Left = 16
    Top = 104
    Width = 248
    Height = 13
    Caption = 'Zusatzinformationen (z.B. Halbjahr, G'#252'ltigkeit etc.):'
  end
  object Label4: TLabel
    Left = 266
    Top = 75
    Width = 64
    Height = 13
    Caption = 'Klassenraum:'
  end
  object Head: TLabel
    Left = 16
    Top = 16
    Width = 121
    Height = 13
    Caption = 'Eigenschaften ver'#228'ndern'
  end
  object Label5: TLabel
    Left = 16
    Top = 234
    Width = 36
    Height = 13
    Caption = 'Design:'
  end
  object Panel: TPanel
    Left = 0
    Top = 289
    Width = 417
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 4
    OnResize = PanelResize
    ExplicitTop = 241
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 417
      Height = 8
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = 344
      ExplicitTop = 16
      ExplicitWidth = 50
    end
    object btnOK: TButton
      Left = 335
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 9
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Abbrechen'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Title: TEdit
    Left = 72
    Top = 45
    Width = 329
    Height = 21
    TabOrder = 0
  end
  object Form: TEdit
    Left = 72
    Top = 72
    Width = 105
    Height = 21
    TabOrder = 1
  end
  object Adds: TMemo
    Left = 16
    Top = 123
    Width = 385
    Height = 102
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 3
    WantReturns = False
  end
  object ClassR: TEdit
    Left = 352
    Top = 72
    Width = 49
    Height = 21
    TabOrder = 2
  end
  object cbxClearQuads: TCheckBox
    Left = 16
    Top = 258
    Width = 385
    Height = 17
    Caption = 'Leere F'#228'cher mit grauem Quadrat anzeigen'
    TabOrder = 5
  end
  object Design: TComboBox
    Left = 72
    Top = 231
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 6
    Items.Strings = (
      'Gelb (Standard)'
      'Grau'
      'Ozeanblau'
      'Mattes Schwarz'
      'Strahlendwei'#223
      'Feuerrot')
  end
end
