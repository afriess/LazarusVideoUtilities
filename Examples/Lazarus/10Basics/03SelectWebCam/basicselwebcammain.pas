unit basicselwebcammain;

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
    procedure FormDestroy(Sender: TObject);
    procedure TVDblClick(Sender: TObject);
    procedure TVDeletion(Sender: TObject; Node: TTreeNode);
  end;

  { TFilterNode }

  TFilterNode = class(TObject)
    FriendlyName : String;
    CLSID        : TGUID;
    constructor Create(aFriendlyName:String;aCLSID:TGUID);
  end;

var
  BasicCatForm: TBasicCatForm;

implementation

uses
  DXSUtil
  , DirectShow9;

{$R *.lfm}

{ TFilterNode }

constructor TFilterNode.Create(aFriendlyName: String; aCLSID: TGUID);
begin
  inherited Create;
  FriendlyName:=aFriendlyName;
  CLSID:=aCLSID;
end;

{ TBasicCatForm }

procedure TBasicCatForm.BuSelectClick(Sender: TObject);
var
  filterNr: integer;
  SysDev: TSysDevEnum;
  actualNode: TTreeNode;
begin
  TV.Items.Clear;
  SysDev:= TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
  actualNode:= TV.Items.AddChildObjectFirst(nil,'WebCam',TFilterNode.Create('Category: VideoInputDeviceCategory',CLSID_VideoInputDeviceCategory));
  try
    for filterNr := 0 to SysDev.CountFilters-1 do begin
      TV.Items.AddChildObject(actualNode,
           SysDev.Filters[filterNr].FriendlyName,
           TFilterNode.Create(SysDev.Filters[filterNr].FriendlyName,SysDev.Filters[filterNr].CLSID));
    end;
  finally
    FreeAndNil(SysDev);
  end;
end;

procedure TBasicCatForm.FormDestroy(Sender: TObject);
begin
  TV.Items.Clear;
end;

procedure TBasicCatForm.TVDblClick(Sender: TObject);
var
  actualNode: TTreeNode;
  actualFilter: TFilterNode;
begin
  if not (Sender is TTreeView) then
    exit; //-->> no Treeview, exit, beacuase nothing to do
  if not Assigned(TTreeView(Sender).Selected) then
    exit; //-->> nothing selected in treeview, exit, beacuase nothing to do
  actualNode:= TTreeView(Sender).Selected;
  if Assigned(actualNode.Data) then begin
    actualFilter:= TFilterNode(actualNode.Data);
    // show some information
    ShowMessage(actualFilter.FriendlyName + LineEnding + 'GUID:' + actualFilter.CLSID.ToString());
  end;
end;

procedure TBasicCatForm.TVDeletion(Sender: TObject; Node: TTreeNode);
begin
  // to avoid unfreed objects
  if Assigned(Node.Data) then
    TFilterNode(Node.Data).Free;
end;

end.

