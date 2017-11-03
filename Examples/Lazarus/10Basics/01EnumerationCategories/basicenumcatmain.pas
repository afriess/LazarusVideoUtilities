unit BasicEnumCatMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TBasicEnumCatForm }

  TBasicEnumCatForm = class(TForm)
    BuEnum: TButton;
    LbCategories: TListBox;
    procedure BuEnumClick(Sender: TObject);
  private

  public

  end;

var
  BasicEnumCatForm: TBasicEnumCatForm;

implementation

uses
  DXSUtil
  , DirectShow9;

{$R *.lfm}

{ TBasicEnumCatForm }

procedure TBasicEnumCatForm.BuEnumClick(Sender: TObject);
var
  i: integer;
  SysDev: TSysDevEnum;
begin
  SysDev:= TSysDevEnum.Create;
  try
  if SysDev.CountCategories > 0 then
    for i := 0 to SysDev.CountCategories - 1 do
    begin
      LbCategories.Items.Add(SysDev.Categories[i].FriendlyName);
    end;
  finally
    FreeAndNil(SysDev);
  end;
end;

end.

//(CLSID_VideoInputDeviceCategory);
