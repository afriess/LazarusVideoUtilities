{* Libraries *}

{$DEFINE HaveFFmpeg}
{$IF Defined(HaveFFmpeg) and Defined(IncludeConstants)}
  av__codec = 'libavcodec';
  LIBAVCODEC_VERSION_MAJOR   = 52;
  LIBAVCODEC_VERSION_MINOR   = 20;
  LIBAVCODEC_VERSION_RELEASE = 0;

  av__format = 'libavformat';
  LIBAVFORMAT_VERSION_MAJOR   = 52;
  LIBAVFORMAT_VERSION_MINOR   = 31;
  LIBAVFORMAT_VERSION_RELEASE = 0;

  av__util = 'libavutil';
  LIBAVUTIL_VERSION_MAJOR   = 49;
  LIBAVUTIL_VERSION_MINOR   = 15;
  LIBAVUTIL_VERSION_RELEASE = 0;
{$IFEND}

{$DEFINE HaveSWScale}
{$IF Defined(HaveSWScale) and Defined(IncludeConstants)}
  sw__scale = 'libswscale';
  LIBSWSCALE_VERSION_MAJOR   = 0;
  LIBSWSCALE_VERSION_MINOR   = 7;
  LIBSWSCALE_VERSION_RELEASE = 1;
{$IFEND}
