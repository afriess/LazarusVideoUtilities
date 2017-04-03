// compiler/IDE dependent config
{$IFDEF FPC}
  {$H+} // use AnsiString instead of ShortString as String-type (default in Delphi)

  {$DEFINE HasInline}
{$ELSE}
  {$DEFINE Delphi}

  // Delphi version numbers (ignore Delphi < 7 and Delphi 8 (VER160))

  {$IFDEF VER180} // Delphi 2006 (=10)
    {$DEFINE DELPHI_10}
    {$DEFINE DELPHI_7_UP}
    {$DEFINE DELPHI_9_UP}
    {$DEFINE DELPHI_10_UP}
  {$ENDIF}

  {$IFDEF VER170} // Delphi 2005 (=9)
    {$DEFINE DELPHI_9}
    {$DEFINE DELPHI_7_UP}
    {$DEFINE DELPHI_9_UP}
  {$ENDIF}

  {$IFDEF VER150} // Delphi 7
    {$DEFINE DELPHI_7}
    {$DEFINE DELPHI_7_UP}
  {$ENDIF}

  // inline directive introduced with Delphi 2005
  {$IFDEF DELPHI_9_UP}
    {$DEFINE HasInline}
  {$ENDIF}
{$ENDIF}


// platform dependent config
{$IF Defined(MSWINDOWS)}
  // include defines but no constants
  {$I config-win.inc}
{$ELSEIF Defined(DARWIN)}
  // include defines but no constants
  {$I config-darwin.inc}

  {$DEFINE CONSOLE}
  {$DEFINE UTF8_FILENAMES}
{$ELSEIF Defined(UNIX)}
  // include defines but no constants
  {$IF Defined(FREEBSD)}
    {$I config-freebsd.inc}
  {$ELSEIF Defined(Linux)}
    {$I config-linux.inc}
  {$IFEND}

  // linux apps are always console-apps so leave this defined.
  {$DEFINE CONSOLE}
{$IFEND}
