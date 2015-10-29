unit Teachers;

interface

  uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ComCtrls, Timetable,
    ExtCtrls, StdCtrls, PNGFuncs;

  type
    TfrmTeachers = class( TForm )
      Editor: TListView;
      Panel: TPanel;
      Bevel1: TBevel;
      btnNew: TButton;
      btnDelete: TButton;
      btnDock: TButton;
      procedure EditorDblClick( Sender: TObject );
      procedure FormShow( Sender: TObject );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure PanelResize( Sender: TObject );
      procedure btnNewClick( Sender: TObject );
      procedure btnDeleteClick( Sender: TObject );
      procedure EditorSelectItem( Sender: TObject; Item: TListItem; Selected: Boolean );
      procedure FormCreate( Sender: TObject );
      procedure EditorStartDrag( Sender: TObject; var DragObject: TDragObject );
      procedure EditorEndDrag( Sender, Target: TObject; X, Y: Integer );
      procedure EditorCustomDrawSubItem( Sender: TCustomListView; Item: TListItem; SubItem: Integer;
        State: TCustomDrawState; var DefaultDraw: Boolean );
      procedure btnDockClick( Sender: TObject );
    public
      procedure ChangeTeacher( index: Integer );
      procedure UpdateEditor;
    private
      FUndocked: Boolean;
    end;

  var
    frmTeachers: TfrmTeachers;

