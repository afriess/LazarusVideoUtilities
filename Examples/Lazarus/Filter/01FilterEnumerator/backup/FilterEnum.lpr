program FilterEnum;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  Editor;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormEditor, FormEditor);
  Application.Run;
end.
