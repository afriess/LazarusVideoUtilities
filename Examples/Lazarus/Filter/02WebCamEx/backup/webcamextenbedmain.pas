unit webcamextenbedmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ActnList, StdActns, StdCtrls, ComCtrls, DSPack, DXSUtil, variants;

type

  { TFormWebCam }

  TFormWebCam = class(TForm)
    actShowFilterEditor: TAction;
    ActionList: TActionList;
    actFileExit: TFileExit;
    Filter: TFilter;
    FilterGraph: TFilterGraph;
    LblInterfaces: TLabel;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    Devices: TMenuItem;
    MenuItem2: TMenuItem;
    PageControl1: TPageControl;
    TS_Video: TTabSheet;
    TS_Interfaces: TTabSheet;
    TV: TTreeView;
    VideoWindow: TVideoWindow;
    procedure actShowFilterEditorExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TVCreateNodeClass(Sender: TCustomTreeView;
      var NodeClass: TTreeNodeClass);
    procedure TVDeletion(Sender: TObject; Node: TTreeNode);
  private
    InterfacesList : TStringList;
    procedure GetFilterIntoTV(const actualNode: TTreeNode;
      var AnSysDev: TSysDevEnum);
    procedure OnSelectDevice(sender: TObject);
    procedure FindFilterInterfaces;
  public

  end;

  { TFilterNode }

  TFilterNode = class(TTreeNode)
  private
    FFriendlyName : String;
    FCLSID        : TGUID;
    procedure SetFriendlyName(AValue: String);
  public
    constructor Create(AnOwner: TTreeNodes; AnFriendlyName: String; AnCLSID: TGUID);
    property FriendlyName : String read FFriendlyName write SetFriendlyName;
    property CLSID        : TGUID read FCLSID write FCLSID;
  end;

var
  FormWebCam: TFormWebCam;
  SysDev: TSysDevEnum;

implementation

uses
  DirectShow9
  , ActiveX
  , BaseFilterEditor;

{$R *.lfm}

//function Succeeded(Res: HResult) : Boolean;inline; // copied from ActiveX
//  begin
//    Result := Res and $80000000 = 0;
//  end;

{ TFilterNode }


procedure TFilterNode.SetFriendlyName(AValue: String);
begin
  if FFriendlyName=AValue then Exit;
  FFriendlyName:=AValue;
end;

constructor TFilterNode.Create(AnOwner: TTreeNodes; AnFriendlyName: String;
  AnCLSID: TGUID);
begin
  FFriendlyName:= AnFriendlyName;
  FCLSID:= AnCLSID;
end;

{ TFormWebCam }

procedure TFormWebCam.FormCreate(Sender: TObject);
var
  i: integer;
  Device: TMenuItem;
begin
  InterfacesList := TStringList.Create;
  SysDev:= TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
  if SysDev.CountFilters > 0 then
    for i := 0 to SysDev.CountFilters - 1 do
    begin
      Device := TMenuItem.Create(Devices);
      Device.Caption := SysDev.Filters[i].FriendlyName;
      Device.Tag := i;
      Device.OnClick := @OnSelectDevice;
      Devices.Add(Device);
    end;
end;

procedure TFormWebCam.TVCreateNodeClass(Sender: TCustomTreeView;
  var NodeClass: TTreeNodeClass);
begin
  NodeClass:= TFilterNode;
end;

procedure TFormWebCam.TVDeletion(Sender: TObject; Node: TTreeNode);
begin
  // to avoid unfreed objects
  if Assigned(Node.Data) then
    TFilterNode(Node.Data).Free;
end;

procedure TFormWebCam.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  InterfacesList.Clear;
  InterfacesList.Free;
  // Stop FilterGraph if needed
  if (FilterGraph.State = gsPlaying) or (FilterGraph.State = gsPaused) then
    FilterGraph.Stop;
  FilterGraph.ClearGraph;
  VideoWindow.FilterGraph:=nil; // unbound the videowindow to avoid errors, after the ClearGraph
  SysDev.Free;
end;

procedure TFormWebCam.actShowFilterEditorExecute(Sender: TObject);
var
  BaseFilterEditor : TFormBaseFilter;
begin
  BaseFilterEditor:= TFormBaseFilter.Create(nil);
  try
    BaseFilterEditor.ShowModal;
  finally
    BaseFilterEditor.Free;
  end;
