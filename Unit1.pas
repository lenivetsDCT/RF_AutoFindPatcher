unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, tlhelp32, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Memo1: TMemo;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Button1: TButton;
    CheckBox2: TCheckBox;
    CheckBox5: TCheckBox;
    GroupBox2: TGroupBox;
    Button3: TButton;
    GroupBox3: TGroupBox;
    Button2: TButton;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    Edit2: TEdit;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox6: TCheckBox;
    Button4: TButton;
    function FindString(ProcessID: DWORD; RangeFrom, RangeTo: DWORD;
      StringToFind: AnsiString): Pointer;
    procedure Button1Click(Sender: TObject);
    function Write(ProcessID: DWORD; bt: integer; adr: Pointer;
      lng: integer): Boolean;
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    function gPid(exename: string): integer;
    procedure PatchOsad(N:String);
    procedure PatchWeapon(Name:string);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  Form1: TForm1;
  wnd: HWND;

implementation

{$R *.dfm}

procedure TForm1.PatchOsad(N:String);
Var
  adr,adr2,sadr: Pointer;
begin
  wnd := FindWindow(nil, 'RF Online');
  if wnd <> 0 then
  begin
    adr := FindString(gPid('RF Online'), $0000000000000000, $7FFFFFFFFFFFFFFF, N);
  while ((integer(adr))>0) do
  begin
      adr2:=adr;
      sadr:=adr;
    if Write(gPid('RF Online'), 3,sadr, 1) then   //Адрес находит с сдвигом -2. Обычно Осадка -2 Байта это 30скил.
      begin
       Memo1.Lines.Add('OK 30Skill');
      end;

    if CheckBox2.Checked then
    begin
      adr := ptr(integer(adr) + 197);  //Адрес Осадки + С3 (+2 сдвиг)
      if Write(gPid('RF Online'), 50298, adr, 2) then
        Memo1.Lines.Add('OK Speed');
    end;
      if CheckBox5.Checked then
    begin
      adr2 := ptr(integer(adr2) + 218);   //Адрес осадки +  D8  (+2 сдвиг)
      if Write(gPid('RF Online'), 67, adr2, 1) then
        Memo1.Lines.Add('OK Radius');
    end;
      adr := FindString(gPid('RF Online'), (integer(adr)+Length(N)), $7FFFFFFFFFFFFFFF, N);
    end;
  end
  else
    ShowMessage('Окно RF Online не найденно !');
end;

procedure TForm1.PatchWeapon(Name:string);
Var
  adr,adrs: Pointer;
begin
  wnd := FindWindow(nil, 'RF Online');
  if wnd <> 0 then
  begin
      adr := FindString(gPid('RF Online'), $0000000000000000, $7FFFFFFFFFFFFFFF,
        Name);
        adrs:=adr;
      adrs := ptr(integer(adr) + 172); //2Символа к смещеню за счет названия оружки  (смотреть процедуру кнопки)
       Write(gPid('RF Online'), 0, adr, 2);
        Memo1.Lines.Add('OK Weapon Speed');
      adr := ptr(integer(adr) + 221); //2 символа изза символов перед названием.
        Write(gPid('RF Online'), 69, adr, 1);
        Memo1.Lines.Add('OK Weapon Radius');
  end
  else
    ShowMessage('Окно RF Online не найденно !');
end;


function dec2hex(value: DWORD): string;
const
  hexdigit = '0123456789ABCDEF';
begin
  while value <> 0 do
  begin
    dec2hex := hexdigit[succ(value and $F)];
    value := value shr 4;
  end;
end;

function TForm1.Write(ProcessID: DWORD; bt: integer; adr: Pointer;
  lng: integer): Boolean;
Var
  hProcess: DWORD;
  BytesRead: NativeUInt;
  OldProtect: DWORD;
begin
BytesRead:=lng;
  hProcess := OpenProcess(PROCESS_ALL_ACCESS, False, ProcessID);
  // снятие защиты
  VirtualProtectEx(hProcess, adr, lng, PAGE_EXECUTE_READWRITE, @OldProtect);
  if WriteProcessMemory(hProcess, adr, addr(bt), lng, BytesRead) then
    Result := True
  else
    Result := False;
  // возврат
  VirtualProtectEx(hProcess, adr, lng, OldProtect, @OldProtect);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if Button2.Caption = 'Loot' then
  begin
    wnd := FindWindow(nil, 'RF Online');
    if wnd <> 0 then
    begin
      Button2.Caption := 'StopL';
      if CheckBox1.Checked then
        Timer1.Interval := 5
      else
        Timer1.Interval := 100;
      Timer1.Enabled := True;
    end
    else
    begin
      Button2.Caption := 'Loot';
      Timer1.Enabled := False;
    end;
  end
  else
  begin
    Button2.Caption := 'Loot';
    Timer1.Enabled := False;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
