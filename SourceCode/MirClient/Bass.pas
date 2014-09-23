unit Bass;

interface

uses
  Windows, DLLFile, DLLLoader;

const
  BASSVERSION = $204; // API version
  BASSVERSIONTEXT = '2.4';

  // Use these to test for error from functions that return a DWORD or QWORD
  DW_ERROR = LongWord(-1); // -1 (DWORD)
  QW_ERROR = Int64(-1); // -1 (QWORD)

  // Error codes returned by BASS_ErrorGetCode()
  BASS_OK = 0; // all is OK
  BASS_ERROR_MEM = 1; // memory error
  BASS_ERROR_FILEOPEN = 2; // can't open the file
  BASS_ERROR_DRIVER = 3; // can't find a free sound driver
  BASS_ERROR_BUFLOST = 4; // the sample buffer was lost
  BASS_ERROR_HANDLE = 5; // invalid handle
  BASS_ERROR_FORMAT = 6; // unsupported sample format
  BASS_ERROR_POSITION = 7; // invalid position
  BASS_ERROR_INIT = 8; // BASS_Init has not been successfully called
  BASS_ERROR_START = 9; // BASS_Start has not been successfully called
  BASS_ERROR_ALREADY = 14; // already initialized/paused/whatever
  BASS_ERROR_NOCHAN = 18; // can't get a free channel
  BASS_ERROR_ILLTYPE = 19; // an illegal type was specified
  BASS_ERROR_ILLPARAM = 20; // an illegal parameter was specified
  BASS_ERROR_NO3D = 21; // no 3D support
  BASS_ERROR_NOEAX = 22; // no EAX support
  BASS_ERROR_DEVICE = 23; // illegal device number
  BASS_ERROR_NOPLAY = 24; // not playing
  BASS_ERROR_FREQ = 25; // illegal sample rate
  BASS_ERROR_NOTFILE = 27; // the stream is not a file stream
  BASS_ERROR_NOHW = 29; // no hardware voices available
  BASS_ERROR_EMPTY = 31; // the MOD music has no sequence data
  BASS_ERROR_NONET = 32; // no internet connection could be opened
  BASS_ERROR_CREATE = 33; // couldn't create the file
  BASS_ERROR_NOFX = 34; // effects are not enabled
  BASS_ERROR_NOTAVAIL = 37; // requested data is not available
  BASS_ERROR_DECODE = 38; // the channel is a "decoding channel"
  BASS_ERROR_DX = 39; // a sufficient DirectX version is not installed
  BASS_ERROR_TIMEOUT = 40; // connection timedout
  BASS_ERROR_FILEFORM = 41; // unsupported file format
  BASS_ERROR_SPEAKER = 42; // unavailable speaker
  BASS_ERROR_VERSION = 43; // invalid BASS version (used by add-ons)
  BASS_ERROR_CODEC = 44; // codec is not available/supported
  BASS_ERROR_ENDED = 45; // the channel/file has ended
  BASS_ERROR_UNKNOWN = -1; // some other mystery problem

  // BASS_SetConfig options
  BASS_CONFIG_BUFFER = 0;
  BASS_CONFIG_UPDATEPERIOD = 1;
  BASS_CONFIG_GVOL_SAMPLE = 4;
  BASS_CONFIG_GVOL_STREAM = 5;
  BASS_CONFIG_GVOL_MUSIC = 6;
  BASS_CONFIG_CURVE_VOL = 7;
  BASS_CONFIG_CURVE_PAN = 8;
  BASS_CONFIG_FLOATDSP = 9;
  BASS_CONFIG_3DALGORITHM = 10;
  BASS_CONFIG_NET_TIMEOUT = 11;
  BASS_CONFIG_NET_BUFFER = 12;
  BASS_CONFIG_PAUSE_NOPLAY = 13;
  BASS_CONFIG_NET_PREBUF = 15;
  BASS_CONFIG_NET_PASSIVE = 18;
  BASS_CONFIG_REC_BUFFER = 19;
  BASS_CONFIG_NET_PLAYLIST = 21;
  BASS_CONFIG_MUSIC_VIRTUAL = 22;
  BASS_CONFIG_VERIFY = 23;
  BASS_CONFIG_UPDATETHREADS = 24;

  // BASS_SetConfigPtr options
  BASS_CONFIG_NET_AGENT = 16;
  BASS_CONFIG_NET_PROXY = 17;

  // Initialization flags
  BASS_DEVICE_8BITS = 1; // use 8 bit resolution, else 16 bit
  BASS_DEVICE_MONO = 2; // use mono, else stereo
  BASS_DEVICE_3D = 4; // enable 3D functionality
  BASS_DEVICE_LATENCY = 256; // calculate device latency (BASS_INFO struct)
  BASS_DEVICE_CPSPEAKERS = 1024; // detect speakers via Windows control panel
  BASS_DEVICE_SPEAKERS = 2048; // force enabling of speaker assignment
  BASS_DEVICE_NOSPEAKER = 4096; // ignore speaker arrangement

  // DirectSound interfaces (for use with BASS_GetDSoundObject)
  BASS_OBJECT_DS = 1; // IDirectSound
  BASS_OBJECT_DS3DL = 2; // IDirectSound3DListener

  // BASS_DEVICEINFO flags
  BASS_DEVICE_ENABLED = 1;
  BASS_DEVICE_DEFAULT = 2;
  BASS_DEVICE_INIT = 4;

  // BASS_INFO flags (from DSOUND.H)
  DSCAPS_CONTINUOUSRATE = $00000010; // supports all sample rates between min/maxrate
  DSCAPS_EMULDRIVER = $00000020; // device does NOT have hardware DirectSound support
  DSCAPS_CERTIFIED = $00000040; // device driver has been certified by Microsoft
  DSCAPS_SECONDARYMONO = $00000100; // mono
  DSCAPS_SECONDARYSTEREO = $00000200; // stereo
  DSCAPS_SECONDARY8BIT = $00000400; // 8 bit
  DSCAPS_SECONDARY16BIT = $00000800; // 16 bit

  // BASS_RECORDINFO flags (from DSOUND.H)
  DSCCAPS_EMULDRIVER = DSCAPS_EMULDRIVER; // device does NOT have hardware DirectSound recording support
  DSCCAPS_CERTIFIED = DSCAPS_CERTIFIED; // device driver has been certified by Microsoft

  // defines for formats field of BASS_RECORDINFO (from MMSYSTEM.H)
  WAVE_FORMAT_1M08 = $00000001; // 11.025 kHz, Mono,   8-bit
  WAVE_FORMAT_1S08 = $00000002; // 11.025 kHz, Stereo, 8-bit
  WAVE_FORMAT_1M16 = $00000004; // 11.025 kHz, Mono,   16-bit
  WAVE_FORMAT_1S16 = $00000008; // 11.025 kHz, Stereo, 16-bit
  WAVE_FORMAT_2M08 = $00000010; // 22.05  kHz, Mono,   8-bit
  WAVE_FORMAT_2S08 = $00000020; // 22.05  kHz, Stereo, 8-bit
  WAVE_FORMAT_2M16 = $00000040; // 22.05  kHz, Mono,   16-bit
  WAVE_FORMAT_2S16 = $00000080; // 22.05  kHz, Stereo, 16-bit
  WAVE_FORMAT_4M08 = $00000100; // 44.1   kHz, Mono,   8-bit
  WAVE_FORMAT_4S08 = $00000200; // 44.1   kHz, Stereo, 8-bit
  WAVE_FORMAT_4M16 = $00000400; // 44.1   kHz, Mono,   16-bit
  WAVE_FORMAT_4S16 = $00000800; // 44.1   kHz, Stereo, 16-bit

  BASS_SAMPLE_8BITS = 1; // 8 bit
  BASS_SAMPLE_FLOAT = 256; // 32-bit floating-point
  BASS_SAMPLE_MONO = 2; // mono
  BASS_SAMPLE_LOOP = 4; // looped
  BASS_SAMPLE_3D = 8; // 3D functionality
  BASS_SAMPLE_SOFTWARE = 16; // not using hardware mixing
  BASS_SAMPLE_MUTEMAX = 32; // mute at max distance (3D only)
  BASS_SAMPLE_VAM = 64; // DX7 voice allocation & management
  BASS_SAMPLE_FX = 128; // old implementation of DX8 effects
  BASS_SAMPLE_OVER_VOL = $10000; // override lowest volume
  BASS_SAMPLE_OVER_POS = $20000; // override longest playing
  BASS_SAMPLE_OVER_DIST = $30000; // override furthest from listener (3D only)

  BASS_STREAM_PRESCAN = $20000; // enable pin-point seeking/length (MP3/MP2/MP1)
  BASS_MP3_SETPOS = BASS_STREAM_PRESCAN;
  BASS_STREAM_AUTOFREE = $40000; // automatically free the stream when it stop/ends
  BASS_STREAM_RESTRATE = $80000; // restrict the download rate of internet file streams
  BASS_STREAM_BLOCK = $100000; // download/play internet file stream in small blocks
  BASS_STREAM_DECODE = $200000; // don't play the stream, only decode (BASS_ChannelGetData)
  BASS_STREAM_STATUS = $800000; // give server status info (HTTP/ICY tags) in DOWNLOADPROC

  BASS_MUSIC_FLOAT = BASS_SAMPLE_FLOAT;
  BASS_MUSIC_MONO = BASS_SAMPLE_MONO;
  BASS_MUSIC_LOOP = BASS_SAMPLE_LOOP;
  BASS_MUSIC_3D = BASS_SAMPLE_3D;
  BASS_MUSIC_FX = BASS_SAMPLE_FX;
  BASS_MUSIC_AUTOFREE = BASS_STREAM_AUTOFREE;
  BASS_MUSIC_DECODE = BASS_STREAM_DECODE;
  BASS_MUSIC_PRESCAN = BASS_STREAM_PRESCAN; // calculate playback length
  BASS_MUSIC_CALCLEN = BASS_MUSIC_PRESCAN;
  BASS_MUSIC_RAMP = $200; // normal ramping
  BASS_MUSIC_RAMPS = $400; // sensitive ramping
  BASS_MUSIC_SURROUND = $800; // surround sound
  BASS_MUSIC_SURROUND2 = $1000; // surround sound (mode 2)
  BASS_MUSIC_FT2MOD = $2000; // play .MOD as FastTracker 2 does
  BASS_MUSIC_PT1MOD = $4000; // play .MOD as ProTracker 1 does
  BASS_MUSIC_NONINTER = $10000; // non-interpolated sample mixing
  BASS_MUSIC_SINCINTER = $800000; // sinc interpolated sample mixing
  BASS_MUSIC_POSRESET = $8000; // stop all notes when moving position
  BASS_MUSIC_POSRESETEX = $400000; // stop all notes and reset bmp/etc when moving position
  BASS_MUSIC_STOPBACK = $80000; // stop the music on a backwards jump effect
  BASS_MUSIC_NOSAMPLE = $100000; // don't load the samples

  // Speaker assignment flags
  BASS_SPEAKER_FRONT = $1000000; // front speakers
  BASS_SPEAKER_REAR = $2000000; // rear/side speakers
  BASS_SPEAKER_CENLFE = $3000000; // center & LFE speakers (5.1)
  BASS_SPEAKER_REAR2 = $4000000; // rear center speakers (7.1)
  BASS_SPEAKER_LEFT = $10000000; // modifier: left
  BASS_SPEAKER_RIGHT = $20000000; // modifier: right
  BASS_SPEAKER_FRONTLEFT = BASS_SPEAKER_FRONT or BASS_SPEAKER_LEFT;
  BASS_SPEAKER_FRONTRIGHT = BASS_SPEAKER_FRONT or BASS_SPEAKER_RIGHT;
  BASS_SPEAKER_REARLEFT = BASS_SPEAKER_REAR or BASS_SPEAKER_LEFT;
  BASS_SPEAKER_REARRIGHT = BASS_SPEAKER_REAR or BASS_SPEAKER_RIGHT;
  BASS_SPEAKER_CENTER = BASS_SPEAKER_CENLFE or BASS_SPEAKER_LEFT;
  BASS_SPEAKER_LFE = BASS_SPEAKER_CENLFE or BASS_SPEAKER_RIGHT;
  BASS_SPEAKER_REAR2LEFT = BASS_SPEAKER_REAR2 or BASS_SPEAKER_LEFT;
  BASS_SPEAKER_REAR2RIGHT = BASS_SPEAKER_REAR2 or BASS_SPEAKER_RIGHT;

  BASS_UNICODE = $80000000;

  BASS_RECORD_PAUSE = $8000; // start recording paused

  // DX7 voice allocation & management flags
  BASS_VAM_HARDWARE = 1;
  BASS_VAM_SOFTWARE = 2;
  BASS_VAM_TERM_TIME = 4;
  BASS_VAM_TERM_DIST = 8;
  BASS_VAM_TERM_PRIO = 16;

  // BASS_CHANNELINFO types
  BASS_CTYPE_SAMPLE = 1;
  BASS_CTYPE_RECORD = 2;
  BASS_CTYPE_STREAM = $10000;
  BASS_CTYPE_STREAM_OGG = $10002;
  BASS_CTYPE_STREAM_MP1 = $10003;
  BASS_CTYPE_STREAM_MP2 = $10004;
  BASS_CTYPE_STREAM_MP3 = $10005;
  BASS_CTYPE_STREAM_AIFF = $10006;
  BASS_CTYPE_STREAM_WAV = $40000; // WAVE flag, LOWORD=codec
  BASS_CTYPE_STREAM_WAV_PCM = $50001;
  BASS_CTYPE_STREAM_WAV_FLOAT = $50003;
  BASS_CTYPE_MUSIC_MOD = $20000;
  BASS_CTYPE_MUSIC_MTM = $20001;
  BASS_CTYPE_MUSIC_S3M = $20002;
  BASS_CTYPE_MUSIC_XM = $20003;
  BASS_CTYPE_MUSIC_IT = $20004;
  BASS_CTYPE_MUSIC_MO3 = $00100; // MO3 flag

  // 3D channel modes
  BASS_3DMODE_NORMAL = 0; // normal 3D processing
  BASS_3DMODE_RELATIVE = 1; // position is relative to the listener
  BASS_3DMODE_OFF = 2; // no 3D processing

  // software 3D mixing algorithms (used with BASS_CONFIG_3DALGORITHM)
  BASS_3DALG_DEFAULT = 0;
  BASS_3DALG_OFF = 1;
  BASS_3DALG_FULL = 2;
  BASS_3DALG_LIGHT = 3;

  // EAX environments, use with BASS_SetEAXParameters
  EAX_ENVIRONMENT_GENERIC = 0;
  EAX_ENVIRONMENT_PADDEDCELL = 1;
  EAX_ENVIRONMENT_ROOM = 2;
  EAX_ENVIRONMENT_BATHROOM = 3;
  EAX_ENVIRONMENT_LIVINGROOM = 4;
  EAX_ENVIRONMENT_STONEROOM = 5;
  EAX_ENVIRONMENT_AUDITORIUM = 6;
  EAX_ENVIRONMENT_CONCERTHALL = 7;
  EAX_ENVIRONMENT_CAVE = 8;
  EAX_ENVIRONMENT_ARENA = 9;
  EAX_ENVIRONMENT_HANGAR = 10;
  EAX_ENVIRONMENT_CARPETEDHALLWAY = 11;
  EAX_ENVIRONMENT_HALLWAY = 12;
  EAX_ENVIRONMENT_STONECORRIDOR = 13;
  EAX_ENVIRONMENT_ALLEY = 14;
  EAX_ENVIRONMENT_FOREST = 15;
  EAX_ENVIRONMENT_CITY = 16;
  EAX_ENVIRONMENT_MOUNTAINS = 17;
  EAX_ENVIRONMENT_QUARRY = 18;
  EAX_ENVIRONMENT_PLAIN = 19;
  EAX_ENVIRONMENT_PARKINGLOT = 20;
  EAX_ENVIRONMENT_SEWERPIPE = 21;
  EAX_ENVIRONMENT_UNDERWATER = 22;
  EAX_ENVIRONMENT_DRUGGED = 23;
  EAX_ENVIRONMENT_DIZZY = 24;
  EAX_ENVIRONMENT_PSYCHOTIC = 25;
  // total number of environments
  EAX_ENVIRONMENT_COUNT = 26;

  BASS_STREAMPROC_END = $80000000; // end of user stream flag

  // BASS_StreamCreateFileUser file systems
  STREAMFILE_NOBUFFER = 0;
  STREAMFILE_BUFFER = 1;
  STREAMFILE_BUFFERPUSH = 2;

  // BASS_StreamPutFileData options
  BASS_FILEDATA_END = 0; // end & close the file

  // BASS_StreamGetFilePosition modes
  BASS_FILEPOS_CURRENT = 0;
  BASS_FILEPOS_DECODE = BASS_FILEPOS_CURRENT;
  BASS_FILEPOS_DOWNLOAD = 1;
  BASS_FILEPOS_END = 2;
  BASS_FILEPOS_START = 3;
  BASS_FILEPOS_CONNECTED = 4;
  BASS_FILEPOS_BUFFER = 5;

  // BASS_ChannelSetSync types
  BASS_SYNC_POS = 0;
  BASS_SYNC_END = 2;
  BASS_SYNC_META = 4;
  BASS_SYNC_SLIDE = 5;
  BASS_SYNC_STALL = 6;
  BASS_SYNC_DOWNLOAD = 7;
  BASS_SYNC_FREE = 8;
  BASS_SYNC_SETPOS = 11;
  BASS_SYNC_MUSICPOS = 10;
  BASS_SYNC_MUSICINST = 1;
  BASS_SYNC_MUSICFX = 3;
  BASS_SYNC_OGG_CHANGE = 12;
  BASS_SYNC_MIXTIME = $40000000; // FLAG: sync at mixtime, else at playtime
  BASS_SYNC_ONETIME = $80000000; // FLAG: sync only once, else continuously

  // BASS_ChannelIsActive return values
  BASS_ACTIVE_STOPPED = 0;
  BASS_ACTIVE_PLAYING = 1;
  BASS_ACTIVE_STALLED = 2;
  BASS_ACTIVE_PAUSED = 3;

  // Channel attributes
  BASS_ATTRIB_FREQ = 1;
  BASS_ATTRIB_VOL = 2;
  BASS_ATTRIB_PAN = 3;
  BASS_ATTRIB_EAXMIX = 4;
  BASS_ATTRIB_MUSIC_AMPLIFY = $100;
  BASS_ATTRIB_MUSIC_PANSEP = $101;
  BASS_ATTRIB_MUSIC_PSCALER = $102;
  BASS_ATTRIB_MUSIC_BPM = $103;
  BASS_ATTRIB_MUSIC_SPEED = $104;
  BASS_ATTRIB_MUSIC_VOL_GLOBAL = $105;
  BASS_ATTRIB_MUSIC_VOL_CHAN = $200; // + channel #
  BASS_ATTRIB_MUSIC_VOL_INST = $300; // + instrument #

  // BASS_ChannelGetData flags
  BASS_DATA_AVAILABLE = 0; // query how much data is buffered
  BASS_DATA_FLOAT = $40000000; // flag: return floating-point sample data
  BASS_DATA_FFT256 = $80000000; // 256 sample FFT
  BASS_DATA_FFT512 = $80000001; // 512 FFT
  BASS_DATA_FFT1024 = $80000002; // 1024 FFT
  BASS_DATA_FFT2048 = $80000003; // 2048 FFT
  BASS_DATA_FFT4096 = $80000004; // 4096 FFT
  BASS_DATA_FFT8192 = $80000005; // 8192 FFT
  BASS_DATA_FFT_INDIVIDUAL = $10; // FFT flag: FFT for each channel, else all combined
  BASS_DATA_FFT_NOWINDOW = $20; // FFT flag: no Hanning window

  // BASS_ChannelGetTags types : what's returned
  BASS_TAG_ID3 = 0; // ID3v1 tags : TAG_ID3 structure
  BASS_TAG_ID3V2 = 1; // ID3v2 tags : variable length block
  BASS_TAG_OGG = 2; // OGG comments : series of null-terminated UTF-8 strings
  BASS_TAG_HTTP = 3; // HTTP headers : series of null-terminated ANSI strings
  BASS_TAG_ICY = 4; // ICY headers : series of null-terminated ANSI strings
  BASS_TAG_META = 5; // ICY metadata : ANSI string
  BASS_TAG_VENDOR = 9; // OGG encoder : UTF-8 string
  BASS_TAG_LYRICS3 = 10; // Lyric3v2 tag : ASCII string
  BASS_TAG_RIFF_INFO = $100; // RIFF "INFO" tags : series of null-terminated ANSI strings
  BASS_TAG_RIFF_BEXT = $101; // RIFF/BWF Broadcast Audio Extension tags : TAG_BEXT structure
  BASS_TAG_MUSIC_NAME = $10000; // MOD music name : ANSI string
  BASS_TAG_MUSIC_MESSAGE = $10001; // MOD message : ANSI string
  BASS_TAG_MUSIC_ORDERS = $10002; // MOD order list : BYTE array of pattern numbers
  BASS_TAG_MUSIC_INST = $10100; // + instrument #, MOD instrument name : ANSI string
  BASS_TAG_MUSIC_SAMPLE = $10300; // + sample #, MOD sample name : ANSI string

  // BASS_ChannelGetLength/GetPosition/SetPosition modes
  BASS_POS_BYTE = 0; // byte position
  BASS_POS_MUSIC_ORDER = 1; // order.row position, MAKELONG(order,row)

  // BASS_RecordSetInput flags
  BASS_INPUT_OFF = $10000;
  BASS_INPUT_ON = $20000;

  BASS_INPUT_TYPE_MASK = $FF000000;
  BASS_INPUT_TYPE_UNDEF = $00000000;
  BASS_INPUT_TYPE_DIGITAL = $01000000;
  BASS_INPUT_TYPE_LINE = $02000000;
  BASS_INPUT_TYPE_MIC = $03000000;
  BASS_INPUT_TYPE_SYNTH = $04000000;
  BASS_INPUT_TYPE_CD = $05000000;
  BASS_INPUT_TYPE_PHONE = $06000000;
  BASS_INPUT_TYPE_SPEAKER = $07000000;
  BASS_INPUT_TYPE_WAVE = $08000000;
  BASS_INPUT_TYPE_AUX = $09000000;
  BASS_INPUT_TYPE_ANALOG = $0A000000;

  BASS_FX_DX8_CHORUS = 0;
  BASS_FX_DX8_COMPRESSOR = 1;
  BASS_FX_DX8_DISTORTION = 2;
  BASS_FX_DX8_ECHO = 3;
  BASS_FX_DX8_FLANGER = 4;
  BASS_FX_DX8_GARGLE = 5;
  BASS_FX_DX8_I3DL2REVERB = 6;
  BASS_FX_DX8_PARAMEQ = 7;
  BASS_FX_DX8_REVERB = 8;

  BASS_DX8_PHASE_NEG_180 = 0;
  BASS_DX8_PHASE_NEG_90 = 1;
  BASS_DX8_PHASE_ZERO = 2;
  BASS_DX8_PHASE_90 = 3;
  BASS_DX8_PHASE_180 = 4;

