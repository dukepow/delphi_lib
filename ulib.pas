{.$I ULIB.INC}
unit Ulib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes
  {$IFDEF INTERNETULIB}
  ,DB,  IdFTP,ScktComp, IdTCPClient,IdTCPConnection,DbiErrs,DBTables
  {$ENDIF}
  {$IFNDEF FMX}
  ,Dialogs, Forms, ExtCtrls, Activex, ComCtrls, ShlObj,
  Graphics, StrUtils, DateUtils,  Imm,  ShellAPI,
  urlMon,deskicon, mask, Registry, Controls, TlHelp32, JPEG, JvLabel
  {$ENDIF}
  ;

type
 TImeInputMode = ( imHangul, imEnglish );
 TColorConvertType = ( cctRGBtoBGR, cctBGRtoRGB );
 TCursorSave = class(TInterfacedObject)   //커서 바꾸기 사용법 IInterface 로 선언후 create 만하면됨
  private
    FCursor: TCursor;
  public
    constructor Create;
    destructor Destroy; override;
  end;
 TCompoDisable = class(TInterfacedObject)  //버튼 바꾸기 사용법 IInterface 로 선언후 create 만하면됨
    //bbb : IInterface;
    //    begin
    //  bbb := TCompoDisable.create(XiButton4);
   private
    FOwner : TControl;
   public
    constructor Create(AOwner: TControl);
    destructor Destroy; override;
 end;
 TCompoVisible = class(TInterfacedObject)  //버튼 바꾸기 사용법 IInterface 로 선언후 create 만하면됨
    //bbb : IInterface;
    //    begin
    //  bbb := TCompoDisable.create(XiButton4);
   private
    FOwner : TControl;
   public
    constructor Create(AOwner: TControl);
    destructor Destroy; override;
 end;

 TTimerDisable = class(TInterfacedObject)  //타이머 디스에이블 사용법 IInterface 로 선언후 create 만하면됨
    //bbb : IInterface;
    //    begin
    //  bbb := TTimerDisable.create(timer);
   private
    FOwner : TTimer;
   public
    constructor Create(AOwner: TTimer);
    destructor Destroy; override;
 end;

 TTGFileInfo = record
  Name : String;
  Size : int64;
  Path : String;
  ext : String;
  Date : TDateTime;
  isFolder : boolean;
  constructor Create(const AFileName : String);
  function FormatByteSize : String;
 end;

 TWindowsEdition =
   (weUnknown = 0, weWinXPHome = 1, weWinXPPro, weWinXPHomeN, weWinXPProN, weWinXPHomeK,
    weWinXPProK, weWinXPHomeKN, weWinXPProKN, weWinXPStarter, weWinXPMediaCenter,
    weWinXPTablet, weWinVistaStarter = 101, weWinVistaHomeBasic, weWinVistaHomeBasicN,
    weWinVistaHomePremium, weWinVistaBusiness, weWinVistaBusinessN,
    weWinVistaEnterprise, weWinVistaUltimate, weWin7Starter, weWin7HomeBasic,
    weWin7HomePremium, weWin7Professional, weWin7Enterprise, weWin7Ultimate,
    weWin10Starter, weWin10HomeBasic,
    weWin10HomePremium, weWin10Professional, weWin10Enterprise, weWin10Ultimate,
    weWin2008R2Enterprise, weWin2008R2Datacenter, weWin2008R2Standard,
    weWin2008R2Itanium, weWin2008R2Web, weWin2008R2Foundation, weWin2008R2HPC,
    weWin8, weWin8Pro, weWin8Enterprise, weWin8Ultimate, weWin8RT);

  TUJLib = class
    OrderID : String;
    function GetVersionInfo(AIdent: String): String;
    function GetApplicationVersion: String; {어플리케이션의 버젼 정보를 알수 있다}
    function CheckExtApplications(Ext : String) : TStringList;  {확장자와 연결된 어플이 있는지 확인후 어플이름들 반환}
    function CheckExtApplication(Ext : String; idx : integer = 0) : String;  {확장자와 연결된 어플이 있는지 확인후 어플이름 반환}
    function GetApplicationPath : String;    // 현재 경로를 반환
    procedure Delay(TickMilliTime : Int64);  //milisecond 만큼 대기한다.
    procedure ScreenShotRect(
       const ARect: TRect;              // 저장할 화면 영역
       AFileName: String;                 // 저장할 파일명
       ALayer: Boolean = False;      // 레이어 윈도 캡쳐 ( Win2000 이상)
       ACursor: Boolean = False;    // 영역내에 커서가 있는 경우 커서 그리기
       AQuality: Integer = 75);
    {$IFDEF INTERNETULIB}
    function GetOrderID(Sender:TDataSet): String;
    function GetDetailID(Sender:TdataSet; fieldname:string):string;
    function GetMemoryDataFile(dateandtime:TdateTime) : string;  {날짜를 이용하여 2004몇째주.mem 을 리턴}
    function ClearDataSet(Sender:TdataSet) : boolean; { 데이셋의 데이타를 모두 지워버린다 }
    function GetOrderField:TStringList;
    function GetClientField : TStringList;
    function GetUniqFileName(idf:TidFTP; filepath:String) : String;
    procedure MyException(Sender: TObject; E: Exception);
    {$ENDIF}
    function GetUniqUserKey : String; {무조건 유일키를 만들어 낸다}
    function GetUniqDayKey : String; {날짜로 유일키를 만들어 낸다}
    function GetExpireSerialNumber(yyyymmdd : string) : String;  //날짜를 가지고 복호화가능 시리얼만들기
    function GetSerialToExpire(key : String) : TDate;  //키를 가지고 날짜를 만들어냄
    function GetUniqLocalFileName(filepath: String): String;
    function GetUniqIndexFileName(filepn : String) : String;
    function CheckSerialNumber(SerialNumber: String): integer;  //시리얼의 인덱스 반환
    function GetSerialNumber(idx:int64; snSize: integer): String; overload;   //시리얼 반환
    function GetSerialNumber(idx, snSize: integer): String; overload;  //시리얼 반환
    function GetUniqMilisecondKey: String;  {17시간로 생긴 유일키 만들기 }
    function GetUniqMilisecondRandKey: String; {18시간로 생긴 유일키 만들기 }

    function GetUniqDateRandKey(incSec : int64): String;  //필요시간까지 유효한 날짜키
    function CheckUniqDateRandKey(key: String) : TDateTime; overload;
    function CheckUniqDateRandKey(key: String; expSecond : Int64 ) : boolean; overload;

    function GetDiskFreeSize(Diskname : String) : Int64;  {디스트 남은 용량 }
    procedure FlashTaskBarWindow; {태스크바에 있는 윈도우를 깜박거리게 한다 }
    procedure ShowPress;
    procedure HidePress;
    procedure FTimerTimer(Sender: TObject);

    function StringPop(srcstr : String; popChar : String = '"') : string;  //popchar 사이에 있는 글자 리턴
    function explode(srcstr:String; exp:String; arrpos:integer; blankignore : boolean = false):String; //글자 쪼개기
    procedure explodeList(sepq: String; LineStr: String; var tmpList: TStringList);
    function explodeListFindAndValue(srcList : TStringList; FindKey : String; sepq : String) : String;
    function explodeCount(srcstr:String; exp:String; blankignore : boolean = false):integer;
    Function winexecAndWait32V2( FileName: String; Visibility: integer = SW_NORMAL;WaitPls : integer = 1): DWORD;
    function IsRunningProcessCount(const ProcFileName: String) : Integer;
    Function exec( FileName: String; strparam:String = ''; ShowMode : integer = SW_NORMAL) : DWORD;
    function BoolToStr(aValue: Boolean; const aYes: string = 'ON'; const aNo: string = 'OFF'): string; overload;
    function StrToBool(aStr: String; const aTrue1 : string = 'True'; const aTrue2 : string = 'ON'; const cass : boolean = false) : boolean; overload;
    function Str2Int( str:String): integer;
    function Str2Int64( str:String): int64;
    function Int2Str( int:Integer; size:integer = 0): String; overload;
    function Int2Str( int:Int64; size:integer = 0): String; overload;
    function Join(exp : String; strlist: TStringList): String; overload;
    function Join( str : String ) : String; overload;
    function LastPos(const Substr, str : string) : integer;
    function RemoveChar(sSrc: string; CharList: String = '~`!@#$%^&*()-+|\/<>{}'): string;  //특수문자 제거
    procedure StringListAdd(list: TStringList; const str : string); //stringlist에 중복 방지하여 add
    function TimedMessageBox(ptszMessage: LPCTSTR; flags: UINT = 0; dwTimeout: DWORD = 3000): Integer;
    procedure OnlyOneExec(str: PChar; showerrm : boolean = true; msg : String = '');
    PROCEDURE CritErrorsOff;  {치명적인 오류메세지 죽이기 }
    PROCEDURE CritErrorsOn;   {치명적인 오류메세지 죽이기 }
    function unix2date( unixstr : String ) : TDateTime;
    function date2unix( datetime : TDateTime ) : String;
    function GetDayInterval(FromDate, ToDate : TDateTime) : integer; //두 날짜 사이의 일수 구하기
    function Str2DateTime(Date : String) : TDateTime;  //yyyy-mm-dd hh:ss:nn
    function GetImeInputMode(const AHandle: THandle): TImeInputMode;
    procedure SetImeInputMode(const AHandle: THandle; const Value: TImeInputMode);
    function MyHDD : String;
    function PayStrToInt(stString : String) : int64;
    function IntToPayStr(itNumber : int64) : String;
    function StrAlign(srcStr : String; ASize, AAlign : integer) : String;
    function WindowsDirFixup(APath:String):String;

    function CRC32ChecksumOfFile(Filename:string): Integer;  {CRC 체크하는 함수 첫부분하고 마지막 부분만 체크해서 뽑는다}

    function UpDateParam(opt : String) : String;   //해당 파라메터의 값을 반환

    function UpDateApplicationComplete(Sender: TObject): boolean;
    function GetHexToInt(inChar: Char): Integer;
    function MySystemShutdown(Bootchk : boolean) : boolean;
    function getByteView(byte: int64): String;  {파일사이즈를 출력해준다}
    procedure FindFileName(const FolderName: String; subdir: boolean; mask: string; //디렉에 파일 찾기 이름만
      maskoption: boolean; var retval: tstringlist; detailbool : boolean = false; onlydirbool : boolean = false; systemfile : boolean = true);
    procedure FindFilePath(const FolderName: String; subdir: boolean; mask: string; //디렉에 파일 찾기
      maskoption: boolean; var retval: tstringlist; detailbool : boolean = false; onlydirbool : boolean = false; systemfile : boolean = true);
    procedure FindOldFile(const FolderName:String; var retval : TstringList; day : TDateTime);  //findfile이용 day이전 파일 리스트
    function  GenKeyForCase(CaseValue : String; const RandomKey : Word = 0) : Cardinal;
    function GetMousePointControl(pt : TPoint) : String;
    function GetFileSize(FileName : String) : Int64;  //파일 사이즈
    function GetHardDiskPartitionType(const DriveLetter: Char): string;  //파티션타입 fat32
    function LinuxDirFixup(APath: String): String;
    function GetUserPath(AHandle : THandle) : String;  {사용자의 내문서  }
    function EncodeURIComponent(const InputStr: string; const bQueryStr: Boolean): string; //자바스크립트랑은 다름
    function DecodeURIComponent(const Code: string): string;  //자바스크립트랑은 다름
    function ColorConvert(src : String; format : TColorConvertType = cctRGBtoBGR) : String;
    procedure Wait(timeout_milli: integer);

    {엔코드 관련}
    function UrlEncodeToA(const S : String; DstCodePage: LongWord = CP_UTF8) : AnsiString;

    {화면 폰트 관련}
    function CalcFontSize(obj : TJvLabel; nWidth, nHeight : Integer; sText : string): Integer;
  private
    function RunasAdmin(AFileName: PChar; AParam: PChar = nil; ShowMode : integer = SW_SHOWNORMAL) : integer;
    {선언부}
  public
    {선언부}
    procedure ExitProg(const msg : String = ''; timeout : DWORD = 3000);
    procedure ExceptionHandler(Sender: TObject; E: Exception);

  end;



var UJLib: TUJLib;
FPress:TForm;
FTimer:TTimer;
TimerInc:integer;
SavedErrorMode  : Word;
SavedErrorModea  : Word;
SavedErrorModeb  : Word;
SavedErrorModec  : Word;
xprogmsg : String;              //프로그래스에 표기할 제목
rootPath : String;
windowPath : String;   //윈도우 디렉
desktopPath : String;   //바탕화면 디렉
documentPath : String;  //도큐먼트 디렉
programfilesPath : String;  //프로그램 파일즈 경로
WindowEdition : TWindowsEdition;  //윈도우 에디션

const
  NUL                  = #00;
  CR                   = #13;
  LF                   = #10;
  CRLF                 = CR+LF;
  LFCR                 = LF+CR;
  EOM                  = CR+LF+'.'+CR+LF;
  CETX                 = #03;
  CENQ                 = #05;
  CACK                 = #06;
  CNAK                 = #21;
  LineEnding = #13#10;

  cAT                  = '@';
  cOK                  = 'OK';
  CONSTSL : String = '|_#%#_|';
  CONSTSP : String = '|_|%|_|';
  CONSTSS : String = '|+#|';
  SLICEUNITSIZE : Int64 = 524288;

