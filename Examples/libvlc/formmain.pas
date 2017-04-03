Unit FormMain;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, FileUtil, lclvlc, RTTIGrids, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, vlc;

Type

  { TForm1 }

  TForm1 = Class(TForm)
    btnFrameGrab: TToolButton;
    btnFWD: TToolButton;
    btnLoad: TToolButton;
    btnNudgeBack: TToolButton;
    btnNudgeForward: TToolButton;
    btnPause: TToolButton;
    btnPlay: TToolButton;
    btnRewind: TToolButton;
    btnStop: TToolButton;
    dlgFindVLC: TOpenDialog;
    ilTools: TImageList;
    lblPos: TLabel;
    memFeedback: TMemo;
    OpenDialog1: TOpenDialog;
    pnlTrackbar: TPanel;
    pnlVideoOuter: TPanel;
    pnlVideo: TPanel;
    Splitter2: TSplitter;
    StatusBar1: TStatusBar;
    tbMain: TToolBar;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    ToolButton6: TToolButton;
    ToolButton9: TToolButton;
    TrackBarPlaying: TTrackBar;
    TrackBarVolume: TTrackBar;
    Procedure btnLoadClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure LCLVLCPlayer1Backward(Sender: TObject);
    Procedure LCLVLCPlayer1Buffering(Sender: TObject);
    Procedure LCLVLCPlayer1EOF(Sender: TObject);
    Procedure LCLVLCPlayer1Error(Sender: TObject; Const AError: String);
    Procedure LCLVLCPlayer1Forward(Sender: TObject);
    Procedure LCLVLCPlayer1LengthChanged(Sender: TObject; Const time: TDateTime);
    Procedure LCLVLCPlayer1MediaChanged(Sender: TObject);
    Procedure LCLVLCPlayer1NothingSpecial(Sender: TObject);
    Procedure LCLVLCPlayer1Opening(Sender: TObject);
    Procedure LCLVLCPlayer1PausableChanged(Sender: TObject; Const AValue: Boolean);
    Procedure LCLVLCPlayer1Pause(Sender: TObject);
    Procedure LCLVLCPlayer1Playing(Sender: TObject);
    Procedure LCLVLCPlayer1PositionChanged(Sender: TObject; Const APos: Double);
    Procedure LCLVLCPlayer1SeekableChanged(Sender: TObject; Const AValue: Boolean);
    Procedure LCLVLCPlayer1Snapshot(Sender: TObject; Const AfileName: String);
    Procedure LCLVLCPlayer1Stop(Sender: TObject);
    Procedure LCLVLCPlayer1TimeChanged(Sender: TObject; Const time: TDateTime);
    Procedure LCLVLCPlayer1TitleChanged(Sender: TObject; Const ATitle: Integer);
    procedure TrackBarPlayingChange(Sender: TObject);

      procedure TrackBarPlayingMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  Private
    FLCLVLCPlayer1: TLCLVLCPlayer;
    FDuration: TDateTime;

    Procedure AddFeedback(AFeedback: String);
    Function GetUpdatingPosition: Boolean;
    Procedure RefreshUI;
    Procedure SetUpdatingPosition(AValue: Boolean);
    { private declarations }
  Public
    FUpdatingPosition: Integer;
    FLastPosition: Integer;

    Property UpdatingPosition: Boolean read GetUpdatingPosition write SetUpdatingPosition;
  End;

Var
  Form1: TForm1;

Implementation

{$R *.lfm}
Function TForm1.GetUpdatingPosition: Boolean;
Begin
  Result := FUpdatingPosition <> 0;
End;

Procedure TForm1.SetUpdatingPosition(AValue: Boolean);
Begin
  If AValue Then
    Inc(FUpdatingPosition)
  Else
    Dec(FUpdatingPosition);
End;

Procedure TForm1.RefreshUI;
Var
  bRunning: Boolean;
