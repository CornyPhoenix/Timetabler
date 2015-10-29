unit Packlist;

interface

  uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
    Timetable, PNGFuncs;

  type
    TSubState = ( getsIn, getsOut, stays );

    TfrmPacklist = class( TForm )
      Label1: TLabel;
      Panel: TPanel;
      Bevel1: TBevel;
      btnOK: TButton;
      Label2: TLabel;
      BoxOut: TPaintBox;
      BoxIn: TPaintBox;
      Label3: TLabel;
      btnOther: TButton;
      labExams: TLabel;
      Glower: TTimer;
      procedure btnOKClick( Sender: TObject );
      procedure PanelResize( Sender: TObject );
      procedure FormShow( Sender: TObject );
      procedure FormCreate( Sender: TObject );
      procedure FormResize( Sender: TObject );
      procedure FormDestroy( Sender: TObject );
      procedure BoxOutPaint( Sender: TObject );
      procedure btnOtherClick( Sender: TObject );
      procedure GlowerTimer( Sender: TObject );
    private
      FToday: Boolean;
      FFrom, FTo: Integer;
      Off1, Off2: TBitmap;
      FLast, FNow, FNext: TDate;
      FGlowCounter: Integer;
      procedure DrawIt;
      procedure GetDay;
      procedure SetBtnCap;
      function GetDayOfWeek: Integer;
      procedure CheckExams;
      procedure StartGlowing;
    public
      procedure ChangedSubs;
    end;

  var
    frmPacklist: TfrmPacklist;

  const
    GlowFrom = $0000B2FF;
    GlowTo = $000050FF;