procedure MessageBoxTimerProc(hWnd: HWND; uMsg: UINT; idEvent: UINT; Time: DWORD); stdcall;
function MinDeleteDir(const DirName : string; const UseRecycleBin: Boolean): Boolean;
procedure DeleteDirectory(const Name: string);  //파일 지우기
function SubTrim(Value : String; StrSize : Integer):String; //글자들을 원하는 사이즈로 나누기  구분 없고 ... 붙임
function SubCutAnsiString(Value : String; StrSize : Integer) : String;  //글자를 원하는 사이즈로 구분 crlf넣어서 자름
function HalfTrim(Value : String):String; //글자들을 무조건 반으로 나누기  중간에 crlf
function GetPositionOfNthOccurence(sSubStr, sStr: string; iNth: integer): integer;  //원하는 Inth 개의 위치 찾기
function CRC16(CRC: Word; Data: Pointer; DataSize: LongWord): Word; assembler;
function SwapEndian32(Value: integer): integer; register;  //32bit big endian  <--> little endian
function SwapEndian16(Value: smallint): smallint; register;  //16bit big endian  <--> little endian

implementation


function SwapEndian32(Value: integer): integer; register;
asm
  bswap eax
end;

function SwapEndian16(Value: smallint): smallint; register;
asm
  rol   ax, 8
