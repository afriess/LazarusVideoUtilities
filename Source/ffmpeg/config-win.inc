{* Libraries *}

{$DEFINE HaveFFmpeg}
{$IF Defined(HaveFFmpeg) and Defined(IncludeConstants)}
  av__codec = 'avcodec-51';
  LIBAVCODEC_VERSION_MAJOR   = 51;
  LIBAVCODEC_VERSION_MINOR   = 16;
  LIBAVCODEC_VERSION_RELEASE = 0;

  av__format = 'avformat-52';
  LIBAVFORMAT_VERSION_MAJOR   = 52;
  LIBAVFORMAT_VERSION_MINOR   = 0;
  LIBAVFORMAT_VERSION_RELEASE = 0;

  av__util = 'avutil-49';
  LIBAVUTIL_VERSION_MAJOR   = 49;
  LIBAVUTIL_VERSION_MINOR   = 0;
  LIBAVUTIL_VERSION_RELEASE = 1;
{$IFEND}

{$DEFINE HaveSWScale}
{$IF Defined(HaveSWScale) and Defined(IncludeConstants)}
  sw__scale = 'swscale-0';
  LIBSWSCALE_VERSION_MAJOR   = 0;
  LIBSWSCALE_VERSION_MINOR   = 7;
  LIBSWSCALE_VERSION_RELEASE = 2;
{$IFEND}
