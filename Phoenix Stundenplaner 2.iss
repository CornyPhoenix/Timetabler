; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{A60AE1D9-0CB1-4627-B303-F437AA7F0526}
AppName=Phoenix Stundenplaner
AppVerName=Phoenix Stundenplaner 2.13.1
AppVersion=2.13.1.1941
AppPublisher=Phoenix Systems
AppPublisherURL=http://stundenplaner.phoenixsystems.de/
AppSupportURL=http://stundenplaner.phoenixsystems.de/
AppUpdatesURL=http://stundenplaner.phoenixsystems.de/
DefaultDirName={pf}\Phoenix Stundenplaner
DefaultGroupName=Phoenix Stundenplaner
AllowNoIcons=yes
LicenseFile=C:\Users\Admin\Documents\RAD Studio\Projekte\Timetabeling\License.rtf
OutputDir=C:\Users\Admin\Documents\RAD Studio\Projekte\Timetabeling\Setup
OutputBaseFilename=SetupPhoenixStundenplaner2
SetupIconFile=C:\Users\Admin\Documents\RAD Studio\Projekte\Timetabeling\setup.ico
Compression=lzma
SolidCompression=yes
WizardImageFile=C:\Users\Admin\Documents\RAD Studio\Projekte\Timetabeling\Setup\setup_big.bmp
WizardSmallImageFile=C:\Users\Admin\Documents\RAD Studio\Projekte\Timetabeling\Setup\setup_small.bmp
UninstallDisplayName=Phoenix Stundenplaner 2
UninstallDisplayIcon={app}\Timetabeling.exe, 0

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "basque"; MessagesFile: "compiler:Languages\Basque.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "hungarian"; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "slovak"; MessagesFile: "compiler:Languages\Slovak.isl"
Name: "slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Registry]
Root: HKCR; Subkey: ".timetable"; ValueName: ""; ValueType: string; ValueData: "Phoenix Timetable"; Flags: uninsdeletekey;
Root: HKCR; Subkey: "Phoenix Timetable"; ValueName: ""; ValueType: string; ValueData: "Stundenplan"; Flags: uninsdeletekey;
Root: HKCR; Subkey: "Phoenix Timetable\DefaultIcon"; ValueName: ""; ValueType: string; ValueData: """{app}\Timetabeling.exe"",1"; Flags: uninsdeletekey;
Root: HKCR; Subkey: "Phoenix Timetable\Shell"; Flags: uninsdeletekey;
Root: HKCR; Subkey: "Phoenix Timetable\Shell\Open"; ValueName: ""; ValueType: string; ValueData: "Stundenplan &bearbeiten"; Flags: uninsdeletekey;
Root: HKCR; Subkey: "Phoenix Timetable\Shell\Open\Command"; ValueName: ""; ValueType: string; ValueData: """{app}\Timetabeling.exe"" ""%1"""; Flags: uninsdeletekey;

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Users\Admin\Documents\RAD Studio\Projekte\Timetabeling\Timetabeling.exe"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\Phoenix Stundenplaner"; Filename: "{app}\Timetabeling.exe"
Name: "{group}\{cm:ProgramOnTheWeb,Phoenix Stundenplaner}"; Filename: "http://stundenplaner.phoenixsystems.de/"
Name: "{group}\{cm:UninstallProgram,Phoenix Stundenplaner}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\Phoenix Stundenplaner"; Filename: "{app}\Timetabeling.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\Phoenix Stundenplaner"; Filename: "{app}\Timetabeling.exe"; Tasks: quicklaunchicon

[UninstallDelete]
Type: files; Name: "{app}\recent.files"

[Run]
Filename: "{app}\Timetabeling.exe"; Description: "{cm:LaunchProgram,Phoenix Stundenplaner}"; Flags: nowait postinstall skipifsilent