implementation

  uses Main, Global;
  {$R *.dfm}

  procedure TfrmPacklist.BoxOutPaint( Sender: TObject );
  begin
    DrawIt;
  end;

  procedure TfrmPacklist.btnOKClick( Sender: TObject );
  begin
    Close
  end;

  procedure TfrmPacklist.btnOtherClick( Sender: TObject );
  begin
    FToday := not FToday;
    GetDay;
    DrawIt;
    SetBtnCap;
  end;

  procedure TfrmPacklist.FormCreate( Sender: TObject );
  begin
    FToday := True;
    SetBtnCap;
    DesignForm( Self );
    DesignLabel( Label1 );
    Off1 := TBitmap.Create;
    Off2 := TBitmap.Create;
    Off1.Canvas.Font := Self.Font;
    Off2.Canvas.Font := Self.Font;
  end;

  procedure TfrmPacklist.FormDestroy( Sender: TObject );
  begin
    Off1.Free;
    Off2.Free;
  end;

  procedure TfrmPacklist.FormResize( Sender: TObject );
  begin
    BoxOut.Width := ClientWidth - 32;
    BoxIn.Width := BoxOut.Width;
    labExams.Width := BoxOut.Width;
  end;

  procedure TfrmPacklist.FormShow( Sender: TObject );
  var
    Today: Integer;
  begin
    // Heutiger Tag
    Today := GetDayOfWeek;
    // Daten herausfinden
    FNow := Trunc( now );
    case Today of
      6: FNow := FNow - 2;
      5: FNow := FNow - 1;
    end;
    // Nächster Schultag
    if Today in [ 4, 5, 6 ] then
      FNext := FNow + 3
    else
      FNext := FNow + 1;
    // Letzter Schultag
    if Today = 0 then
      FLast := FNow - 3
    else
      FLast := FNow - 1;
    // Restliche Informationen
    GetDay;
  end;

  procedure TfrmPacklist.PanelResize( Sender: TObject );
  begin
    btnOK.Left := ClientWidth - btnOK.Width - 8;
  end;

  procedure TfrmPacklist.DrawIt;
  var
    C, Off1C, Off2C: Integer;
    State: TSubState;

    procedure ClearBitmap( const Bitmap: TBitmap );
    begin
      with Bitmap.Canvas do
        begin
          Pen.Color := clWhite;
          Rectangle( 0, 0, Bitmap.Width, Bitmap.Height );
        end;
    end;

    function CheckSubject( aSubject: Byte ): TSubState;
    var
      InFrom, InTo: Boolean;
      I: Integer;
    begin
      InFrom := False;
      for I := 0 to MaxLesson do
        if MainForm.FTimetable.Subjects[ FFrom, I ].Subject = aSubject then
          begin
            InFrom := True;
            Break;
          end;

      InTo := False;
      for I := 0 to MaxLesson do
        if MainForm.FTimetable.Subjects[ FTo, I ].Subject = aSubject then
          begin
            InTo := True;
            Break;
          end;

      if InFrom then
        if InTo then
          Result := stays
        else
          Result := getsOut
        else if InTo then
          Result := getsIn
        else
          Result := stays;
    end;

    procedure DrawSubject( aSubject: Byte; const Bitmap: TBitmap; var Counter: Integer; aColor: TColor );
    const
      Bnd = 70;
    var
      PNG: TPNG;
      txtW, txtX, I: Integer;
    begin
      // Rahmen
      Bitmap.Canvas.Pen.Color := aColor;
      Bitmap.Canvas.Rectangle( Counter, 0, Counter + Bnd, Bnd );
      // Stundenbild
      PNG := TPNG.CreateBlank( COLOR_RGBALPHA, 8, Bnd - 2, Bnd - 2 );
      try
        if MainForm.FTimetable.CheckImage[ aSubject ] then
          begin
            MainForm.FTimetable.SubImage[ aSubject ].Antialiase( PNG );
            PNG.Draw( Bitmap.Canvas, Rect( Counter + 1, 1, Counter + Bnd - 1, Bnd - 1 ) );
          end
        else
          for I := 1 to Bnd - 1 do
            with Bitmap.Canvas do
              begin
                Pen.Color := Farblauf( clLGray, clDGray, I * 1000 div Bnd );
                MoveTo( Counter + 1, I );
                LineTo( Counter + Bnd - 1, I );
              end;
      finally
        PNG.Free;
      end;
      // Text zeichnen
      with Bitmap.Canvas do
        begin
          Font.Color := aColor;
          txtW := TextWidth( MainForm.FTimetable.Subject[ aSubject ] );
          txtX := Counter + ( Bnd - txtW ) div 2;
          TextOut( txtX, Bnd, MainForm.FTimetable.Subject[ aSubject ] );
        end;
      // Counter erhöhen
      inc( Counter, Bnd + 16 );
    end;

  begin
    Off1.SetSize( BoxIn.Width, 90 );
    Off2.SetSize( BoxIn.Width, 90 );
    // Leeren
    ClearBitmap( Off1 );
    ClearBitmap( Off2 );
    // Positionscounter
    Off1C := 0;
    Off2C := 0;
    // Symbole ermitteln
    for C := 0 to MainForm.FTimetable.Count do
      begin
        State := CheckSubject( C );
        case State of
          getsIn: DrawSubject( C, Off1, Off1C, clGreen );
          getsOut: DrawSubject( C, Off2, Off2C, clRed );
        end;
      end;
    // Aufzeichnen
    BoxIn.Canvas.Draw( 0, 0, Off1 );
    BoxOut.Canvas.Draw( 0, 0, Off2 );
  end;

  procedure TfrmPacklist.GetDay;
  var
    Today: Integer;
  const
    Cap = 'Packliste zu %s';
  begin
    Today := GetDayOfWeek;
    // Today begrenzen
    if Today > MaxDay then
      Today := MaxDay;
    // Wochentage ermitteln
    if FToday then
      begin
        FFrom := Today;
        FTo := FFrom + 1;
        if FTo > MaxDay then
          FTo := 0;
      end
    else
      begin
        FTo := Today;
        FFrom := FTo - 1;
        if FFrom < 0 then
          FFrom := MaxDay;
      end;
    // Caption
    if FToday then
      begin
        Label1.Caption := Format( Cap, [ FormatDateTime( 'dddd, "den" dd.mm.yyyy', FNext ) ] );
        if GetDayOfWeek in [ 0 .. 3, 6 ] then
          Label1.Caption := Label1.Caption + ' (morgen)';
      end
    else
      begin
        Label1.Caption := Format( Cap, [ FormatDateTime( 'dddd, "den" dd.mm.yyyy', FNow ) ] );
        if GetDayOfWeek in [ 0 .. 4 ] then
          Label1.Caption := Label1.Caption + ' (heute)';
      end;
    // Klausren überprüfen
    CheckExams;
  end;

  procedure TfrmPacklist.SetBtnCap;
  const
    Cap = '%s auf %s';
  begin
    FToday := not FToday;
    GetDay;
    btnOther.Caption := Format( Cap, [ Days[ FFrom ], Days[ FTo ] ] );
    FToday := not FToday;
    GetDay;
  end;

  procedure TfrmPacklist.ChangedSubs;
  begin
    if Visible then
      DrawIt;
  end;

  function TfrmPacklist.GetDayOfWeek;
  var
    DOW: Integer;
  begin
    DOW := DayOfWeek( now );
    if DOW = 1 then
      DOW := 8;
    dec( DOW, 2 );
    Result := DOW;
  end;

  procedure TfrmPacklist.GlowerTimer( Sender: TObject );
  const
    Max = 1000;
    Trans = Pi * 2 / Max;
  begin
    FGlowCounter := FGlowCounter + 20;
    if FGlowCounter > Max then
      FGlowCounter := FGlowCounter - Max;
    labExams.Font.Color := Farblauf( GlowFrom, GlowTo, 500 + Trunc( cos( FGlowCounter * Trans ) * 500 ) );
  end;

  procedure TfrmPacklist.CheckExams;
  var
    I, C: Integer;
    CheckDate: TDate;
    ExIDs: array of Integer;
  begin
    // Welches Datum wird überprüft?
    CheckDate := FNow;
    if FToday then
      CheckDate := FNext;
    // Setzen des Exams.Counters
    C := -1;
    // Abklappern aller Exams
    for I := 0 to MainForm.FTimetable.Exams.Count - 1 do
      if Trunc( MainForm.FTimetable.Exams[ I ].Date ) = CheckDate then
        begin
          inc( C );
          SetLength( ExIDs, C + 1 );
          ExIDs[ C ] := I;
        end;
    // Keine Examina?
    if C = -1 then
      begin
        Glower.Enabled := False;
        labExams.Font.Color := clWindowText;
        labExams.Caption := FormatDateTime( '"Für" dddd "stehen keine Arbeiten oder Klausuren an."', CheckDate );
        Exit;
      end
    else
      begin
        labExams.Font.Color := GlowFrom;
        labExams.Caption := FormatDateTime( '"Für" dddd "steht folgendes an: ', CheckDate )
          + MainForm.FTimetable.Exams[ ExIDs[ 0 ] ].name;
        for I := 1 to Length( ExIDs ) - 1 do
          labExams.Caption := labExams.Caption + ', ' + MainForm.FTimetable.Exams[ ExIDs[ I ] ].name;
        StartGlowing;
      end;
  end;

  procedure TfrmPacklist.StartGlowing;
  begin
    FGlowCounter := 0;
    Glower.Enabled := True;
  end;

end.
