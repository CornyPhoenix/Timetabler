unit FormPrint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Printers, Timetable, PNGFuncs;

type
  TfrmPrint = class(TForm)
    Panel: TPanel;
    Bevel1: TBevel;
    Panel2: TPanel;
    Label1: TLabel;
    Modus: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    Preview: TImage;
    Label2: TLabel;
    PWidth: TEdit;
    Label3: TLabel;
    PHeight: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    BW: TCheckBox;
    Dialog: TPrintDialog;
    Head: TLabel;
    FM: TCheckBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure PanelResize(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ModusChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PWidthKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
    procedure PWidthExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FOld: TPNG;
    FCalc: Boolean;
    FPage: TPoint;
    FPageMetric: TPoint;
    function GetFullClip: Boolean;
    procedure UpdatePreview;
    function GetPageBounds( Index: Integer ): Single;
    function WidthToPixel( aMilimeter: Single ): Integer;
    function HeightToPixel( aMilimeter: Single ): Integer;
  public
    procedure Print( aPreview: Boolean );
    property Fullclip: Boolean read GetFullClip;
  published
    property PW: Single index 0 read GetPageBounds;
    property PH: Single index 1 read GetPageBounds;
  end;

var
  frmPrint: TfrmPrint;

const
  A4Scale = 0.70707070707070707070707070707071;

implementation

uses
  Main, Global;

{$R *.dfm}

function TfrmPrint.WidthToPixel( aMilimeter: Single ): Integer;
begin
  Result := Round( aMilimeter * FPage.X / FPageMetric.X );
end;

function TfrmPrint.HeightToPixel( aMilimeter: Single ): Integer;
begin
  Result := Round( aMilimeter * FPage.X / FPageMetric.X );
end;

procedure TfrmPrint.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrint.btnOKClick(Sender: TObject);
begin
  Print( False );
  Close;
end;

procedure TfrmPrint.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.FTimetable.BlackWhite := MaiNForm.acBW.Checked;
  MainForm.FTimetable.ShowDates := True;
  MainForm.FTimetable.FramedSubjects := MainForm.acDrawRects.Checked;
  MainForm.FTimetable.DrawBorder := False;
end;

procedure TfrmPrint.FormCreate(Sender: TObject);
begin
  FCalc := False;
  FOld := TPNG.Create;
  DesignForm( Self );
  DesignLabel( Head );
  Caption := Application.Title;
end;

procedure TfrmPrint.FormDestroy(Sender: TObject);
begin
  FOld.Free;
end;

procedure TfrmPrint.FormResize(Sender: TObject);
var
  L: Integer;
begin
  Panel2.Height := ClientHeight - Panel.Height - Panel2.Top - 16;
  Panel2.Width := Round( Panel2.Height * A4Scale );
  L := Panel2.Width + Panel2.Left + 16;
  Label1.Left := L;
  Label2.Left := L;
  Label4.Left := L;
  Modus.Width := ClientWidth - L - 16;
  Modus.Left := L;
  PWidth.Left := L;
  PHeight.Left := L;
  BW.Left := L;
  FM.Left := L;
  L := L + PWidth.Width + 8;
  Label3.Left := L;
  Label5.Left := L;
end;

procedure TfrmPrint.FormShow(Sender: TObject);
begin
  MainForm.FTimetable.ShowDates := False;
  MainForm.FTimetable.DrawBorder := True;
  Print( True );
  FormResize( Sender );
end;

procedure TfrmPrint.Panel2Resize(Sender: TObject);
begin
  UpdatePreview;
end;

procedure TfrmPrint.PanelResize(Sender: TObject);
begin
  btnOK.Left := Panel.Width - btnOK.Width - 8;
end;

procedure TfrmPrint.Print(aPreview: Boolean);
var
  Cont, PNG: TPNG;
  mLeft, mTop: Integer;
begin
  if not aPreview then
    begin
      // Dialog anzeigen
      if not Dialog.Execute then
        Exit;
      // Seitengröße setzen
      FPage.X := Printer.PageWidth;
      FPage.Y := Printer.PageHeight;
      // Drucker starten
      Printer.Title := MainForm.FTimeTable.Header.Title + ' ' + MainForm.FTimeTable.Header.Form;
      if FullClip then
        Printer.Orientation := poLandscape;
      // Anfangen
      Printer.BeginDoc;
      FPageMetric.X := GetDeviceCaps( Printer.Canvas.Handle, HORZSIZE );
      FPageMetric.Y := GetDeviceCaps( Printer.Canvas.Handle, VERTSIZE );
    end
  else
    begin
      // Preview leeren
      Preview.Picture := nil;
      // Standardgrößen
      FPage.X := 2100;
      FPage.Y := 2970;
      FPageMetric.X := 210;
      FPageMetric.Y := 297;
    end;

  // Schwarz-Weiß-Modus
  MainForm.FTimetable.BlackWhite := BW.Checked;
  MainForm.FTimetable.FramedSubjects := FM.Checked;

  Cont := TPNG.CreateBlank( COLOR_RGBALPHA, 8, FPage.X, FPage.Y );
  try
    Cont.FillAlpha(255);
    Cont.FillCanvas( clWhite );
    // Seitenränder
    mLeft := WidthToPixel( 25 );
    mTop := HeightToPixel( 25 );
    // Grafik erstellen
    if Fullclip then
      PNG := TPNG.CreateBlank( COLOR_RGBALPHA, 8, FPage.X - 2*mLeft, FPage.Y - 2*mTop )
    else
      PNG := TPNG.CreateBlank( COLOR_RGBALPHA, 8, WidthToPixel( PW ), HeightToPixel( PH ) );
    try
      PNG.FillCanvas( clWhite );
      MainForm.FTimetable.Draw( PNG );
      PNG.Draw( Cont.Canvas, Rect( mLeft, mTop, mLeft + PNG.Width, mTop + PNG.Height ) );
      PNG.Draw( Cont.Canvas, Rect( mLeft, 2*mTop + PNG.Height, mLeft + PNG.Width, 2*mTop + 2*PNG.Height ) );
    finally
      PNG.Free;
    end;
    // Aufmalen
    if aPreview then
      begin
        FOld.Assign( Cont );
        FCalc := True;
        UpdatePreview;
      end
    else
      Cont.Draw( Printer.Canvas, Rect( 0, 0, FPage.X, FPage.Y ) );
  finally
    Cont.Free;
  end;

  // Druck starten / beenden
  if not aPreview then
    Printer.EndDoc;
end;

procedure TfrmPrint.UpdatePreview;
var
  PNG: TPNG;
begin
  if not FCalc then
    Exit;
  Preview.Picture := nil;
  PNG := TPNG.CreateBlank(COLOR_RGBALPHA, 8, Preview.Width, Preview.Height);
  try
    FOld.Antialiase(PNG);
    PNG.Draw(Preview.Canvas, Rect(0, 0, Preview.Width, Preview.Height));
  finally
    PNG.Free;
  end;
end;

procedure TfrmPrint.PWidthExit(Sender: TObject);
begin
  Print( True );
end;

procedure TfrmPrint.PWidthKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet( Key, ['0'..'9', ',', #46, #8] ) then
    Key := #0;
end;

function TfrmPrint.GetFullClip;
begin
  Result := ( Modus.ItemIndex = 1 );
end;

procedure TfrmPrint.ModusChange(Sender: TObject);
begin
  Print( True );
end;

function TfrmPrint.GetPageBounds(Index: Integer): Single;
begin
  if Index = 0 then
    Result := StrToFloatDef( PWidth.Text, 15 )
  else
    Result := StrToFloatDef( PHeight.Text, 10.5 );
  Result := Result * 10;
end;

end.
