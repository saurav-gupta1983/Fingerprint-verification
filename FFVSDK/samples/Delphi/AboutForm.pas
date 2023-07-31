unit AboutForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Util, ComCtrls, Nffv;

type
  TFileVersionInfo = record
   CompanyName      : string;
   FileDescription  : string;
   FileVersion      : string;
   InternalName     : string;
   LegalCopyright   : string;
   LegalTradeMarks  : string;
   OriginalFilename : string;
   ProductName      : string;
   ProductVersion   : string;
   Comments         : string;
   IsRegistered     : string;
  end;
  
type
  TAboutForm = class(TForm)
    ButtonOK: TButton;
    imgNeurotechnology: TImage;
    lblVeriFinger: TLabel;
    lvComponents: TListView;
    btnRefresh: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    procedure AddItemToListView(versionInfo: TFileVersionInfo);
    procedure FillVersionInfo(info: TNLibraryInfo; var versionInfo: TFileVersionInfo);
    procedure Refresh;
  end;

procedure AboutBox(Owner: TForm);

implementation
 uses MainForm;
{$R *.dfm}

procedure AboutBox(Owner: TForm);
var
  Form: TAboutForm;
begin
  Form := TAboutForm.Create(Owner);
  Form.ShowModal;
  Form.Free;
end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
 Refresh;
end;

function GetKeyVersionInfo(FileName, Key: String): String;
const
 vqvFmt = '\StringFileInfo\%4.4x%4.4x\%s';
var
 vlen: DWord;
 FInfoSize : longint;
 FInfo : pointer;
 FLang  : PInteger;
 //FLangNum : integer;
 vptr : pchar;
begin
 Result:= '';
 FInfoSize:= GetFileVersionInfoSize(pchar(FileName), vlen);
 if FInfoSize > 0 then
 begin
  GetMem(FInfo, FInfoSize);
  if GetFileVersionInfo(pchar(FileName), vlen, FInfoSize, FInfo) then
  begin
   VerQueryValue(FInfo, '\VarFileInfo\Translation', Pointer(FLang), vlen);
  // FLangNum:= vlen div 4;
   if VerQueryValue(FInfo, PChar(Format(vqvFmt,[LoWord(FLang^), HiWord(FLang^), Key])),
       pointer(vptr), vlen) then
     Result:= vptr;
  end;
  FreeMem(FInfo, FInfoSize);
 end;
end;

function GetVersionInfo(const FileName: String): TFileVersionInfo;
 var ResultInfo: TFileVersionInfo;
begin
 with ResultInfo do begin
  CompanyName       := GetKeyVersionInfo(FileName, 'CompanyName');
  FileDescription   := GetKeyVersionInfo(FileName, 'FileDescription');
  FileVersion       := StringReplace(GetKeyVersionInfo(FileName, 'FileVersion'),',','.',[rfReplaceAll]);
  InternalName      := GetKeyVersionInfo(FileName, 'InternalName');
  LegalCopyright    := GetKeyVersionInfo(FileName, 'LegalCopyright');
  LegalTradeMarks   := GetKeyVersionInfo(FileName, 'LegalTradeMarks');
  OriginalFilename  := GetKeyVersionInfo(FileName, 'OriginalFilename');
  ProductName       := GetKeyVersionInfo(FileName, 'ProductName');
  ProductVersion    := StringReplace(GetKeyVersionInfo(FileName, 'ProductVersion'),',','.',[rfReplaceAll]);
  Comments          := GetKeyVersionInfo(FileName, 'Comments');
  IsRegistered      := '';
 end;
 Result := ResultInfo;
end;

procedure TAboutForm.Refresh;
 var versionInfo: TFileVersionInfo;
     info: TNLibraryInfo;
begin
 lvComponents.Clear;
 versionInfo := GetVersionInfo(Application.ExeName);
 AddItemToListView(versionInfo);

 info := NffvGetInfo;
 FillVersionInfo(info, versionInfo);
 AddItemToListView(versionInfo);
end;

procedure TAboutForm.FillVersionInfo(info: TNLibraryInfo; var versionInfo: TFileVersionInfo);
begin
 versionInfo.FileDescription := info.Title;
 versionInfo.LegalCopyright := info.Copyright;
 versionInfo.CompanyName := info.Company;
 versionInfo.ProductName := info.Product;
 versionInfo.FileVersion := Format('%d.%d.%d.%d', [info.VersionMajor,
  info.VersionMinor, info.VersionBuild, info.VersionRevision]);
end;

procedure TAboutForm.AddItemToListView(versionInfo: TFileVersionInfo);
 var addedItem: TListItem;
begin
 addedItem := lvComponents.Items.Add;
 with addedItem, addedItem.SubItems do
 begin
  Caption := versionInfo.FileDescription;
  Add(versionInfo.FileVersion);
  Add(versionInfo.LegalCopyright);
 end;
end;

procedure TAboutForm.btnRefreshClick(Sender: TObject);
begin
 Refresh;
end;

end.
