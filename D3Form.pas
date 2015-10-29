unit D3Form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DGLOpenGL, Textures, Usefull;

type
  TD3 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure FormDestroy(Sender: TObject);
  private
    RC        : HGLRC;
    DC        : HDC;
    ShowFPS   : Boolean;
    FontBase  : GLUInt;
    StartTick : Cardinal;
    Frames    : Integer;
    FPS       : Single;
    Testtex   : Cardinal;
    procedure GoToFullScreen(pWidth, pHeight, pBPP, pFrequency : Word);
    procedure BuildFont(pFontName : String);
    procedure PrintText(pX,pY : Integer; const pText : String);
    procedure ShowText;
  public
    { Public-Deklarationen }
  end;

var
  D3: TD3;

implementation

{$R *.dfm}

procedure TD3.GoToFullScreen(pWidth, pHeight, pBPP, pFrequency : Word);
var
  dmScreenSettings : DevMode;
begin
  // Fenster vor Vollbild vorbereiten
  WindowState := wsMaximized;
  BorderStyle := bsNone;

  ZeroMemory(@dmScreenSettings, SizeOf(dmScreenSettings));
  with dmScreenSettings do
      begin
      dmSize              := SizeOf(dmScreenSettings);
      dmPelsWidth         := pWidth;                    // Breite
      dmPelsHeight        := pHeight;                   // Höhe
      dmBitsPerPel        := pBPP;                      // Farbtiefe
      dmDisplayFrequency  := pFrequency;                // Bildwiederholfrequenz
      dmFields            := DM_PELSWIDTH or DM_PELSHEIGHT or DM_BITSPERPEL or DM_DISPLAYFREQUENCY;
    end;

  if (ChangeDisplaySettings(dmScreenSettings, CDS_FULLSCREEN) = DISP_CHANGE_FAILED) then
    begin
      MessageBox(0, 'Konnte Vollbildmodus nicht aktivieren!', 'Error', MB_OK or MB_ICONERROR);
      exit
    end;

  Left := 0;    Top := 0;
end;

procedure TD3.FormCreate(Sender: TObject);
begin
  // OpenGL-Funtionen initialisieren
  InitOpenGL;
  // Gerätekontext holen
  DC := GetDC(Handle);
  // Renderkontext erstellen (32 Bit Farbtiefe, 24 Bit Tiefenpuffer, Doublebuffering)
  RC := CreateRenderingContext(DC, [opDoubleBuffered], 32, 24, 0, 0, 0, 0);
  // Erstellten Renderkontext aktivieren
  ActivateRenderingContext(DC, RC);
  // Tiefenpuffer aktivieren
  glEnable(GL_DEPTH_TEST);
  // Nur Fragmente mit niedrigerem Z-Wert (näher an Betrachter) "durchlassen"
  glDepthFunc(GL_LESS);
  // Löschfarbe für Farbpuffer setzen
  glClearColor(0,0,0,0);
  // Displayfont erstellen
  BuildFont('Courier');
  // Idleevent für Rendervorgang zuweisen
  Application.OnIdle := ApplicationEventsIdle;
  // Zeitpunkt des Programmstarts für FPS-Messung speichern
  StartTick := GetTickCount;
  Textures.LoadTexture('test.png', TestTex, false );
end;

procedure TD3.FormDestroy(Sender: TObject);
begin
  // Renderkontext deaktiveren
  DeactivateRenderingContext;
  // Renderkontext "befreien"
  wglDeleteContext(RC);
  // Erhaltenen Gerätekontext auch wieder freigeben
  ReleaseDC(Handle, DC);
  // Falls wir im Vollbild sind, Bildschirmmodus wieder zurücksetzen
  ChangeDisplaySettings(devmode(nil^), 0);
end;

// =============================================================================
//  TForm1.BuildFont
// =============================================================================
//  Displaylisten für Bitmapfont erstellen
// =============================================================================
procedure TD3.BuildFont(pFontName : String);
var
  Font : HFONT;
begin
  // Displaylisten für 256 Zeichen erstellen
  FontBase := glGenLists(96);
  // Fontobjekt erstellen
  Font     := CreateFont(30, 0, 0, 0, Windows.FW_REGULAR, 0, 0, 0, ANSI_CHARSET, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS,
                         ANTIALIASED_QUALITY, FF_DONTCARE or DEFAULT_PITCH, PChar(pFontName));
  // Fontobjekt als aktuell setzen
  SelectObject(DC, Font);
  // Displaylisten erstellen
  wglUseFontBitmaps(DC, 0, 256, FontBase);
  // Fontobjekt wieder freigeben
  DeleteObject(Font)
end;

// =============================================================================
//  TForm1.PrintText
// =============================================================================
//  Gibt einen Text an Position x/y aus
// =============================================================================
procedure TD3.PrintText(pX,pY : Integer; const pText : String);
begin
  if (pText = '') then
    Exit;

  glPushAttrib(GL_LIST_BIT);
    glRasterPos2i(pX, pY);
    glListBase(FontBase);
    glCallLists(Length(pText), GL_UNSIGNED_BYTE, PChar(pText));
  glPopAttrib;
end;

// =============================================================================
//  TForm1.ShowText
// =============================================================================
//  FPS, Hilfstext usw. ausgeben
// =============================================================================
procedure TD3.ShowText;
begin

  // Tiefentest und Texturierung für Textanzeige deaktivieren
  glDisable(GL_DEPTH_TEST);
  glDisable(GL_TEXTURE_2D);
  // In orthagonale (2D) Ansicht wechseln
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  glOrtho(0,640,480,0, -1,1);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  PrintText(5,15, FloatToStr(FPS)+' fps');
  glEnable(GL_DEPTH_TEST);
  glEnable(GL_TEXTURE_2D);

end;

procedure TD3.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
begin
  // In die Projektionsmatrix wechseln
  glMatrixMode(GL_PROJECTION);

  // Identitätsmatrix laden
  glLoadIdentity;

  // Viewport an Clientareal des Fensters anpassen
  glViewPort(0, 0, ClientWidth, ClientHeight);

  // Perspective, FOV und Tiefenreichweite setzen
  gluPerspective(60, ClientWidth/ClientHeight, 1, 128);

  // In die Modelansichtsmatrix wechseln
  glMatrixMode(GL_MODELVIEW);

  // Identitätsmatrix laden
  glLoadIdentity;

  // Farb- und Tiefenpuffer löschen
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  //glEnable( GL_TEXTURE_2D );

  // Quadrat
  glBegin( GL_QUADS );
    glTexCoord2f( 0, 0 );   glVertex3f( -1, -1, -5 );
    glTexCoord2f( 1, 0 );   glVertex3f(  1, -1, -5 );
    glTexCoord2f( 1, 1 );   glVertex3f(  1,  1, -5 );
    glTexCoord2f( 0, 1 );   glVertex3f( -1,  1, -5 );
  glEnd;

  // FPS ausgeben
  ShowText;

  // Hinteren Puffer nach vorne bringen
  SwapBuffers(DC);

  // Windows denken lassen, das wir noch nicht fertig wären
  Done := False;

  // Nummer des gezeichneten Frames erhöhen
  inc(Frames);

  // FPS aktualisieren
  if GetTickCount - StartTick >= 500 then
    begin
      FPS       := Frames/(GetTickCount-StartTick)*1000;
      Frames    := 0;
      StartTick := GetTickCount
    end;
end;

end.
