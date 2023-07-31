{ <summary>
  Contains classes and methods that provide the Free
  Fingerprint Verification SDK functionality. 
  </summary>                                         }
unit Nffv;

interface
  uses Util, NffvUser;

const
  { Name of the dll that provides the main functionality of the
    FFV SDK.                                                    }
  dllName = 'Nffv.dll';
  
type
 { Enumerates enrollment or verification status values. }
 TNffvStatus = ( nfesNone = 0, nfesTemplateCreated = 1, { Indicates that the fingerprint template was created. }
  nfesNoScanner = 2, { Indicates that there is no fingerprint scanner connected. }
 
                    nfesScannerTimeout = 3, { Indicates that the fingerprint scanner has reached the
                      timeout.                                               }
                     nfesUserCanceled = 4, { Indicates that a user has canceled a fingerprint scanning. }
                      nfesQualityCheckFailed = 100 { Indicates that the Free Fingerprint Verification SDK had
                      failed to check the quality of a fingerprint.            }
                    );

type
  { <summary>
    The main class of the Free Fingerprint Verification SDK.
    Provides methods and properties for working with users and
    fingerprints.
    </summary>                                                 }
  TNffv = class
    private
    public
      { <summary>
        Creates a new instance of the TNffv.
        </summary>
        <param name="databaseName">Database name. This database is
                                   used for storing user details and
                                   fingerprints.</param>
        <param name="password">Password for database.</param>        }
      Constructor Create(databaseName: string; password: string); overload;
      { <summary>
        Creates a new instance of the TNffv.
        </summary>
        <param name="databaseName">Database name. This database is
                                   used for storing user details
                                   and fingerprints.</param>
        <param name="password">Password for database.</param>
        <param name="scannerModules">String that contains a list of
                                     scanners to load.</param>      }
      Constructor Create(databaseName: string; password: string; scannerModules: string); overload;
      { <summary>
        Releases resources used by object. 
        </summary>                          }
      Destructor  Destroy; override;

      { <summary>
        Removes all users from a database.
        </summary>                         }
      procedure RemoveUsers;
      { <summary>
        Removes a user specified by an index from a database.
        </summary>
        <param name="index">User's index.</param>             }
      procedure RemoveUser(index: LongInt);
      
      { <summary>
        Gets the number of users that the Nffv contains.
        </summary>
        <returns>
        The number of users in the Nffv.
        </returns>                                       }
      function GetUserCount: LongInt;
      { <summary>
        \Returns a user details by the index.
        </summary>
        <param name="index">User's index.</param>
        <returns>
        A reference to TNffvUser object which provides methods for
        managing enrolled users. 
        </returns>                                                 }
      function GetUserByIndex(index: LongInt): TNffvUser;
      { <summary>
        \Returns a user details by Id.
        </summary>
        <param name="id">User's identification number.</param>
        <returns>
        A reference to TNffvUser object which provides methods for
        managing enrolled users. 
        </returns>                                                 }
      function GetUserById(id: LongInt): TNffvUser;
      { <summary>
        \Returns an index of the user specified by Id.
        </summary>
        <param name="id">User's ID.</param>
        <returns>
        Index of the user specified by Id.
        </returns>                                     }
      function GetUserIndexById(id: LongInt): LongInt;

      { <summary>
        Cancels a fingerprint enrollment or verification operation.
        </summary>
        <remarks>
        This method is useful when the fingerprint enrollment or
        verification operation take too long. In this case a message
        box can be shown for a user to cancel this operation. 
        </remarks>                                                   }
      procedure Cancel;
      { <summary>
        Gets a fingerprint from a scanner and saves it to a database.
        </summary>
        <param name="timeout">Specifies the time in
                              milliseconds after which the
                              fingerprint scanner stops
                              scanning fingerprint. This
                              usually happens when a finger is
                              removed from a scanner for longer
                              than timeout milliseconds. </param>
        <param name="engineStatus">The enrollment status value.</param>
        <returns>
        A reference to TNffvUser object which provides methods for
        managing enrolled users. 
        </returns>                                                      }
      function Enroll(timeout: LongWord; var engineStatus: TNffvStatus): TNffvUser;
      { <summary>
        Compares a captured fingerprint with the one that was
        enrolled to a database before in order to determine whether
        two match.
        </summary>
        <param name="user">A reference to a database record
                           that should be matched with the
                           scanned fingerprint. </param>
        <param name="timeout">Specifies the time in
                              milliseconds after which the
                              fingerprint scanner stops
                              scanning fingerprint. This
                              usually happens when a finger is
                              removed from a scanner for longer
                              than timeout milliseconds. </param>
        <param name="engineStatus">Verification status value.</param>
        <returns>
        This function returns a matching score. 
        </returns>                                                    }
      function Verify(user: TNffvUser; timeout: LongWord; var engineStatus: TNffvStatus): LongInt;

      { <summary>
        Gets image quality threshold.
        </summary>
        <returns>
        The fingerprint quality threshold. The value should be in
        range [0, 255]. The default value is 100.
        </returns>                                                }
      function GetQualityThreshold: Byte;
      { <summary>
        Sets image quality threshold.
        </summary>
        <param name="threshold">The fingerprint quality threshold.
                                The value should be in range [0,
                                255]. The default value is 100. </param> }
      procedure SetQualityThreshold(threshold: Byte);
      { <summary>
        Gets the minimum similarity value that verification function
        uses to determine whether the fingerprint matches.
        </summary>
        <returns>
        The minimum similarity value that verification function
        accept for the same finger fingerprints. The default value is
        0.01 %. 
        </returns>                                                    }
      function GetMatchingThreshold: LongInt;
      { <summary>
        Sets the minimum similarity value that verification function
        uses to determine whether the fingerprint matches.
        </summary>
        <param name="threshold">The minimum similarity value that
                                verification function accept for the
                                same finger fingerprints. The
                                default value is 0.01 %. </param>    }
      procedure SetMatchingThreshold(threshold: LongInt);

  end;

{ <summary>
  \Returns available fingerprint scanner modules for usage in
  the Free Fingerprint Verification SDK.
  </summary>
  <returns>
  String that hold available fingerprint scanners. Each
  fingerprint scanner module is separated by a semicolon.
  </returns>                                                  }
function GetAvailableScannerModules(): String;
{ <summary>
  Gets information about the Nffv library.
  </summary>
  <returns>
  Object which type is TNlibraryInfo.
  </returns>                               }
function NffvGetInfo(): TNLibraryInfo;
{ <summary>
  Gets a string message that hold information about TNffv
  status.
  </summary>
  <param name="status">NffvStatus object.</param>
  <returns>
  String message that hold information about TNffv status.
  </returns>                                               }
function EngineStatusString(status: TNffvStatus): string;
{ <summary>
  Releases memory allocated by the <see cref="Nffv.GetAvailableScannerModules" text="GetAvailableScannerModules" />
  function.
  </summary>
  <param name="point">Memory block to release.</param>                                                              }
procedure NffvFreeMemory(point: PChar); stdcall; external dllName;

implementation

  function  NffvGetInfoA(var info: TNLibraryInfo): Integer stdcall; external dllName;
  function  NffvGetAvailableScannerModulesA(var scannerModules: PChar): Integer stdcall; external dllName;
  function  NffvInitializeA(dbName: String; password: String; scannerModules: String): Integer stdcall; external dllName; overload;
  function  NffvInitializeA(dbName: String; password: String; var scannerModules: Integer): Integer stdcall; external dllName; overload;
  procedure NffvUninitialize(); stdcall; external dllName;

  function NffvEnroll(timeout: LongWord; var engineStatus: LongInt; var hUser: Pointer): Integer; stdcall; external dllName;
  function NffvVerify(hUser: Pointer; timeout: LongWord; var engineStatus: LongInt; var score: LongInt): Integer; stdcall; external dllName;
  function NffvCancel(): Integer stdcall; external dllName;

  function NffvGetUserById(id: LongInt; var hUser: Pointer): Integer; stdcall; external dllName;
  function NffvGetUserIndexById(id: LongInt; var index: LongInt): Integer; stdcall; external dllName;

  function NffvGetUserCount(var count: LongInt): Integer; stdcall; external dllName;
  function NffvGetUser(index: LongInt; var pValue: Pointer): Integer; stdcall; external dllName;
  function NffvRemoveUser(index: LongInt): Integer; stdcall; external dllName;
  function NffvClearUsers(): Integer stdcall; external dllName;

  function NffvGetQualityThreshold(var b: Byte): Integer stdcall; external dllName;
  function NffvSetQualityThreshold(b: Byte): Integer stdcall; external dllName;
  function NffvGetMatchingThreshold(var pValue: Longint): Integer stdcall; external dllName;
  function NffvSetMatchingThreshold(pValue: Longint): Integer stdcall; external dllName;

  function NffvGetInfo: TNLibraryInfo;
   var res: Integer;
      info: TNLibraryInfo;
  begin
   res := NffvGetInfoA(info);
   if (Failed(res)) then
    begin
      RaiseError('NffvGetInfo failed.', res);
    end;
   Result := info;
  end;

  function EngineStatusString(status: TNffvStatus): string;
  begin
    if (status = nfesNone) then
      Result := 'None';
    if (status = nfesTemplateCreated) then
      Result := 'Template Created';
    if (status = nfesNoScanner) then
      Result := 'No scanner';
    if (status = nfesScannerTimeout) then
      Result := 'Scanner timeout';
    if (status = nfesUserCanceled) then
      Result := 'User canceled';
    if (status = nfesQualityCheckFailed) then
      Result := 'Quality check failed';
  end;

  function GetAvailableScannerModules(): String;
    var res: Integer;
        str: PChar;
        str2: String;
        resultString: String;
  begin
    res := NffvGetAvailableScannerModulesA(str);
    str2 := string(str);
    resultString := str2;
    if (Failed(res)) then
    begin
      RaiseError('GetAvailableScannerModules failed.', res);
    end;
    Result := resultString;
    NffvFreeMemory(str);
  end;

  function TNffv.GetQualityThreshold: Byte;
    var res: Integer;
        b: Byte;
  begin
    res := NffvGetQualityThreshold(b);
    if (Failed(res)) then
    begin
      RaiseError('Get quality threshold failed.', res);
    end;
    Result := b;
  end;

  function TNffv.GetMatchingThreshold: LongInt;
    var res: Integer;
        b: LongInt;
  begin
    res := NffvGetMatchingThreshold(b);
    if (Failed(res)) then
    begin
      RaiseError('Get matching threshold failed.', res);
    end;
    Result := b;
  end;

  procedure TNffv.SetQualityThreshold(threshold: Byte);
    var res: Integer;
  begin
    res := NffvSetQualityThreshold(threshold);
    if (Failed(res)) then
    begin
      RaiseError('Set quality threshold failed.', res);
    end;
  end;

  procedure TNffv.SetMatchingThreshold(threshold: LongInt);
    var res: Integer;
  begin
    res := NffvSetMatchingThreshold(threshold);
    if (Failed(res)) then
    begin
      RaiseError('Set matching threshold failed.', res);
    end;
  end;
  
  procedure TNffv.RemoveUsers;
    var res: Integer;
  begin
    res := NffvClearUsers();
    if (Failed(res)) then
    begin
      RaiseError('Remove users failed.', res);
    end;
  end;

  procedure TNffv.RemoveUser(index: LongInt);
    var res: Integer;
  begin
    res := NffvRemoveUser(index);
    if (Failed(res)) then
    begin
      RaiseError('Remove user failed.', res);
    end;
  end;

  function TNffv.GetUserCount: Integer;
    var res: Integer;
        count: LongInt;
  begin
    res := NffvGetUserCount(count);
    if (Failed(res)) then
    begin
      RaiseError('User count failed.', res);
    end;
    Result := count;
  end;

  function TNffv.GetUserById(id: LongInt): TNffvUser;
    var index: LongInt;
  begin
    index := GetUserIndexById(id);
    Result := GetUserByIndex(index);
  end;

  function TNffv.GetUserIndexById(id: LongInt): LongInt;
     var res: Integer;
        index: LongInt;
  begin
    res := NffvGetUserIndexById(id, index);
    if (Failed(res)) then
    begin
      RaiseError('Get user index by id failed.', res);
    end;
    Result := index;
  end;

  function TNffv.GetUserByIndex(index: LongInt): TNffvUser;
    var res: Integer;
        handle: Pointer;
        user: TNffvUser;
  begin
    res := NffvGetUser(index, handle);
    if (Failed(res)) then
    begin
      RaiseError('Get user by index failed.', res);
    end;
    user := TNffvUser.Create(handle);
    Result := user;
  end;

  procedure TNffv.Cancel;
    var res: Integer;
  begin
    res := NffvCancel();
    if (Failed(res)) then
    begin
      RaiseError('Cancel failed.', res);
    end;
  end;

  function TNffv.Enroll(timeout: Cardinal; var engineStatus: TNffvStatus): TNffvUser;
    var res: Integer;
        engStatus: Integer;
        handle: Pointer;
  begin
    res := NffvEnroll(timeout, engStatus, handle);
    if (Failed(res)) then
    begin
      RaiseError('Enrollment failed.', res);
    end;
    engineStatus := TNffvStatus(engStatus);
    if (engineStatus = nfesTemplateCreated) then
    begin
      Result := TNffvUser.Create(handle);
    end
    else
      Result := nil;
  end;

  function TNffv.Verify(user: TNffvUser; timeout: Cardinal; var engineStatus: TNffvStatus): LongInt;
    var res: Integer;
        engStatus: Integer;
        score: LongInt;
  begin
    res := NffvVerify(user.Handle, timeout, engStatus, score);
    if (Failed(res)) then
    begin
      RaiseError('Verification failed.', res);
    end;
    engineStatus := TNffvStatus(engStatus);
    Result := score;
  end;

  destructor TNffv.Destroy;
  begin
    NffvUninitialize();
    inherited Destroy;
  end;

  Constructor TNffv.Create(databaseName: string; password: string; scannerModules: string);
    var res: Integer;
        temp: Integer;
  begin
    temp := 0;
    if (Length(scannerModules) = 0) then
    begin
     res := NffvInitializeA(databaseName, password, temp);
    end
    else
    begin
     res := NffvInitializeA(databaseName, password, scannerModules);
    end;
    if (Failed(res)) then
    begin
      RaiseError('Create of engine failed.', res);
    end;
  end;

   Constructor TNffv.Create(databaseName: string; password: string);
    var res: Integer;
  begin
    res := NffvInitializeA(databaseName, password, '');
    if (Failed(res)) then
    begin
      RaiseError('Create of engine failed.', res);
    end;
  end;

end.
