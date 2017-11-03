unit WebCamMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ActnList, StdActns, StdCtrls, DSPack, DXSUtil, variants;

type

  { TFormWebCam }

  TFormWebCam = class(TForm)
    actShowFilterEditor: TAction;
    ActionList: TActionList;
    actFileExit: TFileExit;
    Filter: TFilter;
    FilterGraph: TFilterGraph;
    LblInterfaces: TLabel;
    LbInterfaces: TListBox;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    Devices: TMenuItem;
    MenuItem2: TMenuItem;
    VideoWindow: TVideoWindow;
    procedure actShowFilterEditorExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    InterfacesList : TStringList;
    procedure OnSelectDevice(sender: TObject);
    procedure FindFilterInterfaces;
  public

  end;

var
  FormWebCam: TFormWebCam;
  SysDev: TSysDevEnum;

implementation

uses
  DirectShow9
  , BaseFilterEditor;

{$R *.lfm}

function Succeeded(Res: HResult) : Boolean;inline; // copied from ActiveX
  begin
    Result := Res and $80000000 = 0;
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
begin
  FilterGraph.ClearGraph;
  FilterGraph.Active := false;
  Filter.BaseFilter.Moniker := SysDev.GetMoniker(TMenuItem(Sender).tag);
  IFilter(Filter).NotifyFilter(foRefresh);
  FilterGraph.Active := true;
  with FilterGraph as ICaptureGraphBuilder2 do
    CheckDSError(RenderStream(@PIN_CATEGORY_PREVIEW , nil, Filter as IBaseFilter, nil, VideoWindow as IbaseFilter));
  FilterGraph.Play;
  FindFilterInterfaces;
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
  LbInterfaces.Clear;
  LbInterfaces.Items.Assign(InterfacesList);
end;

end.