Begin
  bRunning := FLCLVLCPlayer1.Playing;

  If Not bRunning Then
  Begin
    UpdatingPosition := True;
    Try
      TrackBarPlaying.Position := 0;
      TrackBarPlaying.SelStart := 0;
      TrackBarPlaying.SelEnd := 0;

      TrackBarVolume.Position := 0;
      TrackBarVolume.SelStart := 0;
      TrackBarVolume.SelEnd := 0;
    Finally
      UpdatingPosition := False;
    End;

    StatusBar1.SimpleText := '';
    lblPos.Caption := '';
  End;

  If Not bRunning Then
  begin
    btnPause.Enabled := False;
    TrackBarPlaying.Enabled := False;
  end;

  btnStop.Enabled := bRunning;
  btnFWD.Enabled := bRunning;
  btnFrameGrab.Enabled := bRunning;
  btnNudgeBack.Enabled := bRunning;
  btnNudgeForward.Enabled := bRunning;
End;

Procedure TForm1.AddFeedback(AFeedback: String);
Begin
  memFeedback.Lines.Add(AFeedback);
  memFeedback.SelStart := Length(memFeedback.Lines.Text);
End;

Procedure TForm1.LCLVLCPlayer1Backward(Sender: TObject);
Begin
  AddFeedback('LCLVLCPlayer1Backward');
End;

Procedure TForm1.FormCreate(Sender: TObject);
Begin
  // There are errors when dynamically creating this object...
  // Guessing it's due to Initialise being called late...
  FLCLVLCPlayer1 := TLCLVLCPlayer.Create(Self);
  FLCLVLCPlayer1.UseEvents:=True;
  FLCLVLCPlayer1.ParentWindow := pnlVideo;

  FLCLVLCPlayer1.OnBackward := @LCLVLCPlayer1Backward;
  FLCLVLCPlayer1.OnBuffering := @LCLVLCPlayer1Buffering;
  FLCLVLCPlayer1.OnEOF := @LCLVLCPlayer1EOF;
  FLCLVLCPlayer1.OnError := @LCLVLCPlayer1Error;
  FLCLVLCPlayer1.OnForward := @LCLVLCPlayer1Forward;
  FLCLVLCPlayer1.OnLengthChanged := @LCLVLCPlayer1LengthChanged;
  FLCLVLCPlayer1.OnMediaChanged := @LCLVLCPlayer1MediaChanged;
  FLCLVLCPlayer1.OnNothingSpecial := @LCLVLCPlayer1NothingSpecial;
  FLCLVLCPlayer1.OnOpening := @LCLVLCPlayer1Opening;
  FLCLVLCPlayer1.OnPausableChanged := @LCLVLCPlayer1PausableChanged;
  FLCLVLCPlayer1.OnPause := @LCLVLCPlayer1Pause;
  FLCLVLCPlayer1.OnPlaying := @LCLVLCPlayer1Playing;
  FLCLVLCPlayer1.OnPositionChanged := @LCLVLCPlayer1PositionChanged;
  FLCLVLCPlayer1.OnSeekableChanged := @LCLVLCPlayer1SeekableChanged;
  FLCLVLCPlayer1.OnSnapshot := @LCLVLCPlayer1Snapshot;
  FLCLVLCPlayer1.OnStop := @LCLVLCPlayer1Stop;
  FLCLVLCPlayer1.OnTimeChanged := @LCLVLCPlayer1TimeChanged;
  FLCLVLCPlayer1.OnTitleChanged := @LCLVLCPlayer1TitleChanged;
End;

Procedure TForm1.btnLoadClick(Sender: TObject);
Begin
  If Not FileExists(VLCLibrary.LibraryPath) Then
  begin
    VLCLibrary.LibraryPath:='C:\Program Files (x86)\VideoLAN\VLC\libvlc.dll';

    If Not FileExists(VLCLibrary.LibraryPath) Then
      If dlgFindVLC.Execute Then
        VLCLibrary.LibraryPath := dlgFindVLC.FileName;
  end;

  If FileExists(VLCLibrary.LibraryPath) Then
    If OpenDialog1.Execute Then
      FLCLVLCPlayer1.PlayFile(OpenDialog1.FileName);
End;

Procedure TForm1.FormDestroy(Sender: TObject);
Begin
  FreeAndNil(FLCLVLCPlayer1);
End;

Procedure TForm1.LCLVLCPlayer1Buffering(Sender: TObject);
Begin
  StatusBar1.SimpleText:='Buffering';
  //AddFeedback('LCLVLCPlayer1Buffering');
End;

Procedure TForm1.LCLVLCPlayer1EOF(Sender: TObject);
Begin
  AddFeedback('LCLVLCPlayer1EOF');
  RefreshUI;
End;

