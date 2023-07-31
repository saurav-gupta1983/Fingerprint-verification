unit EnrollForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TEnrollFrm = class(TForm)
    tbName: TEdit;
    lblName: TLabel;
    btnCancel: TButton;
    btnOk: TButton;
  private
    { Private declarations }
  public
    function GetUsername: String;
    procedure SetUsername(name: String);
  end;

var
  EnrollFrm: TEnrollFrm;

implementation

{$R *.dfm}

function TEnrollFrm.GetUsername: string;
begin
 Result := tbName.Text;
end;

procedure TEnrollFrm.SetUsername(name: string);
begin
  tbName.Text := name;
end;

end.
