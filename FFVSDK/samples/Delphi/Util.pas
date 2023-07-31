unit Util;

interface
  uses Math, Windows, SysUtils;
    
type
 TNLibraryInfo = record
  Title: array[0..63] of Char;
  Product: array[0..63] of Char;
  Company: array[0..63] of Char;
  Copyright: array[0..63] of Char;
  VersionMajor: Integer;
  VersionMinor: Integer;
  VersionBuild: Integer;
  VersionRevision: Integer;
  DistributorId: Integer;
  SerialNumber: Integer;
 end;
  
  function Succeeded(Res: Integer): Boolean;
  function Failed(Res: Integer): Boolean;
  procedure RaiseError(msg: String; Err: Integer); overload;
  procedure RaiseError(msg: String); overload;
  function GetOS: String;
  function MatchingThresholdToString(value: Integer): string;
  function MatchingThresholdFromString(value: string): Integer;

implementation
const
 Epsilon   = 1.0E-12;
  dllName = 'Nffv.dll';
  
  function NffvGetErrorMessageA(errorCode: LongInt; msg: PChar): Integer stdcall; external dllName;
   
function GetOS: String;
var
  PlatformId, VersionNumber: string;
  CSDVersion: String;
begin
  CSDVersion := '';

  // Detect platform
  case Win32Platform of
    // Test for the Windows 95 product family
    VER_PLATFORM_WIN32_WINDOWS:
    begin
      if Win32MajorVersion = 4 then
        case Win32MinorVersion of
          0:  if (Length(Win32CSDVersion) > 0) and
                 (Win32CSDVersion[1] in ['B', 'C']) then
                PlatformId := '95 OSR2'
              else
                PlatformId := '95';
          10: if (Length(Win32CSDVersion) > 0) and
                 (Win32CSDVersion[1] = 'A') then
                PlatformId := '98 SE'
              else
                PlatformId := '98';
          90: PlatformId := 'ME';
        end
      else
        PlatformId := '9x version (unknown)';
    end;
    // Test for the Windows NT product family
    VER_PLATFORM_WIN32_NT:
    begin
      if Length(Win32CSDVersion) > 0 then CSDVersion := Win32CSDVersion;
      if Win32MajorVersion <= 4 then
        PlatformId := 'NT'
      else
        if Win32MajorVersion = 5 then
          case Win32MinorVersion of
            0: PlatformId := '2000';
            1: PlatformId := 'XP';
            2: PlatformId := 'Server 2003';
          else
            PlatformId := 'Future Windows version (unknown)';
          end
        else
         if Win32MajorVersion = 6 then PlatformId := 'Vista'
         else
          PlatformId := 'Future Windows version (unknown)';
    end;
  end;
  VersionNumber := Format(' Version %d.%d Build %d %s', [Win32MajorVersion,
                                                        Win32MinorVersion,
                                                        Win32BuildNumber,
                                                        CSDVersion]);
  Result := 'Microsoft Windows ' + PlatformId + VersionNumber;
end;

function MatchingThresholdToString(value: LongInt): string;
 var p : double;
     tmp: integer;
     tmp2: Double;
     str: string;
begin
 DecimalSeparator := '.';
 p := - value / 12.0;
 tmp := Max(0, Ceil(-p) - 2);
 tmp2 := Power(10, p)*100;
 str := '%.'+IntToStr(tmp)+'f';
 str := Format(str,[tmp2]);
 Result := str;
end;

function MatchingThresholdFromString(value: string): Integer;
 var p: double;
begin
 DecimalSeparator := '.';
 p := Log10(Max(Epsilon,Min(1,StrToFloat(Trim(value))/100)));
 Result := Max(0, Round(-12 * p));
end;

function ErrToStr(err: Integer): String;
  var res: Integer;
      str: String;
      point: PChar;
begin
  str := '';
  res := NffvGetErrorMessageA(err, nil);
  if (res > 0) then
  begin
    res := res + 1;
    point := GetMemory(res);
    res := NffvGetErrorMessageA(err, point);
    if (Failed(res)) then
    begin
      RaiseError('NErrorGetDefaultMessageA failed.', res);
    end;
    str := string(point);
    FreeMem(point);
  end;
  Result := str;
end;

function Succeeded(Res: Integer): Boolean;
begin
  Result := Res >= 0;
end;

function Failed(Res: Integer): Boolean;
begin
  Result := Res < 0;
end;

procedure RaiseError(msg: String; Err: Integer);
begin
  raise Exception.CreateFmt(msg + #13#10'Error:'#13#10' Code = %d'#13#10' ' + ErrToStr(Err),
    [Err]);
end;

procedure RaiseError(msg: String);
begin
  raise Exception.CreateFmt(msg, []);
end;
end.