end;
{-------------------------------------------------------------------------------}
{ crc16 mobius 는 crc 초기값이 $FFFF 출력은 라디안으로 }
{crc := $FFFF;
  crc := ulib.CRC16(crc,PansiChar(#01 + #04 + #00 + #00 + #00 + #02), 6);
  $CB71  나옴
  }
function CRC16(CRC: Word; Data: Pointer; DataSize: LongWord): Word; assembler;
asm
         AND    EDX,EDX
         JZ     @Exit
         AND    ECX,ECX
         JLE    @Exit
         PUSH   EBX
         PUSH   EDI
         XOR    EBX,EBX
         LEA    EDI,CS:[OFFSET @CRC16]
@Start:  MOV    BL,[EDX]
         XOR    BL,AL
         SHR    AX,8
         XOR    AX,[EDI + EBX * 2]
         INC    EDX
         DEC    ECX
         JNZ    @Start
         POP    EDI
         POP    EBX
@Exit:   RET
         NOP
@CRC16:  DW     00000h, 0C0C1h, 0C181h, 00140h, 0C301h, 003C0h, 00280h, 0C241h
         DW     0C601h, 006C0h, 00780h, 0C741h, 00500h, 0C5C1h, 0C481h, 00440h
         DW     0CC01h, 00CC0h, 00D80h, 0CD41h, 00F00h, 0CFC1h, 0CE81h, 00E40h
         DW     00A00h, 0CAC1h, 0CB81h, 00B40h, 0C901h, 009C0h, 00880h, 0C841h
         DW     0D801h, 018C0h, 01980h, 0D941h, 01B00h, 0DBC1h, 0DA81h, 01A40h
         DW     01E00h, 0DEC1h, 0DF81h, 01F40h, 0DD01h, 01DC0h, 01C80h, 0DC41h
         DW     01400h, 0D4C1h, 0D581h, 01540h, 0D701h, 017C0h, 01680h, 0D641h
         DW     0D201h, 012C0h, 01380h, 0D341h, 01100h, 0D1C1h, 0D081h, 01040h
         DW     0F001h, 030C0h, 03180h, 0F141h, 03300h, 0F3C1h, 0F281h, 03240h
         DW     03600h, 0F6C1h, 0F781h, 03740h, 0F501h, 035C0h, 03480h, 0F441h
         DW     03C00h, 0FCC1h, 0FD81h, 03D40h, 0FF01h, 03FC0h, 03E80h, 0FE41h
         DW     0FA01h, 03AC0h, 03B80h, 0FB41h, 03900h, 0F9C1h, 0F881h, 03840h
         DW     02800h, 0E8C1h, 0E981h, 02940h, 0EB01h, 02BC0h, 02A80h, 0EA41h
         DW     0EE01h, 02EC0h, 02F80h, 0EF41h, 02D00h, 0EDC1h, 0EC81h, 02C40h
         DW     0E401h, 024C0h, 02580h, 0E541h, 02700h, 0E7C1h, 0E681h, 02640h
         DW     02200h, 0E2C1h, 0E381h, 02340h, 0E101h, 021C0h, 02080h, 0E041h
         DW     0A001h, 060C0h, 06180h, 0A141h, 06300h, 0A3C1h, 0A281h, 06240h
         DW     06600h, 0A6C1h, 0A781h, 06740h, 0A501h, 065C0h, 06480h, 0A441h
         DW     06C00h, 0ACC1h, 0AD81h, 06D40h, 0AF01h, 06FC0h, 06E80h, 0AE41h
         DW     0AA01h, 06AC0h, 06B80h, 0AB41h, 06900h, 0A9C1h, 0A881h, 06840h
         DW     07800h, 0B8C1h, 0B981h, 07940h, 0BB01h, 07BC0h, 07A80h, 0BA41h
         DW     0BE01h, 07EC0h, 07F80h, 0BF41h, 07D00h, 0BDC1h, 0BC81h, 07C40h
         DW     0B401h, 074C0h, 07580h, 0B541h, 07700h, 0B7C1h, 0B681h, 07640h
         DW     07200h, 0B2C1h, 0B381h, 07340h, 0B101h, 071C0h, 07080h, 0B041h
         DW     05000h, 090C1h, 09181h, 05140h, 09301h, 053C0h, 05280h, 09241h
         DW     09601h, 056C0h, 05780h, 09741h, 05500h, 095C1h, 09481h, 05440h
         DW     09C01h, 05CC0h, 05D80h, 09D41h, 05F00h, 09FC1h, 09E81h, 05E40h
         DW     05A00h, 09AC1h, 09B81h, 05B40h, 09901h, 059C0h, 05880h, 09841h
         DW     08801h, 048C0h, 04980h, 08941h, 04B00h, 08BC1h, 08A81h, 04A40h
         DW     04E00h, 08EC1h, 08F81h, 04F40h, 08D01h, 04DC0h, 04C80h, 08C41h
         DW     04400h, 084C1h, 08581h, 04540h, 08701h, 047C0h, 04680h, 08641h
         DW     08201h, 042C0h, 04380h, 08341h, 04100h, 081C1h, 08081h, 04040h
end;


function GetStringFromRegistry( sKey, sItem, sDefVal : string ) : string;
var
reg : TRegIniFile;
begin
   reg := TRegIniFile.Create;
   reg.RootKey := HKEY_LOCAL_MACHINE;
   reg.OpenKey(sKey,false);
   Result := reg.ReadString('', sItem, sDefVal );
   reg.Free;
end;

procedure SaveStringToRegistry( sKey, sItem, sVal : string );
var
reg : TRegIniFile;
begin
reg := TRegIniFile.Create( sKey );
reg.WriteString('', sItem, sVal + #0 );
reg.Free;
end;

function GetWindowsEdition: TWindowsEdition;
const
  ProductName = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion';
var
  Edition: string;
begin
  Result := weUnknown;
  Edition := GetStringFromRegistry(ProductName,'ProductName','');
  if (pos('Windows XP', Edition) = 1) then
  begin
   // Windows XP Editions
   if (pos('Home Edition N', Edition) > 0) then
      Result :=  weWinXPHomeN
   else
   if (pos('Professional N', Edition) > 0) then
      Result :=  weWinXPProN
   else
   if (pos('Home Edition K', Edition) > 0) then
      Result :=  weWinXPHomeK
   else
   if (pos('Professional K', Edition) > 0) then
      Result :=  weWinXPProK
   else
   if (pos('Home Edition KN', Edition) > 0) then
      Result :=  weWinXPHomeKN
   else
   if (pos('Professional KN', Edition) > 0) then
      Result :=  weWinXPProKN
   else
   if (pos('Home', Edition) > 0) then
      Result :=  weWinXPHome
   else
   if (pos('Professional', Edition) > 0) then
      Result :=  weWinXPPro
   else
   if (pos('Starter', Edition) > 0) then
      Result :=  weWinXPStarter
   else
   if (pos('Media Center', Edition) > 0) then
      Result :=  weWinXPMediaCenter
   else
   if (pos('Tablet', Edition) > 0) then
      Result :=  weWinXPTablet;
  end
  else
  if (pos('Windows Vista', Edition) = 1) then
  begin
   // Windows Vista Editions
   if (pos('Starter', Edition) > 0) then
      Result := weWinVistaStarter
   else
   if (pos('Home Basic N', Edition) > 0) then
      Result := weWinVistaHomeBasicN
   else
   if (pos('Home Basic', Edition) > 0) then
      Result := weWinVistaHomeBasic
   else
   if (pos('Home Premium', Edition) > 0) then
      Result := weWinVistaHomePremium
   else
   if (pos('Business N', Edition) > 0) then
      Result := weWinVistaBusinessN
   else
   if (pos('Business', Edition) > 0) then
      Result := weWinVistaBusiness
   else
   if (pos('Enterprise', Edition) > 0) then
      Result := weWinVistaEnterprise
   else
   if (pos('Ultimate', Edition) > 0) then
      Result := weWinVistaUltimate;
  end
  else
  if (pos('Windows 7', Edition) = 1) then
  begin
   // Windows 7 Editions
   if (pos('Starter', Edition) > 0) then
      Result := weWin7Starter
   else
   if (pos('Home Basic', Edition) > 0) then
      Result := weWin7HomeBasic
   else
   if (pos('Home Premium', Edition) > 0) then
      Result := weWin7HomePremium
   else
   if (pos('Professional', Edition) > 0) then
      Result := weWin7Professional
   else
   if (pos('Enterprise', Edition) > 0) then
      Result := weWin7Enterprise
   else
   if (pos('Ultimate', Edition) > 0) then
      Result := weWin7Ultimate;
  end
  else
  if (pos('Windows 10', Edition) = 1) then
  begin
   // Windows 10 Editions
   if (pos('Starter', Edition) > 0) then
      Result := weWin10Starter
   else
   if (pos('Home', Edition) > 0) then
      Result := weWin10HomeBasic
   else
   if (pos('Home Premium', Edition) > 0) then
      Result := weWin10HomePremium
   else
   if (pos('Pro', Edition) > 0) then
      Result := weWin10Professional
   else
   if (pos('Enterprise', Edition) > 0) then
      Result := weWin10Enterprise
   else
   if (pos('Ultimate', Edition) > 0) then
      Result := weWin10Ultimate;
  end
  else
  if (pos('Windows 8', Edition) = 1) then
  begin
   // Windows 8 Editions
   if (pos('Pro', Edition) > 0) then
      Result := weWin8Pro
   else
   if (pos('Enterprise', Edition) > 0) then
      Result := weWin8Enterprise
   else
   if (pos('Ultimate', Edition) > 0) then
      Result := weWin8Ultimate
   else
      Result := weWin8;
  end
  else
  if (pos('2008', Edition) > 0) then
  begin
    // Windows 2008 Editions
   if (pos('Web', Edition) > 0) then
      Result := weWin2008R2Web
   else
   if (pos('Enterprise', Edition) > 0) then
      Result := weWin2008R2Enterprise
   else
   if (pos('Standard', Edition) > 0) then
      Result := weWin2008R2Standard
   else
   if (pos('HPC', Edition) > 0) then
      Result := weWin2008R2HPC
   else
   if (pos('Itanium', Edition) > 0) then
      Result := weWin2008R2Itanium
   else
   if (pos('Foundation', Edition) > 0) then
      Result := weWin2008R2Foundation
   else
      Result := weWin2008R2Datacenter;
  end
  else
  if (pos('Windows RT', Edition) = 1) then
    Result := weWin8RT;

  if Result = weUnknown then
    Result := weWin10HomeBasic;
end;

function HalfTrim(Value : String):String; //글자들을 무조건 반으로 나누기
var
  iLen : Integer;
  iMid : Integer;
begin
  Result := '';
  iMid := Trunc(Length(Value) / 2);
  if ByteType(Value, iMid) = mbTrailByte then
  begin
    Inc(iMid);
  end;
  Result := Copy(Value, 1, iMid - 1) + #13#10 + Copy(Value, iMid, MAXINT);
end;

function SubTrim(Value : String; StrSize : Integer):String; //글자들을 원하는 사이즈로 나누기
var
  iLen : Integer;
  iLEnd,iMid : Integer;
begin
  if (StrSize < 10) or (Length(Value) < StrSize) then
  begin
    Result := Value;
    exit;
  end;
  Result := '';
  iLEnd := Trunc(StrSize / 2);
  if ByteType(Value, iLEnd) = mbTrailByte then
  begin
    Dec(iLEnd);
  end;
  iMid := Length(Value) - iLend;
  if ByteType(Value, iMid) = mbTrailByte then
  begin
    Inc(iMid);
  end;

  Result := Copy(Value, 1, iLEnd - 1) + '...' + Copy(Value, iMid, MAXINT);
end;

function SubCutAnsiString(Value : String; StrSize : Integer) : String;   //한글은 2바이트로 계산 함 즉 10이면 한글은 5글자
var
  iLen : Integer;
  iLEnd,iMid : Integer;
  va : AnsiString;
begin
  if (Length(AnsiString(Value)) < StrSize) then
  begin
    Result := Value;
    exit;
  end;
  Result := '';
  va := AnsiString(value);

    //한글이 들었다
    while true do
    begin
      iLEnd := StrSize;
      if ByteType(va, iLEnd) = mbLeadByte then
      begin
        Dec(iLEnd);
      end;
      Result := Result + copy(AnsiString(va),1,iLEnd);
      Delete(AnsiString(va),1,iLEnd);
      if Length(va) < StrSize then
      begin
        Result := Result + #13#10 + va;
        break;
      end;
      Result := Result + #13#10;
    end;

end;

function GetPositionOfNthOccurence(sSubStr, sStr: string; iNth: integer): integer;
var
  sTempStr: string;
  iIteration: integer;
  iTempPos: integer;
  iTempResult: integer;
begin
  result := 0;

  // validate input parameters
  if ((iNth < 1) or (sSubStr = '') or (sStr = '')) then exit;

  // evaluate
  iIteration := 0;
  iTempResult := 0;
  sTempStr := sStr;
  while (iIteration < iNth) do
  begin
    iTempPos := Pos(sSubStr, sTempStr);
    if (iTempPos = 0) then exit;
    iTempResult := iTempResult + iTempPos;
    sTempStr := Copy(sStr, iTempResult + 1, Length(sStr) - iTempResult);
    inc(iIteration);
  end;
  result := iTempResult;
end;

function TUJLib.GetUniqDateRandKey(incSec : int64): String;  {21시간로 생긴 램덤키 만들기 ms 안씀}
var
  td : TDateTime;
  y,m,d,h,mm,s,ms : Word;
  yr, yv, hr, hv : integer;
  mr, mv, dr, dv : integer;
begin
  td := IncSecond(now,incSec);
  DecodeDateTime(td,y,m,d,h,mm,s,ms);
  Randomize;
  yr := Random(999);
  yv := y + yr;
  hr := Random(50);
  hv := h + hr;
  mr := Random(80);
  mv := m + mr;
  dr := Random(60);
  dv := d + dr;
  result :=  copy(int2str(hr,2),1,2) + copy(int2str(yv,4),1,4) + copy(int2str(mv,2),1,2) +
  copy(int2str(dr,2),1,2)
  + copy(int2str(dv,2),1,2) + copy(int2str(hv,2),1,2)
  + copy(int2str(mm,2),1,2) + copy(int2str(s,2),1,2)
  + copy(int2str(yr,3),1,3) + copy(int2str(mr,2),1,2)
  + int2str(Random(99),2);
end;

function TUJLib.CheckUniqDateRandKey(key: String): TDateTime;
var
  y,m,d,h,mm,s,ms : Word;
  yr, yv, hr, hv : integer;
  mr, mv, dr, dv : integer;
begin
  if Length(key) < 21 then exit(0);
  yr := strtoint(copy(key,19,3));
  yv := strtoint(copy(key,3,4)) - yr;
  mr := strtoint(copy(key,22,2));
  mv := strtoint(copy(key,7,2)) - mr;
  dr := strtoint(copy(key,9,2));
  dv := strtoint(copy(key,11,2)) - dr;
  hr := strtoint(copy(key,1,2));
  hv := strtoint(copy(key,13,2)) - hr;
  mm := strtoint(copy(key,15,2));
  s := strtoint(copy(key,17,2));
  ms := 0;
  Result := EncodeDateTime(yv,mv,dv,hv,mm,s,ms);
end;

function TUJLib.CheckUniqDateRandKey(key: String; expSecond: Int64): boolean;
begin
  result := false;
  if (IncSecond(CheckUniqDateRandKey(key),expSecond) > now) then
    exit(true);
end;

function  TUJLib.GenKeyForCase(CaseValue : String; const RandomKey : Word = 0) : Cardinal;
var
 I, Ln : Cardinal;
begin
 Result := 0;
 Ln := Length(CaseValue);
 if Ln<1 then Exit;
 for I:=1 to Ln
     do Result := Result + ((Ord(CaseValue[I]) xor (Randomkey * I))) shl ((I and 3) shl 3);
 Result := Result + 1;
end;

function TUJLib.GetHardDiskPartitionType(const DriveLetter: Char): string;
var
  NotUsed: DWORD;
  VolumeFlags: DWORD;
  VolumeInfo: array[0..MAX_PATH] of Char;
  VolumeSerialNumber: DWORD;
  PartitionType: array[0..32] of Char;
begin
  GetVolumeInformation(PChar(DriveLetter + ':\'),
    nil, SizeOf(VolumeInfo), @VolumeSerialNumber, NotUsed,
    VolumeFlags, PartitionType, 32);
  Result := PartitionType;
end;

Procedure TUJLib.Delay(TickMilliTime : Int64);
var
Past,Now: Int64;
begin
  Past := GetTickCount64;
  repeat
    Now := GetTickCount64;
    Application.ProcessMessages;
  Until Now > Past + TickMilliTime;
end;



procedure TUJLib.FindFilePath(const FolderName: String; subdir: boolean; mask: string;
  maskoption: boolean; var retval: tstringlist; detailbool : boolean = false; onlydirbool : boolean = false; systemfile : boolean = true);
var //폴더를 검색하는 함수인데 폴더네임만 주고 나머지 옵션들은 위에거 따르면 된다.
  //onlydirbool 을 사용하고 싶으면 subdir은 false여야한다
 SR : TSearchRec;
 slmask : tstringlist;
 tmpext : string;
 i : integer;
 rets: TStringList;
 FN : string;
 FS : string;  //찾는 파일
begin
  rets := TStringList.Create;
  rets.Clear;
  slmask := TStringList.Create;
  slmask.Clear;
  slmask.Delimiter := ';';
  slmask.DelimitedText := mask;
  slmask.Text := UpperCase(StringReplace(slmask.text, '*.', '.', [rfReplaceAll] ));
  if (mask = '*') or (mask = '') then
  begin
    maskoption := false;
    FS := '*';
  end else if slmask.Count = 1 then
  begin
    maskoption := false;
    FS := mask;
  end else
  begin
    FS := '*';
  end;

  FN := FolderName;

//  if FN[Length(FN)] <> '\' then FN := FN + '\';//AppendStr(FN, '\');

  FN := IncludeTrailingPathDelimiter(FN);

  if (findFirst(FN+FS,faAnyFile,Sr)) = 0 then
  repeat
    if not systemfile then
    begin
      if ((SR.Attr and faSysFile) = faSysFile) then continue;
    end;
    if (Sr.Name <> '.') and (Sr.Name <> '..') then
    begin
      if ((SR.Attr and faDirectory) = faDirectory ) and subdir then
      begin
        FindFilePath(FN +SR.Name, subdir, mask, maskoption, retval);
      end
      else if ((SR.Attr and faDirectory) = faDirectory )  and onlydirbool then
      begin
        rets.Add(FN + sr.Name);
      end
      else  if not ((SR.Attr and faDirectory) = faDirectory ) then
      begin
        if maskoption then
        begin
          tmpext := UpperCase(ExtractFileExt(sr.Name));
          if slmask.IndexOf(tmpext) <> -1 then
          begin
            if detailbool then
            begin
              rets.Add(FN + sr.Name
                + CONSTSL + int2str(sr.Size) + CONSTSL
                + FormatDateTime('yyyy-mm-dd hh:nn:ss',FileDateToDateTime(sr.Time))
                + CONSTSL + Int2Str(sr.Attr) );
            end else begin
              rets.Add(FN + sr.Name);
            end;
          end;
        end
        else
        begin
          if (not onlydirbool) then
          begin
            tmpext := UpperCase(ExtractFileExt(sr.Name));
            if detailbool then
            begin
              rets.Add(sr.Name
                + CONSTSL + int2str(sr.Size) + CONSTSL
                + FormatDateTime('yyyy-mm-dd hh:nn:ss',FileDateToDateTime(sr.Time))
                + CONSTSL + Int2Str(sr.Attr) );
            end else
              rets.Add(FN + sr.Name);
          end;
        end;
      end;
    end;
  until FindNext(Sr) <> 0;

  FindClose(Sr);
  for I := 0 to rets.Count - 1 do
  begin
    if trim(rets.Strings[i] ) <> '' then
      retval.Add( rets.Strings[i] );
  end;
  slmask.Free;
  rets.Free;
end;

procedure TUJLib.FindFileName(const FolderName: String; subdir: boolean; mask: string;
  maskoption: boolean; var retval: tstringlist; detailbool : boolean = false; onlydirbool : boolean = false; systemfile : boolean = true);
var
  I : integer;
begin
  FindFilePath(FolderName, subdir, mask, maskoption, retval, detailbool, onlydirbool, systemfile);
  if detailbool then
    exit;
  for I := 0 to retval.Count - 1 do
  begin
    retval.Strings[I] := ExtractFileName(retval.Strings[I]);
  end;
end;

procedure TUJLib.FindOldFile(const FolderName: String; var retval: TstringList;
  day: TDateTime);
var
  flist : TStringList;
  daytxt : String;
  I: Integer;
begin
  flist := TStringList.Create;
  ujlib.FindFilePath(FolderName,false,'',false,flist,true);
  for I := 0 to flist.Count - 1 do
  begin
    if explodeCount( flist.Strings[I], CONSTSL) < 3 then
      Continue;
    daytxt := explode(flist.Strings[I],CONSTSL,2);
    if StrToDateTime(daytxt) < day then
    begin
      retval.Add(IncludeTrailingPathDelimiter(FolderName) + explode(flist.Strings[I],CONSTSL,0));
    end;
  end;
  flist.Free;
end;

{-------------------------} //TODO: 예외처리 핸들러 {-----------------------------------}
procedure TUJLib.ExceptionHandler(Sender: TObject; E: Exception);
begin
	// 에러가 났을 때는 그냥 프로그램을 종료한다.
  ShowMessage('계속적인 에러가 발생시에는 21cbiz로 연락주십시오');
	PostMessage(Application.MainForm.Handle, WM_QUIT, 0, 0);
end;

{$IFDEF INTERNETULIB}
{-------------------------} //TODO: 예외처리 다른방법 {-----------------------------------}
procedure TUJLib.MyException(Sender:TObject;E:Exception);
var
  A:array[0..255] of char;
  S:String;
begin
  if E is EDBEngineError then
  begin
        MessageBeep(0);
        with E as EDBEngineError do
        case Errors[0].ErrorCode of
             DBIERR_KEYVIOL:
                TimedMessageBox('키값이 중복되었습니다.',0,1000);
             DBIERR_NOSUCHTABLE:
                TimedMessageBox('테이블이 존재하지 않습니다.',
                                       0,700);
             DBIERR_QBEFLDFOUND:
                TimedMessageBox('테이블에 해당 필드가 없습니다.',
                                       0,700);
             DBIERR_INVALIDKEYWORD:
                TimedMessageBox('예약어를 잘못 사용 했습니다. 구문이 맞나 확인하십시오.' ,0,700);
        else begin
             ShowMessage(IntToStr(Errors[0].ErrorCode));
             StrPCopy(A,E.Message);
             TimedMessageBox(A,0,700);
        end;
       end;
  end
  else if E is EDatabaseError then
  begin
        MessageBeep(0);
        TimedMessageBox('데이터베이스에서 에러 발생.',0,1000);
  end
  else if E is EDBEditError then
  begin
        MessageBeep(0);
        TimedMessageBox('입력 형식이 맞지 않습니다.',0,700);
  end
  else if (E is EDivByZero) or (E is EZeroDivide) then
  begin
        MessageBeep(0);
        TimedMessageBox('0으로 나눌 수 없습니다.',0,700);
  end
  else if E is ERangeError then
  begin
        MessageBeep(0);
        TimedMessageBox('범위를 초과햇습니다.',0,700);
  end
  else if (E is EIntOverflow) or (E is EOverflow) or (E is EUnderflow) then
  begin
        MessageBeep(0);
        TimedMessageBox('오브플로우가 발생했습니다.',0,700);
  end
  else if E is EInOutError then
  begin
        MessageBeep(0);
        with E as EInOutError do
        StrPCopy(A,E.Message);
        TimedMessageBox(A,0,700);
  end
  else if E is EInvalidCast then
  begin
        MessageBeep(0);
        TimedMessageBox('타입캐스트에서 에러가 발생했습니다.',0,700);
  end
  else if E is EConvertError then
  begin
        MessageBeep(0);
        StrPCopy(A,E.Message);
        TimedMessageBox(A,0,700);
  end
  else if E is EOutOfMemory then
  begin
        MessageBeep(0);
        TimedMessageBox('메모리가 부족합니다.',0,700);
  end
  else if E is EInvalidOp then
  begin
        MessageBeep(0);
        TimedMessageBox('부동소숫점 에러.',0,700);
  end
  else
  begin
     MessageBeep(0);
     StrPCopy(A,E.Message);
     TimedMessageBox(A,0,700);
  end;
end;
{$ENDIF}
{-------------------------} //TODO: 프로그램 강제 종료 {-----------------------------------}
procedure TUJLib.ExitProg(const msg : String = ''; timeout : DWORD = 3000);
var
  i : integer;
begin
  if msg <> '' then
  begin
    TimedMessageBox(PWideChar( msg ),0,timeout);
  end;
  for i := 0 to 1000 do sleep(1);
  PostMessage(Application.MainForm.Handle, WM_QUIT, 0, 0);
end;

{------------------------} //TODO: 어플리케이션 버젼정보 {-----------------------------}
//  Result := GetVersionInfo('FileDescription');
//  Result := GetVersionInfo('LegalCopyright');
//  Result := GetVersionInfo('DateOfRelease');
//  Result := GetVersionInfo('ProductVersion');
//  Result := GetVersionInfo('FileVersion');

function TUJLib.GetVersionInfo(AIdent: String): String;

type
  TLang = packed record
    Lng, Page: WORD;
  end;

  TLangs = array [0 .. 10000] of TLang;

  PLangs = ^TLangs;

var
  BLngs: PLangs;
  BLngsCnt: Cardinal;
  BLangId: String;
  RM: TMemoryStream;
  RS: TResourceStream;
  BP: PChar;
  BL: Cardinal;
  BId: String;

begin
  // Assume error
  Result := '';

  RM := TMemoryStream.Create;
  try
    // Load the version resource into memory
    RS := TResourceStream.CreateFromID(HInstance, 1, RT_VERSION);
    try
      RM.CopyFrom(RS, RS.Size);
    finally
      FreeAndNil(RS);
    end;

    // Extract the translations list
    if not VerQueryValue(RM.Memory, '\\VarFileInfo\\Translation', Pointer(BLngs), BL) then
      Exit; // Failed to parse the translations table
    BLngsCnt := BL div sizeof(TLang);
    if BLngsCnt <= 0 then
      Exit; // No translations available

    // Use the first translation from the table (in most cases will be OK)
    with BLngs[0] do
      BLangId := IntToHex(Lng, 4) + IntToHex(Page, 4);

    // Extract field by parameter
    BId := '\\StringFileInfo\\' + BLangId + '\\' + AIdent;
    if not VerQueryValue(RM.Memory, PChar(BId), Pointer(BP), BL) then
      Exit; // No such field

    // Prepare result
    Result := BP;
  finally
    FreeAndNil(RM);
  end;
end;

function TUJLib.GetApplicationVersion:string;
begin
  Result := GetVersionInfo('FileVersion');
end;

function TUJLib.GetApplicationPath : String;    // 현재 경로를 반환
begin
  Result := ExcludeTrailingBackslash( ExtractFilePath(ParamStr(0)) );
end;


function TUJLib.CheckExtApplication(Ext: String; idx : integer = 0): String;  {확장자와 연결된 어플이 있는지 확인후 어플이름 경로 반환}
var
  ck : TStringList;
begin
  ck := CheckExtApplications(Ext);
  if Assigned(ck) then
  begin
    if idx < ck.Count then
    begin
      Result := ck.Strings[idx];
    end else
    begin
      Result := ck.Strings[0];
    end;
  end else
  begin
    Result := '';
  end;
end;

function TUJLib.CheckExtApplications(Ext : String) : TStringList;
//컴퓨터\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.avi\OpenWithProgids
//컴퓨터\HKEY_LOCAL_MACHINE\SOFTWARE\Classes\PotPlayer64.AVI\shell\open\command 로 수정 필요
const
  EXT_KEY='Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\';
var
  Reg: TRegistry;
  FReg : TRegistry;
  i: Integer;
  sList: TStringList;
  cpt : string;
begin
  Result:=TStringlist.Create;

  Reg:=TRegistry.Create;
  FReg := TRegistry.Create;
  try
    Reg.RootKey:=HKEY_CURRENT_USER;
    FReg.RootKey := HKEY_LOCAL_MACHINE;
    // 키가 (읽을 수) 없다면 관둠
    if not Reg.OpenKeyReadOnly(EXT_KEY+'.'+ LowerCase(Ext) ) then Exit;

    // 만약 Application 이라는 값이 있다면 그 놈이 직빵 연결 프로그램
    if Reg.ValueExists('Application') then
      StringListAdd( Result, Reg.ReadString('Application'))
    // 없다면 OpenWithList 를 뒤짐
    else begin
      Reg.CloseKey;
      // 키가 (읽을 수) 없다면 관둠
      if not Reg.OpenKeyReadOnly(EXT_KEY+'.'+LowerCase(Ext)+ '\OpenWithProgids') then Exit;

      sList:=TStringList.Create;
      try
        Reg.GetValueNames(sList);
        for i:=sList.Count-1 downto 0 do begin
          cpt := copy( sList[i], ( sList[I].Length ) - (Ext.Length) + 1);
          if CompareText(cpt , Ext) = 0 then
          begin
            if not FReg.OpenKeyReadOnly('SOFTWARE\Classes\' + sList[i] + '\shell\open\command') then break;
            cpt := Freg.ReadString('');
            cpt := StringPop(cpt,'"');
            if FileExists(cpt) then
            begin
              StringListAdd(Result, cpt);
//              break;
            end;
          end;
        end;
      finally
        FreeAndNil(sList);
      end; // try..finally
    end; // if ValueExists
  finally
    FreeAndNil(Reg);
    FreeAndNil(FReg);
  end;
  if Result.Count = 0 then
    FreeAndNil(Result);
//출처: https://bloodguy.tistory.com/entry/확장자에-연결된-프로그램이-있는지-알아보는-함수 [Bloodguy]
end;

{------------------------} //TODO: 유일키를 만들어 준다 {-----------------------------}
function GUID2String(pGUID: TGUID) : string;
var
 nI: integer;
begin
 Result := IntToHex(pGUID.D1, 8) + 
           IntToHex(pGUID.D2, 4) + 
           IntToHex(pGUID.D3, 4);
 for nI := 0 to 7 do
   Result := Result + IntToHex(ord(pGUID.D4[nI]), 2);
end;

function GetGUIDString: string;
var
 pGUID: TGUID;
begin
 CoCreateGUID(pGUID);
 Result := GUID2String(pGUID);
end;

function TUJLib.GetUniqUserKey : String;
begin
  Result := GetGUIDString;
end;

function TUJLib.GetUserPath(AHandle : THandle): String;
var
  Allocator: IMalloc;
  SpecialDir: PItemIdList;
  FBuf: array[0..MAX_PATH] of Char;
  PerDir: string;
begin
  if SHGetMalloc(Allocator) = NOERROR then
  begin
    SHGetSpecialFolderLocation(AHandle, CSIDL_PERSONAL, SpecialDir);
    SHGetPathFromIDList(SpecialDir, @FBuf[0]);
    Allocator.Free(SpecialDir);
    Result := string(FBuf);
  end;
end;

function TUJLib.ColorConvert(src: String; format: TColorConvertType): String;
var
  tempstr : String;
begin
  tempstr := src;
  if format = cctRGBtoBGR then
  begin
    if tempstr[1] = '#' then
    begin
      Delete(tempstr,1,1);
    end;
    Result := '$' + copy(tempstr,5,2) + copy(tempstr,3,2) + copy(tempstr,1,2);
  end else if format = cctBGRtoRGB then
  begin
    if tempstr[1] = '$' then
    begin
      Delete(tempstr,1,1);
    end;
    Result := '#' + copy(tempstr,5,2) + copy(tempstr,3,2) + copy(tempstr,1,2);
  end;
end;

{------------------------ 파일의 crc 값을 뽑아낸다 앞에1개 뒤에 1개만뽑음 -----------------------------}

function TUJLib.CRC32ChecksumOfFile(Filename:string): Integer;
const
 READBUFFERSIZE = 4096;

const
 CRCSeed = $ffffffff;
 CRC32tab : Array[0..255] of DWord = (
     $00000000, $77073096, $ee0e612c, $990951ba, $076dc419, $706af48f,
     $e963a535, $9e6495a3, $0edb8832, $79dcb8a4, $e0d5e91e, $97d2d988,
     $09b64c2b, $7eb17cbd, $e7b82d07, $90bf1d91, $1db71064, $6ab020f2,
     $f3b97148, $84be41de, $1adad47d, $6ddde4eb, $f4d4b551, $83d385c7,
     $136c9856, $646ba8c0, $fd62f97a, $8a65c9ec, $14015c4f, $63066cd9,
     $fa0f3d63, $8d080df5, $3b6e20c8, $4c69105e, $d56041e4, $a2677172,
     $3c03e4d1, $4b04d447, $d20d85fd, $a50ab56b, $35b5a8fa, $42b2986c,
     $dbbbc9d6, $acbcf940, $32d86ce3, $45df5c75, $dcd60dcf, $abd13d59,
     $26d930ac, $51de003a, $c8d75180, $bfd06116, $21b4f4b5, $56b3c423,
     $cfba9599, $b8bda50f, $2802b89e, $5f058808, $c60cd9b2, $b10be924,
     $2f6f7c87, $58684c11, $c1611dab, $b6662d3d, $76dc4190, $01db7106,
     $98d220bc, $efd5102a, $71b18589, $06b6b51f, $9fbfe4a5, $e8b8d433,
     $7807c9a2, $0f00f934, $9609a88e, $e10e9818, $7f6a0dbb, $086d3d2d,
     $91646c97, $e6635c01, $6b6b51f4, $1c6c6162, $856530d8, $f262004e,
     $6c0695ed, $1b01a57b, $8208f4c1, $f50fc457, $65b0d9c6, $12b7e950,
     $8bbeb8ea, $fcb9887c, $62dd1ddf, $15da2d49, $8cd37cf3, $fbd44c65,
     $4db26158, $3ab551ce, $a3bc0074, $d4bb30e2, $4adfa541, $3dd895d7,
     $a4d1c46d, $d3d6f4fb, $4369e96a, $346ed9fc, $ad678846, $da60b8d0,
     $44042d73, $33031de5, $aa0a4c5f, $dd0d7cc9, $5005713c, $270241aa,
     $be0b1010, $c90c2086, $5768b525, $206f85b3, $b966d409, $ce61e49f,
     $5edef90e, $29d9c998, $b0d09822, $c7d7a8b4, $59b33d17, $2eb40d81,
     $b7bd5c3b, $c0ba6cad, $edb88320, $9abfb3b6, $03b6e20c, $74b1d29a,
     $ead54739, $9dd277af, $04db2615, $73dc1683, $e3630b12, $94643b84,
     $0d6d6a3e, $7a6a5aa8, $e40ecf0b, $9309ff9d, $0a00ae27, $7d079eb1,
     $f00f9344, $8708a3d2, $1e01f268, $6906c2fe, $f762575d, $806567cb,
     $196c3671, $6e6b06e7, $fed41b76, $89d32be0, $10da7a5a, $67dd4acc,
     $f9b9df6f, $8ebeeff9, $17b7be43, $60b08ed5, $d6d6a3e8, $a1d1937e,
     $38d8c2c4, $4fdff252, $d1bb67f1, $a6bc5767, $3fb506dd, $48b2364b,
     $d80d2bda, $af0a1b4c, $36034af6, $41047a60, $df60efc3, $a867df55,
     $316e8eef, $4669be79, $cb61b38c, $bc66831a, $256fd2a0, $5268e236,
     $cc0c7795, $bb0b4703, $220216b9, $5505262f, $c5ba3bbe, $b2bd0b28,
     $2bb45a92, $5cb36a04, $c2d7ffa7, $b5d0cf31, $2cd99e8b, $5bdeae1d,
     $9b64c2b0, $ec63f226, $756aa39c, $026d930a, $9c0906a9, $eb0e363f,
     $72076785, $05005713, $95bf4a82, $e2b87a14, $7bb12bae, $0cb61b38,
     $92d28e9b, $e5d5be0d, $7cdcefb7, $0bdbdf21, $86d3d2d4, $f1d4e242,
     $68ddb3f8, $1fda836e, $81be16cd, $f6b9265b, $6fb077e1, $18b74777,
     $88085ae6, $ff0f6a70, $66063bca, $11010b5c, $8f659eff, $f862ae69,
     $616bffd3, $166ccf45, $a00ae278, $d70dd2ee, $4e048354, $3903b3c2,
     $a7672661, $d06016f7, $4969474d, $3e6e77db, $aed16a4a, $d9d65adc,
     $40df0b66, $37d83bf0, $a9bcae53, $debb9ec5, $47b2cf7f, $30b5ffe9,
     $bdbdf21c, $cabac28a, $53b39330, $24b4a3a6, $bad03605, $cdd70693,
     $54de5729, $23d967bf, $b3667a2e, $c4614ab8, $5d681b02, $2a6f2b94,
     $b40bbe37, $c30c8ea1, $5a05df1b, $2d02ef8d  );
var
 fh: THandle;
 buf: array[0..READBUFFERSIZE-1] of Byte;
 NumRead,i,TmpRes : DWORD;
    function CRC32(value: Byte; crc: DWord) : DWord;
    begin
    Result := CRC32Tab[Byte(crc xor DWord(value))] xor
           ((crc shr 8) and $00ffffff);
    end;
    Function CRCend( crc : DWord ): DWord;
    begin
    CRCend := (crc xor CRCSeed);
    end;
begin
 TmpRes := CRCSeed;

 fh := CreateFile(pchar(FileName),GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,
   FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN,0);

 if fh > 0 then
 begin
     //첫부분 확인
     if ReadFile(fh,buf,READBUFFERSIZE,numread, nil) then
     begin
       for i := 1 to numread do
         TmpRes := TmpRes + CRC32(buf[i-1],TmpRes)
     end;
     //마지막 부분 확인
     fileseek(fh, -READBUFFERSIZE, 2);
     if ReadFile(fh,buf,READBUFFERSIZE,numread, nil) then
     begin
       for i := 1 to numread do
         TmpRes := TmpRes + CRC32(buf[i-1],TmpRes)
     end;

   CloseHandle(fh);
 end;

 TmpRes := CRCEnd(TmpRes);

 Result := Integer(TmpRes);

end;
{------------------------ 태스크바에 있는 윈도우를 깜빡거리게 한다  -----------------------------}
procedure TUJLib.FlashTaskBarWindow;
var
 a : FlashwInfo;
begin
   a.cbSize := SizeOf(a);
   a.hwnd := Application.Handle;
   a.dwFlags := FLASHW_ALL;
   a.uCount := 3;
   a.dwTimeout := 500;
   FlashWindowEx( a );
end;
{------------------------ 디스크 남은 용량  -----------------------------}
function TUJLib.GetDayInterval(FromDate, ToDate: TDateTime): integer;
var
   Ts1, Ts2 : Ttimestamp;
begin
   Ts1 := DateTimeToTimeStamp(FromDate);
   Ts2 := DateTimeToTimeStamp(ToDate);
   //# GetInterval := Ts2.Date - Ts1.Date;
   Result := TS2.Date - TS1.Date;
end;

function TUJLib.GetDiskFreeSize(Diskname : String) : Int64;
var
 FreeBytesAvailableToCaller,
 TotalNumberOfBytes,
 TotalNumberOfFreeBytes : TLargeInteger;
begin
    GetDiskFreeSpaceEx(
    PChar(Diskname),
    FreeBytesAvailableToCaller,
    TotalNumberOfBytes,
    @TotalNumberOfFreeBytes
    );
    Result := TotalNumberOfFreeBytes div 1024;
end;

//-- 파일 사이즈 구하기 #############################################
function TUJLib.GetFileSize(FileName: String): Int64;
var
  hh : TFileStream;
begin
  Result := 0;
  hh := TFileStream.Create(FileName,fmShareDenyRead);
  if assigned(hh) then
    Result := hh.Size;
  hh.Free;
end;

{$IFDEF INTERNETULIB}
{------------------------ 데이터셋의 모든 데이터를 지워버린다  -----------------------------}
function TUJLib.ClearDataSet(Sender : TdataSet) : boolean;
begin
    try
        while not Sender.Eof do
        begin
            Sender.First;
            Sender.Delete;
        end;
        Result := true;
    except
        Result := false;
    end;
end;

{------------------------ 날짜를 이용하여 해당주로 파일명을 만든다  -----------------------------}
function TUJLib.GetMemoryDataFile(dateandtime: TdateTime) : String;
var    str : string;
begin
    str := formatdatetime('yyyy',dateandtime);
    if (MonthOfTheYear(dateandtime) = 1) and (WeekOfTheYear(dateandtime) > 10) then
        Str := floattostr(YearOf(dateandtime) - 1)
    else if (MonthOfTheYear(dateandtime) = 12) and (WeekOfTheYear(dateandtime) = 1) then
        Str := floattostr(YearOf(dateandtime) + 1);
    Result := str +
    RightStr('00' + floattostr(WeekOfTheYear(dateandtime)),2);
end;

{$ENDIF}
{------------------------ 디렉토리 삭제하기  -----------------------------}

//-----------------------------------------------------------------
// 디렉토리 및 파일을 지운다.
// 하위 디렉토리와 모든 파일도 함께 지워진다.
// 인자 설명
//    - DirName : 지울 디렉토리명
//    - UseRecycleBin : 휴지통을 사용할 것인가 여부 (아니면 영구삭제)
//  리턴값 설명
//    - 성공 여부
//-----------------------------------------------------------------
function MinDeleteDir(const DirName : string; const UseRecycleBin: Boolean): Boolean;
var
SHFileOpStruct: TSHFileOpStruct;
DirBuf: array [0..255] of char;
Directory: string;
begin
try
  Directory := ExcludeTrailingPathDelimiter(DirName);

  Fillchar(SHFileOpStruct, sizeof(SHFileOpStruct), 0);
  FillChar(DirBuf, sizeof(DirBuf), 0);
  StrPCopy(DirBuf, Directory);

  with SHFileOpStruct do
  begin
    Wnd := 0;
    pFrom := @DirBuf;
    wFunc := FO_DELETE;
    if UseRecycleBin = True then
      fFlags := fFlags or FOF_ALLOWUNDO;
    fFlags := fFlags or FOF_NOCONFIRMATION;
    fFlags := fFlags or FOF_SILENT;
  end;

  Result := (SHFileOperation(SHFileOpStruct) = 0);
except
  Result := False;
end;
end;

procedure DeleteDirectory(const Name: string);
var
  F: TSearchRec;
begin
  if FindFirst(Name + '\*', faAnyFile, F) = 0 then begin
    try
      repeat
        if ((F.Attr and faDirectory) <> 0) then begin
          if (F.Name <> '.') and (F.Name <> '..') then begin
            DeleteDirectory(Name + '\' + F.Name);
          end;
        end else begin
          DeleteFile((Name + '\' + F.Name));
        end;
      until FindNext(F) <> 0;
    finally
      FindClose(F);
    end;
    RemoveDir(Name);
  end;
end;

{$IFDEF INTERNETULIB}
{------------------------ idftp중복파일 이름바꾸기 -------------------}
function TUJLib.GetUniqFileName(idf:TidFTP; filepath:String) : String;
var
    tmpfname:String;
    fname:String;
    fexec:String;
    i : integer;
    Afiles : TStringList;
begin
    Afiles := TStringList.Create;
    idf.List(Afiles, '*.*', True);
    tmpfname := Copy(filepath, LastDelimiter('/', filepath) + 1, Length(filepath));
    i := 1;
    while Afiles.IndexOf(tmpfname) > -1 do
    begin
        fname := Copy(filepath, 1, LastDelimiter('.', filepath) - 1) + inttostr(i);
        fexec := Copy(filepath, LastDelimiter('.', filepath) + 1, Length(filepath));
        tmpfname := Copy(fname, LastDelimiter('/', fname) + 1, Length(fname)) + '.' + fexec;
        idf.List(Afiles, '*', False);
        inc(i);
    end;

    Result := tmpfname;
end;
{$ENDIF}

{------------------------ 윈도우디렉토리를 정확히한다  -----------------------------}
procedure TUJLib.Wait(timeout_milli: integer);
var
  cut : TDateTime;
begin
  cut := now;
  cut := IncMilliSecond(cut,timeout_milli);
  while (cut > now) do
  begin
    Application.ProcessMessages;
  end;
  sleep(10);
end;

function TUJLib.WindowsDirFixup(APath:String):String;
var s:string;      //마지막에 \ 붙지 않음

  function ReplaceStr(const S, Srch, Replace: string): string;
  var
    I: Integer;
    Source: string;
  begin
    Source := S;
    Result := '';
    repeat
      I := Pos(Srch, Source);
      if I > 0 then begin
        Result := Result + Copy(Source, 1, I - 1) + Replace;
        Source := Copy(Source, I + Length(Srch), MaxInt);
      end
      else Result := Result + Source;
    until I <= 0;
  end;

begin
  s := ReplaceStr(APath,'/','\');
  s := ReplaceStr(s,'\\','\');
  if copy(s,length(s),1) = '\' then
    s := copy(s,1,length(s)-1);
  Result := s;
end;

function TUJLib.LastPos(const Substr, str: string): integer;
var
  Reverse: string;
  RevPart: string;
begin
  Reverse:= ReverseString(str);
  RevPart:= ReverseString(Substr);
  Result:= (Length(str) + 1) - Pos(RevPart, Reverse);
  if (Result > Length(str)) then Result:= -1;
end;

function TUJLIB.RemoveChar(sSrc: string; CharList : string): string;
var
  I: integer;
begin
   Result:='';
   for I:=1 to Length(sSrc) do
   begin
    if Pos(sSrc[I], CharList) = 0 then Result := Result + sSrc[I];
  end;
end;

procedure TUJLIB.StringListAdd(list: TStringList; const str : string);
var
  cstr : string;
  fidx : integer;
  I: Integer;
begin
  cstr := trim(str);
  fidx := -1;
  for I := 0 to List.Count - 1 do
  begin
    if List.Strings[I] = cstr then
    begin
      fidx := I;
      break;
    end;
  end;
  if fidx = -1 then
  begin
    list.Add(cstr);
  end;
end;


function TUJLib.StrToBool(aStr: String; const aTrue1, aTrue2 : string;
  const cass: boolean): boolean;
begin
  Result := false;
  if cass then
  begin
    if aTrue1 = aStr then Result := true
    else if aTrue2 = aStr then Result := true ;
  end else begin
    if LowerCase(aTrue1) = LowerCase(aStr) then Result := true
    else if LowerCase(aTrue2) = LowerCase(aStr) then Result := true;
  end;
end;

{------------------------ 리눅스디렉토리를 정확히한다  -----------------------------}
function TUJLib.LinuxDirFixup(APath:String):String;
var s:string;

  function ReplaceStr(const S, Srch, Replace: string): string;
  var
    I: Integer;
    Source: string;
  begin
    Source := S;
    Result := '';
    repeat
      I := Pos(Srch, Source);
      if I > 0 then begin
        Result := Result + Copy(Source, 1, I - 1) + Replace;
        Source := Copy(Source, I + Length(Srch), MaxInt);
      end
      else Result := Result + Source;
    until I <= 0;
  end;

begin
  s := ReplaceStr(APath,'\','/');
  s := ReplaceStr(s,'///','/');
  s := ReplaceStr(s,'//','/');
  Result := s;
end;

//---------------------------------------------------------------------------
// 콤마 금액을 숫자로
function  TUJLib.PayStrToInt(stString : String) : int64;
var
  tmpStr : String;
begin
  tmpStr := StringReplace(stString, '원', '', [rfReplaceAll]);
  tmpStr := StringReplace(tmpStr, '\', '', [rfReplaceAll]);
  result := str2int(StringReplace(tmpStr,',','',[rfReplaceAll]));
end;

//---------------------------------------------------------------------------
// 숫자를 콤마 금액으로
function TUJLib.IntToPayStr(itNumber : int64) : String;
begin
    Result := FormatFloat('#,###', itNumber);
    if itNumber = 0 then Result := '0';
end;

function TUJLib.Join(exp : String; strlist: TStringList): String;
var
  tm : TStringList;
  I: Integer;
begin
  tm := TStringList.Create;
  tm.AddStrings(strlist);
  Result := '';
  for I := 0 to tm.Count - 2 do
  begin
    Result := Result + tm.Strings[I] + exp;
  end;
  Result := Result + tm.Strings[tm.Count-1];
end;

function TUJLib.Join(str: String): String;
var
  tm : TStringList;
  I: Integer;
begin
  tm := TStringList.Create;
  tm.Text := str;
  Result := '';
  for I := 0 to tm.Count - 2 do
  begin
    Result := Result + tm.Strings[I] + CONSTSS;
  end;
  Result := Result + tm.Strings[tm.Count-1];
end;

{------------------------ 하드 시리얼  -----------------------------}
function TUJLib.MyHDD : String;
var
    VolumeSerialNumber, MaximumComponentLength, FileSystemFlags : DWORD;
begin
    GetVolumeInformation('C:\', nil, 0, @VolumeSerialNumber,
        MaximumComponentLength, FileSystemFlags, nil, 0);
    Result := IntToHex(HIWORD(VolumeSerialNumber), 4)
        + '-' + IntToHex(LOWORD(VolumeSerialNumber), 4);
end;

{------------------------ 윈도우 끄던가 리붓하던가 fasle=완전꺼 -----------------------------}
function TUJLib.MySystemShutdown(Bootchk: boolean) : boolean;
var
  TTokenHd: THandle;
  TTokenPvg: TTokenPrivileges;
  cbtpPrevious: DWORD;
  rTTokenPvg: TTokenPrivileges;
  pcbtpPreviousRequired: DWORD;
  tpResult: Boolean;
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    tpResult := OpenProcessToken(GetCurrentProcess(),
      TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
      TTokenHd) ;
    if tpResult then
    begin
      tpResult := LookupPrivilegeValue(nil,
                                       SE_SHUTDOWN_NAME,
                                       TTokenPvg.Privileges[0].Luid) ;
      TTokenPvg.PrivilegeCount := 1;
      TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      cbtpPrevious := SizeOf(rTTokenPvg) ;
      pcbtpPreviousRequired := 0;
      if tpResult then
        Windows.AdjustTokenPrivileges(TTokenHd,
                                      False,
                                      TTokenPvg,
                                      cbtpPrevious,
                                      rTTokenPvg,
                                      pcbtpPreviousRequired) ;
    end;
  end;

  if Bootchk = false then
  begin
      if not ExitWindowsEx(EWX_POWEROFF or EWX_FORCE,0) then
      begin
        result := false;
        exit;
      end;
  end else begin
      if not ExitWindowsEx(EWX_REBOOT or EWX_FORCE, 0) then
      begin
        Result := false;
        exit;
      end;
  end;
  Result := true;
end;

{------------------------ 키입력이 한글 모드인지  -----------------------------}
function TUJLib.GetImeInputMode(const AHandle: THandle): TImeInputMode;
var
 hContext: HIMC;
 dwSentence : DWORD;
 dwConversion : DWORD;
begin
 hContext := ImmGetContext(AHandle);
 try
   ImmGetConversionStatus(hContext, dwConversion, dwSentence);
   if (dwConversion and IME_CMODE_HANGUL) = IME_CMODE_HANGUL then
     Result := imHangul
   else
     Result := imEnglish;
 finally
   ImmReleaseContext(AHandle, hContext);
 end;
end;

function TUJLib.GetMousePointControl(pt: TPoint): String;
var
  CNAME : array[0..255] of char;
  hand : HWND;
begin
  GetCursorPos(pt);
  hand := WindowFromPoint(pt);
  GetClassName(hand,CNAME,sizeof(CNAME));
  Result := CNAME;
end;

procedure TUJLib.ScreenShotRect(const ARect: TRect; AFileName: String; ALayer,
  ACursor: Boolean; AQuality: Integer);
var
  Bitmap: TBitmap;
  Jpeg: TJpegImage;
  DC: HDC;
  ACursorInfo: Windows.TCursorInfo;
  AIconInfo: ICONINFO;
begin
  Bitmap := TBitmap.Create;
  Jpeg := TJpegImage.Create;

  try
    with Bitmap do
    begin
      PixelFormat := pf24Bit;
      Width := ARect.Right - ARect.Left + 1;
      Height := ARect.Bottom - ARect.Top + 1;
    end;

    DC := GetDC(0);

    try
      if ALayer then
        BitBlt(Bitmap.Canvas.Handle,
                 0, 0, Bitmap.Width, Bitmap.Height, DC, ARect.Left, ARect.Top, SRCCOPY or $40000000)
      else
        BitBlt(Bitmap.Canvas.Handle,
                 0, 0, Bitmap.Width, Bitmap.Height, DC, ARect.Left, ARect.Top, SRCCOPY);

      if ACursor then
      begin
        ACursorInfo.cbSize := SizeOf(ACursorInfo);
        GetCursorInfo(ACursorInfo);

        Dec(ACursorInfo.ptScreenPos.X, ARect.Left);
        Dec(ACursorInfo.ptScreenPos.Y, ARect.Top);

        //
        // 핫스팟 위치 보정
        //
        if GetIconInfo(ACursorInfo.hCursor, AIconInfo) then
        begin
          Dec(ACursorInfo.ptScreenPos.x, AIconInfo.xHotspot);
          Dec(ACursorInfo.ptScreenPos.y, AIconInfo.yHotspot);

          if (AIconInfo.hbmMask <> 0) then DeleteObject(AIconInfo.hbmMask);
          if (AIconInfo.hbmColor <> 0) then DeleteObject(AIconInfo.hbmColor);
        end;

        //
        // 커서 그리기
        //
        DrawIcon(Bitmap.Canvas.Handle,
                       ACursorInfo.ptScreenPos.x, ACursorInfo.ptScreenPos.y, ACursorInfo.hCursor);
      end;
    finally
      ReleaseDC(0, DC);
    end;

    with Jpeg do
    begin
      Assign(Bitmap);
      CompressionQuality := AQuality;  // Jpeg 파일 퀄러티 (~100)
      Compress;
      SaveToFile(AFileName);
    end;
  finally
    Bitmap.Free;
    Jpeg.Free;
  end;
end;

procedure TUJLib.SetImeInputMode(const AHandle: THandle; const Value: TImeInputMode);
var
 hContext: HIMC;
 dwSentence : DWORD;
 dwConversion : DWORD;
begin
 hContext := ImmGetContext(AHandle);
 try
   ImmGetConversionStatus(hContext, dwConversion, dwSentence);
   if Value = imHangul Then
     ImmSetConversionStatus(hContext, IME_CMODE_HANGUL, dwSentence)
   else
     ImmSetConversionStatus(hContext, IME_CMODE_ALPHANUMERIC, dwSentence);
 finally
   ImmReleaseContext(AHandle, hContext);
 end;
end;
{------------------------ 유닉스 시간을 datetime으로  -----------------------------}
function TUJLib.unix2date( unixstr : String ) : TDateTime;
begin
    Result := UnixToDateTime(StrToInt64(unixstr));
end;
function TUJLib.date2unix( datetime : TDateTime ) : String;
begin
    Result := IntToStr( DateTimeToUnix(datetime));
end;

{ -------------------- 한번만 실행되는 어플 -----------------------}
procedure TUJLib.OnlyOneExec(str: PChar; showerrm : boolean = true; msg : String = '');
VAR
HMutex:Longint;
begin
    HMutex := CreateMutex(NIL,True,str);
    IF (GetLastError = ERROR_ALREADY_EXISTS) THEN BEGIN
      if showerrm then
      begin
        if msg <> '' then
          ExitProg(msg,3000)
        else
          ExitProg('Alredy Program Start',3000);
      end else
        ExitProg;
    end;
end;

{--------------------- 시간되면 사라지는 메세지 박스---------------}
procedure MessageBoxTimerProc(hWnd: HWND; uMsg: UINT; idEvent: UINT; Time: DWORD);
begin
//  PostQuitMessage(0);
  hwnd := FindWindow(nil, PChar('알림'));
  if hwnd <> 0 then
    EndDialog(hwnd, 0);

end;

function TUJLib.TimedMessageBox(ptszMessage: LPCTSTR; flags: UINT; dwTimeout: DWORD): Integer;
var
idTimer: UINT;
uiResult: UINT;
msg: TMSG;
begin
//    Ujlib.TimedMessageBox(0,'주문 목록을 전송하였습니다','알림',0,3000);
    idTimer := SetTimer(0, 0, dwTimeout, @MessageBoxTimerProc);
    uiResult := MessageBox(0, ptszMessage, '알림', flags);
    KillTimer(0, idTimer);

    if (PeekMessage(msg, 0, WM_QUIT, WM_QUIT, PM_REMOVE)) then
       uiResult := 0;
    Result := uiResult;
end;

{$IFDEF INTERNETULIB}
{-------------------------------------------------------------------------------}
{데이터셋을 넘겨 orderid 를 얻는다 항상 마지막 값이 처음에 있어야 한다}
function TUJLib.GetOrderID(Sender:TDataSet): String;
begin
  Sender.Filtered := false;
  Sender.Filter := 'orderid = ''' + FormatDateTime('yymmdd',Now) + '*''';
  Sender.Filtered := true;
  Sender.First;
  if Sender.Eof then
    Result := FormatDateTime('yymmdd',Now) + '001'
  else
    Result := Copy(Sender.fieldByName('orderid').AsString,1,6) + RightStr('000' +
     IntToStr(StrToInt(Copy(Sender.FieldByName('orderid').AsString,7,3)) + 1), 3);

end;

{-------------------------------------------------------------------------------}
{detailid 를 얻는다}
function TUJLib.GetDetailID(Sender:TdataSet;fieldname:String): String;
var temp : String;
    tempv : boolean;
begin
  temp := Sender.Filter;
  tempv := Sender.Filtered;
  Sender.Filtered := false;
  Sender.Filter := fieldname + ' = ''' + FormatDateTime('yyyymmddhhnn',Now) + '*''';
  Sender.Filtered := true;
  Sender.First;
  if Sender.RecordCount <= 0 then
    Result := FormatDateTime('yyyymmddhhnn',Now) + '0001'
  else
    Result := copy(Sender.FieldByName(fieldname).AsString,1,12) +
    RightStr('0000' + IntToStr(StrToInt(copy(Sender.FieldByName(fieldname).AsString,13,4)) + 1), 4);
  Sender.Filter := temp;
  Sender.Filtered := tempv;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TUJLib.Str2DateTime(Date: String): TDateTime;
var
  fmtStngs : TFormatSettings;
begin
  GetLocaleFormatSettings(GetThreadLocale, fmtStngs);
  fmtstngs.DateSeparator := '-';
  fmtStngs.ShortDateFormat := 'yyyy-mm-dd';
  fmtStngs.TimeSeparator := ':';
  fmtStngs.LongTimeFormat := 'hh:nn:ss';

  date := StringReplace(date, '24:00:00', '00:00:00', [rfReplaceAll]);

  Result := StrToDateTime(date, fmtStngs);
end;

function TUJLib.Str2Int( str:String): integer;
begin
  if Trim(str) = '' then
    Result := 0
  else
    try
      Result := StrToInt(str);
    except
      Result := 0;
    end;
end;

function TUJLib.Str2Int64( str:String): int64;
begin
  if Trim(str) = '' then
    Result := 0
  else
    try
      Result := StrToInt64(str);
    except
      Result := 0;
    end;
end;

function TUJLib.StrAlign(srcStr: String; ASize, AAlign: integer): String;
var
  tmpSize, i : integer;
  rsStr : String;
begin
  if Length(srcStr) > ASize then
  begin
    result := srcStr;
  end else begin
    tmpSize := (Asize - Length(srcStr)) div 2;
    rsStr := '';
    for I := 0 to tmpSize - 1 do
      rsStr := rsStr + ' ';
    Result := rsStr + srcStr;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TUJLib.explodeList(sepq: String; LineStr: String; var tmpList: TStringList);
 var
   tmpStr : String;
 begin
  tmpList.BeginUpdate;
   while true do begin
     if Pos(sepq, LineStr) <> 0 then begin
        tmpStr := Copy(LineStr, 0, Pos(sepq, LineStr) - 1);
        tmpList.Add(tmpStr);
        LineStr := Copy(LineStr, Pos(sepq, LineStr) + length(sepq), Length(LineStr));
        continue;
     end
     else begin
       tmpList.Add(LineStr);
       break;
     end;
   end;
  tmpList.EndUpdate;
 end;

 {-------------------------------------------------------------------------------}
function TUJLib.explodeListFindAndValue(srcList: TStringList; FindKey, sepq: String): String;
var
  i : integer;
begin
  result := '';
  for I := 0 to srcList.count - 1 do
  begin
    if explode(srcList.Strings[i],sepq,0) = FindKey then
    begin
      Result := explode(srcList.Strings[i],sepq,1);
      exit;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TUJLib.explode(srcstr:String; exp:String; arrpos:integer; blankignore : boolean = false): String;
var StrList:TStringList;
tmpStr : String;
begin
  StrList := TStringList.Create;
   while true do begin
     if Pos(exp, srcstr) <> 0 then begin
        if blankignore then
          while copy(srcstr,1,length(exp)) = exp do
            Delete(srcstr,1,length(exp));
        tmpStr := Copy(srcstr, 1, Pos(exp, srcstr) - 1);
        StrList.Add(tmpStr);
        srcstr := Copy(srcstr, Pos(exp, srcstr) + length(exp), Length(srcstr));
        if blankignore then
          while copy(srcstr,1,length(exp)) = exp do
            Delete(srcstr,1,length(exp));
        continue;
     end
     else begin
       StrList.Add(srcstr);
       break;
     end;
   end;
  if StrList.Count > arrpos then
    Result := StrList.Strings[arrpos]
  else
    Result := '';
  StrList.Free;
end;

function TUJLib.StringPop(srcstr : String; popChar : String = '"') : string;
var
  spos : integer;
  sstr : string;
begin
  Result := '';
  sstr := srcstr;
  delete(sstr,1,(pos(popchar,srcstr) + popchar.Length - 1 ));

  if pos(popchar,sstr) > 0 then
  begin
      sstr := copy(sstr,1,pos(popchar,sstr)-1);
      Result := sstr;
  end;
end;

{-------------------------------------------------------------------------------}
function TUJLib.explodeCount(srcstr:String; exp:String; blankignore : boolean = false):integer;
var StrList:TStringList;
    tmpStr : String;
begin
    StrList := TStringList.Create;
    StrList.Clear;
    while true do begin
      if Pos(exp, srcstr) <> 0 then begin
        if blankignore then
          while copy(srcstr,1,length(exp)) = exp do
            Delete(srcstr,1,length(exp));
        tmpStr := Copy(srcstr, 1, Pos(exp, srcstr) - 1);
        StrList.Add(tmpStr);
        srcstr := Copy(srcstr, Pos(exp, srcstr) + length(exp), Length(srcstr));
        if blankignore then
          while copy(srcstr,1,length(exp)) = exp do
            Delete(srcstr,1,length(exp));
        continue;
      end
      else begin
        if srcstr <> '' then
          StrList.Add(srcstr);
        break;
      end;
   end;
   Result := StrList.Count;
   StrList.Free;
end;
{-------------------------------------------------------------------------------}
procedure TUJLib.ShowPress;
begin
  FPress := TForm.Create(nil);
  FPress.Width := 100;
  FPress.Height := 30;
  FPress.Position := poScreenCenter;
  FPress.BorderStyle := bsNone;
  FPress.Color := clWhite;
  FPress.Canvas.Brush.Color := clNavy;
  FPress.FormStyle := fsStayOnTop;
  FPress.Show;
  FPress.UPdate;
  Application.ProcessMessages;

  FTimer := TTimer.Create(nil);
  FTimer.OnTimer := FTimerTimer;
  FTimer.Interval := 500;
  FTimer.Enabled := true;
end;
{-------------------------------------------------------------------------------}
procedure TUJLib.HidePress;
begin
  FPress.Close;
  FTimer.Enabled := false;
end;
{-------------------------------------------------------------------------------}
procedure TUJLib.FTimerTimer(Sender: TObject);
begin
  TimerInc := TimerInc + 10;
  if TimerInc > 100 then
  begin
    TimerInc := 0;
    if FPress.Canvas.Brush.Color = clBlack then
      FPress.Canvas.Brush.Color := clWhite
    else
      FPress.Canvas.Brush.Color := clNavy;
  end
  else
    FPress.Canvas.FillRect(Rect(1,1,TimerInc,29));
  Application.ProcessMessages;
  FPress.Update;
end;

{$IFDEF INTERNETULIB}
{-------------------------------------------------------------------------------}
{  Order_T 필드를 리턴한다 }
function TUJLib.GetOrderField : TStringList;
begin
  Result := TStringList.Create;
  Result.Clear;
  with Result do
  begin
    Add('orderid');
    Add('hyunjang');
    Add('su');
    Add('danga');
    Add('sup_price');
    Add('bigo');
    Add('pro_idx');
    Add('codename');
    Add('valuename');
    Add('color');
    Add('unit');
    Add('cost');
    Add('outdate');
  end;
end;

{-------------------------------------------------------------------------------}
{  Client_T 필드를 리턴한다 }
function TUJLib.GetClientField : TStringList;
begin
  Result := TStringList.Create;
  Result.Clear;
  with Result do
  begin
    Add('co_code'); Add('co_sangho'); Add('co_name');  Add('co_serial');
    Add('co_address');  Add('co_uptae'); Add('co_jongmok'); Add('co_tel');
    Add('co_fax'); Add('co_manager'); Add('co_manager_tel'); Add('co_manager_jumin');
    Add('co_manager_email'); Add('co_ceo_address'); Add('co_ceo_tel'); Add('co_ceo_hp');
    Add('co_tax'); Add('co_acc_type'); Add('co_require'); Add('co_regdate');
  end;
end;
{$ENDIF}

// (1) 파일과 연관(association)된 프로그램으로 파일을 엽니다
//     ShellExecute(Handle, 'open', PChar('test.txt'), nil, nil, SW_SHOW);

// (2) notepad.exe 에 파라미터로 config.sys 파일을 주어 메모장을 실행합니다
//     ShellExecute(Handle, 'open', 'notepad', 'c:\config.sys', nil, SW_SHOW);

// (3) PC에 설치된 기본 웝브라우저로 지정한 사이트를 엽니다.
//     ShellExecute(Handle, 'open', 'www.howto.pe.kr', nil, nil, SW_SHOW);

// (4) 특정 폴더를 시작 폴더로 하는 윈도우즈 탐색기를 엽니다
//     ShellExecute(Handle, 'explore', PChar('c:\windows)', nil, nil, SW_SHOW);

// (5) readme.doc 파일을 연결된 프로그램으로 인쇄하고 화면을 닫습니다
//     ShellExecute(Handle, 'print', 'readme.doc', nil, nil, SW_SHOW);
    
// (6) rMyDelphiFile.pas 파일을 wordpad 프로그램으로 인쇄하고 화면을 닫습니다
//     ShellExecute(Handle, 'print', 'wordpad.wxe', 'MyDelphiFile.pas', nil, SW_SHOW);

// (7) readme.doc 파일을 프린터를 선택하여 연결된 프로그램으로 인쇄하고 화면을 닫습니다
//     var
//       Device : array[0..255] of char;
//       Driver : array[0..255] of char;
//       Port   : array[0..255] of char;
//       S: String;
//       hDeviceMode: THandle;
//     begin
//       Printer.PrinterIndex := -1;  // 프린터 인덱스를 지정합니다. 여기서는 기본 프린터(-1) 선택
//       Printer.GetPrinter(Device, Driver, Port, hDeviceMode);
//       S := Format('"%s" "%s" "%s"',[Device, Driver, Port]);
//       ShellExecute(Handle, 'printto', 'readme.doc', Pchar(S), nil, SW_HIDE);

// (8) 기본 메일 프로그램을 실행합니다.
//     ShellExecute(Handle, nil, 'mailto:cozy@howto.pe.kr', nil, nil, SW_SHOW);

// (9) DOS 명령어를 실행하고 화면을 닫습니다
//     ShellExecute(Handle, 'open', PChar('command.com'), PChar('/c copy file1.txt file2.txt'), nil, SW_SHOW);

// (10) DOS 명령어를 실행하고 화면을 닫지 않습니다
//      ShellExecute(Handle, 'open', PChar('command.com'), PChar('/k dir'), nil, SW_SHOW);

// (11) ShellExecute()의 리턴값은 실행된 프로그램의 핸들이거나 에러코드입니다
//      리턴값이 32 이하이면 에러가 발생한것으로 각각은 아래와 같은 의미가 있습니다

//   var
//     code: Integer;
//   begin
//     code := ShellExecute(...);
//     if code <= 32 then ShowMessage(ShowShellExecuteError(code));
//   end;
    
//   // ShellExecute()의 리턴코드에 대한 에러 메시지
//   function ShowShellExecuteError(i: integer): String;
//   begin
//     case i of 0: result := 'The operating system is out of memory or resources.';
//       ERROR_FILE_NOT_FOUND: result := 'The specified file was not found.';
//       ERROR_PATH_NOT_FOUND: result := 'The specified path was not found.';
//       ERROR_BAD_FORMAT: result := 'The .EXE file is invalid (non-Win32 .EXE or error in .EXE image).';
//       SE_ERR_ACCESSDENIED: result := 'The operating system denied access to the specified file.';
//       SE_ERR_ASSOCINCOMPLETE: result := 'The filename association is incomplete or invalid.';
//       SE_ERR_DDEBUSY: result := 'The DDE transaction could not be completed because other DDE transactions were being processed.';
//       SE_ERR_DDEFAIL: result := 'The DDE transaction failed.';
//       SE_ERR_DDETIMEOUT: result := 'The DDE transaction could not be completed because the request timed out.';
//       SE_ERR_DLLNOTFOUND: result := 'The specified dynamic-link library was not found.';
//       //SE_ERR_FNF          : result:='The specified file was not found.';
//       SE_ERR_NOASSOC           : result:='Unbekannter Extender.';
//       SE_ERR_OOM: result := 'There was not enough memory to complete the operation.';
//       //SE_ERR_PNF          : result:='The specified path was not found.';
//       SE_ERR_SHARE: result := 'A sharing violation occurred.';
//     end;
//   end;

// (12) ShellExecuteEx()를 이용하여 notepad.exe 를 실행한 후 종료될때까지 기다립니다
//   var
//     SEInfo: TShellExecuteInfo;
//     ExitCode: DWORD;
//     ExecuteFile, ParamString, StartInString: string;
//   begin
//     ExecuteFile   := 'notepad.exe';   // 실행할 프로그램
//     ParamString   := 'c:\winzip.log'; // 프로그램의 명령행 파라미터
//     StartInString := 'c:\';           // 시작 위치
//     FillChar(SEInfo, SizeOf(SEInfo), 0);
//     SEInfo.cbSize := SizeOf(TShellExecuteInfo);

//     with SEInfo do
//     begin
//       fMask        := SEE_MASK_NOCLOSEPROCESS;
//       Wnd          := Application.Handle;
//       lpFile       := PChar(ExecuteFile);
//       lpParameters := PChar(ParamString);
//       lpDirectory  := PChar(StartInString);
//       nShow        := SW_SHOWNORMAL;
//     end;
//     if ShellExecuteEx(@SEInfo) then
//     begin
//       repeat
//         Application.ProcessMessages;
//         GetExitCodeProcess(SEInfo.hProcess, ExitCode);
//       until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
//       ShowMessage('프로그램이 종료되었습니다');
//     end
//     else ShowMessage('프로그램을 실행할 수 없습니다');
// [출처] [공유] ShellExecute(Ex) 사용법 예제 12가지|작성자 Develop


function TUJLib.RunasAdmin(AFileName: PChar; AParam: PChar = nil; ShowMode : integer = SW_SHOWNORMAL) : integer;
var
  sei: TShellExecuteInfo;
  err: DWORD;
begin
  FillChar(sei, SizeOf(sei), 0);
  sei.cbSize := SizeOf(SHELLEXECUTEINFO);
  sei.lpVerb := 'runas'; // Vista 나 Win7의 경우에만 사용
  if AParam <> nil then
    sei.lpParameters := AParam;
  (*
  Vista 이하에서는 sei.lpVerb := 'open'; 정도면 되겠네요.
  만약 파라미터가 필요하시다면 sei.lpParameters := 'PARAM'; 을 사용하세요.
  *)
  sei.lpFile := AFileName;
  sei.nShow  := ShowMode;
  sei.lpDirectory := PChar( extractFilePath(AFileName) );
  Result := 0;
  if not ShellExecuteEx(@sei) then
  begin
    err := GetLastError();

    if err = ERROR_CANCELLED then
    begin
      ShowMessage('사용자가 권한 상승 요청을 거절');
    end
    else if err = ERROR_FILE_NOT_FOUND then
    begin
      ShowMessage('FILE NOT FOUND!');
    end
    else if err = ERROR_ACCESS_DENIED then
    begin
      ShowMessage('ACCESS DENIED');
    end else
    begin
      ShowMessage('error no: ' + IntToStr(err));
    end;
    Result := Integer(err);
  end;
end;
{-------------------------------------------------------------------------------}
{ 프로세스 이름으로 몇개있는지 개수 리턴 }
function TUJLib.IsRunningProcessCount(const ProcFileName: String) : Integer;
var
  Process32: TProcessEntry32;
  SHandle:   THandle;
  Next:      Boolean;

begin
  Result:=0;

  Process32.dwSize:=SizeOf(TProcessEntry32);
  SHandle         :=CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);

  // 프로세스 리스트를 돌면서 매개변수로 받은 이름과 같은 프로세스가 있을 경우 count 증가하고 루프종료
  if Process32First(SHandle, Process32) then begin
    repeat
      Next:=Process32Next(SHandle, Process32);
      if AnsiCompareText(Process32.szExeFile, Trim(ProcFileName))=0 then begin
         inc(Result);
      end;
    until not Next;
  end;
  CloseHandle(SHandle);
end;
{-------------------------------------------------------------------------------}
{ 프로그램 실행후 대기한다 }
Function TUJLib.winexecAndWait32V2( FileName: String; Visibility: integer = SW_NORMAL ;WaitPls : integer = 1{대기하기 싫으면 -1}): DWORD;
      Procedure WaitFor( processHandle: THandle );
      Var
      msg: TMsg;
      ret: DWORD;
      Begin
        Repeat
          ret := MsgWaitForMultipleObjects(
            1, { 1 handle to wait on }
            processHandle, { the handle }
            False, { wake on any event }
            INFINITE, { wait without timeout }
            QS_PAINT or { wake on paint messages }
            QS_SENDMESSAGE { or messages from other threads }
          );
          If ret = WAIT_FAILED Then Exit; { can do little here }
          If ret = (WAIT_OBJECT_0 + 1) Then Begin
            { Woke on a message, process paint messages only. Calling
            PeekMessage gets messages send from other threads processed. }
            While PeekMessage( msg, 0, WM_PAINT, WM_PAINT, PM_REMOVE ) Do
              DispatchMessage( msg );
          End;
        Until ret = WAIT_OBJECT_0;
      End; { Waitfor }
Var { V1 by Pat Ritchey, V2 by P.Below }
  zAppName:array[0..512] of char;
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
  Begin { winexecAndWait32V2 }
    StrPCopy(zAppName,FileName);
    FillChar(StartupInfo,Sizeof(StartupInfo),#0);
    StartupInfo.cb := Sizeof(StartupInfo);
    StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow := Visibility;
    If not CreateProcess(nil,
      zAppName, { pointer to command line string }
      nil, { pointer to process security attributes }
      nil, { pointer to thread security attributes }
      false, { handle inheritance flag }
      CREATE_NEW_CONSOLE or { creation flags }
      NORMAL_PRIORITY_CLASS,
      nil, { pointer to new environment block }
      nil, { pointer to current directory name }
      StartupInfo, { pointer to STARTUPINFO }
      ProcessInfo) { pointer to PROCESS_INF }
      Then
      Result := DWORD(-1) { failed, GetLastError has error code }
      Else Begin
        if WaitPls > 0 then
        begin
          Waitfor(ProcessInfo.hProcess);
          GetExitCodeProcess(ProcessInfo.hProcess, Result);
          CloseHandle( ProcessInfo.hProcess );
          CloseHandle( ProcessInfo.hThread );
        end;
    End; { Else }
End; { winexecAndWait32V2}

Function TUJLib.exec( FileName: String; strparam:String = ''; ShowMode : integer = SW_NORMAL) : DWORD;
begin
  if not FileExists(FileName) then
    exit(0);
 if integer(WindowEdition) >  100 then  //vista 이상
 begin
   RunasAdmin(Pchar(FileName),PChar(strparam), ShowMode);
   Result := 0;
 end else
   Result := ShellExecute(0, 'open', PChar(FileName), PChar(strparam), PChar(extractFilePath(FileName)), ShowMode);
end;

{ 치명적인 오류 메시지 나타내지 않음 }
PROCEDURE TUJLib.CritErrorsOff;
Begin
 { 운영체제에서 치명적인 오류 에러메시지 박스 보여주지 않음 }
 SavedErrorMode := SetErrorMode(SEM_FailCriticalErrors);
 { 운영체제에서 메모리 할당 오류 }
 SavedErrorModea := SetErrorMode(SEM_NOALIGNMENTFAULTEXCEPT);
 { 운영체제에서 일반보호오류발생 에러메시지 박스 보여주지 않음 }
 SavedErrorModeb := SetErrorMode(SEM_NOGPFAULTERRORBOX);
 { 운영체제에서 파일 찾기 실패시 에러메시지 박스 보여주지 않음 }
 SavedErrorModec := SetErrorMode(SEM_NOOPENFILEERRORBOX);
End;

{ 치명적인 오류메시지  보여줌 }
PROCEDURE TUJlib.CritErrorsOn;
Begin
SetErrorMode(SavedErrorMode);
SetErrorMode(SavedErrorModea);
SetErrorMode(SavedErrorModeb);
SetErrorMode(SavedErrorModec);
End;

function TUJLib.Int2Str(int: Integer; size : integer = 0): String;
begin
  Result := int2str(int64(int),size);
end;

function TUJLib.Int2Str(int: Int64; size: integer): String;
var
  tmp : string;
begin
  tmp := '';
  if size > 0 then
  begin
    while Length(tmp) < size do tmp := tmp + '0';
    if length(inttostr(int)) >= size then
    begin
      Result := inttostr(int);
    end else begin
      if int < 0 then
        Result := inttostr(int)
      else
        Result := copy(tmp+inttostr(int),Length(tmp+inttostr(int))-size+1,size);
    end;
  end else begin
    Result := inttostr(int);
  end;
end;

function TUJLib.UpDateParam(opt: String): String;     //해당 파라메터의 값을 반환
var
  i : integer;
begin
  Result := '';
  for i := 1 to ParamCount - 1 do begin
    if trim(ParamStr(i)) = opt then begin
      if copy(ParamStr(i+1),1,1) <> '-' then begin
        Result := ParamStr(i+1);
{        if pos('"', Result) = 1 then
        begin
          Result := copy(Result,2,Length(Result)-3);
          ShowMessage(result);
        end; {}
      end else begin
        Result := 'true';
      end;
    end;
  end;
end;

function TUJLib.UrlEncodeToA(const S: String;
  DstCodePage: LongWord): AnsiString;
var
    I, J   : Integer;
    AStr   : AnsiString;
    RStr   : AnsiString;
    HexStr : String[2];
begin
    AStr := S;

    SetLength(RStr, Length(AStr) * 3);
    J := 0;
    for I := 1 to Length(AStr) do begin
        case AStr[I] of
            '0'..'9', 'A'..'Z', 'a'..'z' :
                begin
                    Inc(J);
                    RStr[J] := AStr[I];
                end
        else
            Inc(J);
            RStr[J] := '%';
            HexStr  := IntToHex(Ord(AStr[I]), 2);
            Inc(J);
            RStr[J] := HexStr[1];
            Inc(J);
            RStr[J] := HexStr[2];
        end;
    end;
    SetLength(RStr, J);
    Result := RStr;
end;

function TUJLib.CalcFontSize(obj : TJvLabel; nWidth, nHeight : Integer; sText : string): Integer;

Const
  MAX_FONT_SIZE = 144;
  MIN_FONT_SIZE = 2;
var
  ARect : TRect;
  I : Integer;
begin

  ARect := Default(TRect);
  ARect.Right := nWidth;
  ARect.Bottom := nHeight;

  for I := MIN_FONT_SIZE to MAX_FONT_SIZE do
  begin
    (obj as TJvLabel).Canvas.Font.Size := I;
    (obj as TJvLabel).Canvas.TextRect(ARect, sText, [tfCalcRect]);

    if ((ARect.Right - ARect.Left) < nWidth)
      and ((ARect.Bottom - ARect.Top) < nHeight) then
        Result := I;
  end;

end;

function TUJLib.GetUniqDayKey: String;  {13자리의 날짜로 생긴 유일키 만들기 }
var
  y,m,d,h,mm,s,ms : Word;
  tmp : integer;
begin
  DecodeDateTime(now,y,m,d,h,mm,s,ms);
  tmp := y+d*m;
  result :=  copy(int2str(y,4),4,1) + copy(int2str(y,4),3,2) +
  copy(int2str(y,4),1,2) + copy(int2str(d,2),1,2) +
  copy(int2str(tmp,4),1,4) + copy(int2str(m,2),1,2);
end;

function TUJLIB.GetExpireSerialNumber(yyyymmdd : string) : String;
begin
  Result := 'D' + int2str( Random(999),4) + int2Str(Random(9),1)
    + copy(yyyymmdd,5,2) + int2str( Random(999),4) + copy(yyyymmdd,1,2)
    + int2str( Random(9999),4) + copy(yyyymmdd,7,2) + int2str( Random(99),2)
    + copy(yyyymmdd,4,1) + int2str( Random(999),3) + copy(yyyymmdd,3,1) + int2str( Random(9999),4);
end;

function TUJLIB.GetSerialToExpire(key : String) : TDate;  //키를 가지고 날짜를 만들어냄
var
  tmpk : String;
begin
  //20181223  ->  D059121205172016882333877713606
  tmpk := copy(key,13,2) + copy(key,27,1) + copy(key, 23, 1) + '-' + copy(key,7,2) + '-' + copy(key, 19,2);
  Result := StrToDate(tmpk);
end;

function TUJLib.GetUniqLocalFileName(filepath: String): String;
begin
  Result := filepath;
  while FileExists(Result) do
  begin
    Result := ExtractFilePath(Result) + '_' + ExtractFileName( Result );
  end;
end;

function TUJlib.GetUniqIndexFileName(filepn : String) : String;
var
  I : Integer;
begin
  Result := filepn;
  I := 1;
  while FileExists(Result) do
  begin
    Result := ExtractFilePath(Result) + changeFileExt(ExtractFileName( filepn ),int2str(I) + ExtractFileExt(filepn));
    inc(I);
  end;
end;

function TUJLib.GetUniqMilisecondKey: String;  {17시간로 생긴 유일키 만들기 }
var
  y,m,d,h,mm,s,ms : Word;
begin
  DecodeDateTime(now,y,m,d,h,mm,s,ms);
  result :=  copy(int2str(y,4),1,4) + copy(int2str(m,2),1,2) +
  copy(int2str(d,2),1,2) + '_' + copy(int2str(h,2),1,2) +
  copy(int2str(mm,2),1,2) + copy(int2str(s,2),1,2) + copy(int2str(ms,2),1,2)
  + RandomFrom(['1','2','3','4','5','6','7','8','9']);
end;

function TUJLib.GetUniqMilisecondRandKey: String;  {18시간로 생긴 유일키 만들기 }
var
  y,m,d,h,mm,s,ms : Word;
begin
  DecodeDateTime(now,y,m,d,h,mm,s,ms);
  Randomize;
  result :=  copy(int2str(y,4),1,4) + copy(int2str(m,2),1,2) +
  copy(int2str(d,2),1,2) + copy(int2str(h,2),1,2) +
  copy(int2str(mm,2),1,2) + copy(int2str(s,2),1,2) + copy(int2str(ms,2),1,2)
  + int2str(Random(99),2);
end;

function TUJLib.GetSerialNumber(idx, snSize : integer) : String;
var
  i,j : integer;
  uni,sni, src : String;
begin
  uni := '21cBISSNESCOMPANYTEL050-5834-5834HELLOMYUSERIDDUKEPOWHIK';
  sni := int2str(idx,snSize);
  j := 0;
  for i := 1 to Length(sni) do
  begin
    src := src + IntToHex( ord(uni[i]) + ord(sni[i]),2);
    j := j + ord(uni[i]) + ord(sni[i]);
  end;
  Result := src + inttostr(j mod 10);
end;

function TUJLib.GetSerialNumber(idx: int64; snSize: integer): String;
var
  i,j : integer;
  uni,sni, src : String;
begin
  uni := '21cBISSNESCOMPANYTEL050-5834-5834HELLOMYUSERIDDUKEPOWHIK';
  sni := int2str(idx,snSize);
  j := 0;
  for i := 1 to Length(sni) do
  begin
    src := src + IntToHex( ord(uni[i]) + ord(sni[i]),2);
    j := j + ord(uni[i]) + ord(sni[i]);
  end;
  Result := src + inttostr(j mod 10);
end;

function TUJLib.BoolToStr(aValue: Boolean; const aYes, aNo: string): string;
begin
  if aValue then
    Result := aYes
  else
    Result := aNo
end;

function TUJLib.CheckSerialNumber(SerialNumber : String) : integer;
var
  i,j : integer;
  uni, src : String;
begin
  uni := '21cBISSNESCOMPANYTEL050-5834-5834HELLOMYUSERIDDUKEPOWHIK';
  j := 0;
  for i := 1 to ((Length(SerialNumber)-1) div 2) do
  begin
    if (gethextoint(SerialNumber[i*2-1]) * 16 + Gethextoint(SerialNumber[i*2]) - ord(uni[i]) > 47)
      and (gethextoint(SerialNumber[i*2-1]) * 16 + Gethextoint(SerialNumber[i*2]) - ord(uni[i]) < 58) then
    begin
      src := src + Char(gethextoint(SerialNumber[i*2-1]) * 16 + Gethextoint(SerialNumber[i*2]) - ord(uni[i]));
      j := j + gethextoint(SerialNumber[i*2-1]) * 16 + Gethextoint(SerialNumber[i*2]);
    end else begin
      Result := 0;
      exit;
    end;
  end;
  try
    Result := strtoint(src);
    if (inttostr(j mod 10) <> SerialNumber[Length(SerialNumber)] ) then begin
      Result := 0;
    end;
  except
    Result := 0;
  end;
end;

FUNCTION  TUJLib.GetHexToInt(inChar:Char):Integer;
var
 C : Char;
begin
 C := UpCase(inChar);
 Result := 0;
 if C in ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'] then
 begin
   Case inChar of
     'A':  Result := 10;
     'B':  Result := 11;
     'C':  Result := 12;
     'D':  Result := 13;
     'E':  Result := 14;
     'F':  Result := 15;
     else
       Result := StrToIntDef(inChar,0);
   end;
 end;
end;

function TUJLib.UpDateApplicationComplete(Sender : TObject) : boolean;
var
  ProgFileName , s,AOriginalFileName, pastr : String;
  i : integer;
begin
  {-------------------------} //TODO: 자신의 업데이트가 있음 재기동 {-----------------------------------}
  Application.OnException := ExceptionHandler;
  ProgFileName := ExtractFileName(ParamStr(0)); // 자신의 프로그램 이름 추출

  // 업데이트 프로그램 자신을 패치시킨다
  s := RootPath + 'new_' + ProgFileName;
  pastr := '';
  for i := 1 to ParamCount do begin
    pastr := pastr + ' ' + ParamStr(i);
  end;

  if (UpperCase(ParamStr(1)) <> 'DELETENEW') and (FileExists(s)) then
  begin
    TForm(Sender).OnShow := nil;
    TForm(Sender).OnActivate := nil;
    exec(s, 'MYSELF'+pastr);
    ExitProg;   // 죽기
    Result := False;
    exit;
  end;
  if UpperCase(ParamStr(1)) = 'MYSELF' then
  begin
  	if UpperCase(Copy(ProgFileName, 1, 4)) = 'NEW_' then
    begin
    	s := Copy(ProgFileName, 5, Length(ProgFileName));
    	AOriginalFileName := RootPath + s;

    	TForm(Sender).OnActivate := nil;
      TForm(Sender).OnShow := nil;

      while FileExists(AOriginalFileName) do
      begin
      	DeleteFile(AOriginalFileName);
      end;

    	CopyFile(PChar(ParamStr(0)), PChar(AOriginalFileName), False);

      exec(AOriginalFileName, 'DELETENEW'+pastr);
      Result := False;
      ExitProg;
      exit;
    end;
  end;

	// 나 자신 업데이트 끝
  if UpperCase(ParamStr(1)) = 'DELETENEW' then
  begin
  	s := RootPath + 'NEW_' + ProgFileName;
  	while FileExists(s) do
    begin
    	DeleteFile(s);
    end;
  end;
  Result := True;
end;

function TUjlib.getByteView(byte : int64) : String;
var
  cgiga : int64;
  cmega : int64;
  ckbyte : int64;
  gresult, mresult, kresult : int64;
begin
	cgiga := 1024 * 1024 * 1024;
	cmega := 1024 * 1024;
	ckbyte := 1024;
  gresult := 0;   mresult := 0;    kresult := 0;
	if(byte - cgiga >= 0) then
  begin
		gresult := byte div cgiga;
		byte := byte - cgiga;
	end;
	if(byte - cmega >= 0) then
  begin
		mresult := byte div cmega;
		byte := byte - cmega;
	end;
	if(byte - ckbyte >= 0) then
  begin
		kresult := byte div ckbyte;
		byte := byte - ckbyte;
	end;
	if(gresult > 0) then
		result := CurrToStr( gresult) + '.' + copy(inttostr(mresult),0,2) + ' Gb'
	else if(mresult > 0) then
		result := CurrToStr(mresult) + '.' + copy(inttostr(kresult),0,2) + ' Mb'
	else if(kresult > 0) then
		result := CurrToStr(kresult) + '.' + copy(inttostr(byte),0,2) + ' Kb'
	else
		result := CurrToStr(byte) + ' Byte';

end;

function TUjlib.EncodeURIComponent(const InputStr: string; const bQueryStr: Boolean): string;
var
   Idx: Integer;
begin
   Result := '';
   for Idx := 1 to Length(InputStr) do
      begin
         case InputStr[Idx] of
            'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.':
               Result := Result + InputStr[Idx];
            ' ':
               if bQueryStr then
                  Result := Result + '+'
               else
                  Result := Result + '%20';
            else
               Result := Result + '%' + SysUtils.IntToHex(Ord(InputStr[Idx]), 2);
         end;
      end;
end;


function TUjlib.DecodeURIComponent(const Code: String): String;
var
i : Integer;
Ch1, Ch2: Char;
begin
  Result := '';
  i := 1;
  while i < Length(Code) do
  begin
    if Code[i] = '%' then inc(i)
    else begin
      while Code[i] <> '%' do begin
        Result := Result + Code[i];
        inc(i);
      end
    end;

    if Code[i] = '%' then inc(i);

    if i < Length(Code) then begin
      Ch1 := Code[i];
      Ch2 := Code[i + 1];
      inc(i, 2);
      Try
        Result := Result + Chr(StrToInt('$' + Ch1 + Ch2));
      Except
        Result := Result + Ch1 + Ch2;
      End;
    end;
  end;
end;

{ TButtonDisable }

constructor TCompoDisable.Create(AOwner: TControl);
begin
  inherited Create;
  AOwner.Enabled := False;
  FOwner := AOwner;
end;

destructor TCompoDisable.Destroy;
begin
  FOwner.Enabled := True;
  inherited;
end;

{ TTimerDisable }

constructor TTimerDisable.Create(AOwner: TTimer);
begin
  inherited Create;
  AOwner.Enabled := false;
  FOwner := AOwner;
end;

destructor TTimerDisable.Destroy;
begin
  FOwner.Enabled := true;
  inherited;
end;

{ TCursorSave }

constructor TCursorSave.Create;
begin
  inherited;
  FCursor := Screen.Cursor;
  Screen.Cursor := crAppStart;
end;

destructor TCursorSave.Destroy;
begin
  Screen.Cursor := FCursor;
  inherited;
end;

{ TCompoVisible }

constructor TCompoVisible.Create(AOwner: TControl);
begin
  inherited Create;
  AOwner.Visible := not AOwner.Visible;
  FOwner := AOwner;
end;

destructor TCompoVisible.Destroy;
begin
  FOwner.Visible := not FOwner.Visible;
  inherited;
end;

{ TTGFileInfo }

constructor TTGFileInfo.Create(const AFileName: String);
var
  M : TFileStream;
  D : TDateTimeInfoRec;
begin
  if FileGetDateTimeInfo(AFileName, D) then
  begin
    Name := ExtractFileName(AFileName);
    Path := ExtractFilePath(AFileName);
    ext := ExtractFileExt(AFileName);
    try
      M := TFileStream.Create(AFileName,fmOpenRead, fmShareDenyNone);
      Size := M.Size;
      Date := D.CreationTime;
    finally
      M.Free;
    end;
  end;

end;

function TTGFileInfo.FormatByteSize: String;
const
  B = 1;
  KB = 1024 * B;
  MB = 1024 * KB;
  GB = 1024 * MB;
begin
  if Size > GB then Result := FormatFloat('#.## GB', Size / GB)
  else if Size > MB then Result := FormatFloat('#.## MB', Size / MB)
  else if Size > KB then Result := FormatFloat('#.## KB', Size / KB)
  else Result := FormatFloat('#.## B', Size);
end;

Initialization
  rootPath := ExtractFilePath(ParamStr(0));
  windowPath := GetWindowDir + '\';
  desktopPath := GetDeskTopDir + '\';
  documentPath := GetDocumentDir + '\';
  programfilesPath := GetProgramFilesDir + '\';
  WindowEdition := GetWindowsEdition;


end.
