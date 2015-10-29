unit Publish;

interface

  uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls, MD5Func,
    XTF;

  type
    TfrmPublish = class( TForm )
      Panel: TPanel;
      Bevel1: TBevel;
      btnPublish: TButton;
      btnCancel: TButton;
      Head: TLabel;
      Label1: TLabel;
      edtName: TEdit;
      Error: TLabel;
      procedure PanelResize( Sender: TObject );
      procedure btnCancelClick( Sender: TObject );
      procedure FormCreate( Sender: TObject );
      procedure FormShow( Sender: TObject );
      procedure edtNameChange( Sender: TObject );
      procedure btnPublishClick( Sender: TObject );
      procedure FormResize( Sender: TObject );
    private
      function GetError: string;
      procedure SetError( const AValue: string );
    public
      property ErrorMsg: string read GetError write SetError;
    end;

  var
    frmPublish: TfrmPublish;

implementation

  uses Main, Global;
  {$R *.dfm}

  procedure TfrmPublish.btnCancelClick( Sender: TObject );
  begin
    Close;
  end;

  procedure TfrmPublish.btnPublishClick( Sender: TObject );
  const
    Reserve = 'http://www.phoenixsystems.de/stundenplaner/upload.php';
    Dest1 = 'timetables/';
    Dest2 = 'Timetables.xtf';
  var
    FileName: string;
    Plan: TXTFPlan;
  begin
    FileName := MD5( FormatDateTime( 'dd.mm.yyyy, hh:nn:ss,zzzz', now ) ) + '.timetable';
    MainForm.FTimetable.SaveToServer( Reserve, Dest1 + FileName );
    Plan := TXTFPlan.Create;
    try
      Plan.ID := MainForm.FTimetable.Header.Form;
      Plan.name := edtName.Text;
      Plan.Time := FormatDateTime( 'd. mmmm yyyy "um" hh:nn "Uhr"', now );
      Plan.FileName := FileName;
      MainForm.FXTF.AddItem( Plan );
      MainForm.FXTF.SaveToServer( Reserve, Dest2 );
    finally
      Plan.Free;
    end;
    Close;
    MainForm.LoadPlaeneItems;
  end;

  procedure TfrmPublish.edtNameChange( Sender: TObject );
  begin
    btnPublish.Enabled := edtName.Text <> '';
  end;

  procedure TfrmPublish.FormCreate( Sender: TObject );
  begin
    DesignForm( Self );
    DesignLabel( Head );
    Error.Font.Color := clRed;
    Caption := Application.Title;
  end;

  procedure TfrmPublish.FormResize( Sender: TObject );
  begin
    Error.Width := ClientWidth - 32;
  end;

  procedure TfrmPublish.FormShow( Sender: TObject );
  begin
    edtName.Text := MainForm.FTimetable.Header.Title + ' ' + MainForm.FTimetable.Header.Form;
    btnPublish.Enabled := ErrorMsg = '';
  end;

  procedure TfrmPublish.PanelResize( Sender: TObject );
  begin
    btnPublish.Left := ClientWidth - btnPublish.Width - 8;
  end;

  function TfrmPublish.GetError;
  begin
    Result := Error.Caption;
  end;

  procedure TfrmPublish.SetError( const AValue: string );
  var
    E: Boolean;
  begin
    E := AValue <> '';
    Error.Visible := E;
    // btnPublish.Enabled := not E;
    edtName.Visible := not E;
    Label1.Visible := not E;
    Error.Caption := AValue;

    if E then
      edtName.Color := clBtnFace
    else
      edtName.Color := clWindow;
  end;

end.
