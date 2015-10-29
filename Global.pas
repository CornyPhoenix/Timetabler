unit Global;

interface

  uses SysUtils, Classes, Forms, StdCtrls, Graphics, PNGFuncs;

  procedure DesignForm( const AForm: TForm );
  procedure DesignLabel( const ALabel: TLabel );
  function ParamSet( const AParam: string ): Boolean;
  function LoadPNG( const name: string ): TPNG;
  function Farblauf( Start, Ende: TColor; Position: Integer ): TColor;

  var
    AppPath: string;

implementation

  procedure DesignForm( const AForm: TForm );
  const
    FName = 'Segoe UI';
  begin
    if Screen.Fonts.IndexOf( FName ) > -1 then
      AForm.Font.name := FName;
    AForm.Font.Size := 9;
    if AForm.Caption = '' then
      AForm.Caption := Application.Title;
  end;

  procedure DesignLabel( const ALabel: TLabel );
  begin
    with ALabel.Font do
      begin
        Size := 12;
        Color := clHotLight;
      end;
  end;

  function ParamSet( const AParam: string ): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 1 to ParamCount do
      if ParamStr( I ) = AParam then
        begin
          Result := True;
          Break;
        end;
  end;

  function LoadPNG( const name: string ): TPNG;
  var
    RC: TResourceStream;
  begin
    Result := TPNG.Create;
    RC := TResourceStream.Create( HInstance, name, 'PNG' );
    try
      Result.LoadFromStream( RC );
    finally
      RC.Free;
    end;
  end;

  function Farblauf( Start, Ende: TColor; Position: Integer ): TColor;
  var
    R, G, B: Integer;
    R1, G1, B1, R2, G2, B2: Integer;

    procedure GetRGB( AColor: Integer; out R, G, B: Integer );
    begin
      AColor := ColorToRGB( AColor );
      R := Byte( AColor );
      G := Byte( AColor shr 8 );
      B := Byte( AColor shr 16 );
    end;

  begin
    if Start = Ende then
      begin
        Result := Start;
        Exit;
      end;

    if Position <= 0 then
      begin
        Result := Start;
        Exit;
      end
    else if Position >= 1000 then
      begin
        Result := Ende;
        Exit;
      end;

    GetRGB( Start, R1, G1, B1 );
    GetRGB( Ende, R2, G2, B2 );

    asm
      MOV EBX, Position

        { Rot }
        MOV EAX, R1
        MOV EDX, R2

        IMUL EDX, EBX
        MOV ECX, 1000
        SUB ECX, EBX
        IMUL EAX, ECX

        ADD EAX, EDX
        MOV R, EAX

        { Grün }
        MOV EAX, G1
        MOV EDX, G2

        IMUL EDX, EBX
        MOV ECX, 1000
        SUB ECX, EBX
        IMUL EAX, ECX

        ADD EAX, EDX
        MOV G, EAX

        { Blau }
        MOV EAX, B1
        MOV EDX, B2

        IMUL EDX, EBX
        MOV ECX, 1000
        SUB ECX, EBX
        IMUL EAX, ECX

        ADD EAX, EDX
        MOV B, EAX

    end
    ;

    R := Round( R / 1000 );
    G := Round( G / 1000 );
    B := Round( B / 1000 );
    Result := ( R or ( G shl 8 ) or ( B shl 16 ) );
  end;

initialization

  AppPath := ExtractFilePath( ParamStr( 0 ) );

end.
