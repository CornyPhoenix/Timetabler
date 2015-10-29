unit ExportFrm;

interface

  uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Flow;

  type
    TfrmExport = class( TForm )
      Head: TLabel;
      Panel: TBottomPanel;
      btnCancel: TButton;
      btnOK: TButton;
      Label1: TLabel;
      edtW: TEdit;
      Label2: TLabel;
      Label3: TLabel;
      edtH: TEdit;
      Label4: TLabel;
      Label5: TLabel;
      Antialiasing: TComboBox;
      Label6: TLabel;
      cbxShowDates: TCheckBox;
      cbxBW: TCheckBox;
      cbxFramed: TCheckBox;
      cbxShorts: TCheckBox;
      procedure FormCreate( Sender: TObject );
    private
      function GetBounds( AIndex: Integer ): Integer;
      function GetAntialias: Integer;
    public
      property BoundsWidth: Integer index 0 read GetBounds;
      property BoundsHeight: Integer index 1 read GetBounds;
      property Antialias: Integer read GetAntialias;
    end;

  var
    frmExport: TfrmExport;

implementation

  uses Main, Global;
  {$R *.dfm}

  procedure TfrmExport.FormCreate( Sender: TObject );
  begin
    DesignForm( Self );
    DesignLabel( Head );
    Caption := Application.Title;
  end;

  function TfrmExport.GetBounds( AIndex: Integer ): Integer;
  begin
    if AIndex = 0 then
      Result := StrToIntDef( edtW.Text, 1000 )
    else
      Result := StrToIntDef( edtH.Text, 700 );
  end;

  function TfrmExport.GetAntialias;
  begin
    Result := Antialiasing.ItemIndex + 1;
  end;

end.
