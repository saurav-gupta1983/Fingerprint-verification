unit SettingsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Util;

type
  TSettingsFrm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    tbQThreshold: TTrackBar;
    cbMThreshold: TComboBox;
    btnCancel: TButton;
    btnOk: TButton;
    Label3: TLabel;
    Label4: TLabel;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent; qthreshold: Byte; mthreshold: LongInt); reintroduce; virtual;
  end;

var
  SettingsFrm: TSettingsFrm;

implementation

{$R *.dfm}

constructor TSettingsFrm.Create(AOwner: TComponent; qthreshold: Byte; mthreshold: LongInt);
  var i: Integer;
      str: String;
begin
  inherited Create(aowner);

  tbQThreshold.Max := 255;
  tbQthreshold.Position := qthreshold;

  cbMThreshold.Items.Add('0.1');
  cbMThreshold.Items.Add('0.01');
  cbMThreshold.Items.Add('0.001');

  for I := 0 to cbMThreshold.Items.Count - 1 do
  begin
    str := cbMThreshold.Items[i];
    if (str = MatchingThresholdToString(mthreshold)) then
    begin
      cbMThreshold.ItemIndex := i;
    end;
  end;
end;

end.
