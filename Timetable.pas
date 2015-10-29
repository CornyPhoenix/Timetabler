unit Timetable;

interface

  uses PNGFuncs, SysUtils, Graphics, Classes, Types, Streams, IdBaseComponent, IdComponent, IdTCPConnection,
    IdTCPClient, IdHTTP, IdMultiPartFormData;

  const
    // Maxima
    MaxDay = 4;
    MaxLesson = 11;
    MaxSub = 18;

    Days: array [ 0 .. MaxDay ] of string = ( 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag' );
    DayShorts: array [ 0 .. MaxDay ] of string = ( 'Mo', 'Di', 'Mi', 'Do', 'Fr' );

    // Wochentage
    MONTAG = 0;
    DIENSTAG = 1;
    MITTWOCH = 2;
    DONNERSTAG = 3;
    FREITAG = 4;

  type
    TDay = 0 .. 6;
    TSubject = 0 .. 255;
    THour = 0 .. MaxLesson;
    TCourse = $00 .. $FF;
    TDates = array [ 0 .. MaxDay ] of TDate;

    TExam = class
    private
      FName, FInfo: string;
      FSubject: TSubject;
      FLength, FStart: THour;
      FDate: TDate;
    public
      procedure LoadFromStream( const AStream: TStream );
      procedure SaveToStream( const AStream: TStream );
      property name: string read FName write FName;
      property Subject: TSubject read FSubject write FSubject;
      property Length: THour read FLength write FLength;
      property Start: THour read FStart write FStart;
      property Date: TDate read FDate write FDate;
      property Info: string read FInfo write FInfo;
    end;

    TExams = class
    private
      FExams: array of TExam;
    protected
      procedure DeleteExams; virtual;
      procedure SetExam( AIndex: Byte; const AExam: TExam ); virtual;
      function GetExam( AIndex: Byte ): TExam;
      function GetCount: Byte;
    public
      constructor Create; virtual;
      destructor Destroy; override;
      procedure LoadFromStream( const AStream: TStream );
      procedure SaveToStream( const AStream: TStream );
      procedure Clear; virtual;
      procedure Delete( const AIndex: Byte ); virtual;
      function Add: TExam;
      property Exam[ AIndex: Byte ]: TExam read GetExam write SetExam; default;
      property Count: Byte read GetCount;
    end;

    TLesson = class
    private
      FCourse: TCourse;
      FRoom: Byte;
      FSubject: TSubject;
    public
      property Course: TCourse read FCourse write FCourse;
      property Room: Byte read FRoom write FRoom;
      property Subject: TSubject read FSubject write FSubject;
    end;

    TAddSubject = class
    private
      FName, FTeacher: string;
      FImage: TPNG;
      FHasImage: Boolean;
    protected
      procedure SetImage( aImage: TPNG );
    public
      constructor Create; virtual;
      destructor Destroy; override;
      procedure ClearImage;
      procedure LoadFromStream( AStream: TStream );
      procedure SaveToStream( AStream: TStream );
      property name: string read FName write FName;
      property Teacher: string read FTeacher write FTeacher;
      property Image: TPNG read FImage write SetImage;
      property HasImage: Boolean read FHasImage;
    end;

    TAddTeacher = class
    private
      FTeacher, FCourseName: string;
      FSubject: TSubject;
    public
      procedure LoadFromStream( AStream: TStream );
      procedure SaveToStream( AStream: TStream );
      property Teacher: string read FTeacher write FTeacher;
      property Subject: TSubject read FSubject write FSubject;
      property CourseName: string read FCourseName write FCourseName;
    end;

    TAddSubjects = array of TAddSubject;
    TAddTeachers = array of TAddTeacher;
    TTeacherList = array [ 1 .. MaxSub ] of string;
    TSubjects = array [ 0 .. MaxDay ] of array [ 0 .. MaxLesson ] of TLesson;

    TTimetableDesign = ( dnYellow, dnGray, dnBlue, dnBlack, dnWhite, dnRed );

    TTimetableHeader = class
    const
      CurrentVersion = 1.31;
    private
      FVersion: Single;
      FTitle, FForm, FAdds: string;
      FClassR: Integer;
      FBackground: TColor;
      FClearedQuads: Boolean;
      FDesign: TTimetableDesign;
      FOnChangeDesign: TNotifyEvent;
    protected
      procedure SetDesign( const ADesign: TTimetableDesign ); virtual;
    public
      constructor Create; virtual;
      procedure LoadFromStream( const AStream: TStream );
      procedure SaveToStream( const AStream: TStream );
      property Title: string read FTitle write FTitle;
      property Form: string read FForm write FForm;
      property Adds: string read FAdds write FAdds;
      property ClassR: Integer read FClassR write FClassR;
      property Background: TColor read FBackground write FBackground;
      property ClearedQuads: Boolean read FClearedQuads write FClearedQuads;
      property Design: TTimetableDesign read FDesign write SetDesign;
      property OnChangeDesign: TNotifyEvent read FOnChangeDesign write FOnChangeDesign;
      property Version: Single read FVersion;
    end;

    TTimetable = class
    private
      // Grafik-Variabeln
      LWidth, LOffset, cX, cY, uX, uY, mX, mY, mtY, qW, qH, pW, sW, sH, soX, soY, fnt1, fnt2, fnt3, fntO, fntC2,
        fntC1: Integer;
      // Property-Helper
      FHeader: TTimetableHeader;
      FTeachers: TTeacherList;
      FAddSubs: TAddSubjects;
      FAddTeachers: TAddTeachers;
      FFileName: string;
      FShine, FCurShine, FStorage: TPNG;
      FDayQuad: TPNG;
      FSubjects: TSubjects;
      FBW, FShowDates, FFramedSubjects, FShowCourses, FDrawBorder, FDrawImages, FAbbreviation: Boolean;
      FDayStart, FDayEnd, FDayFont: TColor;
      FExams: TExams;
      FDOW: TDay;
      function YLes( aID: THour ): Integer;
      function GetCount: Integer;
      function GetCoursesCount: Integer;
      function GetTextMiddle( ATop, AHeight: Integer ): Integer;
      function Get2FontPos( ATop, AHeight, ASize1, ASize2: Integer ): TPoint;
      procedure CreateSubs;
      procedure FreeSubs;
      procedure FreeAddSubs;
      procedure FreeAddTeachers;
      procedure SaveAddSubsToStream( AStream: TStream );
      procedure LoadAddSubsFromStream( AStream: TStream );
      procedure SetFont( ASize: Integer; ABold: Boolean; AColor: TColor );
      procedure PrepareDesign( const ADesign: TTimetableDesign );
      procedure CalculateDayQuad;
      procedure HeaderChangeDesign( Sender: TObject );
      function LessonEngagedInExam( ADate: TDate; ALesson: THour ): Integer;
      procedure SaveVersion1_3( AStream: TStream );
      procedure LoadVersion1_3( AStream: TStream );
      function GetSubText( ADay: TDay; ALesson: THour; ADate: TDate; const ASeperator: string = ' • ' ): string;
      function CheckTxt( const AText: string; AWidth: Integer ): string;
      procedure InitDrawingConstants;
      procedure ClearStorage;
    protected
      function GetTeacher( index: Byte ): string; virtual;
      procedure SetTeacher( index: Byte; const Value: string ); virtual;
      function GetSubject( index: Byte ): string; virtual;
      procedure SetSubject( index: Byte; const Value: string ); virtual;
      function GetSubjects( Day, Lesson: Byte ): TLesson; virtual;
      procedure SetSubjects( Day, Lesson: Byte; aValue: TLesson ); virtual;
      function GetSubImg( index: Byte ): TPNG; virtual;
      procedure SetSubImg( index: Byte; aValue: TPNG ); virtual;
      function GetCheckImg( index: Byte ): Boolean; virtual;
      procedure DrawSubjectText( AX, AY: Integer; ADay, ALesson: Byte; const AMain: string; ASubject: Byte;
        ADate: TDate ); virtual;
    public
      constructor Create; virtual;
      constructor CreateFile( const AFile: string ); virtual;
      destructor Destroy; override;
      procedure LoadFromFile( const AFile: string );
      procedure SaveToFile( const AFile: string );
      procedure LoadFromStream( AStream: TStream );
      procedure SaveToStream( AStream: TStream );
      procedure LoadFromServer( const aURL: string );
      procedure SaveToServer( const aReservator, aURL: string );
      procedure DrawStorage;
      procedure DrawImage( cX, cY: Integer );
      procedure Draw( const APNG: TPNG );
      procedure AddSubject( const AName, aTeacher: string ); overload; virtual;
      procedure AddSubject( const AName, aTeacher: string; APNG: TPNG ); overload; virtual;
      procedure DeleteSubject( index: Integer ); virtual;
      procedure GetSelItem( X, Y: Integer; var Day, Lesson: Integer );
      procedure GetTeachers( const ASubject: TSubject; var AList: TStringList );
      function AddTeacher( const ASubject: TSubject; const AName, ACourseName: string ): Integer;
      procedure DeleteTeacher( const AIndex: Integer );
      function FindTeacher( const ACourseStamp: string ): TCourse;
      { Properties }
      property Header: TTimetableHeader read FHeader write FHeader;
      property Teacher[ index: Byte ]: string read GetTeacher write SetTeacher;
      property Subject[ index: Byte ]: string read GetSubject write SetSubject;
      property SubImage[ index: Byte ]: TPNG read GetSubImg write SetSubImg;
      property CheckImage[ index: Byte ]: Boolean read GetCheckImg;
      property Count: Integer read GetCount;
      property FileName: string read FFileName;
      property Subjects[ Day, Lesson: Byte ]: TLesson read GetSubjects write SetSubjects;
      property Storage: TPNG read FStorage;
      property Width: Integer read cX;
      property Height: Integer read cY;
      property BlackWhite: Boolean read FBW write FBW;
      property Exams: TExams read FExams write FExams;
      property ShowDates: Boolean read FShowDates write FShowDates;
      property FramedSubjects: Boolean read FFramedSubjects write FFramedSubjects;
      property CoursesCount: Integer read GetCoursesCount;
      property Courses: TAddTeachers read FAddTeachers write FAddTeachers;
      property ShowCourses: Boolean read FShowCourses write FShowCourses;
      property DrawBorder: Boolean read FDrawBorder write FDrawBorder;
      property DrawImages: Boolean read FDrawImages write FDrawImages;
      property Abbreviation: Boolean read FAbbreviation write FAbbreviation;
    end;

  const
    clLYellow = $0000FFFF;
    clDYellow = $0000C8FF;
    clLGray = $00646464;
    clDGray = $00323232;
    clLBorder = $007F7F7F;
    clDBorder = $00000000;
    fntName = 'Segoe UI';
    Times: array [ 0 .. MaxLesson ] of string = ( '7:45', '8:35', '9:35', '10:25', '11:25', '12:15', '13:10', '14:00',
      '14:45', '15:30', '16:45', '17:00' );

    // Subs
    Subs: array [ 0 .. MaxSub ] of string = ( '', 'Deutsch', 'Mathematik', 'Englisch', 'Französisch', 'Spanisch',
      'Latein', 'Physik', 'Chemie', 'Biologie', 'Informatik', 'Erdkunde', 'WiPo', 'Geschichte', 'Religion',
      'Philosophie', 'Kunst', 'Musik', 'Sport' );
    SubImgID: array [ 1 .. MaxSub ] of string = ( 'DE', 'MA', 'EN', 'FR', 'ES', 'LA', 'PY', 'CH', 'BI', 'IF', 'EK',
      'WP', 'GE', 'RE', 'PH', 'KU', 'MU', 'SP' );

  function EncodeRoom( const ARoom: Byte ): string;
  function DecodeRoom( const ARoomCode: string ): Byte;

  var
    SubImg: array [ 1 .. MaxSub ] of TPNG;

implementation

  uses Global;
  {$R xKits\Timetable.RES}
  {$REGION 'Stream-Operations'}

  procedure ReadSubject( const AStream: TStream; var aValue: TLesson );
  begin
    if not assigned( aValue ) then
      Exit;

    with aValue do
      begin
        Subject := ReadByte( AStream );
        Room := ReadByte( AStream );
        Course := ReadByte( AStream );
      end;
  end;

  procedure ReadSubjects( const AStream: TStream; var aValue: TSubjects );
  var
    X, Y: Integer;
  begin
    for X := 0 to MaxDay do
      for Y := 0 to MaxLesson do
        ReadSubject( AStream, aValue[ X, Y ] );
  end;

  function ReadTeachers( const AStream: TStream ): TTeacherList;
  var
    I: Integer;
  begin
    for I := 1 to MaxSub do
      Result[ I ] := ReadStrW( AStream );
  end;

  procedure ReadAddSubs( const AStream: TStream; var aValue: TAddSubjects );
  var
    I, Max: Integer;
  begin
    Max := ReadInt( AStream );
    SetLength( aValue, Max );
    for I := 0 to Max - 1 do
      begin
        aValue[ I ] := TAddSubject.Create;
        with aValue[ I ] do
          begin
            name := ReadStrW( AStream );
            Teacher := ReadStrW( AStream );
          end;
      end;
  end;

  procedure WriteSubject( const AStream: TStream; aValue: TLesson );
  begin
    with aValue do
      begin
        WriteByte( AStream, Subject );
        WriteByte( AStream, Room );
        WriteByte( AStream, Course );
      end;
  end;

  procedure WriteSubjects( const AStream: TStream; aValue: TSubjects );
  var
    X, Y: Integer;
  begin
    for X := 0 to MaxDay do
      for Y := 0 to MaxLesson do
        WriteSubject( AStream, aValue[ X, Y ] );
  end;

  procedure WriteTeachers( const AStream: TStream; aValue: TTeacherList );
  var
    I: Integer;
  begin
    for I := 1 to MaxSub do
      WriteStrW( AStream, aValue[ I ] );
  end;

  procedure WriteAddSubs( const AStream: TStream; aValue: TAddSubjects );
  var
    I, Max: Integer;
  begin
    Max := Length( aValue );
    WriteInt( AStream, Max );
    for I := 0 to Max - 1 do
      with aValue[ I ] do
        begin
          WriteStrW( AStream, name );
          WriteStrW( AStream, Teacher );
        end;
  end;
  {$ENDREGION}
  { TExam }

  procedure TExam.LoadFromStream( const AStream: TStream );
  begin
    FName := ReadStringW( AStream );
    FSubject := ReadByte( AStream );
    FLength := ReadByte( AStream );
    FStart := ReadByte( AStream );
    FDate := ReadDateTime( AStream );
    FInfo := ReadStringW( AStream );
  end;

  procedure TExam.SaveToStream( const AStream: TStream );
  begin
    WriteStringW( AStream, FName );
    WriteByte( AStream, FSubject );
    WriteByte( AStream, FLength );
    WriteByte( AStream, FStart );
    WriteDateTime( AStream, FDate );
    WriteStringW( AStream, FInfo );
  end;

  { TExams }

  constructor TExams.Create;
  begin
    SetLength( FExams, 0 );
  end;

  destructor TExams.Destroy;
  begin
    DeleteExams;
    inherited Destroy;
  end;

  procedure TExams.LoadFromStream( const AStream: TStream );
  var
    I: Integer;
    Count: Byte;
  begin
    DeleteExams;
    Count := ReadByte( AStream );
    SetLength( FExams, Count );
    for I := 0 to Count - 1 do
      begin
        FExams[ I ] := TExam.Create;
        FExams[ I ].LoadFromStream( AStream );
      end;
  end;

  procedure TExams.SaveToStream( const AStream: TStream );
  var
    I: Integer;
  begin
    WriteByte( AStream, Byte( Length( FExams ) ) );
    for I := 0 to Length( FExams ) - 1 do
      FExams[ I ].SaveToStream( AStream );
  end;

  procedure TExams.DeleteExams;
  var
    I: Integer;
  begin
    for I := 0 to Length( FExams ) - 1 do
      FExams[ I ].Destroy;
    SetLength( FExams, 0 );
  end;

  procedure TExams.SetExam( AIndex: Byte; const AExam: TExam );
  begin
    FExams[ AIndex ] := AExam;
  end;

  function TExams.GetExam( AIndex: Byte ): TExam;
  begin
    Result := FExams[ AIndex ];
  end;

  procedure TExams.Clear;
  begin
    DeleteExams;
  end;

  procedure TExams.Delete( const AIndex: Byte );
  var
    I, Max: Integer;
  begin
    Max := Length( FExams ) - 1;
    for I := AIndex to Max - 1 do
      FExams[ I ] := FExams[ I + 1 ];
    FExams[ Max ].Destroy;
    SetLength( FExams, Max );
  end;

  function TExams.Add: TExam;
  var
    Max: Integer;
  begin
    Max := Length( FExams );
    SetLength( FExams, Max + 1 );
    FExams[ Max ] := TExam.Create;
    Result := FExams[ Max ];
  end;

  function TExams.GetCount;
  begin
    Result := Byte( Length( FExams ) );
  end;

  { TTimetableHeader }

  constructor TTimetableHeader.Create;
  begin
    FTitle := 'Stundenplan';
    FBackground := $00FFFFFF;
    FClearedQuads := True;
    FVersion := CurrentVersion;
    SetDesign( dnBlack );
  end;

  procedure TTimetableHeader.LoadFromStream( const AStream: TStream );
  var
    GotVersion: Byte;
    fs: TFormatSettings;
  begin
    fs.DecimalSeparator := '.';
    GotVersion := ReadByte( AStream );
    if GotVersion <> $FF then
      begin
        AStream.Position := AStream.Position - 1;
        FVersion := 0.1;
      end
    else
      FVersion := StrToFloat( string( ReadStrA( AStream ) ), fs );
    // Angaben lesen
    FTitle := ReadStrW( AStream );
    FForm := ReadStrW( AStream );
    FAdds := ReadStrW( AStream );
    FClassR := ReadInt( AStream );
    // Ab Version 1.1
    if FVersion >= 1.1 then
      begin
        FClearedQuads := ReadBool( AStream );
        SetDesign( TTimetableDesign( ReadInt( AStream ) ) );
      end
    else
      begin
        FClearedQuads := True;
        SetDesign( dnYellow );
      end;
  end;

  procedure TTimetableHeader.SaveToStream( const AStream: TStream );
  var
    fs: TFormatSettings;
  begin
    // Has a version
    WriteByte( AStream, $FF );
    FVersion := CurrentVersion;
    fs.DecimalSeparator := '.';
    WriteStrA( AStream, AnsiString( FloatToStr( FVersion, fs ) ) );
    // Angaben schreiben
    WriteStrW( AStream, FTitle );
    WriteStrW( AStream, FForm );
    WriteStrW( AStream, FAdds );
    WriteInt( AStream, FClassR );
    // Ab Version 1.1
    WriteBool( AStream, FClearedQuads );
    WriteInt( AStream, Integer( FDesign ) );
  end;

  procedure TTimetableHeader.SetDesign( const ADesign: TTimetableDesign );
  begin
    FDesign := ADesign;
    if assigned( OnChangeDesign ) then
      OnChangeDesign( Self );
  end;

  { TTimetable }

  constructor TTimetable.Create;
  begin
    CreateSubs;
    // Grafiken erstellen
    FShine := LoadPNG( 'SHINE' );
    FCurShine := TPNG.Create;
    FStorage := TPNG.Create;
    FDayQuad := TPNG.CreateBlank( COLOR_RGB, 8, 1, 1000 );
    // Wochentag herausfinden (Montag = 0 bis Sonntag = 6)
    FDOW := DayOfWeek( now ) - 2;
    if FDOW = -1 then
      FDOW := 6;
    // Header erstellen
    FHeader := TTimetableHeader.Create;
    FHeader.OnChangeDesign := HeaderChangeDesign;
    FHeader.SetDesign( dnYellow );
    // Zusatzfächer auf null setzen
    SetLength( FAddSubs, 0 );
    // Klausuren erstellen
    FExams := TExams.Create;
    // Außenrand anfangs zeichnen
    FDrawBorder := True;
    FDrawImages := True;
    FAbbreviation := False;
  end;

  constructor TTimetable.CreateFile( const AFile: string );
  begin
    Create;
    LoadFromFile( AFile );
  end;

  destructor TTimetable.Destroy;
  begin
    SetLength( FAddSubs, 0 );
    FShine.Free;
    FCurShine.Free;
    FHeader.Free;
    FStorage.Free;
    // Quads freigeben
    FDayQuad.Free;
    // Sujects freigeben
    FreeSubs;
    // Zusätzliche Subjects freigeben
    FreeAddSubs;
    // Zusätzliche Lehrer freigeben
    FreeAddTeachers;
    // Examina freigeben
    FExams.Destroy;
    inherited Destroy;
  end;

  procedure TTimetable.LoadFromStream( AStream: TStream );
  begin
    // Header
    SkipHeader( AStream, 43 );
    FHeader.LoadFromStream( AStream );
    // Rest
    FTeachers := ReadTeachers( AStream );
    LoadAddSubsFromStream( AStream );
    ReadSubjects( AStream, FSubjects );
    // Ab Version 1.2
    if FHeader.FVersion >= 1.2 then
      FExams.LoadFromStream( AStream )
    else
      FExams.DeleteExams;
    // Ab Version 1.3
    LoadVersion1_3( AStream );
    FAbbreviation := False;
  end;

  function TTimetable.CheckTxt( const AText: string; AWidth: Integer ): string;
  var
    W: Integer;
  begin
    W := FStorage.Canvas.TextWidth( AText );
    if W < AWidth then
      Exit( AText );

    Result := AText + '...';
    while FStorage.Canvas.TextWidth( Result ) > AWidth do
      Result := Copy( Result, 1, Length( Result ) - 4 ) + '...';
  end;

  procedure TTimetable.SaveToStream( AStream: TStream );
  begin
    // Header
    FileHeader( AStream, 'xeonlab''s Timetable 2.5'#13'It''s all dynamic.!'#13, 43 );
    FHeader.SaveToStream( AStream );
    // Rest
    WriteTeachers( AStream, FTeachers );
    SaveAddSubsToStream( AStream );
    WriteSubjects( AStream, FSubjects );
    // Ab Version 1.2
    if FHeader.FVersion >= 1.2 then
      FExams.SaveToStream( AStream );
    // Ab Version 1.3
    SaveVersion1_3( AStream );
  end;

  procedure TTimetable.LoadFromFile( const AFile: string );
  var
    fs: TFileStream;
  begin
    fs := TFileStream.Create( AFile, fmOpenRead );
    try
      LoadFromStream( fs );
      FFileName := AFile;
    finally
      fs.Free;
    end;
  end;

  procedure TTimetable.SaveToFile( const AFile: string );
  var
    fs: TFileStream;
  begin
    fs := TFileStream.Create( AFile, fmCreate );
    try
      SaveToStream( fs );
      FFileName := AFile;
    finally
      fs.Free;
    end;
  end;

  procedure TTimetable.DrawSubjectText( AX, AY: Integer; ADay, ALesson: Byte; const AMain: string; ASubject: Byte;
    ADate: TDate );
  var
    Main, aSub: string;
    MaxWidth: Integer;
    YPos: TPoint;
  begin
    // Maximale Breite berechnen
    MaxWidth := sW - 4 * uX - qW;
    // Y-Positionen berechnen
    YPos := Get2FontPos( AY, qH, fnt1, fnt2 );
    // Ist keine Grafik vorhanden?
    if not FDrawImages then
      dec( AX, qW );
    // Text
    with FStorage.Canvas do
      begin
        // Fach ausgeben
        SetFont( fnt1, false, clDBorder );
        Main := CheckTxt( AMain, MaxWidth );
        TextOut( AX + qW + uX, YPos.X, AMain );
        // Lehrer / Raum ausgeben
        SetFont( fnt2, false, fntC2 );
        if FBW then
          Font.Color := clBlack;
        // Sub-Text ermitteln und ausgeben
        aSub := CheckTxt( GetSubText( ADay, ALesson, ADate ), MaxWidth );
        TextOut( AX + qW + uX, YPos.Y, aSub );
        // Rahmen um Stunde?
        if FDrawImages and ( GetSubject( ASubject ) <> '' ) then
          begin
            Pen.Color := clDBorder;
            Rectangle( AX + LOffset, AY + LOffset, AX + qW, AY + qH );
          end;
      end;
  end;

  function TTimetable.YLes( aID: THour ): Integer;
  begin
    Result := soY + aID * sH;
    if aID > 1 then
      inc( Result, 5 * uY );
    if aID > 3 then
      inc( Result, 5 * uY );
    if aID > 5 then
      inc( Result, 5 * uY );
  end;

  procedure TTimetable.InitDrawingConstants;
  begin
    // Units
    uX := cX div 200;
    uY := cY div 140;
    LWidth := cX div 800;
    if LWidth < 1 then
      LWidth := 1;
    LOffset := LWidth div 2;
    // Margins
    mX := 6 * uX;
    mY := 14 * uY;
    mtY := 4 * uY;
    // Quad-Width
    qW := 7 * uX;
    qH := 7 * uY;
    // Premium-Width
    pW := 9 * uX;
    // Subject-Offsets (so)
    soX := 18 * uX;
    soY := 24 * uY;
    // Subject W/H
    sW := ( ( cX - 5 * ( 3 * uX + qW ) - 2 * mX - pW ) div ( 5 * uX ) ) * uX + 3 * uX + qW;
    sH := 8 * uY;
    // Fontheights
    fnt1 := qH * 4 div 5;
    fnt2 := qH * 1 div 2;
    fnt3 := 8 * uY;
    fntO := uY;
    // fnt1 div 6 + uY div 10;
    // FontColors
    fntC1 := Farblauf( clLGray, clWhite, 500 );
    fntC2 := Farblauf( clDBorder, clWhite, 500 );
  end;

  procedure TTimetable.ClearStorage;
  var
    Offset: Integer;
  begin
    with FStorage.Canvas do
      begin
        Pen.Width := LWidth;
        Pen.Color := clBlack;
        Brush.Style := bsClear;
        // Außenrand
        if FDrawBorder then
          Rectangle( LOffset, LOffset, cX, cY );
        // Font-Eigenschaften
        Font.name := fntName;
        Font.Height := fnt3;
        // Offset setzen
        Offset := mX;
        TextOut( Offset, mtY, FHeader.Title );
        inc( Offset, TextWidth( FHeader.Title ) );
        Font.Style := [ fsBold ];
        TextOut( Offset, mtY, ' ' + FHeader.Form + ' ' );
        inc( Offset, TextWidth( ' ' + FHeader.Form + ' ' ) );
        Font.Style := [ ];
        TextOut( Offset, mtY, FHeader.Adds );
      end;
  end;

  procedure TTimetable.DrawStorage;
  var
    I, D, DayWidth: Integer;
    FSubQuad, FLessonQuad: TPNG;
    Dates: TDates;

    procedure GetImg( AX, AY, aW, aH: Integer; const ASubject: Byte );
    var
      PNG: TPNG;
    begin
      if ( ASubject = 0 ) then
        Exit;

      PNG := TPNG.CreateBlank( COLOR_RGBALPHA, 8, aW, aH );
      try
        if ASubject <= MaxSub then
          SubImg[ ASubject ].Antialiase( PNG )
        else if FAddSubs[ ASubject - MaxSub - 1 ].HasImage then
          FAddSubs[ ASubject - MaxSub - 1 ].Image.Antialiase( PNG );
        PNG.Draw( FStorage.Canvas, Rect( AX, AY, AX + aW, AY + aH ) );
      finally
        PNG.Free;
      end;
    end;

    procedure Init;
    begin
      // Werte aufnehmen
      FStorage := TPNG.CreateBlank( COLOR_RGBALPHA, 8, cX, cY );
      FStorage.FillAlpha( 255 );
      FStorage.FillCanvas( FHeader.Background );
      // Konstanten initialisieren
      InitDrawingConstants;
      // Breite eines Tages
      DayWidth := sW - 3 * uX;
      // Storage leeren
      ClearStorage;
      // Shine erstellen
      FCurShine := TPNG.CreateBlank( COLOR_RGBALPHA, 8, qW, qH div 3 * 2 );
      FShine.Antialiase( FCurShine );
    end;

    procedure InitQuads;
    var
      Y: Integer;
    begin
      // SubQuad erstellen
      FSubQuad := TPNG.CreateBlank( COLOR_RGBALPHA, 8, qW, qH );
      FSubQuad.FillAlpha( 127 );
      with FSubQuad.Canvas do
        begin
          Brush.Style := bsClear;
          Pen.Color := clDBorder;
          // Umrahmung
          Rectangle( 0, 0, qW, qH );
          // Füllung
          for Y := LWidth to qH - LWidth - 1 do
            begin
              Pen.Color := Farblauf( clLGray, clDGray, Y * 1000 div ( qH - 2 ) );
              MoveTo( LWidth, Y );
              LineTo( qW - LWidth, Y );
            end;
        end;
      // FLessonQuad erstellen
      FLessonQuad := TPNG.CreateBlank( COLOR_RGBALPHA, 8, pW, qH );
      FLessonQuad.FillAlpha( 204 );
      with FLessonQuad.Canvas do
        begin
          Brush.Style := bsClear;
          Pen.Color := clDBorder;
          // Umrahmung
          Rectangle( 0, 0, pW, qH );
          // Füllung
          for Y := LWidth to qH - LWidth - 1 do
            begin
              Pen.Color := Farblauf( clDBorder, clDGray, Y * 1000 div ( qH - 2 ) );
              MoveTo( LWidth, Y );
              LineTo( pW - LWidth, Y );
            end;
        end;
    end;

    procedure DestroyQuads;
    begin
      // Alle Quads freigeben
      FSubQuad.Free;
      FLessonQuad.Free;
    end;

    procedure Subject( ASubject, ARoom, ADay, ALesson, ACourse: Byte );
    var
      X, Y: Integer;
      AMain: string;
      ExamID: Integer;
    begin
      ExamID := -1;
      // Klausurüberwachung
      if FShowDates then
        begin
          ExamID := LessonEngagedInExam( Dates[ ADay ], ALesson );
          // Ja, ist eine Klausur
          if ExamID > -1 then
            begin
              ASubject := FExams[ ExamID ].Subject;
              AMain := FExams[ ExamID ].name;
            end;
        end;
      // Get Position
      X := soX + ADay * sW;
      Y := YLes( ALesson );
      // Haupttext
      if ExamID = -1 then
        if FShowCourses and ( ACourse > $00 ) then
          AMain := FAddTeachers[ ACourse - 1 ].FCourseName
        else
          AMain := GetSubject( ASubject );
      // Abkürzen
      if FAbbreviation then
        AMain := Copy( AMain, 1, 3 );
      // Umrahmung
      if FFramedSubjects then
        with FStorage.Canvas do
          begin
            // Textbezeichnung?
            if AMain = '' then
              begin
                if not FHeader.FClearedQuads then
                  Exit;
                Pen.Color := clLBorder
              end
            else
              Pen.Color := clDBorder;
            // Rechteck
            if ExamID > -1 then
              Brush.Color := $0071DAF7
            else
              Brush.Color := $00EFEFEF;
            Rectangle( X + LOffset, Y + LOffset, X + DayWidth, Y + qH );
            Brush.Style := bsClear;
          end;
      // Quad zeichnen
      if FHeader.FClearedQuads then
        FSubQuad.Draw( FStorage.Canvas, Rect( X, Y, X + qW, Y + qH ) );
      // Text ausgeben
      DrawSubjectText( X, Y, ADay, ALesson, AMain, ASubject, Dates[ ADay ] );
      // Fachsymbol
      if FDrawImages then
        GetImg( X + 1 + LOffset, Y + 1 + LOffset, qW - 2 - LOffset * 2, qH - 2 - LOffset * 2, ASubject );
      // Shine
      FCurShine.Draw( FStorage.Canvas, Rect( X, Y, X + FCurShine.Width, Y + FCurShine.Height ) );
    end;

    procedure Lesson( aID: Integer );
    var
      tW, C: Integer;
      YPosition: TPoint;
      B: Boolean;
    begin
      // Überprüfen, ob die Stunde benutzt wird
      if not FHeader.FClearedQuads then
        begin
          B := false;
          for C := 0 to MaxDay do
            if Self.FSubjects[ C, aID ].FSubject <> 0 then
              begin
                B := True;
                Break;
              end;
          if not B then
            Exit;
        end;
      // GetPosition
      YPosition := Get2FontPos( YLes( aID ), qH, fnt1, fnt2 );
      // Quad zeichnen
      FLessonQuad.Draw( FStorage.Canvas, Rect( mX, YLes( aID ), mX + pW, YLes( aID ) + qH ) );
      // Text
      with FStorage.Canvas do
        begin
          // Text1
          SetFont( fnt1, True, clWhite );
          tW := TextWidth( IntToStr( aID + 1 ) ) + uX div 2;
          TextOut( mX + pW - tW, YPosition.X, IntToStr( aID + 1 ) );
          // Text2
          SetFont( fnt2, false, fntC1 );
          tW := TextWidth( Times[ aID ] ) + uX div 2;
          TextOut( mX + pW - tW, YPosition.Y, Times[ aID ] );
        end;
    end;

    procedure Day( ADay: TDay );
    var
      X: Integer;
      Text: string;
    begin
      // Get Position
      X := soX + ADay * sW;
      FDayQuad.Draw( FStorage.Canvas, Rect( X, mY, X + DayWidth, mY + qH ) );
      // Text
      with FStorage.Canvas do
        begin
          // Umrahmung
          Pen.Color := clDBorder;
          // Inneres Rechteck nur wenn Bilder vorhanden sind
          if FDrawImages then
            Rectangle( X, mY, X + qW, mY + qH );
          Rectangle( X, mY, X + DayWidth, mY + qH );
          // Text
          SetFont( fnt1, false, FDayFont );
          // Tages-Überschrift
          if FShowDates then
            begin
              Dates[ ADay ] := Trunc( now + ADay - FDOW );
              if ADay < FDOW then
                Dates[ ADay ] := Dates[ ADay ] + 7;
              // Überprüfe Tag
              if ADay = FDOW then
                Text := 'Heute'
              else
                Text := DayShorts[ ADay ] + FormatDateTime( ', dd.mm.yy', Dates[ ADay ] );
            end
          else if FAbbreviation then
            Text := DayShorts[ ADay ]
          else
            Text := Days[ ADay ];
          Text := CheckTxt( Text, DayWidth - qW - uX );
          // Kein Bild zeichnen?
          if not FDrawImages then
            dec( X, qW );
          TextOut( X + qW + uX, GetTextMiddle( mY, qH ), Text );
        end;
    end;

    procedure ClassRoom;
    var
      txtW: Integer;
      ARoom: Integer;
    begin
      ARoom := FHeader.ClassR;
      if ARoom = 0 then
        Exit;
      // Füllung
      FDayQuad.Draw( FStorage.Canvas, Rect( mX + LOffset, mY + qH - 1, mX + pW, mY ) );
      with FStorage.Canvas do
        begin
          // Umrahmung
          Pen.Color := clDBorder;
          Rectangle( mX + LOffset, mY, mX + pW, mY + qH );
          // Text
          SetFont( fnt1, True, FDayFont );
          txtW := TextWidth( EncodeRoom( ARoom ) ) + uX div 2;
          TextOut( mX + pW - txtW, GetTextMiddle( mY, qH ), EncodeRoom( ARoom ) );
        end;
    end;

  begin
    // Initialisieren
    Init;
    // Classroom
    ClassRoom;
    // Quads erstellen
    InitQuads;
    try
      for D := 0 to 4 do
        Day( D );
      // Fach
      for I := 0 to 11 do
        begin
          Lesson( I );
          for D := 0 to 4 do
            Subject( Subjects[ D, I ].Subject, Subjects[ D, I ].Room, D, I, Subjects[ D, I ].Course );
        end;
    finally
      // Quads freigeben
      DestroyQuads;
    end;
    // Schwarz-Weiß
    if FBW then
      FStorage.BlackWhite;
  end;

  function TTimetable.GetTeacher( index: Byte ): string;
  begin
    if index = 0 then
      Result := ''
    else if index <= MaxSub then
      Result := FTeachers[ index ]
    else if index <= Length( FAddSubs ) + MaxSub then
      Result := FAddSubs[ index - MaxSub - 1 ].Teacher;
  end;

  procedure TTimetable.SetTeacher( index: Byte; const Value: string );
  begin
    if index > 0 then
      if index <= MaxSub then
        FTeachers[ index ] := Value
      else if index <= Length( FAddSubs ) + MaxSub then
        FAddSubs[ index - MaxSub - 1 ].Teacher := Value;
  end;

  function TTimetable.GetSubject( index: Byte ): string;
  begin
    Result := '';
    if index > 0 then
      if index <= MaxSub then
        Result := Subs[ index ]
      else if index <= Length( FAddSubs ) + MaxSub then
        Result := FAddSubs[ index - MaxSub - 1 ].name;
  end;

  procedure TTimetable.SetSubject( index: Byte; const Value: string );
  begin
    if ( index > MaxSub ) and ( index <= Length( FAddSubs ) + MaxSub ) then
      FAddSubs[ index - MaxSub - 1 ].name := Value;
  end;

  function TTimetable.GetSubjects( Day: Byte; Lesson: Byte ): TLesson;
  begin
    Result := FSubjects[ Day, Lesson ];
  end;

  procedure TTimetable.SetSubjects( Day: Byte; Lesson: Byte; aValue: TLesson );
  begin
    FSubjects[ Day, Lesson ] := aValue;
  end;

  procedure TTimetable.AddSubject( const AName: string; const aTeacher: string );
  var
    L: Integer;
  begin
    L := Length( FAddSubs );
    SetLength( FAddSubs, L + 1 );
    FAddSubs[ L ] := TAddSubject.Create;
    with FAddSubs[ L ] do
      begin
        name := AName;
        Teacher := aTeacher;
      end;
  end;

  procedure TTimetable.AddSubject( const AName: string; const aTeacher: string; APNG: TPNG );
  begin
    AddSubject( AName, aTeacher );
    FAddSubs[ high( FAddSubs ) ].Image := APNG;
  end;

  function TTimetable.GetCount;
  begin
    Result := MaxSub + Length( FAddSubs );
  end;

  function TTimetable.GetCoursesCount;
  begin
    Result := Length( FAddTeachers );
  end;

  procedure TTimetable.DeleteSubject( index: Integer );
  var
    I, Max: Integer;
  begin
    Max := high( FAddSubs );
    if ( index < 0 ) or ( index > Max ) then
      Exit;
    for I := index to Max - 1 do
      FAddSubs[ I ] := FAddSubs[ I + 1 ];
    SetLength( FAddSubs, Max );
  end;

  procedure TTimetable.GetSelItem( X, Y: Integer; var Day, Lesson: Integer );
  var
    I: Integer;
  begin
    // Out of rect?
    if ( X < soX ) or ( X > cX - mX ) or ( Y < soY ) or ( Y > cY - mtY ) or ( sW = 0 ) then
      begin
        Day := -1;
        Lesson := -1;
        Exit;
      end;
    // Day-Position
    Day := ( X - soX ) div sW;
    // Lesson-Position
    Lesson := MaxLesson;
    for I := 0 to MaxLesson - 1 do
      if YLes( I ) + qH > Y then
        begin
          Lesson := I;
          Break;
        end;
  end;

  procedure TTimetable.CreateSubs;
  var
    D, L: Integer;
  begin
    for D := 0 to MaxDay do
      for L := 0 to MaxLesson do
        FSubjects[ D, L ] := TLesson.Create;
  end;

  procedure TTimetable.FreeSubs;
  var
    D, L: Integer;
  begin
    for D := 0 to MaxDay do
      for L := 0 to MaxLesson do
        FSubjects[ D, L ].Free;
  end;

  procedure TTimetable.FreeAddSubs;
  var
    I: Integer;
  begin
    for I := 0 to high( FAddSubs ) do
      FAddSubs[ I ].Free;
    SetLength( FAddSubs, 0 );
  end;

  procedure TTimetable.FreeAddTeachers;
  var
    I: Integer;
  begin
    for I := 0 to high( FAddTeachers ) do
      FAddTeachers[ I ].Free;
    SetLength( FAddTeachers, 0 );
  end;

  procedure TTimetable.DrawImage( cX: Integer; cY: Integer );
  begin
    Self.cX := cX;
    Self.cY := cY;
    DrawStorage;
  end;

  procedure TTimetable.Draw( const APNG: TPNG );
  begin
    cX := APNG.Width;
    cY := APNG.Height;
    DrawStorage;
    APNG.Assign( FStorage );
  end;

  procedure TTimetable.SaveAddSubsToStream( AStream: TStream );
  var
    I, Max: Integer;
  begin
    if FHeader.FVersion = 0.1 then
      begin
        WriteAddSubs( AStream, FAddSubs );
        Exit;
      end;

    Max := high( FAddSubs );
    WriteByte( AStream, Max );
    for I := 0 to Max do
      FAddSubs[ I ].SaveToStream( AStream );
  end;

  procedure TTimetable.LoadAddSubsFromStream( AStream: TStream );
  var
    I: Integer;
    Max: Byte;
  begin
    if FHeader.FVersion < 1 then
      begin
        ReadAddSubs( AStream, FAddSubs );
        Exit;
      end;
    // Alte Fächer löschen
    FreeAddSubs;
    Max := ReadByte( AStream ) + 1;
    // Neue anlegen
    SetLength( FAddSubs, Max );
    for I := 0 to Max - 1 do
      begin
        FAddSubs[ I ] := TAddSubject.Create;
        FAddSubs[ I ].LoadFromStream( AStream );
      end;
  end;

  function TTimetable.GetSubImg( index: Byte ): TPNG;
  begin
    Result := TPNG.Create;
    if index = 0 then
      Exit;
    if index <= MaxSub then
      Result.Assign( SubImg[ index ] )
    else if FAddSubs[ index - MaxSub - 1 ].HasImage then
      Result.Assign( FAddSubs[ index - MaxSub - 1 ].Image );
  end;

  procedure TTimetable.SetSubImg( index: Byte; aValue: TPNG );
  begin
    if index <= MaxSub then
      Exit;
    dec( index, MaxSub + 1 );
    FAddSubs[ index ].SetImage( aValue );
  end;

  function TTimetable.GetCheckImg( index: Byte ): Boolean;
  begin
    if index = 0 then
      Result := false
    else if index <= MaxSub then
      Result := True
    else
      Result := FAddSubs[ index - MaxSub - 1 ].HasImage;
  end;

  procedure TTimetable.LoadFromServer( const aURL: string );
  var
    ms: TMemoryStream;
    http: TidHttp;
  begin
    ms := TMemoryStream.Create;
    try
      http := TidHttp.Create( nil );
      try
        http.Get( aURL, ms );
      finally
        http.Free;
      end;
      ms.Position := 0;
      LoadFromStream( ms );
    finally
      ms.Free;
    end;
  end;

  procedure TTimetable.SaveToServer( const aReservator, aURL: string );
  var
    http: TidHttp;
    ms: TMemoryStream;
    mfd: TIdMultiPartFormDataStream;
  begin
    http := TidHttp.Create( nil );
    try
      mfd := TIdMultiPartFormDataStream.Create;
      try
        ms := TMemoryStream.Create;
        try
          SaveToStream( ms );
          mfd.AddObject( 'Upload', 'xeonlab/timetabele', ms, 'upload.timetable' );
          mfd.AddFormField( 'Destination', aURL );
          http.Post( aReservator, mfd );
        finally
          ms.Free;
        end;
      finally
        mfd.Free;
      end;
    finally
      http.Free;
    end;
  end;

  function TTimetable.GetTextMiddle( ATop: Integer; AHeight: Integer ): Integer;
  var
    txtH: Integer;
  begin
    txtH := FStorage.Canvas.TextHeight( '0' );
    Result := ATop + ( AHeight - txtH ) div 2;
  end;

  function TTimetable.Get2FontPos( ATop: Integer; AHeight: Integer; ASize1: Integer; ASize2: Integer ): TPoint;
  var
    txtH1, txtH2: Integer;
  begin
    with FStorage.Canvas do
      begin
        Font.Height := ASize1;
        txtH1 := TextHeight( '0' );
        Font.Height := ASize2;
        txtH2 := TextHeight( '0' );
      end;
    Result.X := ATop + ( ( AHeight - txtH2 - txtH1 ) div 2 );
    Result.Y := Result.X + txtH1 + ( ( AHeight - txtH2 - txtH1 ) div 2 );
  end;

  procedure TTimetable.SetFont( ASize: Integer; ABold: Boolean; AColor: TColor );
  begin
    with FStorage.Canvas.Font do
      begin
        Height := ASize;
        if ABold then
          Style := [ fsBold ]
        else
          Style := [ ];
        Color := AColor;
      end;
  end;

  procedure TTimetable.PrepareDesign( const ADesign: TTimetableDesign );
  begin
    case ADesign of
      dnYellow: begin
          FDayStart := clLYellow;
          FDayEnd := clDYellow;
          FDayFont := clBlack;
        end;
      dnGray: begin
          FDayStart := $00AAAAAA;
          FDayEnd := $00666666;
          FDayFont := clWhite;
        end;
      dnBlue: begin
          FDayStart := $00FF9600;
          FDayEnd := $00A05E00;
          FDayFont := clWhite;
        end;
      dnBlack: begin
          FDayStart := clBlack;
          FDayEnd := $00444444;
          FDayFont := clWhite;
        end;
      dnWhite: begin
          FDayStart := clWhite;
          FDayEnd := $00F4FCEC;
          FDayFont := clBlack;
        end;
      dnRed: begin
          FDayStart := $004C4CFF;
          FDayEnd := $000000FF;
          FDayFont := clWhite;
        end;
    end;
  end;

  procedure TTimetable.HeaderChangeDesign( Sender: TObject );
  begin
    PrepareDesign( FHeader.FDesign );
    CalculateDayQuad;
  end;

  procedure TTimetable.CalculateDayQuad;
  var
    I: Integer;
  const
    Max = 1000;
  begin
    for I := 0 to Max do
      FDayQuad.Pixels[ 0, I ] := Farblauf( FDayStart, FDayEnd, I );
  end;

  function TTimetable.LessonEngagedInExam( ADate: TDate; ALesson: THour ): Integer;
  var
    I: Integer;
  begin
    // Auf Mitternacht setzen
    Result := -1;
    if not FShowDates then
      Exit;
    ADate := Trunc( ADate );
    // Durchsuchen
    for I := 0 to FExams.Count - 1 do
      if Trunc( FExams[ I ].Date ) = ADate then
        if ( FExams[ I ].Start <= ALesson ) and ( FExams[ I ].Start + FExams[ I ].Length > ALesson ) then
          begin
            // Gib Klausur-ID zurück
            Result := I;
            Break;
          end;
  end;

  procedure TTimetable.GetTeachers( const ASubject: TSubject; var AList: TStringList );
  var
    I: Integer;
  begin
    if not assigned( AList ) then
      Exit;
    AList.Add( GetTeacher( ASubject ) );
    for I := 0 to high( FAddTeachers ) do
      if FAddTeachers[ I ].FSubject = ASubject then
        AList.Add( Format( '%s (%s)', [ FAddTeachers[ I ].FTeacher, FAddTeachers[ I ].FCourseName ] ) );

  end;

  function TTimetable.AddTeacher( const ASubject: TSubject; const AName, ACourseName: string ): Integer;
  var
    L: Integer;
  begin
    L := Length( FAddTeachers );
    SetLength( FAddTeachers, L + 1 );
    FAddTeachers[ L ] := TAddTeacher.Create;
    with FAddTeachers[ L ] do
      begin
        Teacher := AName;
        Subject := ASubject;
        CourseName := ACourseName;
      end;
    Result := L;
  end;

  procedure TTimetable.DeleteTeacher( const AIndex: Integer );
  var
    I: Integer;
  begin
    for I := AIndex to high( FAddTeachers ) - 1 do
      FAddTeachers[ I ] := FAddTeachers[ I + 1 ];
    I := high( FAddTeachers ) - 1;
    FAddTeachers[ I + 1 ].Free;
    SetLength( FAddTeachers, I + 1 );
  end;

  function TTimetable.FindTeacher( const ACourseStamp: string ): TCourse;
  var
    I: Integer;
  begin
    Result := $00;
    for I := 0 to high( FAddTeachers ) do
      if Format( '%s (%s)', [ FAddTeachers[ I ].FTeacher, FAddTeachers[ I ].FCourseName ] ) = ACourseStamp then
        begin
          Result := I + 1;
          Break;
        end;
  end;

  procedure TTimetable.LoadVersion1_3( AStream: TStream );
  var
    Max: Integer;
    I: Integer;
  begin
    if FHeader.FVersion >= 1.3 then
      begin
        Max := ReadWord( AStream );
        FreeAddTeachers;
        SetLength( FAddTeachers, Max );
        for I := 0 to Max - 1 do
          begin
            FAddTeachers[ I ] := TAddTeacher.Create;
            FAddTeachers[ I ].LoadFromStream( AStream );
          end;
      end;
  end;

  procedure TTimetable.SaveVersion1_3( AStream: TStream );
  var
    I: Integer;
  begin
    // Ab Version 1.3
    if FHeader.FVersion >= 1.3 then
      begin
        WriteWord( AStream, GetCoursesCount );
        for I := 0 to GetCoursesCount - 1 do
          FAddTeachers[ I ].SaveToStream( AStream );
      end;
  end;

  function TTimetable.GetSubText( ADay: TDay; ALesson: THour; ADate: TDate; const ASeperator: string = ' • ' ): string;
  var
    Room: Integer;
    Course: TCourse;
    Exam: Integer;
  begin
    // Überprüfen, ob es sich um eine Klausur handelt
    Exam := LessonEngagedInExam( ADate, ALesson );
    if Exam = -1 then
      begin
        // Keine Klausur:
        Room := FSubjects[ ADay, ALesson ].FRoom;
        // Wenn keine Abkürzung
        if not FAbbreviation then
          begin
            Course := FSubjects[ ADay, ALesson ].FCourse;
            // Auf Kurs prüfen
            if Course = $00 then
              Result := GetTeacher( FSubjects[ ADay, ALesson ].FSubject )
            else
              Result := FAddTeachers[ Course - 1 ].FTeacher;
          end
        else
          Result := '';
        // Auf Raumnummer prüfen
        if Room > 0 then
          begin
            if not FAbbreviation then
              Result := Result + ASeperator;

            if Room <> FHeader.FClassR then
              Result := Result + EncodeRoom( Room )
            else
              Result := Result + 'Klasse';
          end;
      end
    else
      // Klausur:
      Result := FExams[ Exam ].FInfo;
  end;

  { TAddSubject }

  constructor TAddSubject.Create;
  begin
    FImage := TPNG.Create;
    FHasImage := false;
  end;

  destructor TAddSubject.Destroy;
  begin
    FImage.Free;
    inherited Destroy;
  end;

  procedure TAddSubject.SetImage( aImage: TPNG );
  begin
    FImage.Assign( aImage );
    FHasImage := True;
  end;

  procedure TAddSubject.LoadFromStream( AStream: TStream );
  begin
    FName := ReadStrW( AStream );
    FTeacher := ReadStrW( AStream );
    // Image
    FHasImage := ReadBool( AStream );
    if FHasImage then
      FImage.LoadFromStream( AStream );
  end;

  procedure TAddSubject.SaveToStream( AStream: TStream );
  begin
    WriteStrW( AStream, FName );
    WriteStrW( AStream, FTeacher );
    // Image
    WriteBool( AStream, FHasImage );
    if FHasImage then
      FImage.SaveToStream( AStream );
  end;

  procedure TAddSubject.ClearImage;
  begin
    FImage.Create;
    FHasImage := false;
  end;

  { TAddTeacher }

  procedure TAddTeacher.LoadFromStream( AStream: TStream );
  begin
    FTeacher := ReadStringW( AStream );
    FSubject := ReadByte( AStream );
    FCourseName := ReadStringW( AStream );
  end;

  procedure TAddTeacher.SaveToStream( AStream: TStream );
  begin
    WriteStringW( AStream, FTeacher );
    WriteByte( AStream, FSubject );
    WriteStringW( AStream, FCourseName );
  end;

  { Unit-Procedures }

  procedure InitPictures;
  var
    I: Integer;
  begin
    for I := 1 to MaxSub do
      SubImg[ I ] := LoadPNG( SubImgID[ I ] );
  end;

  procedure FreePictures;
  var
    I: Integer;
  begin
    for I := 1 to MaxSub do
      SubImg[ I ].Free;
  end;

  function EncodeRoom( const ARoom: Byte ): string;
  begin
    case ARoom of
      246 .. 255: Result := 'C' + IntToStr( ARoom - 246 );
      236 .. 245: Result := 'B' + IntToStr( ARoom - 246 );
      226 .. 235: Result := 'A' + IntToStr( ARoom - 246 );
      1 .. 225: Result := IntToStr( ARoom );
      0: Result := '';
    end;
  end;

  function DecodeRoom( const ARoomCode: string ): Byte;
  begin
    if Length( ARoomCode ) > 3 then
      Exit( 0 );
    if ARoomCode = '' then
      Exit( 0 );
    case ARoomCode[ 1 ] of
      'A': Result := ( 226 + StrToIntDef( ARoomCode[ 2 ], 0 ) );
      'B': Result := ( 236 + StrToIntDef( ARoomCode[ 2 ], 0 ) );
      'C': Result := ( 246 + StrToIntDef( ARoomCode[ 2 ], 0 ) );
    else Result := StrToInt( ARoomCode );
    end;
  end;

initialization

  InitPictures;

finalization

  FreePictures;

end.
