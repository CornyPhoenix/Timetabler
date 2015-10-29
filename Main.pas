unit Main;

interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Timetable, Menus, pngimage, ActnList,
    ExtCtrls, ComCtrls, AppEvnts, ImgList, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, XTF,
    ToolWin, StdCtrls;

  type
    TMainForm = class( TForm )
      Menu: TMainMenu;
      Stundenplan1: TMenuItem;
      Save: TSaveDialog;
      Actions: TActionList;
      acSave: TAction;
      Speichern1: TMenuItem;
      acOpen: TAction;
      ffnen1: TMenuItem;
      SaveTT: TSaveDialog;
      OpenTT: TOpenDialog;
      Bearbeiten1: TMenuItem;
      acHeader: TAction;
      itelEigenschaftenbearbeiten1: TMenuItem;
      Box: TPaintBox;
      Bar: TStatusBar;
      AppEv: TApplicationEvents;
      acExport: TAction;
      AlsPNGexportieren1: TMenuItem;
      N1: TMenuItem;
      N2: TMenuItem;
      acPrint: TAction;
      Drucken1: TMenuItem;
      acTeacherL: TAction;
      List1: TImageList;
      acNewSub: TAction;
      NeuesFach1: TMenuItem;
      acSaveAs: TAction;
      N4: TMenuItem;
      Speichernunter1: TMenuItem;
      acNew: TAction;
      acNew1: TMenuItem;
      acInfo: TAction;
      Hilfe1: TMenuItem;
      Info1: TMenuItem;
      acWebpage: TAction;
      Webpageanzeigen1: TMenuItem;
      N5: TMenuItem;
      acClose: TAction;
      Beenden1: TMenuItem;
      N6: TMenuItem;
      acUpdate: TAction;
      AufUpdatesberprfen1: TMenuItem;
      acPacklist: TAction;
      List2: TImageList;
      Plaene: TMenuItem;
      acPublish: TAction;
      Ansicht1: TMenuItem;
      Lehrerliste2: TMenuItem;
      Packliste2: TMenuItem;
      N3: TMenuItem;
      Stundenplanverffentlichen1: TMenuItem;
      Tools: TToolBar;
      ToolButton1: TToolButton;
      ToolButton2: TToolButton;
      ToolButton3: TToolButton;
      ToolButton4: TToolButton;
      ToolButton5: TToolButton;
      ToolButton6: TToolButton;
      ToolButton7: TToolButton;
      ToolButton8: TToolButton;
      ToolButton9: TToolButton;
      ToolButton10: TToolButton;
      ToolButton11: TToolButton;
      acToolBar: TAction;
      acStatusBar: TAction;
      oolbar1: TMenuItem;
      Statusleiste1: TMenuItem;
      N8: TMenuItem;
      Recently: TMenuItem;
      acExamslist: TAction;
      ArbeitsundKlausurplaner1: TMenuItem;
      acShowDates: TAction;
      ArbeitenundDatenanzeigen1: TMenuItem;
      ToolButton12: TToolButton;
      acBW: TAction;
      SchwarzWeiAnsicht1: TMenuItem;
      acCourseNames: TAction;
      Kursnamenanzeigen1: TMenuItem;
      acDrawImages: TAction;
      Stundenbilderanziegen1: TMenuItem;
      acDrawRects: TAction;
      acAbbreviation: TAction;
      Stundenbilderanziegen2: TMenuItem;
      Fchernamenabkrzen1: TMenuItem;
    List1big: TImageList;
      procedure FormCreate( Sender: TObject );
      procedure FormDestroy( Sender: TObject );
      procedure acOpenExecute( Sender: TObject );
      procedure acHeaderExecute( Sender: TObject );
      procedure BoxMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer );
      procedure AppEvHint( Sender: TObject );
      procedure BoxClick( Sender: TObject );
      procedure acExportExecute( Sender: TObject );
      procedure acPrintExecute( Sender: TObject );
      procedure acTeacherLExecute( Sender: TObject );
      procedure acNewSubExecute( Sender: TObject );
      procedure acSaveAsExecute( Sender: TObject );
      procedure acSaveExecute( Sender: TObject );
      procedure acNewExecute( Sender: TObject );
      procedure acInfoExecute( Sender: TObject );
      procedure acWebpageExecute( Sender: TObject );
      procedure FormCloseQuery( Sender: TObject; var CanClose: Boolean );
      procedure acCloseExecute( Sender: TObject );
      procedure acUpdateExecute( Sender: TObject );
      procedure BarResize( Sender: TObject );
      procedure acPacklistExecute( Sender: TObject );
      procedure FormShow( Sender: TObject );
      procedure BoxDragOver( Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean );
      procedure BoxDragDrop( Sender, Source: TObject; X, Y: Integer );
      procedure TimetableClick( Sender: TObject );
      procedure acPublishExecute( Sender: TObject );
      procedure acToolBarExecute( Sender: TObject );
      procedure acStatusBarExecute( Sender: TObject );
      procedure FormResize( Sender: TObject );
      procedure RecentlyItemClick( Sender: TObject );
      procedure FormPaint( Sender: TObject );
      procedure acExamslistExecute( Sender: TObject );
      procedure acShowDatesExecute( Sender: TObject );
      procedure acBWExecute( Sender: TObject );
      procedure acCourseNamesExecute( Sender: TObject );
      procedure acDrawImagesExecute( Sender: TObject );
      procedure acDrawRectsExecute( Sender: TObject );
      procedure acAbbreviationExecute( Sender: TObject );
    private
      FselD, FselL: Integer;
      FDevelope, FChanges, FInternetConnection: Boolean;
      FRecent: TStringList;
      procedure UpdateCheck( Quiet: Boolean );
      procedure SetChanges( AValue: Boolean );
      procedure OnOpen;
      procedure UpdateRecentFiles;
      procedure GetVersion;
    public
      // Drag&Drop
      SendSub: Byte;
      SendPNG: TPNG;
      FTimetable: TTimetable;
      FXTF: TXTF;
      Version, Build: string;
      procedure DrawTT;
      procedure DrawLast;
      procedure AcceptFiles( var msg: TMessage );
      message WM_DROPFILES;
      property Changes: Boolean read FChanges write SetChanges;
      procedure SetSubject( aDay, aLesson: Integer );
      procedure Open( const aFile: string );
      procedure LoadSubImgs;
      procedure LoadPlaeneItems;
    end;

  var
    MainForm: TMainForm;

  const
    Server = 'http://phoenixsystems.de/stundenplaner/';
    ServerURL = 'Timetables.xtf';
    URL = Server + ServerURL;