if CheckBox3.Checked  then
begin
PatchWeapon('Ж'+Edit2.Text);
PatchWeapon('Ж'+Edit2.Text);
end;
if CheckBox4.Checked  then
 PatchWeapon('Т'+Edit2.Text);
 if CheckBox6.Checked  then
PatchWeapon('Л'+Edit2.Text);
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Edit1.Text := IntToStr(Key);
end;

function TForm1.FindString(ProcessID: DWORD; RangeFrom, RangeTo: DWORD;
  StringToFind: AnsiString): Pointer;
const
  BufferSize = 1000;
var
  hProcess: DWORD;
  BytesRead: NativeUInt;
  BytesToRead: DWORD;
  I: DWORD;
  Buffer: Array Of AnsiChar;
  OldProtect: DWORD;
  ps: integer;
 // adrP: Pointer;
begin
Result:=0;
  If (RangeTo - RangeFrom) < 1 Then
  begin
    ShowMessage('Invalid Ranges');
    Exit;
  end;
  hProcess := OpenProcess(PROCESS_VM_READ, False, ProcessID);
  If hProcess = 0 Then
  begin
    ShowMessage(SysErrorMessage(GetLastError));
    Exit;
  end;
  Try
    SetLength(Buffer, BufferSize);
    Try
      I := RangeFrom;
      While (I < RangeTo) Do
      begin
        BytesToRead := BufferSize;
        If (RangeTo - I) < BytesToRead Then
        begin
          BytesToRead := RangeTo - I;
        end;
        VirtualProtectEx(hProcess, Pointer(I), BytesToRead, PAGE_READWRITE,
          OldProtect);
        ReadProcessMemory(hProcess, Pointer(I), @Buffer[0], BytesToRead,
          BytesRead);
        ps := Pos(StringToFind, AnsiString(Buffer));
        If ps > 0 Then
        begin
          // Комменты - вывод то что ищем - текст
          // SetLength(Result, 100);
          // Move(Buffer[Pos(StringToFind, AnsiString(Buffer)) - 1], Result[1], 100);
          // adrF := '$' + IntTOHex(I + ps - 3, Sizeof(I));  ------вывод адреса (String)
          Result := ptr(I + ps - 3);
          VirtualProtectEx(hProcess, Pointer(I), BytesToRead, OldProtect,
            OldProtect);
          Break;
        end;
        Inc(I, BytesToRead);
      end;
    Finally
      Buffer := nil;
    end;
  Finally
    CloseHandle(hProcess);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
Var
ThreadId: integer;
addrs : Cardinal;
ipBase: Cardinal;
   ipb,pb,addr1,addr2: Cardinal;
   Sl,ProcessId:integer;
   wpid,count: Cardinal;
   numberRead: UInt64;
     BytesRead: NativeUInt;
  BytesToRead: DWORD;
  OldProtect: DWORD;
  addr0:UInt64;
begin
//wnd:=FindWindow(nil, 'RF Online');
 //  ThreadId := GetWindowThreadProcessId(wnd,@ProcessId);
 //  wpid:= OpenProcess(PROCESS_ALL_ACCESS,False,ProcessId);
 //  ipBase:=$01CFA8F8;

//          VirtualProtectEx(wpid, Pointer(ipBase), BytesToRead, PAGE_READWRITE,OldProtect);
//        ReadProcessMemory(wpid, Pointer(ipBase), @addr0, BytesToRead,
//          BytesRead);
 ///  //ReadProcessMemory(wpid, Pointer(ipBase),@addr0,16, numberRead);
 //  addr2:=$07504D90;
 //  ipb:=addr0+$10;
 //  VirtualProtectEx(wpid, Pointer(ipb), BytesToRead, PAGE_READWRITE,OldProtect);
 //       ReadProcessMemory(wpid, Pointer(ipb), Addr(Sl), 16,
 //         BytesRead);
 //  //ReadProcessMemory(wpid, Pointer(ipb), Addr(Sl), 4, numberRead);
 //  ShowMessage(IntToStr(SL));
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  // SetForegroundWindow(wnd);
  PostMessage(wnd, WM_SETFOCUS, 0, 0);
  PostMessage(wnd, WM_KEYDOWN, StrToInt(Edit1.Text), 0);
end;

function TForm1.gPid(exename: string): integer;
var
  ProcessID: DWORD;
  wHandle: integer;
begin
  wHandle := FindWindow(nil, PWideChar(exename));
  if wHandle <> 0 then
  begin
    GetWindowThreadProcessId(wHandle, @ProcessID);
    Result := ProcessID;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
Memo1.Lines.Add('---Осадный Набор [30лвл]---');
 PatchOsad('kОсадный Набор');
 Memo1.Lines.Add('---Осадный Набор [40лвл]---');
 PatchOsad('kУлучшенный Осадный Набор');
  Memo1.Lines.Add('---Осадный Набор [45лвл]---');
 PatchOsad('kЭпохальный Ракетометный');
 PatchOsad('kЭпохальный Огнеметный');
end;

end.
