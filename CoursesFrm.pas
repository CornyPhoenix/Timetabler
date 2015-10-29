unit CoursesFrm;

interface

  uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
    Timetable, ComCtrls;

  type
    TfrmCourses = class( TForm )
      Panel: TPanel;
      Bevel: TBevel;
      btnOK: TButton;
      Head: TLabel;
      Image: TImage;
      Label1: TLabel;
      edtMainteacher: TEdit;
      Label2: TLabel;
      View: TListView;
      labCCount: TLabel;
      edtCourseName: TEdit;
      edtTeacher: TEdit;
      btnNew: TButton;
      btnDelete: TButton;
      btnChange: TButton;
      labHint: TLabel;
      procedure FormCreate( Sender: TObject );
      procedure btnOKClick( Sender: TObject );
      procedure FormShow( Sender: TObject );
      procedure edtMainteacherChange( Sender: TObject );
      procedure ViewSelectItem( Sender: TObject; Item: TListItem; Selected: Boolean );
      procedure btnNewClick( Sender: TObject );
      procedure btnDeleteClick( Sender: TObject );
      procedure btnChangeClick( Sender: TObject );
    private
      FSubject: TSubject;
      FCourseIndex: Integer;
      procedure SetSubjectName( const ASubID: TSubject );
      procedure SetMainTeacher( const AValue: string );
      procedure SetCourseIndex( const AValue: Integer );
      function GetMainTeacher: string;
      procedure UpdateView;
    public
      property Subject: TSubject write SetSubjectName;
      property MainTeacher: string read GetMainTeacher write SetMainTeacher;
      property CourseIndex: Integer read FCourseIndex write SetCourseIndex;
    end;

  var
    frmCourses: TfrmCourses;

implementation

  uses Main, Global;
  {$R *.dfm}

  procedure TfrmCourses.btnChangeClick( Sender: TObject );
  var
    ID: Integer;
  begin
    ID := MainForm.FTimetable.FindTeacher
      ( Format( '%s (%s)', [ View.Items[ FCourseIndex ].SubItems[ 0 ], View.Items[ FCourseIndex ].Caption ] ) );
    MainForm.FTimetable.Courses[ ID - 1 ].CourseName := edtCourseName.Text;
    MainForm.FTimetable.Courses[ ID - 1 ].Teacher := edtTeacher.Text;
    UpdateView;
    SetCourseIndex( -1 );
  end;

  procedure TfrmCourses.btnDeleteClick( Sender: TObject );
  begin
    MainForm.FTimetable.DeleteTeacher( MainForm.FTimetable.FindTeacher
        ( Format( '%s (%s)', [ View.Items[ FCourseIndex ].SubItems[ 0 ], View.Items[ FCourseIndex ].Caption ] ) ) );
    UpdateView;
    SetCourseIndex( -1 );
  end;

  procedure TfrmCourses.btnNewClick( Sender: TObject );
  begin
    MainForm.FTimetable.AddTeacher( FSubject, edtTeacher.Text, edtCourseName.Text );
    UpdateView;
    SetCourseIndex( View.Items.Count - 1 );
    edtCourseName.SetFocus;
  end;

  procedure TfrmCourses.btnOKClick( Sender: TObject );
  begin
    Close;
  end;

  procedure TfrmCourses.edtMainteacherChange( Sender: TObject );
  begin
    MainForm.FTimetable.Teacher[ FSubject ] := GetMainTeacher;
    MainForm.Changes := True;
  end;

  procedure TfrmCourses.FormCreate( Sender: TObject );
  begin
    DesignForm( Self );
    DesignLabel( Head );
    Caption := Application.Title;
  end;

  procedure TfrmCourses.FormShow( Sender: TObject );
  begin
    SetCourseIndex( -1 );
  end;

  procedure TfrmCourses.SetSubjectName( const ASubID: TSubject );
  begin
    FSubject := ASubID;
    // Betitelung
    Head.Caption := Format( 'Kurse und Lehrer für %s ändern', [ MainForm.FTimetable.Subject[ ASubID ] ] );
    // Bild des Fachs
    Image.Picture := nil;
    if MainForm.FTimetable.CheckImage[ ASubID ] then
      begin
        Image.Canvas.Rectangle( 0, 0, Image.Width, Image.Height );
        MainForm.FTimetable.SubImage[ ASubID ].Draw( Image.Canvas, Rect( 1, 1, Image.Width - 1, Image.Height - 1 ) );
      end;
    // Alte Werte aufrufen
    SetMainTeacher( MainForm.FTimetable.Teacher[ FSubject ] );
    UpdateView;
  end;

  function TfrmCourses.GetMainTeacher: string;
  begin
    Result := edtMainteacher.Text;
  end;

  procedure TfrmCourses.SetMainTeacher( const AValue: string );
  begin
    edtMainteacher.Text := AValue;
  end;

  procedure TfrmCourses.UpdateView;
  var
    I: Integer;
  begin
    // Leeren
    View.Clear;
    for I := 0 to MainForm.FTimetable.CoursesCount - 1 do
      if MainForm.FTimetable.Courses[ I ].Subject = FSubject then
        with View.Items.Add do
          begin
            // Neuer Eintrag
            Caption := MainForm.FTimetable.Courses[ I ].CourseName;
            SubItems.Add( MainForm.FTimetable.Courses[ I ].Teacher );
          end;
    if View.Items.Count = 1 then
      labCCount.Caption := 'Ein Zusatzkurs'
    else
      labCCount.Caption := Format( '%d Zusatzkurse', [ View.Items.Count ] );
  end;

  procedure TfrmCourses.ViewSelectItem( Sender: TObject; Item: TListItem; Selected: Boolean );
  begin
    SetCourseIndex( View.ItemIndex );
  end;

  procedure TfrmCourses.SetCourseIndex( const AValue: Integer );
  begin
    FCourseIndex := AValue;
    btnDelete.Enabled := AValue <> -1;
    btnChange.Enabled := btnDelete.Enabled;
    if AValue = -1 then
      begin
        edtCourseName.Clear;
        edtTeacher.Clear;
      end
    else
      begin
        edtCourseName.Text := View.Items[ AValue ].Caption;
        edtTeacher.Text := View.Items[ AValue ].SubItems[ 0 ];
      end;
  end;

end.