type
  DWORD = LongWord;
  BOOL = LongBool;
  FLOAT = Single;
  QWORD = Int64;

  HMUSIC = DWORD; // MOD music handle
  HSAMPLE = DWORD; // sample handle
  HCHANNEL = DWORD; // playing sample's channel handle
  HSTREAM = DWORD; // sample stream handle
  HRECORD = DWORD; // recording handle
  HSYNC = DWORD; // synchronizer handle
  HDSP = DWORD; // DSP handle
  HFX = DWORD; // DX8 effect handle
  HPLUGIN = DWORD; // Plugin handle

  // Device info structure
  BASS_DEVICEINFO = record
    name: PAnsiChar; // description
    driver: PAnsiChar; // driver
    flags: DWORD;
  end;

  BASS_INFO = record
    flags: DWORD; // device capabilities (DSCAPS_xxx flags)
    hwsize: DWORD; // size of total device hardware memory
    hwfree: DWORD; // size of free device hardware memory
    freesam: DWORD; // number of free sample slots in the hardware
    free3d: DWORD; // number of free 3D sample slots in the hardware
    minrate: DWORD; // min sample rate supported by the hardware
    maxrate: DWORD; // max sample rate supported by the hardware
    eax: BOOL; // device supports EAX? (always FALSE if BASS_DEVICE_3D was not used)
    minbuf: DWORD; // recommended minimum buffer length in ms (requires BASS_DEVICE_LATENCY)
    dsver: DWORD; // DirectSound version
    latency: DWORD; // delay (in ms) before start of playback (requires BASS_DEVICE_LATENCY)
    initflags: DWORD; // BASS_Init "flags" parameter
    speakers: DWORD; // number of speakers available
    freq: DWORD; // current output rate (OSX only)
  end;

  // Recording device info structure
  BASS_RECORDINFO = record
    flags: DWORD; // device capabilities (DSCCAPS_xxx flags)
    formats: DWORD; // supported standard formats (WAVE_FORMAT_xxx flags)
    inputs: DWORD; // number of inputs
    singlein: BOOL; // only 1 input can be set at a time
    freq: DWORD; // current input rate (OSX only)
  end;

  // Sample info structure
  BASS_SAMPLE = record
    freq: DWORD; // default playback rate
    volume: FLOAT; // default volume (0-100)
    pan: FLOAT; // default pan (-100=left, 0=middle, 100=right)
    flags: DWORD; // BASS_SAMPLE_xxx flags
    length: DWORD; // length (in samples, not bytes)
    max: DWORD; // maximum simultaneous playbacks
    origres: DWORD; // original resolution
    chans: DWORD; // number of channels
    mingap: DWORD; // minimum gap (ms) between creating channels
    mode3d: DWORD; // BASS_3DMODE_xxx mode
    mindist: FLOAT; // minimum distance
    maxdist: FLOAT; // maximum distance
    iangle: DWORD; // angle of inside projection cone
    oangle: DWORD; // angle of outside projection cone
    outvol: FLOAT; // delta-volume outside the projection cone
    vam: DWORD; // voice allocation/management flags (BASS_VAM_xxx)
    priority: DWORD; // priority (0=lowest, $ffffffff=highest)
  end;

  // Channel info structure
  BASS_CHANNELINFO = record
    freq: DWORD; // default playback rate
    chans: DWORD; // channels
    flags: DWORD; // BASS_SAMPLE/STREAM/MUSIC/SPEAKER flags
    ctype: DWORD; // type of channel
    origres: DWORD; // original resolution
    plugin: HPLUGIN; // plugin
    sample: HSAMPLE; // sample
    filename: PChar; // filename
  end;

  BASS_PLUGINFORM = record
    ctype: DWORD; // channel type
    name: PAnsiChar; // format description
    exts: PAnsiChar; // file extension filter (*.ext1;*.ext2;etc...)
  end;
  PBASS_PLUGINFORMS = ^TBASS_PLUGINFORMS;
  TBASS_PLUGINFORMS = array[0..maxInt div sizeOf(BASS_PLUGINFORM) - 1] of BASS_PLUGINFORM;

  BASS_PLUGININFO = record
    version: DWORD; // version (same form as BASS_GetVersion)
    formatc: DWORD; // number of formats
    formats: PBASS_PLUGINFORMS; // the array of formats
  end;
  PBASS_PLUGININFO = ^BASS_PLUGININFO;

  // 3D vector (for 3D positions/velocities/orientations)
  BASS_3DVECTOR = record
    x: FLOAT; // +=right, -=left
    y: FLOAT; // +=up, -=down
    z: FLOAT; // +=front, -=behind
  end;

  // User file stream callback functions
  FILECLOSEPROC = procedure(user: Pointer); stdcall;
  FILELENPROC = function(user: Pointer): QWORD; stdcall;
  FILEREADPROC = function(buffer: Pointer; length: DWORD; user: Pointer): DWORD; stdcall;
  FILESEEKPROC = function(offset: QWORD; user: Pointer): BOOL; stdcall;

  BASS_FILEPROCS = record
    close: FILECLOSEPROC;
    length: FILELENPROC;
    read: FILEREADPROC;
    seek: FILESEEKPROC;
  end;

  // ID3v1 tag structure
  TAG_ID3 = record
    id: array[0..2] of AnsiChar;
    title: array[0..29] of AnsiChar;
    artist: array[0..29] of AnsiChar;
    album: array[0..29] of AnsiChar;
    year: array[0..3] of AnsiChar;
    comment: array[0..29] of AnsiChar;
    genre: Byte;
  end;

  // BWF Broadcast Audio Extension tag structure
  TAG_BEXT = record
    Description: array[0..255] of AnsiChar; // description
    Originator: array[0..31] of AnsiChar; // name of the originator
    OriginatorReference: array[0..31] of AnsiChar; // reference of the originator
    OriginationDate: array[0..9] of AnsiChar; // date of creation (yyyy-mm-dd)
    OriginationTime: array[0..7] of AnsiChar; // time of creation (hh-mm-ss)
    TimeReference: QWORD; // first sample count since midnight (little-endian)
    Version: Word; // BWF version (little-endian)
    UMID: array[0..63] of Byte; // SMPTE UMID
    Reserved: array[0..189] of Byte;
    CodingHistory: array of AnsiChar; // history
  end;

  BASS_DX8_CHORUS = record
    fWetDryMix: FLOAT;
    fDepth: FLOAT;
    fFeedback: FLOAT;
    fFrequency: FLOAT;
    lWaveform: DWORD; // 0=triangle, 1=sine
    fDelay: FLOAT;
    lPhase: DWORD; // BASS_DX8_PHASE_xxx
  end;

  BASS_DX8_COMPRESSOR = record
    fGain: FLOAT;
    fAttack: FLOAT;
    fRelease: FLOAT;
    fThreshold: FLOAT;
    fRatio: FLOAT;
    fPredelay: FLOAT;
  end;

  BASS_DX8_DISTORTION = record
    fGain: FLOAT;
    fEdge: FLOAT;
    fPostEQCenterFrequency: FLOAT;
    fPostEQBandwidth: FLOAT;
    fPreLowpassCutoff: FLOAT;
  end;

  BASS_DX8_ECHO = record
    fWetDryMix: FLOAT;
    fFeedback: FLOAT;
    fLeftDelay: FLOAT;
    fRightDelay: FLOAT;
    lPanDelay: BOOL;
  end;

  BASS_DX8_FLANGER = record
    fWetDryMix: FLOAT;
    fDepth: FLOAT;
    fFeedback: FLOAT;
    fFrequency: FLOAT;
    lWaveform: DWORD; // 0=triangle, 1=sine
    fDelay: FLOAT;
    lPhase: DWORD; // BASS_DX8_PHASE_xxx
  end;

  BASS_DX8_GARGLE = record
    dwRateHz: DWORD; // Rate of modulation in hz
    dwWaveShape: DWORD; // 0=triangle, 1=square
  end;

  BASS_DX8_I3DL2REVERB = record
    lRoom: LongInt; // [-10000, 0]      default: -1000 mB
    lRoomHF: LongInt; // [-10000, 0]      default: 0 mB
    flRoomRolloffFactor: FLOAT; // [0.0, 10.0]      default: 0.0
    flDecayTime: FLOAT; // [0.1, 20.0]      default: 1.49s
    flDecayHFRatio: FLOAT; // [0.1, 2.0]       default: 0.83
    lReflections: LongInt; // [-10000, 1000]   default: -2602 mB
    flReflectionsDelay: FLOAT; // [0.0, 0.3]       default: 0.007 s
    lReverb: LongInt; // [-10000, 2000]   default: 200 mB
    flReverbDelay: FLOAT; // [0.0, 0.1]       default: 0.011 s
    flDiffusion: FLOAT; // [0.0, 100.0]     default: 100.0 %
    flDensity: FLOAT; // [0.0, 100.0]     default: 100.0 %
    flHFReference: FLOAT; // [20.0, 20000.0]  default: 5000.0 Hz
  end;

  BASS_DX8_PARAMEQ = record
    fCenter: FLOAT;
    fBandwidth: FLOAT;
    fGain: FLOAT;
  end;

  BASS_DX8_REVERB = record
    fInGain: FLOAT; // [-96.0,0.0]            default: 0.0 dB
    fReverbMix: FLOAT; // [-96.0,0.0]            default: 0.0 db
    fReverbTime: FLOAT; // [0.001,3000.0]         default: 1000.0 ms
    fHighFreqRTRatio: FLOAT; // [0.001,0.999]          default: 0.001
  end;

  // callback function types
  STREAMPROC = function(handle: HSTREAM; buffer: Pointer; length: DWORD; user: Pointer): DWORD; stdcall;
  {
    User stream callback function. NOTE: A stream function should obviously be as
    quick as possible, other streams (and MOD musics) can't be mixed until
    it's finished.
    handle : The stream that needs writing
    buffer : Buffer to write the samples in
    length : Number of bytes to write
    user   : The 'user' parameter value given when calling BASS_StreamCreate
    RETURN : Number of bytes written. Set the BASS_STREAMPROC_END flag to end
             the stream.
  }