end;

procedure TFormWebCam.OnSelectDevice(sender: TObject);
var
  actualNode: TTreeNode;
begin
  FilterGraph.ClearGraph;
  FilterGraph.Active := false;
  Filter.BaseFilter.Moniker := SysDev.GetMoniker(TMenuItem(Sender).tag);
  IFilter(Filter).NotifyFilter(foRefresh);
  FilterGraph.Active := true;
  with FilterGraph as ICaptureGraphBuilder2 do
    CheckDSError(RenderStream(@PIN_CATEGORY_PREVIEW , nil, Filter as IBaseFilter, nil, VideoWindow as IbaseFilter));
  FilterGraph.Play;
  TV.Items.Clear;

  actualNode:= TV.Items.AddChildFirst(nil,'WebCam'); //,TFilterNode.Create('Category: VideoInputDeviceCategory',CLSID_VideoInputDeviceCategory));
  TFilterNode(actualNode).FriendlyName:= TMenuItem(Sender).Caption;
  GetFilterIntoTV(actualNode,SysDev);
//  TFilterNode(actualNode).CLSID:= Filter.BaseFilter.PropertyBag('CLSID').ToString();
//  FindFilterInterfaces;
end;

procedure TFormWebCam.FindFilterInterfaces;
var
  i: integer;
  unk: IUnknown;
begin
  InterfacesList.Clear;
  try
    // query through the (known) Interfacelist and look if the Interface is valid
    with Filter.BaseFilter.CreateFilter do
      for i := 0 to length(DSItfs)-1 do
        if Succeeded(QueryInterface(DSItfs[i].itf, unk)) then
          InterfacesList.Add(DSItfs[i].name);
  finally
    unk := nil;
  end;

end;

//// Ist Ok
//procedure TFormWebCam.GetFilterIntoTV(const actualNode: TTreeNode;
//  var AnSysDev: TSysDevEnum);
//var
//  filterNr: integer;
//  MyNode: TTreeNode;
//begin
//  for filterNr := 0 to SysDev.CountFilters-1 do begin
//    MyNode:= TV.Items.AddChild(actualNode,AnSysDev.Filters[filterNr].FriendlyName);
//    TFilterNode(MyNode).FriendlyName:= AnSysDev.Filters[filterNr].FriendlyName;
//    TFilterNode(MyNode).CLSID:= AnSysDev.Filters[filterNr].CLSID;
//  end;
//end;

procedure TFormWebCam.GetFilterIntoTV(const actualNode: TTreeNode;
  var AnSysDev: TSysDevEnum);
var
  i: integer;
  MyNode: TTreeNode;
  BaseF: IBaseFilter;
  BaseF1: IBaseFilter;
  unk: IUnknown;
  PinList: TPinList;
  PinInfo: TPinInfo;
  AMoniker     : IMoniker;
begin
//  BaseF:= Filter.BaseFilter.CreateFilter;

  //AMoniker := Filter.BaseFilter.Moniker;
  //if AMoniker <> nil then
  //  begin
  //    AMoniker.BindToObject(nil, nil, IBaseFilter, BaseF);
  //    AMoniker := nil;
  //  end
  //else
  //  BaseF := nil;
  //MyNode:= TV.Items.AddChild(actualNode,'Interfaces');
  //try
  //  // query through the (known) Interfacelist and look if the Interface is valid
  //  with BaseF do
  //    for i := 0 to length(DSItfs)-1 do
  //      if Succeeded(QueryInterface(DSItfs[i].itf, unk)) then
  //        TV.Items.AddChild(MyNode,DSItfs[i].name);
  // finally
  //  unk := nil;
  //end;
  //
  MyNode:= TV.Items.AddChild(actualNode,'Pins');
  if Succeeded(Filter.QueryInterface(IBaseFilter, BaseF1)) then
  begin
    PinList.Assign(BaseF1);
    if PinList.Count > 0 then
      for i := 0 to PinList.Count - 1 do
      begin
        PinInfo := PinList.PinInfo[i];
        case PinInfo.dir of
          PINDIR_INPUT  : TV.Items.AddChild(actualNode,format('%s (input)',[PinInfo.achName]));
          PINDIR_OUTPUT : TV.Items.AddChild(actualNode,format('%s (output)',[PinInfo.achName]));
        end;
        PinInfo.pFilter := nil;
      end;
   end;



end;


end.

