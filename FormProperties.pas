unit FormProperties;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmProperties = class(TForm)
    Panel: TPanel;
    Bevel1: TBevel;
    Label1: TLabel;
    Title: TEdit;
    Label2: TLabel;
    Form: TEdit;
    Label3: TLabel;
    Adds: TMemo;
    btnOK: TButton;
    Button2: TButton;
    Label4: TLabel;
    ClassR: TEdit;
    Head: TLabel;
    cbxClearQuads: TCheckBox;
    Design: TComboBox;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure PanelResize(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmProperties: TfrmProperties;

implementation

uses Global;

{$R *.dfm}

procedure TfrmProperties.FormCreate(Sender: TObject);
begin
  DesignForm( Self );
  DesignLabel( Head );
  Caption := Application.Title;
end;

procedure TfrmProperties.FormResize(Sender: TObject);
begin
  Adds.Width := ClientWidth - 32;
  cbxClearQuads.Width := Adds.Width;
  cbxClearQuads.Top := ClientHeight - Panel.Height - cbxClearQuads.Height - 16;
  Design.Top := cbxClearQuads.Top - Design.Height - 8;
  Label5.Top := Design.Top + 3;
  Adds.Height := Design.Top - Adds.Top - 8;
  Design.Width := ClientWidth div 2;
end;

procedure TfrmProperties.PanelResize(Sender: TObject);
begin
  btnOK.Left := ClientWidth - btnOK.Width - 8;
end;

end.
