unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Nffv, ToolWin, ComCtrls, Menus, ImgList, NffvUser, UserList,
  StdCtrls, ExtCtrls, Buttons, AboutForm, UserInfoForm, EnrollForm, TypInfo, Util, SettingsForm;

type
  TEnrollmentThread = class(TThread)
  private
    _engineStatus: TNffvStatus;
    _user: TNffvUser;
    _name: String;
  protected
    procedure Execute; override;
    procedure UpdateCaption;
  public
    constructor Create(name: string);
    property EngineStatus: TNffvStatus read _engineStatus;
    property EngineUser: TNffvUser read _user;
  end;

  TMatchingThread = class(TThread)
    private
      _user: TNffvUser;
      _engineStatus: TNffvStatus;
      _score: LongInt;
      _userDatabase: TUserDatabase;
    protected
      constructor Create(userDatabase: TUserDatabase; user: TNffvUser);
      procedure Execute; override;
      procedure UpdateCaption;
  end;

  TAnimationThread = class(TThread)
    private
      _timeout: LongInt;
      _current: LongInt;
      _stop: Boolean;
    protected
      constructor Create(timeout: LongInt);
      procedure Execute; override;
      procedure UpdateCaption;
      procedure UpdateStoped;
      procedure Stop;
  end;
  
  TMainForm = class(TForm)
    tbMain: TToolBar;
    ToolButton1: TToolButton;
    pnlMain: TPanel;
    Splitter: TSplitter;
    lbUsers: TListBox;
    ImageList: TImageList;
    pnlLeft: TPanel;
    pbImage: TImage;
    btnEnroll: TBitBtn;
    btnVerify: TBitBtn;
    btnDelete: TBitBtn;
    btnClear: TBitBtn;
    btnSettings: TBitBtn;
    btnAbout: TBitBtn;
    StatusBar: TStatusBar;
    pbBar: TProgressBar;
    btnCancel: TButton;
    Label1: TLabel;
    pnlRight: TPanel;
    procedure FormDestroy(Sender: TObject);
    procedure tbtnDeleteDatabaseClick(Sender: TObject);
    procedure tbtnDeleteUserClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure lbUsersDblClick(Sender: TObject);
    procedure btnEnrollClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnVerifyClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);

  private
    _engine: TNffv;
    _userDatabase: TUserDatabase;

    _enrollmentThread: TEnrollmentThread;
    _matchingThread: TMatchingThread;
    _animationThread: TAnimationThread;
  public
    constructor Create(AOwner: TComponent; engine: TNffv; userDatabase: String); reintroduce; virtual;
    property AnimationThread: TAnimationThread read _animationThread;
    property Engine: TNffv read _engine write _engine;
  end;

var
  MForm: TMainForm;

implementation

{$R *.dfm}

constructor TAnimationThread.Create(timeout: Integer);
begin
  inherited Create(true);
  _timeout := timeout;
end;

procedure TAnimationThread.Execute;
begin
  Synchronize(UpdateCaption);
  while ((not _stop)) do
  begin
    _current := _current + 1;
    if (_current > _timeout) then
    begin
       _current := 0;
    end;
    Synchronize(UpdateCaption);
    Sleep(100);
  end;
  Synchronize(UpdateStoped);
end;

procedure TAnimationThread.UpdateStoped;
begin
 MForm.btnCancel.Visible := false;
 MForm.pbBar.Visible := false;
end;

procedure TAnimationThread.UpdateCaption;
begin
  MForm.btnCancel.Visible := true;
  MForm.pbBar.Visible := true;

  MForm.pbBar.Max := _timeout;
  MForm.pbBar.Position := _current;
end;

procedure TAnimationThread.Stop;
begin
  _stop := true;
end;

constructor TMatchingThread.Create(userDatabase: TUserDatabase; user: TNffvUser);
begin
  inherited Create(false);
  _userDatabase := userDatabase;
  _user := user;
end;

procedure TMatchingThread.Execute;
begin
  if (_user <> nil) then
   begin
     _score := MForm.Engine.Verify(_user, 20000, _engineStatus);
     Synchronize(UpdateCaption);
   end;
end;