const
  // special STREAMPROCs
  STREAMPROC_DUMMY: STREAMPROC = STREAMPROC(0); // "dummy" stream
  STREAMPROC_PUSH: STREAMPROC = STREAMPROC(-1); // push stream

type

  DOWNLOADPROC = procedure(buffer: Pointer; length: DWORD; user: Pointer); stdcall;
  {
    Internet stream download callback function.
    buffer : Buffer containing the downloaded data... NULL=end of download
    length : Number of bytes in the buffer
    user   : The 'user' parameter value given when calling BASS_StreamCreateURL
  }

  SYNCPROC = procedure(handle: HSYNC; channel, data: DWORD; user: Pointer); stdcall;
  {
    Sync callback function. NOTE: a sync callback function should be very
    quick as other syncs cannot be processed until it has finished. If the
    sync is a "mixtime" sync, then other streams and MOD musics can not be
    mixed until it's finished either.
    handle : The sync that has occured
    channel: Channel that the sync occured in
    data   : Additional data associated with the sync's occurance
    user   : The 'user' parameter given when calling BASS_ChannelSetSync
  }

  DSPPROC = procedure(handle: HDSP; channel: DWORD; buffer: Pointer; length: DWORD; user: Pointer); stdcall;
  {
    DSP callback function. NOTE: A DSP function should obviously be as quick
    as possible... other DSP functions, streams and MOD musics can not be
    processed until it's finished.
    handle : The DSP handle
    channel: Channel that the DSP is being applied to
    buffer : Buffer to apply the DSP to
    length : Number of bytes in the buffer
    user   : The 'user' parameter given when calling BASS_ChannelSetDSP
  }

  RECORDPROC = function(handle: HRECORD; buffer: Pointer; length: DWORD; user: Pointer): BOOL; stdcall;
  {
    Recording callback function.
    handle : The recording handle
    buffer : Buffer containing the recorded sample data
    length : Number of bytes
    user   : The 'user' parameter value given when calling BASS_RecordStart
    RETURN : TRUE = continue recording, FALSE = stop
  }

  {
    This function is defined in the implementation part of this unit.
    It is not part of BASS.DLL but an extra function which makes it easier
    to set the predefined EAX environments.
    env    : a EAX_ENVIRONMENT_xxx constant
  }
  TBASS_SetConfig = function(option, value: DWORD): BOOL; stdcall;
  TBASS_GetConfig = function(option: DWORD): DWORD; stdcall;
  TBASS_SetConfigPtr = function(option: DWORD; value: Pointer): BOOL; stdcall;
  TBASS_GetConfigPtr = function(option: DWORD): Pointer; stdcall;
  TBASS_GetVersion = function: DWORD; stdcall;
  TBASS_ErrorGetCode = function: LongInt; stdcall;
  TBASS_GetDeviceInfo = function(device: DWORD; var info: BASS_DEVICEINFO): BOOL; stdcall;
  TBASS_Init = function(device: LongInt; freq, flags: DWORD; win: HWND; clsid: PGUID): BOOL; stdcall;
  TBASS_SetDevice = function(device: DWORD): BOOL; stdcall;
  TBASS_GetDevice = function: DWORD; stdcall;
  TBASS_Free = function: BOOL; stdcall;
  TBASS_GetDSoundObject = function(obj: DWORD): Pointer; stdcall;
  TBASS_GetInfo = function(var info: BASS_INFO): BOOL; stdcall;
  TBASS_Update = function(length: DWORD): BOOL; stdcall;
  TBASS_GetCPU = function: FLOAT; stdcall;
  TBASS_Start = function: BOOL; stdcall;
  TBASS_Stop = function: BOOL; stdcall;
  TBASS_Pause = function: BOOL; stdcall;
  TBASS_SetVolume = function(volume: FLOAT): BOOL; stdcall;
  TBASS_GetVolume = function: FLOAT; stdcall;

  TBASS_PluginLoad = function(filename: PChar; flags: DWORD): HPLUGIN; stdcall;
  TBASS_PluginFree = function(handle: HPLUGIN): BOOL; stdcall;
  TBASS_PluginGetInfo = function(handle: HPLUGIN): PBASS_PLUGININFO; stdcall;

  TBASS_Set3DFactors = function(distf, rollf, doppf: FLOAT): BOOL; stdcall;
  TBASS_Get3DFactors = function(var distf, rollf, doppf: FLOAT): BOOL; stdcall;
  TBASS_Set3DPosition = function(var pos, vel, front, top: BASS_3DVECTOR): BOOL; stdcall;
  TBASS_Get3DPosition = function(var pos, vel, front, top: BASS_3DVECTOR): BOOL; stdcall;
  TBASS_Apply3D = procedure; stdcall;
  TBASS_SetEAXParameters = function(env: LongInt; vol, decay, damp: FLOAT): BOOL; stdcall;
  TBASS_GetEAXParameters = function(var env: DWORD; var vol, decay, damp: FLOAT): BOOL; stdcall;

  TBASS_MusicLoad = function(mem: BOOL; f: Pointer; offset: QWORD; length, flags, freq: DWORD): HMUSIC; stdcall;
  TBASS_MusicFree = function(handle: HMUSIC): BOOL; stdcall;

  TBASS_SampleLoad = function(mem: BOOL; f: Pointer; offset: QWORD; length, max, flags: DWORD): HSAMPLE; stdcall;
  TBASS_SampleCreate = function(length, freq, chans, max, flags: DWORD): HSAMPLE; stdcall;
  TBASS_SampleFree = function(handle: HSAMPLE): BOOL; stdcall;
  TBASS_SampleSetData = function(handle: HSAMPLE; buffer: Pointer): BOOL; stdcall;
  TBASS_SampleGetData = function(handle: HSAMPLE; buffer: Pointer): BOOL; stdcall;
  TBASS_SampleGetInfo = function(handle: HSAMPLE; var info: BASS_SAMPLE): BOOL; stdcall;
  TBASS_SampleSetInfo = function(handle: HSAMPLE; var info: BASS_SAMPLE): BOOL; stdcall;
  TBASS_SampleGetChannel = function(handle: HSAMPLE; onlynew: BOOL): HCHANNEL; stdcall;
  TBASS_SampleGetChannels = function(handle: HSAMPLE; channels: Pointer): DWORD; stdcall;
  TBASS_SampleStop = function(handle: HSAMPLE): BOOL; stdcall;

  TBASS_StreamCreate = function(freq, chans, flags: DWORD; proc: STREAMPROC; user: Pointer): HSTREAM; stdcall;
  TBASS_StreamCreateFile = function(mem: BOOL; f: Pointer; offset, length: QWORD; flags: DWORD): HSTREAM; stdcall;
  TBASS_StreamCreateURL = function(url: PAnsiChar; offset: DWORD; flags: DWORD; proc: DOWNLOADPROC; user: Pointer): HSTREAM;
  stdcall;
  TBASS_StreamCreateFileUser = function(system, flags: DWORD; var procs: BASS_FILEPROCS; user: Pointer): HSTREAM; stdcall;
  TBASS_StreamFree = function(handle: HSTREAM): BOOL; stdcall;
  TBASS_StreamGetFilePosition = function(handle: HSTREAM; mode: DWORD): QWORD; stdcall;
  TBASS_StreamPutData = function(handle: HSTREAM; buffer: Pointer; length: DWORD): DWORD; stdcall;
  TBASS_StreamPutFileData = function(handle: HSTREAM; buffer: Pointer; length: DWORD): DWORD; stdcall;

  TBASS_RecordGetDeviceInfo = function(device: DWORD; var info: BASS_DEVICEINFO): BOOL; stdcall;
  TBASS_RecordInit = function(device: LongInt): BOOL; stdcall;
  TBASS_RecordSetDevice = function(device: DWORD): BOOL; stdcall;
  TBASS_RecordGetDevice = function: DWORD; stdcall;
  TBASS_RecordFree = function: BOOL; stdcall;
  TBASS_RecordGetInfo = function(var info: BASS_RECORDINFO): BOOL; stdcall;
  TBASS_RecordGetInputName = function(input: LongInt): PAnsiChar; stdcall;
  TBASS_RecordSetInput = function(input: LongInt; flags: DWORD; volume: FLOAT): BOOL; stdcall;
  TBASS_RecordGetInput = function(input: LongInt; var volume: FLOAT): DWORD; stdcall;
  TBASS_RecordStart = function(freq, chans, flags: DWORD; proc: RECORDPROC; user: Pointer): HRECORD; stdcall;

  TBASS_ChannelBytes2Seconds = function(handle: DWORD; pos: QWORD): Double; stdcall;
  TBASS_ChannelSeconds2Bytes = function(handle: DWORD; pos: Double): QWORD; stdcall;
  TBASS_ChannelGetDevice = function(handle: DWORD): DWORD; stdcall;
  TBASS_ChannelSetDevice = function(handle, device: DWORD): BOOL; stdcall;
  TBASS_ChannelIsActive = function(handle: DWORD): DWORD; stdcall;
  TBASS_ChannelGetInfo = function(handle: DWORD; var info: BASS_CHANNELINFO): BOOL; stdcall;
  TBASS_ChannelGetTags = function(handle: HSTREAM; tags: DWORD): PAnsiChar; stdcall;
  TBASS_ChannelFlags = function(handle, flags, mask: DWORD): DWORD; stdcall;
  TBASS_ChannelUpdate = function(handle, length: DWORD): BOOL; stdcall;
  TBASS_ChannelLock = function(handle: DWORD; lock: BOOL): BOOL; stdcall;
  TBASS_ChannelPlay = function(handle: DWORD; restart: BOOL): BOOL; stdcall;
  TBASS_ChannelStop = function(handle: DWORD): BOOL; stdcall;
  TBASS_ChannelPause = function(handle: DWORD): BOOL; stdcall;
  TBASS_ChannelSetAttribute = function(handle, attrib: DWORD; value: FLOAT): BOOL; stdcall;
  TBASS_ChannelGetAttribute = function(handle, attrib: DWORD; var value: FLOAT): BOOL; stdcall;
  TBASS_ChannelSlideAttribute = function(handle, attrib: DWORD; value: FLOAT; time: DWORD): BOOL; stdcall;
  TBASS_ChannelIsSliding = function(handle, attrib: DWORD): BOOL; stdcall;
  TBASS_ChannelSet3DAttributes = function(handle: DWORD; mode: LongInt; min, max: FLOAT; iangle, oangle, outvol: LongInt):
    BOOL; stdcall;
  TBASS_ChannelGet3DAttributes = function(handle: DWORD; var mode: DWORD; var min, max: FLOAT; var iangle, oangle, outvol:
    DWORD): BOOL; stdcall;
  TBASS_ChannelSet3DPosition = function(handle: DWORD; var pos, orient, vel: BASS_3DVECTOR): BOOL; stdcall;
  TBASS_ChannelGet3DPosition = function(handle: DWORD; var pos, orient, vel: BASS_3DVECTOR): BOOL; stdcall;
  TBASS_ChannelGetLength = function(handle, mode: DWORD): QWORD; stdcall;
  TBASS_ChannelSetPosition = function(handle: DWORD; pos: QWORD; mode: DWORD): BOOL; stdcall;
  TBASS_ChannelGetPosition = function(handle, mode: DWORD): QWORD; stdcall;
  TBASS_ChannelGetLevel = function(handle: DWORD): DWORD; stdcall;
  TBASS_ChannelGetData = function(handle: DWORD; buffer: Pointer; length: DWORD): DWORD; stdcall;
  TBASS_ChannelSetSync = function(handle: DWORD; type_: DWORD; param: QWORD; proc: SYNCPROC; user: Pointer): HSYNC; stdcall;
  TBASS_ChannelRemoveSync = function(handle: DWORD; sync: HSYNC): BOOL; stdcall;
  TBASS_ChannelSetDSP = function(handle: DWORD; proc: DSPPROC; user: Pointer; priority: LongInt): HDSP; stdcall;
  TBASS_ChannelRemoveDSP = function(handle: DWORD; dsp: HDSP): BOOL; stdcall;
  TBASS_ChannelSetLink = function(handle, chan: DWORD): BOOL; stdcall;
  TBASS_ChannelRemoveLink = function(handle, chan: DWORD): BOOL; stdcall;
  TBASS_ChannelSetFX = function(handle, type_: DWORD; priority: LongInt): HFX; stdcall;
  TBASS_ChannelRemoveFX = function(handle: DWORD; fx: HFX): BOOL; stdcall;

  TBASS_FXSetParameters = function(handle: HFX; par: Pointer): BOOL; stdcall;
  TBASS_FXGetParameters = function(handle: HFX; par: Pointer): BOOL; stdcall;
  TBASS_FXReset = function(handle: HFX): BOOL; stdcall;

