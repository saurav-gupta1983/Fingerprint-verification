unit ChooseScannerForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Nffv;

type
  TScannerForm = class(TForm)
    Label1: TLabel;
    clbScannerList: TCheckListBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    tbDatabase: TEdit;
    tbPassword: TEdit;
    tbUserDatabase: TEdit;
    btnCancel: TButton;
    btnOk: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    _allModuleString: String;
    _scannerString: String;
  public
    property ScannerString: String read _scannerString;
    function GetFingerprintDatabase: String;
    procedure SetFingerprintDatabase(database: String);
    function GetUserDatabase: String;
    procedure SetUserDatabase(database: String);
    function GetPassword: String;
    procedure SetPassword(password: String);
  end;

var
  ScannerForm: TScannerForm;

implementation
{$R *.dfm}

procedure Split
   (const Delimiter: Char;
    Input: string;
    const Strings: TStrings) ;
begin
   Assert(Assigned(Strings)) ;
   Strings.Clear;
   Strings.Delimiter := Delimiter;
   Strings.DelimitedText := Input;
end;

procedure TScannerForm.btnOkClick(Sender: TObject);
  var temp: String;
      i: Integer;
begin
  if (Length(_allModuleString) > 0) then
  begin
    for i := 0 to clbScannerList.Items.Count - 1 do
    begin
      if (clbScannerList.Checked[i]) then
      begin
        if (Length(_scannerString) > 0) then
        begin
         temp := temp + ';';
        end;
        temp := temp + clbScannerList.Items[i];
      end;
    end;
    _scannerString := temp;
  end;
end;

procedure TScannerForm.FormCreate(Sender: TObject);
  var splitted: TStringList;
      i: Integer;
begin
 _allModuleString := GetAvailableScannerModules;
 splitted := TStringList.Create;
 tbUserDatabase.Text := ExtractFilePath(Application.ExeName) + 'UserDB.DelphiSample.ini';
 if (length(_allModuleString) > 0) then
 begin
   try
     Split(';', _allModuleString, splitted) ;
     clbScannerList.Items.Clear;
     for i := 0 to splitted.Count - 1 do
     begin
        clbScannerList.Items.Add(splitted[i]);
     end;
   finally
     splitted.Free;
   end;
 end
 else
 begin
   clbScannerList.Items.Add('No scanner modules found.');
   clbScannerList.Enabled := false;
 end;
 
end;

function TScannerForm.GetFingerprintDatabase: String;
  begin
    Result:= tbDatabase.Text;
  end;

  function TScannerForm.GetUserDatabase: String;
  begin
    Result:= tbUserDatabase.Text;
  end;

  function TScannerForm.GetPassword: String;
  begin
    Result:= tbPassword.Text;
  end;

  procedure TScannerForm.SetFingerprintDatabase(database: String);
  begin
    tbDatabase.Text := database;
  end;

  procedure TScannerForm.SetUserDatabase(database: String);
  begin
    tbUserDatabase.Text := database;
  end;

  procedure TScannerForm.SetPassword(password: String);
  begin
    tbPassword.Text := password;
  end;
end.
