program Timetabeling;

{$R *.dres}

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  Timetable in 'Timetable.pas',
  FormProperties in 'FormProperties.pas' {frmProperties},
  FormSubject in 'FormSubject.pas' {frmSubject},
  FormPrint in 'FormPrint.pas' {frmPrint},
  Teachers in 'Teachers.pas' {frmTeachers},
  AddSub in 'AddSub.pas' {frmAddSub},
  Publish in 'Publish.pas' {frmPublish},
  InfoFrm in 'InfoFrm.pas' {Info},
  Global in 'Global.pas',
  Packlist in 'Packlist.pas' {frmPacklist},
  ExamsFrm in 'ExamsFrm.pas' {ExamForm},
  NewExamFrm in 'NewExamFrm.pas' {NewExam},
  CoursesFrm in 'CoursesFrm.pas' {frmCourses},
  ExportFrm in 'ExportFrm.pas' {frmExport};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Phoenix Stundenplaner 2';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TfrmProperties, frmProperties);
  Application.CreateForm(TfrmSubject, frmSubject);
  Application.CreateForm(TfrmPrint, frmPrint);
  Application.CreateForm(TfrmTeachers, frmTeachers);
  Application.CreateForm(TfrmAddSub, frmAddSub);
  Application.CreateForm(TfrmPublish, frmPublish);
  Application.CreateForm(TInfo, Info);
  Application.CreateForm(TfrmPacklist, frmPacklist);
  Application.CreateForm(TExamForm, ExamForm);
  Application.CreateForm(TNewExam, NewExam);
  Application.CreateForm(TfrmCourses, frmCourses);
  Application.CreateForm(TfrmExport, frmExport);
  Application.Run;
end.
