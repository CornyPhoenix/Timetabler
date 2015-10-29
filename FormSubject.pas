unit FormSubject;

interface

  uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
    Timetable;

  type
    TfrmSubject = class( TForm )
      Panel: TPanel;
      Bevel1: TBevel;
      Subject: TComboBox;
      Label3: TLabel;
      Room: TEdit;
      Label5: TLabel;
      btnOK: TButton;
      btnCancel: TButton;
      btnClear: TButton;
      btnClassR: TLabel;
      Label1: TLabel;
      Label2: TLabel;
      Course: TComboBox;
      btnChange: TLabel;
      Teacher: TLabel;
      procedure btnOKClick( Sender: TObject );
      procedure btnClearClick( Sender: TObject );
      procedure FormShow( Sender: TObject );
      procedure SubjectChange( Sender: TObject );
      procedure btnClassRClick( Sender: TObject );
      procedure btnChangeClick( Sender: TObject );
      procedure PanelResize( Sender: TObject );
      procedure FormResize( Sender: TObject );
      procedure FormCreate( Sender: TObject );
      procedure btnChangeMouseEnter( Sender: TObject );
      procedure btnChangeMouseLeave( Sender: TObject );
      procedure RoomChange( Sender: TObject );
      procedure RoomKeyPress( Sender: TObject; var Key: Char );
      procedure RoomExit( Sender: TObject );
    private
      procedure UpdateSubList;
    public
      OldIndex: Integer;
    end;

  var
    frmSubject: TfrmSubject;

implementation

  uses Main, Teachers, Global;
  {$R *.dfm}

  procedure TfrmSubject.btnChangeClick( Sender: TObject );
  begin
    frmTeachers.ChangeTeacher( Subject.ItemIndex );
    SubjectChange( Sender );
  end;

  procedure TfrmSubject.btnChangeMouseEnter( Sender: TObject );
  begin
    TLabel( Sender ).Font.Style := [ fsUnderline ];
  end;

  procedure TfrmSubject.btnChangeMouseLeave( Sender: TObject );
  begin
    TLabel( Sender ).Font.Style := [ ];
  end;

  procedure TfrmSubject.btnClassRClick( Sender: TObject );
  begin
    Room.Text := IntToStr( MainForm.FTimetable.Header.ClassR );
  end;

  procedure TfrmSubject.btnOKClick( Sender: TObject );
  begin
    ModalResult := mrOk;
  end;

  procedure TfrmSubject.btnClearClick( Sender: TObject );
  begin
    ModalResult := mrYes;
  end;

  procedure TfrmSubject.FormCreate( Sender: TObject );
  begin
    DesignForm( Self );
    DesignLabel( Label1 );
    Caption := Application.Title;
    btnChange.Font.Color := clBlue;
    btnClassR.Font.Color := clBlue;
  end;

  procedure TfrmSubject.FormResize( Sender: TObject );
  begin
    Subject.Width := ClientWidth - Subject.Left - 16;
    btnChange.Left := ClientWidth - btnChange.Width - 16;
  end;

  procedure TfrmSubject.FormShow( Sender: TObject );
  begin
    UpdateSubList;
    Subject.ItemIndex := OldIndex;
    Subject.SetFocus;
    btnClassR.Caption := Format( 'Klasse (%d)', [ MainForm.FTimetable.Header.ClassR ] );
    SubjectChange( Sender );
  end;

  procedure TfrmSubject.PanelResize( Sender: TObject );
  begin
    btnOK.Left := ClientWidth - btnOK.Width - 8;
    btnClear.Left := btnOK.Left - btnClear.Width - 8;
  end;

  procedure TfrmSubject.RoomChange( Sender: TObject );
  begin
    if Room.Text = '0' then
      Room.Clear;
  end;

  procedure TfrmSubject.RoomExit( Sender: TObject );
  begin
    if StrToIntDef( Room.Text, 0 ) > 225 then
      Room.Text := '255';
    if ( Length( Room.Text ) = 1 ) and ( CharInSet( Room.Text[ 1 ], [ 'A' .. 'C' ] ) ) then
      Room.Text := Room.Text + '0';

  end;

  procedure TfrmSubject.RoomKeyPress( Sender: TObject; var Key: Char );
  var
    LetterEntered, TypingLetter: Boolean;

  begin
    TypingLetter := CharInSet( Key, [ 'a' .. 'c', 'A' .. 'C' ] );
    LetterEntered := ( Room.Text <> '' ) and CharInSet( Room.Text[ 1 ], [ 'A' .. 'C' ] );
    if LetterEntered and TypingLetter then
      Key := #0
    else if not CharInSet( Key, [ '0' .. '9', 'A', 'B', 'C', 'a', 'b', 'c', #8, #46 ] ) then
      Key := #0
    else if TypingLetter then
      Key := AnsiUpperCase( Key )[ 1 ]
    else if not TypingLetter and not CharInSet( Key, [ #8, #46 ] ) and ( Length( Room.Text ) = 2 )
      and LetterEntered then
      Key := #0;
  end;

  procedure TfrmSubject.SubjectChange( Sender: TObject );
  var
    Str: TStringList;
  begin
    // Alle Lehrer ermitteln
    Str := TStringList.Create;
    try
      MainForm.FTimetable.GetTeachers( Subject.ItemIndex, Str );
      Course.Items.Assign( Str );
    finally
      Str.Free;
    end;
    // Formatieren
    Teacher.Visible := Course.Items.Count = 1;
    Course.Visible := not Teacher.Visible;
    if Teacher.Visible then
      Teacher.Caption := Course.Items[ 0 ]
    else
      Course.ItemIndex := 0;
    btnChange.Enabled := Subject.ItemIndex > 0;
  end;

  procedure TfrmSubject.UpdateSubList;
  var
    I: Integer;
  begin
    Subject.Items.Clear;
    for I := 0 to MainForm.FTimetable.Count do
      Subject.Items.Add( MainForm.FTimetable.Subject[ I ] );
    Subject.Items[ 0 ] := '(keines)';
  end;

end.
