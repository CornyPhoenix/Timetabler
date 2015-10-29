unit ExamsFrm;

interface

  uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls;

  type
    TExamForm = class( TForm )
      Panel: TPanel;
      Bevel: TBevel;
      btnReady: TButton;
      btnNew: TButton;
      View: TListView;
      btnChange: TButton;
      procedure btnReadyClick( Sender: TObject );
      procedure FormShow( Sender: TObject );
      procedure btnNewClick( Sender: TObject );
      procedure FormCreate( Sender: TObject );
      procedure ViewChange( Sender: TObject; Item: TListItem; Change: TItemChange );
      procedure ViewSelectItem( Sender: TObject; Item: TListItem; Selected: Boolean );
      procedure btnChangeClick( Sender: TObject );
    private
      FUpdating: Boolean;
      procedure UpdateView;
    public
      { Public-Deklarationen }
    end;

  var
    ExamForm: TExamForm;

implementation

  uses Main, NewExamFrm, Global;
  {$R *.dfm}

  procedure TExamForm.btnChangeClick( Sender: TObject );
  begin
    // Dialog vorbereiten & anzeigen
    NewExam.EditingID := View.ItemIndex;
    if NewExam.ShowModal = mrCancel then
      Exit;

    with MainForm.FTimetable.Exams[ View.ItemIndex ] do
      begin
        name := NewExam.ExamName.Text;
        Date := Trunc( NewExam.Date.DateTime );
        Info := NewExam.Info.Text;
        Start := NewExam.StartLes.Value - 1;
        Length := NewExam.Length.Value;
        Subject := NewExam.Subject.ItemIndex + 1;
      end;
    // Ansicht aktualisieren
    UpdateView;
    // Stundenplan neuzeichnen
    MainForm.DrawTT;
    // Stundenplan geändert
    MainForm.Changes := True;
  end;

  procedure TExamForm.btnNewClick( Sender: TObject );
  begin
    // Dialog auf neuen Eintrag ausrichten
    NewExam.EditingOld := False;
    if NewExam.ShowModal = mrCancel then
      Exit;

    with MainForm.FTimetable.Exams.Add do
      begin
        name := NewExam.ExamName.Text;
        Date := Trunc( NewExam.Date.DateTime );
        Info := NewExam.Info.Text;
        Start := NewExam.StartLes.Value - 1;
        Length := NewExam.Length.Value;
        Subject := NewExam.Subject.ItemIndex + 1;
      end;
    // Ansicht aktualisieren
    UpdateView;
    // Stundenplan neuzeichnen
    MainForm.DrawTT;
    // Stundenplan geändert
    MainForm.Changes := True;
  end;

  procedure TExamForm.btnReadyClick( Sender: TObject );
  begin
    Close;
  end;

  procedure TExamForm.FormCreate( Sender: TObject );
  begin
    DesignForm( Self );
  end;

  procedure TExamForm.FormShow( Sender: TObject );
  begin
    UpdateView;
  end;

  procedure TExamForm.UpdateView;
  var
    I, Von, Bis: Integer;
  begin
    FUpdating := True;
    // Ansicht löschen
    View.Clear;
    for I := 0 to MainForm.FTimetable.Exams.Count - 1 do
      with View.Items.Add do
        begin
          // Klausurname
          Caption := MainForm.FTimetable.Exams[ I ].name;
          // Fachbild
          if MainForm.FTimetable.Exams[ I ].Subject <= 18 then
            ImageIndex := MainForm.FTimetable.Exams[ I ].Subject - 1;
          // Klausurfach
          SubItems.Add( MainForm.FTimetable.Subject[ MainForm.FTimetable.Exams[ I ].Subject ] );
          // Klausurtermin
          SubItems.Add( FormatDateTime( 'dd.mm.yyyy', MainForm.FTimetable.Exams[ I ].Date ) );
          // Stunden
          Von := MainForm.FTimetable.Exams[ I ].Start + 1;
          Bis := MainForm.FTimetable.Exams[ I ].Start + MainForm.FTimetable.Exams[ I ].Length;
          if Von = Bis then
            SubItems.Add( Format( '%d.', [ Von ] ) )
          else
            SubItems.Add( Format( '%d. - %d.', [ Von, Bis ] ) );
          // Klausurinfo
          SubItems.Add( MainForm.FTimetable.Exams[ I ].Info );
        end;
    FUpdating := False;
  end;

  procedure TExamForm.ViewChange( Sender: TObject; Item: TListItem; Change: TItemChange );
  begin
    if FUpdating then
      Exit;
    // Umändern
    MainForm.FTimetable.Exams[ Item.index ].name := Item.Caption;
    // Änderungen bekannt geben
    MainForm.DrawTT;

    MainForm.Changes := True;
  end;

  procedure TExamForm.ViewSelectItem( Sender: TObject; Item: TListItem; Selected: Boolean );
  begin
    btnChange.Enabled := View.ItemIndex <> -1;
  end;

end.
