Unit ffmpegWrapper;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils,
  avcodec, avformat, rational;

Type

  { TffmpegFile }

  { TffmpegFileInfo }

  TffmpegFileInfo = Class
  Private
    FFormatContext: PAVFormatContext;
    FFilename: String;
    function GetFormatContext: TAVFormatContext;
    Procedure SetFilename(AValue: String);
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure Clear;

    Function StreamCount: Integer;
    Function Stream(AStreamIndex: Integer) : TAVStream;

    Property Filename: String read FFilename write SetFilename;
    Property FormatContext: TAVFormatContext read GetFormatContext;
  End;

Function CodecContext(AStream : TAVStream) : TAVCodecContext;
Function CodecType(ACodecContext: TAVCodecContext): TCodecType;
Function CodecTypeAsString(ACodecContext: TAVCodecContext): String;
Function CodecTypeToString(ACodecType: TCodecType): String;
Function ToDouble(ARational: TAVRational) : Double;

Function OpenCodec(ACodecContext: TAVCodecContext) : TAVCodec;
Procedure CloseCodec(ACodecContext: TAVCodecContext);

Implementation

Function CodecContext(AStream: TAVStream): TAVCodecContext;
begin
  Result := AStream.codec^
end;

Function CodecType(ACodecContext: TAVCodecContext): TCodecType;
begin
  Result := ACodecContext.codec_type
end;

Function CodecTypeAsString(ACodecContext: TAVCodecContext): String;
begin
  Result := CodecTypeToString(ACodecContext.codec_type);
end;

Function CodecTypeToString(ACodecType: TCodecType): String;
Begin
  Case ACodecType Of
    CODEC_TYPE_UNKNOWN: Result := 'CODEC_TYPE_UNKNOWN';
    CODEC_TYPE_VIDEO: Result := 'CODEC_TYPE_VIDEO';
    CODEC_TYPE_AUDIO: Result := 'CODEC_TYPE_AUDIO';
    CODEC_TYPE_DATA: Result := 'CODEC_TYPE_DATA';
    CODEC_TYPE_SUBTITLE: Result := 'CODEC_TYPE_SUBTITLE';
    CODEC_TYPE_ATTACHMENT: Result := 'CODEC_TYPE_ATTACHMENT';
    CODEC_TYPE_NB: Result := 'CODEC_TYPE_NB';
  End;
End;

Function ToDouble(ARational: TAVRational): Double;
begin
  If ARational.num<>0 Then
    Result := av_q2d(ARational)
  Else
    Result := 0.0;
end;

Function OpenCodec(ACodecContext: TAVCodecContext): TAVCodec;
begin
  Result := avcodec_find_decoder(ACodecContext.codec_id)^;

  If (avcodec_open(@ACodecContext, @Result)<0) Then
    Raise Exception.Create('avcodec_open failed');
end;

Procedure CloseCodec(ACodecContext: TAVCodecContext);
begin
  // TODO:  Find out why this AV's.  It shouldn't...
  //avcodec_close(@ACodecContext);
end;

{ TffmpegFileInfo }

Procedure TffmpegFileInfo.SetFilename(AValue: String);
Var
  errCode: longint;

Begin
  If AValue = FFilename Then
    Exit;

  Clear;

  If FileExists(AValue) Then
  Begin
    errCode := av_open_input_file(FFormatContext, PChar(AValue), nil, 0, nil);
    If (errCode = 0) Then
      FFilename := AValue
    Else
      Raise Exception.CreateFmt('Error opening %s.  Error code %d', [AValue, errCode]);

    errCode := av_find_stream_info(FFormatContext);
  End;
End;

function TffmpegFileInfo.GetFormatContext: TAVFormatContext;
begin
  Result := FFormatContext^;
end;

Constructor TffmpegFileInfo.Create;
Begin
  FFormatContext := nil;
End;

Destructor TffmpegFileInfo.Destroy;
Begin
  Clear;

  Inherited Destroy;
End;

Procedure TffmpegFileInfo.Clear;
Begin
  FFilename := '';

  If FFormatContext <> nil Then
  Begin
    av_close_input_file(FFormatContext);
    FFormatContext := Nil;
  end;
End;

Function TffmpegFileInfo.StreamCount: Integer;
Begin
  Result := FFormatContext^.nb_streams;
End;

Function TffmpegFileInfo.Stream(AStreamIndex: Integer): TAVStream;
begin
  If FFormatContext <> nil Then
    Result := FFormatContext^.streams[AStreamIndex]^;
end;

Initialization
  // For now, this is easier than just registering the specific formats and
  // protocols that we need...
  av_register_all;

End.

