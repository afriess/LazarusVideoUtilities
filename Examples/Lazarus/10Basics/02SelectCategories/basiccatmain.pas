unit basiccatmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls;

type

  { TBasicCatForm }

  TBasicCatForm = class(TForm)
    BuSelect: TButton;
    TV: TTreeView;
    procedure BuSelectClick(Sender: TObject);
  private

  public

  end;

var
  BasicCatForm: TBasicCatForm;

implementation

uses
  DXSUtil;

{$R *.lfm}

{ TBasicCatForm }

procedure TBasicCatForm.BuSelectClick(Sender: TObject);
var
  categoryNr, filterNr: integer;
  SysDev: TSysDevEnum;
  actualNode, parentNode: TTreeNode;
begin
  TV.Items.Clear;
  SysDev:= TSysDevEnum.Create;
  actualNode:= TV.Items.AddChildFirst(nil,'Categories');
  try
  if SysDev.CountCategories > 0 then
    for categoryNr := 0 to SysDev.CountCategories - 1 do
    begin
      parentNode:= TV.Items.AddChild(actualNode, SysDev.Categories[categoryNr].FriendlyName);
      SysDev.SelectIndexCategory(categoryNr);
      for filterNr := 0 to SysDev.CountFilters-1 do begin
        TV.Items.AddChild(parentNode, SysDev.Filters[filterNr].FriendlyName);
      end;
    end;
  finally
    FreeAndNil(SysDev);
  end;
end;

end.