implementation

  uses Main, AddSub, CoursesFrm, Global;
  {$R *.dfm}

  procedure TfrmTeachers.btnDeleteClick( Sender: TObject );
  begin
    if Editor.ItemIndex > MaxSub - 1 then
      MainForm.FTimetable.DeleteSubject( Editor.ItemIndex - MaxSub );
    MainForm.Changes := True;
    UpdateEditor;
  end;

  procedure TfrmTeachers.btnDockClick( Sender: TObject );
  begin
    with Editor do
      begin
        Parent := MainForm;
        Align := alLeft;
        Width := 200;
        ViewStyle := vsSmallIcon;
        GridLines := False;
      end;
    MainForm.DrawTT;
    Close;
    FUndocked := True;
    MainForm.Width := MainForm.Width + 200;
  end;

  procedure TfrmTeachers.btnNewClick( Sender: TObject );
  begin
    MainForm.acNewSubExecute( Sender );
    UpdateEditor;
  end;

  procedure TfrmTeachers.EditorCustomDrawSubItem( Sender: TCustomListView; Item: TListItem; SubItem: Integer;
    State: TCustomDrawState; var DefaultDraw: Boolean );
  begin
    if SubItem = 1 then
      if Item.SubItems[ 0 ] = '(leer)' then
        Sender.Canvas.Font.Color := clGray;
  end;

  procedure TfrmTeachers.EditorDblClick( Sender: TObject );
  var
    I: TListItem;
  begin
    if Editor.ItemIndex > -1 then
      begin
        I := Editor.GetItemAt( 220, Editor.ScreenToClient( Mouse.CursorPos ).Y );
        ChangeTeacher( I.index + 1 );
      end;
  end;

  procedure TfrmTeachers.EditorEndDrag( Sender, Target: TObject; X, Y: Integer );
  begin
    MainForm.DrawLast;
  end;

  procedure TfrmTeachers.EditorSelectItem( Sender: TObject; Item: TListItem; Selected: Boolean );
  begin
    btnDelete.Enabled := ( Editor.ItemIndex > MaxSub - 1 );
  end;

  procedure TfrmTeachers.EditorStartDrag( Sender: TObject; var DragObject: TDragObject );
  begin
    with MainForm do
      begin
        SendSub := Editor.ItemIndex + 1;
        if FTimetable.CheckImage[ SendSub ] then
          FTimetable.SubImage[ SendSub ].Antialiase( SendPNG );
        SendPNG.FillAlpha( 127 );
        with SendPNG.Canvas do
          begin
            brush.Style := bsClear;
            Rectangle( 0, 0, SendPNG.Width, SendPNG.Height );
          end;
      end;
  end;

  procedure TfrmTeachers.FormClose( Sender: TObject; var Action: TCloseAction );
  begin
    MainForm.acTeacherL.Checked := False;
  end;

  procedure TfrmTeachers.FormCreate( Sender: TObject );
  begin
    DesignForm( Self );
  end;

  procedure TfrmTeachers.FormShow( Sender: TObject );
  begin
    UpdateEditor;
    if FUndocked then
      begin
        Editor.Parent := Self;
        Editor.Align := alClient;
        Editor.ViewStyle := vsReport;
        Editor.GridLines := True;
        MainForm.Width := MainForm.Width - 200;
      end;
  end;

  procedure TfrmTeachers.PanelResize( Sender: TObject );
  begin
    btnNew.Left := Panel.Width - btnNew.Width - 8;
    btnDelete.Left := btnNew.Left - btnDelete.Width - 8;
  end;

  procedure TfrmTeachers.UpdateEditor;
  var
    I, J, imgC: Integer;
    Str: TStringList;
    NewSub: string;
  begin
    Editor.Clear;
    MainForm.LoadSubImgs;
    imgC := 0;
    Str := TStringList.Create;
    try
      for I := 1 to MainForm.FTimetable.Count do
        with Editor.Items.Add do
          begin
            Str.Clear;
            Caption := MainForm.FTimetable.Subject[ I ];
            MainForm.FTimetable.GetTeachers( I, Str );
            if Str[ 0 ] = '' then
              NewSub := '(leer)'
            else
              begin
                NewSub := Str[ 0 ];
                for J := 1 to Str.Count - 1 do
                  NewSub := NewSub + ', ' + Str[ J ];
              end;
            SubItems.Add( NewSub );

            if MainForm.FTimetable.CheckImage[ I ] then
              begin
                ImageIndex := imgC;
                inc( imgC );
              end
            else
              ImageIndex := -1;
          end;
    finally
      Str.Free;
    end;
  end;

  procedure TfrmTeachers.ChangeTeacher( index: Integer );
  var
    PNG: TPNG;
  begin
    if index <= MaxSub then
      with frmCourses do
        begin
          // Dialog vorbereiten
          Subject := index;
          // Dialog anzeigen
          ShowModal;
        end
      else
        with frmAddSub do
          begin
            // Subject-Edit
            Sub.Text := MainForm.FTimetable.Subject[ index ];
            Sub.Color := clBtnFace;
            Sub.readonly := True;
            // Altes Bild
            if MainForm.FTimetable.CheckImage[ index ] then
              begin
                OldPic.Visible := True;
                OldPic.Checked := True;
                MainForm.FTimetable.SubImage[ index ].Draw( Preview.Canvas, Rect( 0, 0, Preview.Width, Preview.Height )
                  );
              end;
            // Überschrift
            Caption := MainForm.FTimetable.Subject[ index ] + ' bearbeiten';
            Head.Caption := Caption;
            // Lehrerfeld
            Teacher.Text := MainForm.FTimetable.Teacher[ index ];
            // Anzeigen
            if ShowModal = mrOK then
              begin
                MainForm.FTimetable.Teacher[ index ] := Teacher.Text;
                if ( not OldPic.Checked ) and ( FileExists( ImageFileName ) ) then
                  begin
                    PNG := TPNG.Create;
                    try
                      PNG.LoadFromFile( ImageFileName );
                      PNG.Stretch( 140, 140 );
                      MainForm.FTimetable.SubImage[ index ] := PNG;
                    finally
                      PNG.Free;
                    end;
                  end;
              end;
            // Subject-Edit zurücksetzen
            Sub.Color := clWindow;
            Sub.readonly := False;
            OldPic.Visible := False;
            // Überschrift zur.
            Caption := 'Neues Fach hinzufügen';
            Head.Caption := Caption;
          end;
    if Visible then
      UpdateEditor;

    // Aktualisieren
    with MainForm do
      begin
        DrawTT;
        Changes := True;
      end;
  end;

end.
