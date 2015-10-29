unit AddSub;

interface

  uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, PNGFuncs;

  type
    TfrmAddSub = class( TForm )
      Panel: TPanel;
      Bevel1: TBevel;
      btnOK: TButton;
      btnCancel: TButton;
      Label1: TLabel;
      Sub: TEdit;
      Label2: TLabel;
      Teacher: TEdit;
      Head: TLabel;
      Panel1: TPanel;
      Preview: TImage;
      Label3: TLabel;
      btnImport: TButton;
      Label4: TLabel;
      Open: TOpenDialog;
      OldPic: TCheckBox;
      procedure PanelResize( Sender: TObject );
      procedure FormShow( Sender: TObject );
      procedure FormResize( Sender: TObject );
      procedure btnImportClick( Sender: TObject );
      procedure SubChange( Sender: TObject );
      procedure FormCreate( Sender: TObject );
    private
      FImageFilename: TFileName;
    public
      property ImageFilename: TFileName read FImageFilename;
    end;

  var
    frmAddSub: TfrmAddSub;

implementation

  uses Global;
  {$R *.dfm}

  procedure TfrmAddSub.btnImportClick( Sender: TObject );
  var
    PNG: TPNG;
  const
    Msg = 'Das Bild muss mindestens 140 Pixel breit und hoch sein!';
  begin
    if not Open.Execute then
      Exit;

    PNG := TPNG.Create;
    try
      PNG.LoadFromFile( Open.FileName );
      if ( PNG.Width < 140 ) or ( PNG.Height < 140 ) then
        TaskMessageDlg( 'Falsche Bildgröße', Msg, mtError, [ mbOK ], 0 )
      else
        begin
          PNG.Stretch( Preview.Width, Preview.Height );
          PNG.Draw( Preview.Canvas, Rect( 0, 0, Preview.Width, Preview.Height ) );
          Label4.Caption := Open.FileName;
          FImageFilename := Open.FileName;
        end;
    finally
      PNG.Free;
    end;

    OldPic.Checked := False;
  end;

  procedure TfrmAddSub.FormCreate( Sender: TObject );
  begin
    DesignForm( Self );
    DesignLabel( Head );
  end;

  procedure TfrmAddSub.FormResize( Sender: TObject );
  begin
    Sub.Width := ClientWidth - 32;
    Teacher.Width := Sub.Width;
    btnImport.Left := ClientWidth - btnImport.Width - 16;
    Label4.Width := ClientWidth - Label4.Left - 16;
  end;

  procedure TfrmAddSub.FormShow( Sender: TObject );
  begin
    Sub.SetFocus;
    FImageFilename := '';
    Label4.Caption := '...';
  end;

  procedure TfrmAddSub.PanelResize( Sender: TObject );
  begin
    btnOK.Left := Panel.Width - btnOK.Width - 8;
  end;

  procedure TfrmAddSub.SubChange( Sender: TObject );
  begin
    btnOK.Enabled := ( Sub.Text <> '' ) and ( Teacher.Text <> '' );
  end;

end.