var
  BASS_SetConfig: TBASS_SetConfig;
  BASS_GetConfig: TBASS_GetConfig;
  BASS_SetConfigPtr: TBASS_SetConfigPtr;
  BASS_GetConfigPtr: TBASS_GetConfigPtr;
  BASS_GetVersion: TBASS_GetVersion;
  BASS_ErrorGetCode: TBASS_ErrorGetCode;
  BASS_GetDeviceInfo: TBASS_GetDeviceInfo;
  BASS_Init: TBASS_Init;
  BASS_SetDevice: TBASS_SetDevice;
  BASS_GetDevice: TBASS_GetDevice;
  BASS_Free: TBASS_Free;
  BASS_GetDSoundObject: TBASS_GetDSoundObject;
  BASS_GetInfo: TBASS_GetInfo;
  BASS_Update: TBASS_Update;
  BASS_GetCPU: TBASS_GetCPU;
  BASS_Start: TBASS_Start;
  BASS_Stop: TBASS_Stop;
  BASS_Pause: TBASS_Pause;
  BASS_SetVolume: TBASS_SetVolume;
  BASS_GetVolume: TBASS_GetVolume;

  BASS_PluginLoad: TBASS_PluginLoad;
  BASS_PluginFree: TBASS_PluginFree;
  BASS_PluginGetInfo: TBASS_PluginGetInfo;

  BASS_Set3DFactors: TBASS_Set3DFactors;
  BASS_Get3DFactors: TBASS_Get3DFactors;
  BASS_Set3DPosition: TBASS_Set3DPosition;
  BASS_Get3DPosition: TBASS_Get3DPosition;
  BASS_Apply3D: TBASS_Apply3D;
  BASS_SetEAXParameters: TBASS_SetEAXParameters;
  BASS_GetEAXParameters: TBASS_GetEAXParameters;

  BASS_MusicLoad: TBASS_MusicLoad;
  BASS_MusicFree: TBASS_MusicFree;

  BASS_SampleLoad: TBASS_SampleLoad;
  BASS_SampleCreate: TBASS_SampleCreate;
  BASS_SampleFree: TBASS_SampleFree;
  BASS_SampleSetData: TBASS_SampleSetData;
  BASS_SampleGetData: TBASS_SampleGetData;
  BASS_SampleGetInfo: TBASS_SampleGetInfo;
  BASS_SampleSetInfo: TBASS_SampleSetInfo;
  BASS_SampleGetChannel: TBASS_SampleGetChannel;
  BASS_SampleGetChannels: TBASS_SampleGetChannels;
  BASS_SampleStop: TBASS_SampleStop;

  BASS_StreamCreate: TBASS_StreamCreate;
  BASS_StreamCreateFile: TBASS_StreamCreateFile;
  BASS_StreamCreateURL: TBASS_StreamCreateURL;
  BASS_StreamCreateFileUser: TBASS_StreamCreateFileUser;
  BASS_StreamFree: TBASS_StreamFree;
  BASS_StreamGetFilePosition: TBASS_StreamGetFilePosition;
  BASS_StreamPutData: TBASS_StreamPutData;
  BASS_StreamPutFileData: TBASS_StreamPutFileData;

  BASS_RecordGetDeviceInfo: TBASS_RecordGetDeviceInfo;
  BASS_RecordInit: TBASS_RecordInit;
  BASS_RecordSetDevice: TBASS_RecordSetDevice;
  BASS_RecordGetDevice: TBASS_RecordGetDevice;
  BASS_RecordFree: TBASS_RecordFree;
  BASS_RecordGetInfo: TBASS_RecordGetInfo;
  BASS_RecordGetInputName: TBASS_RecordGetInputName;
  BASS_RecordSetInput: TBASS_RecordSetInput;
  BASS_RecordGetInput: TBASS_RecordGetInput;
  BASS_RecordStart: TBASS_RecordStart;

  BASS_ChannelBytes2Seconds: TBASS_ChannelBytes2Seconds;
  BASS_ChannelSeconds2Bytes: TBASS_ChannelSeconds2Bytes;
  BASS_ChannelGetDevice: TBASS_ChannelGetDevice;
  BASS_ChannelSetDevice: TBASS_ChannelSetDevice;
  BASS_ChannelIsActive: TBASS_ChannelIsActive;
  BASS_ChannelGetInfo: TBASS_ChannelGetInfo;
  BASS_ChannelGetTags: TBASS_ChannelGetTags;
  BASS_ChannelFlags: TBASS_ChannelFlags;
  BASS_ChannelUpdate: TBASS_ChannelUpdate;
  BASS_ChannelLock: TBASS_ChannelLock;
  BASS_ChannelPlay: TBASS_ChannelPlay;
  BASS_ChannelStop: TBASS_ChannelStop;
  BASS_ChannelPause: TBASS_ChannelPause;
  BASS_ChannelSetAttribute: TBASS_ChannelSetAttribute;
  BASS_ChannelGetAttribute: TBASS_ChannelGetAttribute;
  BASS_ChannelSlideAttribute: TBASS_ChannelSlideAttribute;
  BASS_ChannelIsSliding: TBASS_ChannelIsSliding;
  BASS_ChannelSet3DAttributes: TBASS_ChannelSet3DAttributes;
  BASS_ChannelGet3DAttributes: TBASS_ChannelGet3DAttributes;
  BASS_ChannelSet3DPosition: TBASS_ChannelSet3DPosition;
  BASS_ChannelGet3DPosition: TBASS_ChannelGet3DPosition;
  BASS_ChannelGetLength: TBASS_ChannelGetLength;
  BASS_ChannelSetPosition: TBASS_ChannelSetPosition;
  BASS_ChannelGetPosition: TBASS_ChannelGetPosition;
  BASS_ChannelGetLevel: TBASS_ChannelGetLevel;
  BASS_ChannelGetData: TBASS_ChannelGetData;
  BASS_ChannelSetSync: TBASS_ChannelSetSync;
  BASS_ChannelRemoveSync: TBASS_ChannelRemoveSync;
  BASS_ChannelSetDSP: TBASS_ChannelSetDSP;
  BASS_ChannelRemoveDSP: TBASS_ChannelRemoveDSP;
  BASS_ChannelSetLink: TBASS_ChannelSetLink;
  BASS_ChannelRemoveLink: TBASS_ChannelRemoveLink;
  BASS_ChannelSetFX: TBASS_ChannelSetFX;
  BASS_ChannelRemoveFX: TBASS_ChannelRemoveFX;

  BASS_FXSetParameters: TBASS_FXSetParameters;
  BASS_FXGetParameters: TBASS_FXGetParameters;
  BASS_FXReset: TBASS_FXReset;