Procedure TForm1.LCLVLCPlayer1Error(Sender: TObject; Const AError: String);
Begin
  AddFeedback('LCLVLCPlayer1Error: AError=' + AError);
End;

Procedure TForm1.LCLVLCPlayer1Forward(Sender: TObject);
Begin
  AddFeedback('LCLVLCPlayer1Forward');
End;

Procedure TForm1.LCLVLCPlayer1LengthChanged(Sender: TObject; Const time: TDateTime);
Begin
  AddFeedback('LCLVLCPlayer1LengthChanged: time=' + FormatDateTime('HH:nn:ss', time));
  FDuration := time;
End;

Procedure TForm1.LCLVLCPlayer1MediaChanged(Sender: TObject);
Begin
  AddFeedback('LCLVLCPlayer1MediaChanged');
End;

Procedure TForm1.LCLVLCPlayer1NothingSpecial(Sender: TObject);
Begin
  AddFeedback('LCLVLCPlayer1NothingSpecial');
End;

Procedure TForm1.LCLVLCPlayer1Opening(Sender: TObject);
Begin
  AddFeedback('LCLVLCPlayer1Opening');
End;

Procedure TForm1.LCLVLCPlayer1PausableChanged(Sender: TObject; Const AValue: Boolean);
Begin
  btnPause.Enabled := AValue;

  If AValue Then
    AddFeedback('LCLVLCPlayer1PausableChanged: AValue=True')
  Else
    AddFeedback('LCLVLCPlayer1PausableChanged: AValue=False');
End;

Procedure TForm1.LCLVLCPlayer1Pause(Sender: TObject);
Begin
  AddFeedback('LCLVLCPlayer1Pause');
  RefreshUI;
End;

Procedure TForm1.LCLVLCPlayer1Playing(Sender: TObject);
Begin
  AddFeedback('LCLVLCPlayer1Playing');
  RefreshUI;
End;

Procedure TForm1.LCLVLCPlayer1PositionChanged(Sender: TObject; Const APos: Double);
Begin
  // Returns a percentage of the way through the file (0..1)
  //AddFeedback('LCLVLCPlayer1PositionChanged: APos=' + FloatToStr(APos));
  StatusBar1.SimpleText := 'Playing ';

  If ActiveControl<>TrackBarPlaying Then
  begin
    UpdatingPosition:=True;
    TrackBarPlaying.Position := Trunc(100*APos);
    UpdatingPosition:=False;
  end;
End;

Procedure TForm1.LCLVLCPlayer1TimeChanged(Sender: TObject; Const time: TDateTime);
Begin
  // Returns a seek time into the file (ie starts at 00:00:00)
  //AddFeedback('LCLVLCPlayer1TimeChanged: time=' + FormatDateTime('HH:nn:ss', time));
  lblPos.Caption := FormatDateTime('nnn:ss', time) +
    ' / ' + FormatDateTime('nnn:ss', FDuration);

End;

Procedure TForm1.LCLVLCPlayer1SeekableChanged(Sender: TObject; Const AValue: Boolean);
Begin
  TrackBarPlaying.Enabled := AValue;
  If AValue Then
    AddFeedback('LCLVLCPlayer1SeekableChanged: AValue=True')
  Else
    AddFeedback('LCLVLCPlayer1SeekableChanged: AValue=False');
End;

Procedure TForm1.LCLVLCPlayer1Snapshot(Sender: TObject; Const AfileName: String);
Begin
  AddFeedback('LCLVLCPlayer1Snapshot: Filename=' + AfileName);
End;

Procedure TForm1.LCLVLCPlayer1Stop(Sender: TObject);
Begin
  AddFeedback('LCLVLCPlayer1Stop');
End;

Procedure TForm1.LCLVLCPlayer1TitleChanged(Sender: TObject; Const ATitle: Integer);
Begin
  AddFeedback('LCLVLCPlayer1TitleChanged: ATitle=' + IntToStr(ATitle));
End;

procedure TForm1.TrackBarPlayingChange(Sender: TObject);
begin
  If (Not UpdatingPosition) And (FLCLVLCPlayer1.Playing) Then
    FLCLVLCPlayer1.VideoFractionalPosition:=TrackBarPlaying.Position/100;
end;

procedure TForm1.TrackBarPlayingMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ActiveControl := memFeedback;
end;

End.



