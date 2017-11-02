{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit Laz_Win_DSPack;

interface

uses
  BaseClass, BaseFilterEditor, DSEditors, DSPack, DXSUtil, MediaTypeEditor, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('DSEditors', @DSEditors.Register);
end;

initialization
  RegisterPackage('Laz_Win_DSPack', @Register);
end.