implementation

function BASS_SPEAKER_N(n: DWORD): DWORD;
begin
  Result := n shl 24;
end;

function BASS_SetEAXPreset(env: LongInt): BOOL;
begin
  case (env) of
    EAX_ENVIRONMENT_GENERIC:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_GENERIC, 0.5, 1.493, 0.5);
    EAX_ENVIRONMENT_PADDEDCELL:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_PADDEDCELL, 0.25, 0.1, 0);
    EAX_ENVIRONMENT_ROOM:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_ROOM, 0.417, 0.4, 0.666);
    EAX_ENVIRONMENT_BATHROOM:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_BATHROOM, 0.653, 1.499, 0.166);
    EAX_ENVIRONMENT_LIVINGROOM:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_LIVINGROOM, 0.208, 0.478, 0);
    EAX_ENVIRONMENT_STONEROOM:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_STONEROOM, 0.5, 2.309, 0.888);
    EAX_ENVIRONMENT_AUDITORIUM:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_AUDITORIUM, 0.403, 4.279, 0.5);
    EAX_ENVIRONMENT_CONCERTHALL:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_CONCERTHALL, 0.5, 3.961, 0.5);
    EAX_ENVIRONMENT_CAVE:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_CAVE, 0.5, 2.886, 1.304);
    EAX_ENVIRONMENT_ARENA:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_ARENA, 0.361, 7.284, 0.332);
    EAX_ENVIRONMENT_HANGAR:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_HANGAR, 0.5, 10.0, 0.3);
    EAX_ENVIRONMENT_CARPETEDHALLWAY:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_CARPETEDHALLWAY, 0.153, 0.259, 2.0);
    EAX_ENVIRONMENT_HALLWAY:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_HALLWAY, 0.361, 1.493, 0);
    EAX_ENVIRONMENT_STONECORRIDOR:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_STONECORRIDOR, 0.444, 2.697, 0.638);
    EAX_ENVIRONMENT_ALLEY:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_ALLEY, 0.25, 1.752, 0.776);
    EAX_ENVIRONMENT_FOREST:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_FOREST, 0.111, 3.145, 0.472);
    EAX_ENVIRONMENT_CITY:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_CITY, 0.111, 2.767, 0.224);
    EAX_ENVIRONMENT_MOUNTAINS:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_MOUNTAINS, 0.194, 7.841, 0.472);
    EAX_ENVIRONMENT_QUARRY:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_QUARRY, 1, 1.499, 0.5);
    EAX_ENVIRONMENT_PLAIN:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_PLAIN, 0.097, 2.767, 0.224);
    EAX_ENVIRONMENT_PARKINGLOT:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_PARKINGLOT, 0.208, 1.652, 1.5);
    EAX_ENVIRONMENT_SEWERPIPE:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_SEWERPIPE, 0.652, 2.886, 0.25);
    EAX_ENVIRONMENT_UNDERWATER:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_UNDERWATER, 1, 1.499, 0);
    EAX_ENVIRONMENT_DRUGGED:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_DRUGGED, 0.875, 8.392, 1.388);
    EAX_ENVIRONMENT_DIZZY:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_DIZZY, 0.139, 17.234, 0.666);
    EAX_ENVIRONMENT_PSYCHOTIC:
      Result := BASS_SetEAXParameters(EAX_ENVIRONMENT_PSYCHOTIC, 0.486, 7.563, 0.806);
  else
    Result := FALSE;
  end;
