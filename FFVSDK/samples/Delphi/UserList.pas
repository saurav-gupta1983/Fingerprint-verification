unit UserList;
interface
 uses Windows, SysUtils, Util, IniFiles, Classes;
 
 type

  TUser = class
    public
      UserName: string;
      UserID: LongInt;
      constructor Create(const Name   : String;
                         const ID : Integer);
  end;

  TUserDatabase = class(TList)
    private
      _databaseName: String;
    public
      procedure Save;
      function GetById(id: LongInt): TUser;

      Constructor Create(databaseName: string);
      Destructor  Destroy; override;
  end;

 implementation

  Constructor TUser.Create(const Name: string; const ID: Integer);
  begin
    userName := name;
    UserID := id;
  end;

  function TUserDatabase.GetById(id: Integer): TUser;
    var i: Integer;
        user: TUser;
  begin
   for I := 0 to Count - 1 do
   begin
    user := self[i];
    if (user.UserID = id) then
    begin
     Result := user;
     Exit;
    end;
   end;
   Result := nil;
  end;

  Constructor TUserDatabase.Create(databaseName: string);
    var IniFile  : TIniFile;
        i: Integer;
        name: String;
        id: LongInt;
        user: TUser;
  begin
    i := 0;
    if (Length(databaseName) <= 0) then
    begin
      RaiseError('User database name length is zero');
    end;
    _databaseName := databaseName;
    iniFile := TIniFile.Create(_databaseName);
    try
      while (iniFile.SectionExists('User' + IntToStr(i))) do
      begin
        if (iniFile.ValueExists('User' + IntToStr(i), 'ID')) then
        begin
          id := iniFile.ReadInteger('User' + IntToStr(i), 'ID', -1);
          if (id >= 0) then
          begin
            if (iniFile.ValueExists('User' + IntToStr(i), 'UserName')) then
            begin
              name := iniFile.ReadString('User' + IntToStr(i), 'UserName', '');
              if (Length(name) > 0) then
              begin
                user := TUser.Create(name, id);
                self.Add(user);
              end;
            end;
          end;
        end;
        i := i + 1;        
      end;
    finally
      FreeAndNil(iniFile);
    end;
  end;

  Destructor TUserDatabase.Destroy;
  begin
    Save;
    inherited Destroy;
  end;

  procedure TUserDatabase.Save;
    var iniFile: TIniFile;
        i: Integer;
        user: TUser;
  begin
    DeleteFile(_databaseName);
    iniFile := TIniFile.Create(_databaseName);
    try
      for I := 0 to Count - 1 do
      begin
          user := self[i];
          iniFile.WriteString('User' + IntToStr(i), 'UserName', user.UserName);
          iniFile.WriteInteger('User' + IntToStr(i), 'ID', user.UserID);
      end;
    finally
      FreeAndNil(iniFile);
    end;
  end;

 end.
