unit NewExamFrm;

interface

  uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
    ComCtrls, Spin;

  type
    TNewExam = class( TForm )
      Panel: TPanel;
      Bevel: TBevel;
      btnCancel: TButton;
      btnOK: TButton;
      Label1: TLabel;
      Subject: TComboBoxEx;
      Label2: TLabel;
      ExamName: TEdit;
      Label3: TLabel;
      Info: TMemo;
      Label4: TLabel;
      Date: TDateTimePicker;
      Label5: TLabel;
      Head: TLabel;
      StartLes: TSpinEdit;
      Length: TSpinEdit;
      Label6: TLabel;
      btnDelete: TButton;
      procedure SubjectChange( Sender: TObject );
      procedure FormShow( Sender: TObject );
      procedure FormCreate( Sender: TObject );
      procedure ExamNameChange( Sender: TObject );
      procedure StartLesChange( Sender: TObject );
    private
      FEditingID: Integer;
      procedure GetSubjects;
      procedure SetEditing( const Editing: Boolean );
      procedure SetEditID( const Editing: Integer );
    public
      property EditingOld: Boolean write SetEditing;
      property EditingID: Integer read FEditingID write SetEditID;
    end;

  var
    NewExam: TNewExam;

implementation

  uses Main, Global, Timetable;
  {$R *.dfm}

  procedure TNewExam.ExamNameChange( Sender: TObject );
  begin
    btnOK.Enabled := ( ExamName.Text <> '' );
  end;

  procedure TNewExam.FormCreate( Sender: TObject );
  begin
    DesignForm( Self );
    DesignLabel( Head );
    StartLes.MaxValue := MaxLesson + 1;
  end;

  procedure TNewExam.FormShow( Sender: TObject );
  begin
    GetSubjects;
    SubjectChange( Sender );
    Info.Clear;
    Date.DateTime := now;
    if FEditingID > -1 then
      SetEditID( FEditingID );
  end;

  procedure TNewExam.GetSubjects;
  var
    I, imgC: Integer;
  begin
    // Leeren
    Subject.Clear;
    imgC := 0;
    for I := 1 to MainForm.FTimetable.Count - 1 do
      with Subject.ItemsEx.Add do
        begin
          Caption := MainForm.FTimetable.Subject[ I ];
          if MainForm.FTimetable.CheckImage[ I ] then
            begin
              ImageIndex := imgC;
              inc( imgC );
            end
          else
            ImageIndex := -1;
        end;
    Subject.ItemIndex := 0;
  end;

  procedure TNewExam.StartLesChange( Sender: TObject );
  begin
    Length.MaxValue := MaxLesson - StartLes.Value + 2;
  end;

  procedure TNewExam.SubjectChange( Sender: TObject );
  begin
    ExamName.Text := Subject.ItemsEx[ Subject.ItemIndex ].Caption + 'arbeit';
  end;

  procedure TNewExam.SetEditing( const Editing: Boolean );
  begin
    if Editing then
      Head.Caption := 'Eigenschaften ändern'
    else
      begin
        Head.Caption := 'Neue Arbeit oder Klausur hinzufügen';
        FEditingID := -1;
      end;
    btnDelete.Visible := Editing;
  end;

  procedure TNewExam.SetEditID( const Editing: Integer );
  begin
    SetEditing( True );
    FEditingID := Editing;
    // Aussehen
    Head.Caption := Format( '"%s" bearbeiten', [ MainForm.FTimetable.Exams[ Editing ].name ] );
    // Alte Eigenschaften laden
    Subject.ItemIndex := MainForm.FTimetable.Exams[ Editing ].Subject - 1;
    ExamName.Text := MainForm.FTimetable.Exams[ Editing ].name;
    Info.Text := MainForm.FTimetable.Exams[ Editing ].Info;
    Date.DateTime := MainForm.FTimetable.Exams[ Editing ].Date;
    StartLes.Value := MainForm.FTimetable.Exams[ Editing ].Start + 1;
    Length.Value := MainForm.FTimetable.Exams[ Editing ].Length;
  end;

end.
