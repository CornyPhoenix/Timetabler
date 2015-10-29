unit InfoFrm;

interface

  uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls, pngimage;

  type
    TInfo = class( TForm )
      Image: TImage;
      Panel: TPanel;
      Bevel: TBevel;
      Label1: TLabel;
      Label2: TLabel;
      btnOK: TButton;
      Version: TLabel;
      Link: TLabel;
      Link2: TLabel;
      Label4: TLabel;
      FileVersion: TLabel;
      Label3: TLabel;
      btnXeonlab: TLabel;
      procedure btnOKClick( Sender: TObject );
      procedure LinkMouseEnter( Sender: TObject );
      procedure LinkMouseLeave( Sender: TObject );
      procedure LinkClick( Sender: TObject );
      procedure FormCreate( Sender: TObject );
      procedure Link2Click( Sender: TObject );
      procedure FormShow( Sender: TObject );
      procedure btnXeonlabClick( Sender: TObject );
    private
      { Private-Deklarationen }
    public
      { Public-Deklarationen }
    end;

  var
    Info: TInfo;

implementation

  uses ShellApi, Global, Main;
  {$R *.dfm}

  procedure TInfo.btnOKClick( Sender: TObject );
  begin
    Close;
  end;

  procedure TInfo.btnXeonlabClick( Sender: TObject );
  begin
    ShellExecute( Handle, 'open', 'http://xeonlab.com', '', '', SW_SHOW );
  end;

  procedure TInfo.FormCreate( Sender: TObject );
  begin
    DesignForm( Self );
    Link.Left := Label1.Left + Label1.Width;
    Link2.Left := Label4.Left + Label4.Width;
    Label3.Left := Link2.Left + Link2.Width;
    btnXeonlab.Left := Label3.Left + Label3.Width;
    Link.Font.Color := clBlue;
    Link2.Font.Color := clBlue;
    btnXeonlab.Font.Color := clBlue;
  end;

  procedure TInfo.FormShow( Sender: TObject );
  var
    MainV, SubV: Integer;
  begin
    MainV := Trunc( MainForm.FTimetable.Header.Version );
    SubV := Round( ( MainForm.FTimetable.Header.Version - MainV ) * 100 );
    if SubV mod 10 = 0 then
      SubV := SubV div 10;
    FileVersion.Caption := Format( 'Version des Timetable-Dateiformats: %d.%d', [ MainV, SubV ] );
  end;

  procedure TInfo.Link2Click( Sender: TObject );
  begin
    ShellExecute( Handle, 'open', 'http://stundenplaner.phoenixsystems.de', '', '', SW_SHOW );
  end;

  procedure TInfo.LinkClick( Sender: TObject );
  begin
    ShellExecute( Handle, 'open', 'http://www.phoenixsystems.de', '', '', SW_SHOW );
  end;

  procedure TInfo.LinkMouseEnter( Sender: TObject );
  begin
    TLabel( Sender ).Font.Style := [ fsUnderline ];
  end;

  procedure TInfo.LinkMouseLeave( Sender: TObject );
  begin
    TLabel( Sender ).Font.Style := [ ];
  end;

end.