implementation

  uses FormProperties, FormSubject, FormPrint, Teachers, AddSub, Publish, Packlist, InfoFrm, ExamsFrm, ShellApi,
    CoursesFrm, ExportFrm, Global;
  {$R *.dfm}

  procedure TMainForm.acCloseExecute( Sender: TObject );
  begin
    Close;
  end;

  procedure TMainForm.acCourseNamesExecute( Sender: TObject );
  begin
    acCourseNames.Checked := not acCourseNames.Checked;
    FTimetable.ShowCourses := acCourseNames.Checked;
    DrawTT;
  end;

  procedure TMainForm.acDrawImagesExecute( Sender: TObject );
  begin
    acDrawImages.Checked := not acDrawImages.Checked;
    FTimetable.DrawImages := acDrawImages.Checked;
    DrawTT;
  end;

  procedure TMainForm.acDrawRectsExecute( Sender: TObject );
  begin
    acDrawRects.Checked := not acDrawRects.Checked;
    FTimetable.FramedSubjects := acDrawRects.Checked;
    DrawTT;
  end;

  procedure TMainForm.acExamslistExecute( Sender: TObject );
  begin
    ExamForm.ShowModal;
  end;

  procedure TMainForm.acExportExecute( Sender: TObject );
  var
    PNG: TPNG;
  begin
    // Formular
    if frmExport.ShowModal = mrCancel then
      Exit;
    // Speichern-Dialog
    if not Save.Execute then
      Exit;
    // Grafik erstellen
    with frmExport do
      begin
        // Grafik erstellen
        PNG := TPNG.CreateBlank( COLOR_RGBALPHA, 8, BoundsWidth * Antialias, BoundsHeight * Antialias );
        try
          FTimetable.Draw( PNG );
          // Antialiasing
          if Antialias > 1 then
            PNG.Stretch( BoundsWidth, BoundsHeight );
          // Abspeichern
          case Save.FilterIndex of
            1: PNG.SaveToFile( Save.FileName );
            2: PNG.SaveJPEG( Save.FileName );
            3: PNG.SaveBMP( Save.FileName );
          end;
        finally
          PNG.Free;
        end;
      end;
  end;

  procedure TMainForm.acHeaderExecute( Sender: TObject );
  begin
    with frmProperties do
      begin
        // Aktuelle Werte setzen
        Title.Text := FTimetable.Header.Title;
        Form.Text := FTimetable.Header.Form;
        Adds.Text := FTimetable.Header.Adds;
        ClassR.Text := IntToStr( FTimetable.Header.ClassR );
        cbxClearQuads.Checked := FTimetable.Header.ClearedQuads;
        Design.ItemIndex := Integer( FTimetable.Header.Design );
        // Fenster anzeigen
        if ShowModal <> mrOK then
          Exit;
        // Neue Werte schreiben
        FTimetable.Header.Title := Title.Text;
        FTimetable.Header.Form := Form.Text;
        FTimetable.Header.Adds := Adds.Text;
        FTimetable.Header.ClassR := StrToIntDef( ClassR.Text, 0 );
        FTimetable.Header.ClearedQuads := cbxClearQuads.Checked;
        FTimetable.Header.Design := TTimetableDesign( Design.ItemIndex );
      end;
    // Neu zeichnen
    DrawTT;
    Changes := True;
  end;

  procedure TMainForm.acInfoExecute( Sender: TObject );
  begin
    Info.Version.Caption := Format( 'Version %s (Build %s)', [ Version, Build ] );
    Info.ShowModal;
  end;

  procedure TMainForm.acNewExecute( Sender: TObject );
  begin
    FTimetable := TTimetable.Create;
    FTimetable.ShowDates := True;
    DrawTT;
    Changes := True;
  end;

  procedure TMainForm.acNewSubExecute( Sender: TObject );
  var
    PNG: TPNG;
    FName: TFileName;
  begin
    frmAddSub.Sub.Clear;
    frmAddSub.Teacher.Clear;
    if frmAddSub.ShowModal = mrCancel then
      Exit;

    FName := frmAddSub.ImageFileName;
    if FileExists( FName ) then
      begin
        PNG := TPNG.Create;
        try
          PNG.LoadFromFile( FName );
          PNG.Stretch( 140, 140 );
          FTimetable.AddSubject( frmAddSub.Sub.Text, frmAddSub.Teacher.Text, PNG );
        finally
          PNG.Free;
        end;
      end
    else
      FTimetable.AddSubject( frmAddSub.Sub.Text, frmAddSub.Teacher.Text );
    Changes := True;
  end;

  procedure TMainForm.acOpenExecute( Sender: TObject );
  begin
    if not OpenTT.Execute then
      Exit;

    Open( OpenTT.FileName );
  end;

  procedure TMainForm.acPacklistExecute( Sender: TObject );
  begin
    frmPacklist.ShowModal;
  end;

  procedure TMainForm.acPrintExecute( Sender: TObject );
  begin
    frmPrint.ShowModal;
  end;

  procedure TMainForm.acPublishExecute( Sender: TObject );
  begin
    frmPublish.ErrorMsg := '';
    if FTimetable.Header.Form = '' then
      frmPublish.ErrorMsg := frmPublish.ErrorMsg + 'Bitte geben Sie in den Stundenplan-Eigenschaften eine Klasse an! ';
    frmPublish.ShowModal;
  end;

  procedure TMainForm.acSaveAsExecute( Sender: TObject );
  var
    ID: Integer;
  begin
    if not SaveTT.Execute then
      Exit;

    // In die zuletzt geöffneten Dateien aufnehmen
    ID := FRecent.IndexOf( SaveTT.FileName );
    if ID = -1 then
      FRecent.Insert( 0, SaveTT.FileName )
    else
      FRecent.Move( ID, 0 );
    UpdateRecentFiles;

    // Abspeichern
    FTimetable.SaveToFile( SaveTT.FileName );
    Changes := False;
  end;

  procedure TMainForm.acSaveExecute( Sender: TObject );
  begin
    if FileExists( FTimetable.FileName ) then
      FTimetable.SaveToFile( FTimetable.FileName )
    else
      acSaveAsExecute( Sender );
    Changes := False;
  end;

  procedure TMainForm.acShowDatesExecute( Sender: TObject );
  begin
    acShowDates.Checked := not acShowDates.Checked;
    FTimetable.ShowDates := acShowDates.Checked;
    DrawTT;
  end;

  procedure TMainForm.acStatusBarExecute( Sender: TObject );
  begin
    acStatusBar.Checked := not acStatusBar.Checked;
    Bar.Visible := acStatusBar.Checked;
  end;

  procedure TMainForm.acTeacherLExecute( Sender: TObject );
  begin
    acTeacherL.Checked := not acTeacherL.Checked;
    frmTeachers.Visible := acTeacherL.Checked;
  end;

  procedure TMainForm.acToolBarExecute( Sender: TObject );
  begin
    acToolBar.Checked := not acToolBar.Checked;
    Tools.Visible := acToolBar.Checked;
  end;

  procedure TMainForm.acUpdateExecute( Sender: TObject );
  begin
    UpdateCheck( False );
  end;

  procedure TMainForm.acWebpageExecute( Sender: TObject );
  begin
    ShellExecute( handle, 'open', 'http://www.phoenixsystems.de/stundenplaner', '', '', SW_SHOW );
  end;

  procedure TMainForm.AppEvHint( Sender: TObject );
  begin
    Bar.Panels[ 0 ].Text := Application.Hint;
    frmCourses.labHint.Caption := Application.Hint;
  end;

  procedure TMainForm.BarResize( Sender: TObject );
  begin
    Bar.Panels[ 0 ].Width := ClientWidth div 2;
  end;

  procedure TMainForm.BoxClick( Sender: TObject );
  begin
    if ( FselD = -1 ) or ( FselL = -1 ) then
      Exit;

    SetSubject( FselD, FselL );
  end;

  procedure TMainForm.BoxDragDrop( Sender, Source: TObject; X, Y: Integer );
  var
    D, L: Integer;
    Input: string;
  const
    Cap1 = 'Raum eingeben';
    Cap2 = 'Bitte geben Sie einen Raum für %s ein:';
  begin
    Box.Hint := '';
    FTimetable.GetSelItem( X, Y, D, L );

    Input := InputBox( Cap1, Format( Cap2, [ FTimetable.Subject[ SendSub ] ] ), '' );

    if Input = '' then
      Exit;

    FTimetable.Subjects[ D, L ].Subject := SendSub;
    FTimetable.Subjects[ D, L ].Room := StrToIntDef( Input, 0 );

    DrawTT;
    Changes := True;
    frmPacklist.ChangedSubs;
  end;

  procedure TMainForm.BoxDragOver( Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean );
  var
    D, L: Integer;
  begin
    if Source <> frmTeachers.Editor then
      Exit;

    FTimetable.GetSelItem( X, Y, D, L );
    if ( D <> -1 ) and ( L <> -1 ) then
      begin
        Accept := True;
        Box.Hint := Format( '%s auf %s, %d. Stunde setzen', [ FTimetable.Subject[ SendSub ], Days[ D ], L + 1 ] );
        DrawLast;
        SendPNG.Draw( Box.Canvas, Rect( X + 5, Y + 5, X + 45, Y + 45 ) );
      end;

  end;

  procedure TMainForm.BoxMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer );
  var
    D, L: Integer;
  begin
    // Item abfangen
    FTimetable.GetSelItem( X, Y, D, L );
    // Stunde herausfinden udn ausgeben
    if ( D = -1 ) or ( L = -1 ) then
      begin
        Box.Hint := '';
        Box.Cursor := crDefault;
      end
    else
      begin
        Box.Cursor := crHandPoint;
        Box.Hint := Format( '%s, %d. Stunde bearbeiten ...', [ Days[ D ], L + 1 ] );
        FselD := D;
        FselL := L;
      end;
  end;

  procedure TMainForm.FormCloseQuery( Sender: TObject; var CanClose: Boolean );
  const
    msg = 'Sie haben Änderungen vorgenommen. Möchten Sie vor dem Beenden speichern?';
  begin
    if { FDevelope or } not Changes then
      Exit;

    case TaskMessageDlg( 'Beenden', msg, mtWarning, mbYesNoCancel, 0 ) of
      mrYes: acSaveExecute( Sender );
      mrCancel: CanClose := False
    end;
  end;

  procedure TMainForm.FormCreate( Sender: TObject );
  begin
    // Objekte erstellen
    FTimetable := TTimetable.Create;
    FTimetable.ShowDates := True;
    FTimetable.FramedSubjects := True;
    FTimetable.DrawBorder := False;
    // XTF erstellen
    FXTF := TXTF.Create;
    // Version bekommen
    GetVersion;
    // Fenster erstellen
    frmPacklist := TfrmPacklist.Create( Self );
    // Drag & Drop erlauben
    DragAcceptFiles( handle, True );
    // Entwicklungsmodus
    FDevelope := ParamSet( '-develope' );
    if FDevelope then
      Caption := Caption + ' [Entwicklungsmodus]'
    else
      UpdateCheck( True );
    // Segoe UI-Schriftart
    DesignForm( Self );
    LoadSubImgs;
    // Drag & Drop-Bild erstellen
    SendPNG := TPNG.CreateBlank( COLOR_RGBALPHA, 8, 40, 40 );
    SendPNG.FillAlpha( 127 );
    // Auf Internet-Verbindung prüfen
    Plaene.Visible := FInternetConnection;
    // Lädt die Items für die Online-Stundenpläne
    LoadPlaeneItems;
    // Letzte geöffnete Dateien laden
    FRecent := TStringList.Create;
    if FileExists( AppPath + 'recent.files' ) then
      FRecent.LoadFromFile( AppPath + 'recent.files' );
    UpdateRecentFiles;
  end;

  procedure TMainForm.FormDestroy( Sender: TObject );
  begin
    FTimetable.Destroy;
    FXTF.Free;
    DragAcceptFiles( handle, False );
    // Letzte Dateien abspeichern
    FRecent.SaveToFile( AppPath + 'recent.files' );
    FRecent.Free;
    SendPNG.Free;
  end;

  procedure TMainForm.FormPaint( Sender: TObject );
  begin
    DrawTT;
  end;

  procedure TMainForm.FormResize( Sender: TObject );
  begin
    Bar.Panels[ 2 ].Text := Format( '%d x %d Pixel', [ Box.Width, Box.Height ] );
  end;

  procedure TMainForm.FormShow( Sender: TObject );
  begin
    if FileExists( ParamStr( 1 ) ) then
      Open( ParamStr( 1 ) )
    else if FRecent.Count > 0 then
      Open( FRecent[ 0 ] );
  end;

  procedure TMainForm.DrawTT;
  begin
    FTimetable.DrawImage( Box.Width, Box.Height );
    FTimetable.Storage.Draw( Box.Canvas, Rect( 0, 0, Box.Width, Box.Height ) );
  end;

  procedure TMainForm.SetSubject( aDay: Integer; aLesson: Integer );
  var
    msg: Integer;
  begin
    if aDay > MaxDay then
      Exit;

    with frmSubject do
      begin
        Label1.Caption := Format( '%s, %d. Stunde', [ Days[ aDay ], aLesson + 1 ] );
        OldIndex := FTimetable.Subjects[ aDay, aLesson ].Subject;
        Room.Text := EncodeRoom( FTimetable.Subjects[ aDay, aLesson ].Room );
      end;

    msg := frmSubject.ShowModal;

    if msg = mrCancel then
      Exit
    else if msg = mrYes then
      with FTimetable.Subjects[ aDay, aLesson ] do
        begin
          Room := 0;
          Subject := 0;
          Course := $00;
        end
      else
        with frmSubject do
          begin
            FTimetable.Subjects[ aDay, aLesson ].Subject := Subject.ItemIndex;
            FTimetable.Subjects[ aDay, aLesson ].Room := DecodeRoom( Room.Text );
            if Course.Visible then
              FTimetable.Subjects[ aDay, aLesson ].Course := FTimetable.FindTeacher( Course.Text )
            else
              FTimetable.Subjects[ aDay, aLesson ].Course := $00;
          end;

    DrawTT;
    Changes := True;
    frmPacklist.ChangedSubs;
  end;

  procedure TMainForm.acAbbreviationExecute( Sender: TObject );
  begin
    acAbbreviation.Checked := not acAbbreviation.Checked;
    FTimetable.Abbreviation := acAbbreviation.Checked;
    DrawTT;
  end;

  procedure TMainForm.acBWExecute( Sender: TObject );
  begin
    acBW.Checked := not acBW.Checked;
    FTimetable.BlackWhite := acBW.Checked;
    DrawTT;
  end;

  procedure TMainForm.AcceptFiles( var msg: TMessage );
  const
    cnMaxFileNameLen = 255;
  var
    nCount: Integer;
    acFileName: array [ 0 .. cnMaxFileNameLen ] of char;
  begin
    nCount := DragQueryFile( msg.WParam, $FFFFFFFF, acFileName, cnMaxFileNameLen );

    if nCount >= 0 then
      begin
        DragQueryFile( msg.WParam, 0, acFileName, cnMaxFileNameLen );
        Open( acFileName );
      end;
    DragFinish( msg.WParam );
  end;

  procedure TMainForm.UpdateCheck( Quiet: Boolean );
  const
    Error1 = 'Es konnte keine Serververbindung hergestellt werden.';
    Error2 = 'Es ist eine neue Version verfügbar. Möchten Sie das Programm beenden und auf Version %s aufrüsten?' +
      #10#13#10#13'Ihre Einstellungen werden dabei nicht gelöscht. Sie müssen jediglich die neue Version in den alten '
      + 'Installationsordner installieren.';
  var
    Response: string;
    HTTP: TIdHTTP;
  begin
    if ParamSet( '-noupdate' ) then
      Exit;
    HTTP := TIdHTTP.Create( Self );
    try
      try
        Response := HTTP.Get( 'http://www.phoenixsystems.de/stundenplaner/version.txt' );
        if Response <> Version then
          if TaskMessageDlg( Format( 'Neue Version %s vorhanden', [ Response ] ), Format( Error2, [ Response ] ),
            mtInformation, mbYesNo, 0 ) = mrYes then
            begin
              ShellExecute( handle, 'open', 'http://www.phoenixsystems.de/stundenplaner/?update', '', '', SW_SHOW );
              FDevelope := True;
              Application.Terminate;
            end;
        FInternetConnection := True;
      except
        if not Quiet then
          TaskMessageDlg( 'Fehler', Error1, mtError, [ mbOK ], 0 );
        FInternetConnection := False;
      end;
    finally
      HTTP.Free;
    end;
  end;

  procedure TMainForm.SetChanges( AValue: Boolean );
  begin
    FChanges := AValue;
    if FChanges then
      Bar.Panels[ 1 ].Text := 'Geändert'
    else
      Bar.Panels[ 1 ].Text := '';
  end;

  procedure TMainForm.Open( const aFile: string );
  var
    ID: Integer;
  begin
    FTimetable.LoadFromFile( aFile );
    ID := FRecent.IndexOf( aFile );
    if ID = -1 then
      FRecent.Insert( 0, aFile )
    else
      FRecent.Move( ID, 0 );
    UpdateRecentFiles;
    OnOpen;
  end;

  procedure TMainForm.OnOpen;
  begin
    DrawTT;
    Changes := False;
    frmPacklist.ChangedSubs;
    Caption := FTimetable.Header.Title + ' ' + FTimetable.Header.Form;
    frmTeachers.UpdateEditor;
  end;

  procedure TMainForm.LoadPlaeneItems;
  var
    I: Integer;
    mi: TMenuItem;
  begin
    if not FInternetConnection then
      Exit;
    Plaene.Clear;
    FXTF.LoadFromServer( URL );
    for I := 0 to FXTF.Count - 1 do
      begin
        mi := TMenuItem.Create( Plaene );
        mi.Caption := FXTF.Plan[ I ].name;
        mi.OnClick := TimetableClick;
        mi.Hint := Format( '"%s" streamen', [ FXTF.Plan[ I ].name ] );
        Plaene.Add( mi );
      end;
  end;

  procedure TMainForm.LoadSubImgs;
  var
    PNG: TPNG;
    I: Integer;
    BMP: TBitmap;
  begin
    List2.Clear;
    for I := 1 to FTimetable.Count do
      if FTimetable.CheckImage[ I ] then
        begin

          BMP := TBitmap.Create;
          try
            BMP.SetSize( 16, 16 );
            with BMP.Canvas do
              begin
                Pen.Color := clWhite;
                Rectangle( 0, 0, 16, 16 );
              end;
            PNG := TPNG.CreateBlank( COLOR_RGBALPHA, 8, 16, 16 );
            try
              FTimetable.SubImage[ I ].Antialiase( PNG );
              PNG.Draw( BMP.Canvas, Rect( 0, 0, 16, 16 ) );
            finally
              PNG.Free;
            end;
            List2.AddMasked( BMP, clWhite );
          finally
            BMP.Free;
          end;

        end;
  end;

  procedure TMainForm.DrawLast;
  begin
    FTimetable.Storage.Draw( Box.Canvas, Rect( 0, 0, Box.Width, Box.Height ) );
  end;

  procedure TMainForm.TimetableClick( Sender: TObject );
  var
    ID: Integer;
  begin
    if not( Sender is TMenuItem ) then
      Exit;

    ID := TMenuItem( Sender ).Parent.IndexOf( TMenuItem( Sender ) );
    FTimetable.LoadFromServer( Server + 'timetables/' + FXTF.Plan[ ID ].FileName );
    OnOpen;
    SetChanges( True );
  end;

  procedure TMainForm.UpdateRecentFiles;
  var
    I: Integer;
    mm: TMenuItem;
  begin
    Recently.Clear;
    for I := 0 to FRecent.Count - 1 do
      begin
        mm := TMenuItem.Create( Recently );
        with mm do
          begin
            Caption := ExtractFileName( FRecent[ I ] );
            OnClick := RecentlyItemClick;
          end;
        Recently.Add( mm );
      end;
  end;

  procedure TMainForm.RecentlyItemClick( Sender: TObject );
  var
    ID: Integer;
  begin
    ID := Recently.IndexOf( TMenuItem( Sender ) );
    Open( FRecent[ ID ] );
  end;

  procedure TMainForm.GetVersion;
  var
    FileName: PChar;
    VersionInfoSize, VersionInfoValueSize, Zero: DWord;
    VersionInfo, VersionInfoValue: Pointer;
  begin
    // Dateiname ermitteln
    FileName := PChar( ParamStr( 0 ) );
    // Ergebnis leeren
    Version := '';
    // Größe der Versionsinfo erhalten
    VersionInfoSize := GetFileVersionInfoSize( FileName, Zero );
    if VersionInfoSize = 0 then
      Exit;
    // Aus Speicher laden
    GetMem( VersionInfo, VersionInfoSize );
    try
      if GetFileVersionInfo( FileName, 0, VersionInfoSize, VersionInfo ) and VerQueryValue
        ( VersionInfo, '\', VersionInfoValue, VersionInfoValueSize ) and ( 0 <> LongInt( VersionInfoValueSize ) ) then
        with TVSFixedFileInfo( VersionInfoValue^ ) do
          begin
            Version := Format( '%d.%d', [ HiWord( dwFileVersionMS ), LoWord( dwFileVersionMS ) ] );
            if HiWord( dwFileVersionLS ) > 0 then
              Version := Version + '.' + IntToStr( HiWord( dwFileVersionLS ) );
            Build := IntToStr( LoWord( dwFileVersionLS ) );
          end;
    finally
      FreeMem( VersionInfo );
    end;
  end;

end.
