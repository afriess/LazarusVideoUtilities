unit basicselwebcammainext;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, DXSUtil
  ;

type

  { TBasicCatForm }

  TBasicCatForm = class(TForm)
    BuSelect: TButton;
    TV: TTreeView;
    procedure BuSelectClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TVDblClick(Sender: TObject);
    procedure TVDeletion(Sender: TObject; Node: TTreeNode);
  private
    procedure GetFilterIntoTV(const actualNode: TTreeNode;
      var SysDev: TSysDevEnum);
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
 DirectShow9;

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
  SysDev: TSysDevEnum;
  actualNode: TTreeNode;
begin
  SysDev:= TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
  try
    TV.Items.Clear;
    actualNode:= TV.Items.AddChildObjectFirst(nil,'WebCam',TFilterNode.Create('Category: VideoInputDeviceCategory',CLSID_VideoInputDeviceCategory));
    GetFilterIntoTV(actualNode, SysDev);
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

procedure TBasicCatForm.GetFilterIntoTV(const actualNode: TTreeNode;
  var SysDev: TSysDevEnum);
var
  filterNr: integer;
  MyNode: TTreeNode;
begin
  for filterNr := 0 to SysDev.CountFilters-1 do begin
    MyNode:= TV.Items.AddChildObject(actualNode,
               SysDev.Filters[filterNr].FriendlyName,
               TFilterNode.Create(SysDev.Filters[filterNr].FriendlyName,
               SysDev.Filters[filterNr].CLSID));

  end;
end;

procedure TBasicCatForm.GetPinIntoTV(const actualNode: TTreeNode;
  var SysDev: TSysDevEnum);
var
  PinNr: integer;
  MyNode: TTreeNode;
  MyBaseFilter: TBaseFilter;
  actualFilterNode: TFilterNode;
begin
  actualFilterNode:= TFilterNode(actualNode.Data);


  //if Succeeded(Filter.QueryInterface(IBaseFilter, BaseF)) then
  //begin
  //  PinList.Assign(BaseF);
  //  if PinList.Count > 0 then
  //    for i := 0 to PinList.Count - 1 do
  //    begin
  //      PinInfo := PinList.PinInfo[i];
  //      case PinInfo.dir of
  //        PINDIR_INPUT  : lbPins.Items.Add(format('%s (input)',[PinInfo.achName]));
  //        PINDIR_OUTPUT : lbPins.Items.Add(format('%s (output)',[PinInfo.achName]));
  //      end;
  //      PinInfo.pFilter := nil;
  //    end;
  //  BaseF := nil;
  //end;





  //for PinNr := 0 to SysDev.CountFilters-1 do begin
  //  MyNode:= TV.Items.AddChildObject(actualNode,
  //             SysDev.Filters[PinNr].FriendlyName,
  //             TFilterNode.Create(SysDev.Filters[PinNr].FriendlyName,
  //             SysDev.Filters[PinNr].CLSID));
  //
  //end;
end;


end.