procedure TMatchingThread.UpdateCaption;
begin
  MForm.AnimationThread.Stop;
  if (_engineStatus = nfesTemplateCreated) then
  begin
    if (_score > 0) then
      begin
       MessageDlg(_userDatabase.GetById(_user.GetId).UserName + ' verified.' + #13#10 + 'Fingerprints match. Score: ' + IntToStr(_score), mtInformation, [mbOk], 0);
      end
    else
      begin
       MessageDlg(_userDatabase.GetById(_user.GetId).UserName + ' not verified.' + #13#10 + 'Fingerprints do not match.', mtInformation, [mbOk], 0);
      end;
  end
  else
  begin
    MessageDlg('Verification was not finished. Reason: ' + EngineStatusString(_engineStatus), mtError, [mbOk], 0);
  end;
  MForm.btnEnroll.Enabled := true;
  MForm.btnVerify.Enabled := true;
end;

constructor TEnrollmentThread.Create(name: string);
begin
  inherited Create(false);
  _name := name;
end;

procedure TEnrollmentThread.Execute;
begin
 _user := MForm.Engine.Enroll(20000, _engineStatus);
 Synchronize(UpdateCaption);
end;

procedure TEnrollmentThread.UpdateCaption;
var user: TUser;
    bitmap: TBitmap;
begin
 MForm.AnimationThread.Stop;
 if (_engineStatus = nfesTemplateCreated) then
  begin
    if (Length(_name) <= 0) then
    begin
      _name := IntToStr(engineUser.GetId);
    end;
    if (MForm.pbImage.Picture.Bitmap <> nil) then
    begin
      bitmap := MForm.pbImage.Picture.Bitmap;
      FreeAndNil(bitmap);
    end;
    MForm.pbImage.Picture.Bitmap := _user.GetImage;
    user := TUser.Create(_name, _user.GetId);
    MForm._userDatabase.Add(user);
    MForm._userDatabase.Save;
    MForm.lbUsers.AddItem(_name, user);
    MForm.lbUsers.Selected[MForm.lbUsers.Count - 1] := true;
  end
  else
  begin
   MessageDlg('Enrollment was not finished. Reason: ' + EngineStatusString(engineStatus), mtError, [mbOk], 0);
  end;
  MForm.btnEnroll.Enabled := true;
  MForm.btnVerify.Enabled := true;
end;

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  AboutBox(self);
end;

procedure TMainForm.btnCancelClick(Sender: TObject);
begin
  _engine.Cancel;
end;

procedure TMainForm.btnEnrollClick(Sender: TObject);
  var name: String;
begin
  btnEnroll.Enabled := false;
  btnVerify.Enabled := false;
  EnrollFrm := TEnrollFrm.Create(self);
  try
    if (EnrollFrm.ShowModal <> mrOk) then
    begin
      btnEnroll.Enabled := true;
      btnVerify.Enabled := true;
      Exit;
    end;
    name := EnrollFrm.GetUsername;
  finally
    FreeAndNil(EnrollFrm);
  end;

  if (_enrollmentThread <> nil) then
    begin
      _engine.Cancel;
      _enrollmentThread.DoTerminate;
      FreeAndNil(_enrollmentThread);
    end;
    _enrollmentThread := TEnrollmentThread.Create(name);
    if (_animationThread <> nil) then
  begin
    _animationThread.Stop;
    FreeAndNil(_animationThread);
  end;
    _animationThread := TAnimationThread.Create(100);
    _animationThread.Resume;
    if (lbUsers.Items.Count > 0) then
  begin
    lbUsers.Selected[lbUsers.Items.Count - 1] := true;
  end;
end;

procedure TMainForm.btnSettingsClick(Sender: TObject);
begin
  SettingsFrm := TSettingsFrm.Create(self, _engine.GetQualityThreshold, _engine.GetMatchingThreshold);
  try
    if (SettingsFrm.ShowModal = mrOk) then
    begin
      _engine.SetQualityThreshold(SettingsFrm.tbQThreshold.Position);
      _engine.SetMatchingThreshold(MatchingThresholdFromString(SettingsFrm.cbMThreshold.Items[SettingsFrm.cbMThreshold.ItemIndex]));
    end;
  finally
    FreeAndNil(SettingsFrm);
  end;
end;

procedure TMainForm.btnVerifyClick(Sender: TObject);
  var i: Integer;
      selectedIndex: Integer;
      user: TUser;
      userEngine: TNffvUser;
begin
 btnEnroll.Enabled := false;
 btnVerify.Enabled := false;
 selectedIndex := -1;
 for I := lbUsers.Count - 1 downto 0 do
 begin
  if (lbUsers.Selected[i]) then
  begin
    selectedIndex := i;
  end;
 end;
 if (selectedIndex = -1) then
 begin
   MessageDlg('Please select a record from the database.', mtInformation, [mbOK], 0);
   btnEnroll.Enabled := true;
   btnVerify.Enabled := true;
 end
 else
 begin
  user := TUser(lbusers.Items.Objects[selectedIndex]);
  if (user <> nil) then
  begin
    userEngine := _engine.GetUserById(user.UserID);
    if (_matchingThread <> nil) then
    begin
      _engine.Cancel;
      _matchingThread.DoTerminate;
      FreeAndNil(_matchingThread);
    end;
    _matchingThread := TMatchingThread.Create(_userDatabase, userEngine);
    if (_animationThread <> nil) then
  begin
    _animationThread.Stop;
    FreeAndNil(_animationThread);
  end;
    _animationThread := TAnimationThread.Create(100);
    _animationThread.Resume;
  end
  else
  begin
    btnEnroll.Enabled := true;
    btnVerify.Enabled := true;
  end;
 end;
end;

constructor TMainForm.Create(AOwner: TComponent; engine: TNffv; userDatabase: string);
  var i, count: Integer;
      user: TUser;
      id: Integer;
      name: string;
      userEngine: TNffvUser;
begin
  inherited Create(aowner);
  _engine := engine;
  _userDatabase := TUserDatabase.Create(userDatabase);
  count := _engine.GetUserCount;
  for I := 0 to count - 1 do
  begin
    userEngine := _engine.GetUserByIndex(i);
    id := userEngine.GetId;
    user := _userDatabase.GetById(id);
    if (user = nil) then
    begin
      name := IntToStr(id);
      user := TUser.Create(name, id);
      _userDatabase.Add(user);
    end
    else
      name := user.UserName;
    lbUsers.AddItem(name, user);
  end;
  if (lbUsers.Items.Count > 0) then
  begin
    lbUsers.Selected[0] := true;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if _enrollmentThread <> nil then
  begin
      _engine.Cancel;
      _enrollmentThread.DoTerminate;
     FreeAndNil(_enrollmentThread);
  end;
  if _matchingThread <> nil then
  begin
    _engine.Cancel;
      _matchingThread.DoTerminate;
      FreeAndNil(_matchingThread);
  end;

  if (_animationThread <> nil) then
  begin
    _animationThread.Stop;
    FreeAndNil(_animationThread);
  end;

  if (_userDatabase <> nil) then
    FreeAndNil(_userDatabase);
end;

procedure TMainForm.lbUsersDblClick(Sender: TObject);
var i: Integer;
      selectedIndex: Integer;
      user: TUser;
      userEngine: TNffvUser;
begin
 selectedIndex := -1;
 for I := lbUsers.Count - 1 downto 0 do
 begin
  if (lbUsers.Selected[i]) then
  begin
    selectedIndex := i;
  end;
 end;
 if (selectedIndex <> -1) then
 begin
  user := TUser(lbusers.Items.Objects[selectedIndex]);
  UserInformationForm := TUserInformationForm.Create(self);
  try
    UserInformationForm.SetUserName(user.UserName);
    userEngine := _engine.GetUserById(user.UserID);
    if (userEngine <> nil) then
    begin
      UserInformationForm.SetUserImage(userEngine.GetImage);
    end;
    UserInformationForm.ShowModal;
  finally
    FreeAndNil(UserInformationForm);
  end;
 end;

end;

procedure TMainForm.tbtnDeleteDatabaseClick(Sender: TObject);
begin
  if (MessageDlg('All records will be deleted from database. Do you want to continue?', mtConfirmation, mbYesNo, 0) = mrNo) Then
  begin
    Exit;
  end;
  _engine.RemoveUsers;
  lbUsers.Clear;
  _userDatabase.Clear;
  _userDatabase.Save;
end;

procedure TMainForm.tbtnDeleteUserClick(Sender: TObject);
  var i: Integer;
      selectedIndex: Integer;
      user: TUser;
      id: Integer;
begin
 selectedIndex := -1;
 for I := lbUsers.Count - 1 downto 0 do
 begin
  if (lbUsers.Selected[i]) then
  begin
    selectedIndex := i;
  end;
 end;
 if (selectedIndex = -1) then
 begin
   MessageDlg('Please select a record from the database.', mtInformation, [mbOK], 0);
 end
 else
 begin
   user := TUser(lbusers.Items.Objects[selectedIndex]);
   if (user <> nil) then
   begin
     id := user.UserID;
    _userDatabase.Remove(user);
    _engine.RemoveUser(_engine.GetUserIndexById(id));
    lbUsers.Items.Delete(selectedIndex);
   end;
   if (lbUsers.Items.Count > 0) then
  begin
    lbUsers.Selected[0] := true;
  end;
 end; 

end;

end.
