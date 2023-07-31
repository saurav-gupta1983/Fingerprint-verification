program DelphiSample;

uses
  Forms,
  Controls,
  Dialogs,
  MainForm in 'MainForm.pas' {MainForm},
  ChooseScannerForm in 'ChooseScannerForm.pas' {ChooseScannerForm},
  Nffv in 'Nffv.pas',
  NffvUser in 'NffvUser.pas',
  Util in 'Util.pas',
  SysUtils,
  AboutForm in 'AboutForm.pas',
  UserInfoForm in 'UserInfoForm.pas' {UserInformationForm},
  EnrollForm in 'EnrollForm.pas' {EnrollForm},
  SettingsForm in 'SettingsForm.pas' {SettingsForm},
  UserList in 'UserList.pas';

{$R *.res}
 var Engine: TNffv;

begin
  Engine :=  nil;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ScannerForm := TScannerForm.Create(Application);
  if (ScannerForm.ShowModal = mrOk) then
  begin
   try
    Engine := TNffv.Create(ScannerForm.GetFingerprintDatabase, ScannerForm.GetPassword, ScannerForm.ScannerString);
   except
     MessageDlg('Failed to initialize Nffv or create/load database.' + #13#10 +
						'Please check if:' + #13#10 + ' - Provided password is correct;'  + #13#10 + ' - Database filename is correct;' +  #13#10 +
						' - Scanners are used properly.', mtError, [mbOK], 0);
     FreeAndNil(Engine);
     Exit;
   end;
    try
      begin
        MForm := TMainForm.Create(Application, Engine, ScannerForm.GetUserDatabase);
        MForm.ShowModal;
      end;
    finally
      begin
        FreeAndNil(Engine);
      end;
    end;
  end
  else
    Exit;
end.
