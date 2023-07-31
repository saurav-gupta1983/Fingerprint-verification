{ Provides methods and properties for working with users.  }
unit NffvUser;

interface
uses Windows, Graphics, SysUtils, Util;
  type
    { Provides methods and properties for working with users.  }
    TNffvUser = class
      private
        _handle: Pointer;

      public
        { <summary>
          Creates a new instance of the TNffvUser.
          </summary>                               }
        Constructor Create(handle: Pointer);

        property Handle: Pointer read _handle;

        { <summary>
          Retrieves user's Id.
          </summary>
          <returns>
          User's Id.
          </returns>           }
        function GetId(): LongInt;
        { <summary>
          Retrieves a fingerprint image of the concrete user.
          </summary>
          <returns>
          Bitmap object that contains user's fingerprint data.
          </returns>                                           }
        function GetImage(): TBitmap;

    end;
implementation

const
  { Name of the dll that provides the main functionality of the
    FFV SDK.                                                    }
  dllName = 'Nffv.dll';

function NffvUserGetImage(handle: Pointer; var width: LongWord;
    var height: LongWord; var horzResolution: Single; var vertResolution: Single;
    var size: LongWord; pixels: Pointer): Integer stdcall; external dllName;
function NffvUserGetHBitmap(handle: Pointer; var hBitmap: HBitmap): Integer stdcall; external dllName;
function NffvUserGetId(handle: Pointer; var pValue: LongInt): Integer stdcall; external dllName;

Constructor TNffvUser.Create(handle: Pointer);
begin
  if handle <> nil then
    _handle := handle
  else
    begin
      RaiseError('Failed to create user. Handle is NULL');
    end;
end;

function TNffvUser.GetId: LongInt;
  var res: Integer;
      number: Longint;
begin
  res := NffvUserGetId(_handle, number);
  if (Failed(res)) then
  begin
    RaiseError('GetId function failed.', res);
  end;
  Result := number;
end;

function TNffvUser.GetImage: TBitmap;
  var res: Integer;
      nBitmap: TBitmap;
      pBitmap: HBitmap;
begin
  res := NffvUserGetHBitmap(_handle, pBitmap);
   if (Failed(res)) then
  begin
    RaiseError('GetImage function failed.', res);
  end;
  nBitmap := TBitmap.Create;
  nBitmap.Handle := pBitmap;
  Result := nBitmap;
end;
end.