end;

initialization
  begin
    BASS_SetConfig := BassDLL.FindExport('BASS_SetConfig');
    BASS_GetConfig := BassDLL.FindExport('BASS_GetConfig');
    BASS_SetConfigPtr := BassDLL.FindExport('BASS_SetConfigPtr');
    BASS_GetConfigPtr := BassDLL.FindExport('BASS_GetConfigPtr');
    BASS_GetVersion := BassDLL.FindExport('BASS_GetVersion');
    BASS_ErrorGetCode := BassDLL.FindExport('BASS_ErrorGetCode');
    BASS_GetDeviceInfo := BassDLL.FindExport('BASS_GetDeviceInfo');
    BASS_Init := BassDLL.FindExport('BASS_Init');
    BASS_SetDevice := BassDLL.FindExport('BASS_SetDevice');
    BASS_GetDevice := BassDLL.FindExport('BASS_GetDevice');
    BASS_Free := BassDLL.FindExport('BASS_Free');
    BASS_GetDSoundObject := BassDLL.FindExport('BASS_GetDSoundObject');
    BASS_GetInfo := BassDLL.FindExport('BASS_GetInfo');
    BASS_Update := BassDLL.FindExport('BASS_Update');
    BASS_GetCPU := BassDLL.FindExport('BASS_GetCPU');
    BASS_Start := BassDLL.FindExport('BASS_Start');
    BASS_Stop := BassDLL.FindExport('BASS_Stop');
    BASS_Pause := BassDLL.FindExport('BASS_Pause');
    BASS_SetVolume := BassDLL.FindExport('BASS_SetVolume');
    BASS_GetVolume := BassDLL.FindExport('BASS_GetVolume');

    BASS_PluginLoad := BassDLL.FindExport('BASS_PluginLoad');
    BASS_PluginFree := BassDLL.FindExport('BASS_PluginFree');
    BASS_PluginGetInfo := BassDLL.FindExport('BASS_PluginGetInfo');

    BASS_Set3DFactors := BassDLL.FindExport('BASS_Set3DFactors');
    BASS_Get3DFactors := BassDLL.FindExport('BASS_Get3DFactors');
    BASS_Set3DPosition := BassDLL.FindExport('BASS_Set3DPosition');
    BASS_Get3DPosition := BassDLL.FindExport('BASS_Get3DPosition');
    BASS_Apply3D := BassDLL.FindExport('BASS_Apply3D');
    BASS_SetEAXParameters := BassDLL.FindExport('BASS_SetEAXParameters');
    BASS_GetEAXParameters := BassDLL.FindExport('BASS_GetEAXParameters');

    BASS_MusicLoad := BassDLL.FindExport('BASS_MusicLoad');
    BASS_MusicFree := BassDLL.FindExport('BASS_MusicFree');

    BASS_SampleLoad := BassDLL.FindExport('BASS_SampleLoad');
    BASS_SampleCreate := BassDLL.FindExport('BASS_SampleCreate');
    BASS_SampleFree := BassDLL.FindExport('BASS_SampleFree');
    BASS_SampleSetData := BassDLL.FindExport('BASS_SampleSetData');
    BASS_SampleGetData := BassDLL.FindExport('BASS_SampleGetData');
    BASS_SampleGetInfo := BassDLL.FindExport('BASS_SampleGetInfo');
    BASS_SampleSetInfo := BassDLL.FindExport('BASS_SampleSetInfo');
    BASS_SampleGetChannel := BassDLL.FindExport('BASS_SampleGetChannel');
    BASS_SampleGetChannels := BassDLL.FindExport('BASS_SampleGetChannels');
    BASS_SampleStop := BassDLL.FindExport('BASS_SampleStop');

    BASS_StreamCreate := BassDLL.FindExport('BASS_StreamCreate');
    BASS_StreamCreateFile := BassDLL.FindExport('BASS_StreamCreateFile');
    BASS_StreamCreateURL := BassDLL.FindExport('BASS_StreamCreateURL');
    BASS_StreamCreateFileUser := BassDLL.FindExport('BASS_StreamCreateFileUser');
    BASS_StreamFree := BassDLL.FindExport('BASS_StreamFree');
    BASS_StreamGetFilePosition := BassDLL.FindExport('BASS_StreamGetFilePosition');
    BASS_StreamPutData := BassDLL.FindExport('BASS_StreamPutData');
    BASS_StreamPutFileData := BassDLL.FindExport('BASS_StreamPutFileData');

    BASS_RecordGetDeviceInfo := BassDLL.FindExport('BASS_RecordGetDeviceInfo');
    BASS_RecordInit := BassDLL.FindExport('BASS_RecordInit');
    BASS_RecordSetDevice := BassDLL.FindExport('BASS_RecordSetDevice');
    BASS_RecordGetDevice := BassDLL.FindExport('BASS_RecordGetDevice');
    BASS_RecordFree := BassDLL.FindExport('BASS_RecordFree');
    BASS_RecordGetInfo := BassDLL.FindExport('BASS_RecordGetInfo');
    BASS_RecordGetInputName := BassDLL.FindExport('BASS_RecordGetInputName');
    BASS_RecordSetInput := BassDLL.FindExport('BASS_RecordSetInput');
    BASS_RecordGetInput := BassDLL.FindExport('BASS_RecordGetInput');
    BASS_RecordStart := BassDLL.FindExport('BASS_RecordStart');

    BASS_ChannelBytes2Seconds := BassDLL.FindExport('BASS_ChannelBytes2Seconds');
    BASS_ChannelSeconds2Bytes := BassDLL.FindExport('BASS_ChannelSeconds2Bytes');
    BASS_ChannelGetDevice := BassDLL.FindExport('BASS_ChannelGetDevice');
    BASS_ChannelSetDevice := BassDLL.FindExport('BASS_ChannelSetDevice');
    BASS_ChannelIsActive := BassDLL.FindExport('BASS_ChannelIsActive');
    BASS_ChannelGetInfo := BassDLL.FindExport('BASS_ChannelGetInfo');
    BASS_ChannelGetTags := BassDLL.FindExport('BASS_ChannelGetTags');
    BASS_ChannelFlags := BassDLL.FindExport('BASS_ChannelFlags');
    BASS_ChannelUpdate := BassDLL.FindExport('BASS_ChannelUpdate');
    BASS_ChannelLock := BassDLL.FindExport('BASS_ChannelLock');
    BASS_ChannelPlay := BassDLL.FindExport('BASS_ChannelPlay');
    BASS_ChannelStop := BassDLL.FindExport('BASS_ChannelStop');
    BASS_ChannelPause := BassDLL.FindExport('BASS_ChannelPause');
    BASS_ChannelSetAttribute := BassDLL.FindExport('BASS_ChannelSetAttribute');
    BASS_ChannelGetAttribute := BassDLL.FindExport('BASS_ChannelGetAttribute');
    BASS_ChannelSlideAttribute := BassDLL.FindExport('BASS_ChannelSlideAttribute');
    BASS_ChannelIsSliding := BassDLL.FindExport('BASS_ChannelIsSliding');
    BASS_ChannelSet3DAttributes := BassDLL.FindExport('BASS_ChannelSet3DAttributes');
    BASS_ChannelGet3DAttributes := BassDLL.FindExport('BASS_ChannelGet3DAttributes');
    BASS_ChannelSet3DPosition := BassDLL.FindExport('BASS_ChannelSet3DPosition');
    BASS_ChannelGet3DPosition := BassDLL.FindExport('BASS_ChannelGet3DPosition');
    BASS_ChannelGetLength := BassDLL.FindExport('BASS_ChannelGetLength');
    BASS_ChannelSetPosition := BassDLL.FindExport('BASS_ChannelSetPosition');
    BASS_ChannelGetPosition := BassDLL.FindExport('BASS_ChannelGetPosition');
    BASS_ChannelGetLevel := BassDLL.FindExport('BASS_ChannelGetLevel');
    BASS_ChannelGetData := BassDLL.FindExport('BASS_ChannelGetData');
    BASS_ChannelSetSync := BassDLL.FindExport('BASS_ChannelSetSync');
    BASS_ChannelRemoveSync := BassDLL.FindExport('BASS_ChannelRemoveSync');
    BASS_ChannelSetDSP := BassDLL.FindExport('BASS_ChannelSetDSP');
    BASS_ChannelRemoveDSP := BassDLL.FindExport('BASS_ChannelRemoveDSP');
    BASS_ChannelSetLink := BassDLL.FindExport('BASS_ChannelSetLink');
    BASS_ChannelRemoveLink := BassDLL.FindExport('BASS_ChannelRemoveLink');
    BASS_ChannelSetFX := BassDLL.FindExport('BASS_ChannelSetFX');
    BASS_ChannelRemoveFX := BassDLL.FindExport('BASS_ChannelRemoveFX');

    BASS_FXSetParameters := BassDLL.FindExport('BASS_FXSetParameters');
    BASS_FXGetParameters := BassDLL.FindExport('BASS_FXGetParameters');
    BASS_FXReset := BassDLL.FindExport('BASS_FXReset');

  end;

finalization
  begin

  end;

end.
// END OF FILE /////////////////////////////////////////////////////////////////

