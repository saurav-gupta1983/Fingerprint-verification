unit UserInfoForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TUserInformationForm = class(TForm)
    GridPanel1: TGridPanel;
    tbLabel: TEdit;
    pbImage: TImage;
    procedure FormDestroy(Sender: TObject);
  private

  public
    procedure SetUserName(name: string);
    procedure SetUserImage(image: TBitmap);
  end;

var
  UserInformationForm: TUserInformationForm;

implementation

{$R *.dfm}

procedure TUserInformationForm.SetUserName(name: string);
begin
  tbLabel.Text := name;
end;

procedure TUserInformationForm.FormDestroy(Sender: TObject);
begin
 pbImage.Picture := nil;
end;

procedure TUserInformationForm.SetUserImage(image: TBitmap);
begin
 pbImage.Picture.Bitmap := image;
end;

end.
