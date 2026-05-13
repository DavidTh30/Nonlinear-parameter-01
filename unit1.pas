unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  DBGrids, Grids, TAGraph, TASeries, TASources, TATools,
  Types, TAChartUtils, FileUtil, LCLType, IniFiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button11: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    chPoints: TChart;
    chPointsLineSeries1: TLineSeries;
    ClearName1: TButton;
    ClearName2: TButton;
    ctPoints: TChartToolset;
    ctPointsDataPointDragTool1: TDataPointDragTool;
    Edit41: TEdit;
    Edit42: TEdit;
    Edit43: TEdit;
    Edit44: TEdit;
    Edit45: TEdit;
    Edit46: TEdit;
    Edit47: TEdit;
    Edit48: TEdit;
    Edit49: TEdit;
    Edit50: TEdit;
    Edit61: TEdit;
    Edit51: TEdit;
    Edit62: TEdit;
    Edit52: TEdit;
    Edit53: TEdit;
    Edit54: TEdit;
    Edit55: TEdit;
    Edit56: TEdit;
    Edit57: TEdit;
    Edit58: TEdit;
    Edit59: TEdit;
    Edit60: TEdit;
    GroupBox3: TGroupBox;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    StringGrid1: TStringGrid;
    procedure Button11Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure ClearName1Click(Sender: TObject);
    procedure ClearName2Click(Sender: TObject);
    procedure ctPointsDataPointDragTool1AfterMouseUp(ATool: TChartTool;
      APoint: TPoint);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure StringGrid1EditingDone(Sender: TObject);
  private

  public
    function StrIntToStr(Sender: string): string;
    function StrFloatToStr(Sender: string): string;
    Function CheckDirectory(C_DNAME: string;Debug_:TMemo):boolean; //True=Error
  end;

var
  Form1: TForm1;
  XY: array[0..9, 0..1] of double;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.StrIntToStr(Sender: string): string;
var
  i:integer;
begin
  i:=0;
  Try
    i:=StrToInt(Sender);
  except
    On E : EConvertError do
      i:=0;
  end;
  result:= IntToStr(i);
end;

function TForm1.StrFloatToStr(Sender: string): string;
var
  i:double;
begin
  i:=0;
  Try
    i:=StrToFloat(Sender);
  except
    On E : EConvertError do
      i:=0;
  end;
  result:= FloatToStr(i);
end;

Function TForm1.CheckDirectory(C_DNAME: string;Debug_:TMemo):boolean; //True=Error
begin

  result:= false;

  if(C_DNAME<>'')then
  if Not DirectoryExists(C_DNAME) Then
  begin
    {$I-}
    //{$I-} or {$IOCHECKS OFF}
    //{$I-} rewrite (f); {$I+}
    //if IOResult<>0 then begin Writeln ('Error opening file: "file.txt"'); exit; end;
    mkdir(C_DNAME);
    {$I+}
    if IOResult<>0 then
    begin
      Debug_.Append('Directory '+C_DNAME+' error occurred. Details: '+ EInOutError.ClassName);
      ShowMessage('Cannot create '+C_DNAME+' directory. Details: '+ EInOutError.ClassName);
      result:= true;
    end;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
  FileList: TStringList;
  P_: Integer;
begin

  if CheckDirectory('Parameter',Memo1) then begin Showmessage('Folder Parameter Error'); Application.Terminate; end;

  ListBox1.Clear;

  FileList := FindAllFiles(GetCurrentDir+'\Parameter', '*', True);
  try
    //ShowMessage('Found ' + IntToStr(FileList.Count) + ' files.');
    if FileList.Count > 0 then
    begin
      for i := 0 to FileList.Count-1 do
      begin
        //P_ := Pos('.Parameter', FileList.Strings[i]);
        P_:=pos('.parameter',LowerCase(FileList.Strings[i]));
        if (P_ >=1) then ListBox1.Items.Add(ExtractFileName(FileList.Strings[i]));
      end;
    end;
  finally
    FileList.Free;
  end;

  ListBox1.ItemIndex:=-1;

  //Label1.Caption:='# X:Y';
  RandSeed := 675402;
  chPointsLineSeries1.Clear;
  for i := 1 to 10 do
  begin
    P_:=i-1;
    //chPointsLineSeries1.AddXY(i, Random(20) - 10);
    chPointsLineSeries1.AddXY(P_, (i*i)-(2*P_));
    XY[P_,0]:=chPointsLineSeries1.GetXValue(P_);
    XY[P_,1]:=chPointsLineSeries1.GetYValue(P_);
    //Label1.Caption:=Label1.Caption+chr(13)+i.ToString + ' ' + FormatFloat('0.00',chPointsLineSeries1.GetXValue(P_)) + ':' + FormatFloat('0.00',chPointsLineSeries1.GetYValue(P_));
  end;

  StringGrid1.Cells[2,10]:='33';
  StringGrid1.ColWidths[0]:=20;
  StringGrid1.ColWidths[1]:=56;
  StringGrid1.ColWidths[2]:=56;
  //StringGrid1.RowCount:=11;
  //StringGrid1.ColCount:=3;

  StringGrid1.Cells[1,0]:='X';
  StringGrid1.Cells[2,0]:='Y';
  for i := 1 to 10 do
  begin
    StringGrid1.Cells[0,i]:=i.ToString;
    StringGrid1.Cells[1,i]:=  FormatFloat('0.00',XY[i-1,0]);
    StringGrid1.Cells[2,i]:=  FormatFloat('0.00',XY[i-1,1]);
  end;

  //StringGrid1.Refresh;
  //StringGrid1.Repaint;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
var
  i:integer;
  s: string;
  MyIni: TIniFile;
  //User: string;
  //Attempts: Integer;
  //IsActive: Boolean;
begin
  if (ListBox1.ItemIndex<0) then exit;
  if CheckDirectory('Parameter',Memo1) then begin Showmessage('Folder Parameter Error'); exit; end;

  s:= GetCurrentDir+'\Parameter\'+ ListBox1.Items[ListBox1.ItemIndex];
  Edit61.Text:=ListBox1.Items[ListBox1.ItemIndex];

  if FileExists(s) then
  begin
    MyIni := TIniFile.Create(s);
    try
      //MyIni.WriteString('User-Settings', 'Username', 'gfgg');
      //MyIni.WriteInteger('DB-INFO', 'MaxAttempts', 255522);
      //MyIni.WriteBool('Settings', 'AutoLogin', true);
      //User := MyIni.ReadString('User-Settings', 'Username', 'Guest');
      //Attempts := MyIni.ReadInteger('DB-INFO', 'MaxAttempts', 3);
      //IsActive := MyIni.ReadBool('Settings', 'AutoLogin', False);

      chPointsLineSeries1.Clear;
      for i:=1 to 10 do
      begin
        StringGrid1.Cells[1,i] := FormatFloat('0.00',StrToFloat(StrFloatToStr(MyIni.ReadString('XY', 'X'+i.ToString, '0.00'))));
        StringGrid1.Cells[2,i] := FormatFloat('0.00',StrToFloat(StrFloatToStr(MyIni.ReadString('XY', 'Y'+i.ToString, '0.00'))));

        chPointsLineSeries1.AddXY(StrToFloat(StringGrid1.Cells[1,i]),StrToFloat(StringGrid1.Cells[2,i]));
        XY[i-1,0]:=chPointsLineSeries1.GetXValue(i-1);
        XY[i-1,1]:=chPointsLineSeries1.GetYValue(i-1);
      end;
    finally
      // Always free the object
      MyIni.Free;
    end;
  end
  else
  begin
    Showmessage('File not found');
  end;
end;

procedure TForm1.StringGrid1EditingDone(Sender: TObject);
var
  i:integer;
  P_:integer;
  Check_:boolean;
begin
  chPointsLineSeries1.Clear;
      for i:=1 to 10 do
      begin
        StringGrid1.Cells[1,i] := FormatFloat('0.00',StrToFloat(StrFloatToStr(StringGrid1.Cells[1,i])));
        StringGrid1.Cells[2,i] := FormatFloat('0.00',StrToFloat(StrFloatToStr(StringGrid1.Cells[2,i])));

        chPointsLineSeries1.AddXY(StrToFloat(StringGrid1.Cells[1,i]),StrToFloat(StringGrid1.Cells[2,i]));
        //XY[i-1,0]:=chPointsLineSeries1.GetXValue(i-1);
        //XY[i-1,1]:=chPointsLineSeries1.GetYValue(i-1);
      end;

  for i := 0 to 9 do
  begin
    Check_:=false;
    if (chPointsLineSeries1.GetXValue(i)>10) then  chPointsLineSeries1.SetXValue(i,10);
    if (chPointsLineSeries1.GetXValue(i)<0) then  chPointsLineSeries1.SetXValue(i,0);
    if (chPointsLineSeries1.GetYValue(i)>100) then  chPointsLineSeries1.SetYValue(i,100);
    if (chPointsLineSeries1.GetYValue(i)<0) then  chPointsLineSeries1.SetYValue(i,0);
    if (XY[i,0]<>chPointsLineSeries1.GetXValue(i)) then  Check_:=true;
    if (XY[i,1]<>chPointsLineSeries1.GetYValue(i)) then  Check_:=true;

    P_:=i+1;


    if ((i>=0) and (i<=8) and Check_) then
    begin
      if (chPointsLineSeries1.GetXValue(i)>chPointsLineSeries1.GetXValue(i+1)) then
      begin
        chPointsLineSeries1.SetXValue(i,chPointsLineSeries1.GetXValue(i+1)-0.1);
        //Label1.Caption:=Label1.Caption+chr(13)+P_.ToString + '>>';
      end;
    end;
    if ((i>=1) and (i<=9) and Check_) then
    begin
      if (chPointsLineSeries1.GetXValue(i)<chPointsLineSeries1.GetXValue(i-1)) then
      begin
        chPointsLineSeries1.SetXValue(i,chPointsLineSeries1.GetXValue(i-1)+0.1);
        //Label1.Caption:=Label1.Caption+chr(13)+P_.ToString + '<<';
      end;
    end;

    //Label1.Caption:=Label1.Caption+chr(13)+P_.ToString + ' ' + FormatFloat('0.00',chPointsLineSeries1.GetXValue(i)) + ':' + FormatFloat('0.00',chPointsLineSeries1.GetYValue(i));
    XY[i,0]:=chPointsLineSeries1.GetXValue(i);
    XY[i,1]:=chPointsLineSeries1.GetYValue(i);
    StringGrid1.Cells[1,P_]:=  FormatFloat('0.00',XY[i,0]);
    StringGrid1.Cells[2,P_]:=  FormatFloat('0.00',XY[i,1]);
  end;
end;

procedure TForm1.ctPointsDataPointDragTool1AfterMouseUp(ATool: TChartTool; APoint: TPoint);
var
  i: Integer;
  P_:integer;
  Check_:boolean;
begin
  //Label1.Caption:='# X:Y';
  for i := 0 to 9 do
  begin
    Check_:=false;
    chPointsLineSeries1.SetXValue(i,StrToFloat(FormatFloat('0.00',chPointsLineSeries1.GetXValue(i))));
    chPointsLineSeries1.SetYValue(i,StrToFloat(FormatFloat('0.00',chPointsLineSeries1.GetYValue(i))));

    if (chPointsLineSeries1.GetXValue(i)>10) then  chPointsLineSeries1.SetXValue(i,10);
    if (chPointsLineSeries1.GetXValue(i)<0) then  chPointsLineSeries1.SetXValue(i,0);
    if (chPointsLineSeries1.GetYValue(i)>100) then  chPointsLineSeries1.SetYValue(i,100);
    if (chPointsLineSeries1.GetYValue(i)<0) then  chPointsLineSeries1.SetYValue(i,0);
    if (XY[i,0]<>chPointsLineSeries1.GetXValue(i)) then  Check_:=true;
    if (XY[i,1]<>chPointsLineSeries1.GetYValue(i)) then  Check_:=true;

    P_:=i+1;


    if ((i>=0) and (i<=8) and Check_) then
    begin
      if (chPointsLineSeries1.GetXValue(i)>chPointsLineSeries1.GetXValue(i+1)) then
      begin
        chPointsLineSeries1.SetXValue(i,chPointsLineSeries1.GetXValue(i+1)-0.1);
        //Label1.Caption:=Label1.Caption+chr(13)+P_.ToString + '>>';
      end;
    end;
    if ((i>=1) and (i<=9) and Check_) then
    begin
      if (chPointsLineSeries1.GetXValue(i)<chPointsLineSeries1.GetXValue(i-1)) then
      begin
        chPointsLineSeries1.SetXValue(i,chPointsLineSeries1.GetXValue(i-1)+0.1);
        //Label1.Caption:=Label1.Caption+chr(13)+P_.ToString + '<<';
      end;
    end;

    //Label1.Caption:=Label1.Caption+chr(13)+P_.ToString + ' ' + FormatFloat('0.00',chPointsLineSeries1.GetXValue(i)) + ':' + FormatFloat('0.00',chPointsLineSeries1.GetYValue(i));
    XY[i,0]:=chPointsLineSeries1.GetXValue(i);
    XY[i,1]:=chPointsLineSeries1.GetYValue(i);
    StringGrid1.Cells[1,P_]:=  FormatFloat('0.00',XY[i,0]);
    StringGrid1.Cells[2,P_]:=  FormatFloat('0.00',XY[i,1]);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
  P_:integer;
begin
  //Label1.Caption:='# X:Y';
  chPointsLineSeries1.Clear;
  for i := 1 to 10 do
  begin
    P_:=i-1;
    chPointsLineSeries1.AddXY(P_, P_*10);
    XY[P_,0]:=chPointsLineSeries1.GetXValue(i-1);
    XY[P_,1]:=chPointsLineSeries1.GetYValue(i-1);
    StringGrid1.Cells[1,i]:=  FormatFloat('0.00',XY[P_,0]);
    StringGrid1.Cells[2,i]:=  FormatFloat('0.00',XY[P_,1]);
    //Label1.Caption:=Label1.Caption+chr(13)+i.ToString + ' ' + FormatFloat('0.00',chPointsLineSeries1.GetXValue(P_)) + ':' + FormatFloat('0.00',chPointsLineSeries1.GetYValue(P_));
  end;
  //edit41.Caption:=XY[0,0].ToString;
  //edit51.Caption:=XY[0,0].ToString;
end;

procedure TForm1.Button11Click(Sender: TObject);
var
  i:integer;
  FileList: TStringList;
  P_: Integer;
  s:string;
begin

  if CheckDirectory('Parameter',Memo1) then begin Showmessage('Folder Parameter Error'); ListBox1.Clear; exit; end;

  if (ListBox1.ItemIndex>=0) then
    s:=ListBox1.Items[ListBox1.ItemIndex]
  else
    s:='';

  ListBox1.Clear;

  FileList := FindAllFiles(GetCurrentDir+'\Parameter', '*', True);
  try
    //ShowMessage('Found ' + IntToStr(FileList.Count) + ' files.');
    if FileList.Count > 0 then
    begin
      for i := 0 to FileList.Count-1 do
      begin
        //P_ := Pos('.Parameter', FileList.Strings[i]);
        P_:=pos('.parameter',LowerCase(FileList.Strings[i]));
        if (P_ >=1) then ListBox1.Items.Add(ExtractFileName(FileList.Strings[i]));
      end;
    end;
  finally
    FileList.Free;
  end;

  ListBox1.ItemIndex:=-1;

  for i:=0 to  ListBox1.Count-1 do
  begin
    if (ListBox1.Items[i]=s) then  begin ListBox1.ItemIndex:=i; Break; end;
  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i: Integer;
  P_:integer;
begin
  //Label1.Caption:='# X:Y';
  chPointsLineSeries1.Clear;
  for i := 1 to 10 do
  begin
    P_:=i-1;
    chPointsLineSeries1.AddXY(P_, (i*i)-(2*P_));
    XY[P_,0]:=chPointsLineSeries1.GetXValue(i-1);
    XY[P_,1]:=chPointsLineSeries1.GetYValue(i-1);
    StringGrid1.Cells[1,i]:=  FormatFloat('0.00',XY[P_,0]);
    StringGrid1.Cells[2,i]:=  FormatFloat('0.00',XY[P_,1]);
    //Label1.Caption:=Label1.Caption+chr(13)+i.ToString + ' ' + FormatFloat('0.00',chPointsLineSeries1.GetXValue(P_)) + ':' + FormatFloat('0.00',chPointsLineSeries1.GetYValue(P_));
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i: Integer;
  P_:integer;
begin
  //Label1.Caption:='# X:Y';
  chPointsLineSeries1.Clear;
  for i := 1 to 10 do
  begin
    P_:=i-1;
    chPointsLineSeries1.AddXY(P_, 100-(i*i));
    XY[P_,0]:=chPointsLineSeries1.GetXValue(i-1);
    XY[P_,1]:=chPointsLineSeries1.GetYValue(i-1);
    StringGrid1.Cells[1,i]:=  FormatFloat('0.00',XY[P_,0]);
    StringGrid1.Cells[2,i]:=  FormatFloat('0.00',XY[P_,1]);
    //Label1.Caption:=Label1.Caption+chr(13)+i.ToString + ' ' + FormatFloat('0.00',chPointsLineSeries1.GetXValue(P_)) + ':' + FormatFloat('0.00',chPointsLineSeries1.GetYValue(P_));
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i: Integer;
  P_:integer;
begin
  //Label1.Caption:='# X:Y';
  chPointsLineSeries1.Clear;
  for i := 1 to 10 do
  begin
    P_:=i-1;
    chPointsLineSeries1.AddXY(P_, 100/(i*1.01));
    XY[P_,0]:=chPointsLineSeries1.GetXValue(i-1);
    XY[P_,1]:=chPointsLineSeries1.GetYValue(i-1);
    StringGrid1.Cells[1,i]:=  FormatFloat('0.00',XY[P_,0]);
    StringGrid1.Cells[2,i]:=  FormatFloat('0.00',XY[P_,1]);
    //Label1.Caption:=Label1.Caption+chr(13)+i.ToString + ' ' + FormatFloat('0.00',chPointsLineSeries1.GetXValue(P_)) + ':' + FormatFloat('0.00',chPointsLineSeries1.GetYValue(P_));
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  i: Integer;
  P_:integer;
begin
  //Label1.Caption:='# X:Y';
  chPointsLineSeries1.Clear;
  for i := 1 to 10 do
  begin
    P_:=i-1;
    chPointsLineSeries1.AddXY(P_, (10-P_)*10);
    XY[P_,0]:=chPointsLineSeries1.GetXValue(i-1);
    XY[P_,1]:=chPointsLineSeries1.GetYValue(i-1);
    StringGrid1.Cells[1,i]:=  FormatFloat('0.00',XY[P_,0]);
    StringGrid1.Cells[2,i]:=  FormatFloat('0.00',XY[P_,1]);
    //Label1.Caption:=Label1.Caption+chr(13)+i.ToString + ' ' + FormatFloat('0.00',chPointsLineSeries1.GetXValue(P_)) + ':' + FormatFloat('0.00',chPointsLineSeries1.GetYValue(P_));
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  s_Source:string;
  s_Modify:string;
  i:integer;
  p_:integer;
  ResultCode:integer;
begin
  if (ListBox1.ItemIndex<0) then begin Showmessage('No file select'); exit;  end;

  //if (trim(Edit61.Text) ='') then begin Showmessage('No file to save'); exit; end;
  if (trim(Edit61.Text) ='') then begin Edit61.Text:=FormatDateTime('DD',  Now)+'_'+FormatDateTime('MM',  Now)+'_'+FormatDateTime('YYYY',  Now)+'_'+FormatDateTime('hh',  Now)+'_'+FormatDateTime('nn',  Now)+'_'+FormatDateTime('ss',  Now) end;
  p_:=pos('.',LowerCase(Edit61.Text));
  if (p_=1) then begin Showmessage('error file name'); exit; end;
  p_:=pos('<',LowerCase(Edit61.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;
  p_:=pos('>',LowerCase(Edit61.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;
  p_:=pos('?',LowerCase(Edit61.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;
  p_:=pos(':',LowerCase(Edit61.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;
  p_:=pos('/',LowerCase(Edit61.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;
  p_:=pos('\',LowerCase(Edit61.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;

  p_:=pos('.parameter',LowerCase(Edit61.Text));
  if (p_>1) then
    Edit61.Text := Edit61.Text
  else
    Edit61.Text := Edit61.Text+'.Parameter';

  s_Source:= GetCurrentDir+'\Parameter\'+ ListBox1.Items[ListBox1.ItemIndex];
  s_Modify:= GetCurrentDir+'\Parameter\'+ Edit61.Text;

  if not FileExists(s_Source) then
  begin
    Showmessage('File not exists');
  end
  else
  begin

    ResultCode := Application.MessageBox('Rename parameter' + sLineBreak + '!!!', 'Confirm',MB_ICONQUESTION + MB_YESNO);
    if (ResultCode = IDYES) then
    begin  end
    else
    begin exit; end;

    if RenameFile(PChar(s_Source),PChar(s_Modify)) then
    begin
      Showmessage('File renamed successfully');
    end
    else
      Showmessage('Error: Unable to renamed file');
  end;

  ListBox1.ItemIndex:=-1;
  Button11Click(Sender);
  if FileExists(s_Modify) then
  for i:=0 to ListBox1.Count-1 do
  begin
    if (ListBox1.Items[i] = Edit61.Text  ) then  begin ListBox1.ItemIndex:=i; Break; end;
  end;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  i:integer;
  s: string;
  p_:integer;
  MyIni: TIniFile;
  //User: string;
  //Attempts: Integer;
  //IsActive: Boolean;
  ResultCode: Integer;
begin
  //if (trim(Edit62.Text) ='') then begin Showmessage('No file to save'); exit; end;
  if (trim(Edit62.Text) ='') then begin Edit62.Text:=FormatDateTime('DD',  Now)+'_'+FormatDateTime('MM',  Now)+'_'+FormatDateTime('YYYY',  Now)+'_'+FormatDateTime('hh',  Now)+'_'+FormatDateTime('nn',  Now)+'_'+FormatDateTime('ss',  Now) end;
  p_:=pos('.',LowerCase(Edit62.Text));
  if (p_=1) then begin Showmessage('error file name'); exit; end;
  p_:=pos('<',LowerCase(Edit62.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;
  p_:=pos('>',LowerCase(Edit62.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;
  p_:=pos('?',LowerCase(Edit62.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;
  p_:=pos(':',LowerCase(Edit62.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;
  p_:=pos('/',LowerCase(Edit62.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;
  p_:=pos('\',LowerCase(Edit62.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;

  if CheckDirectory('Parameter',Memo1) then begin Showmessage('Folder Parameter Error'); exit; end;

  p_:=pos('.parameter',LowerCase(Edit62.Text));
  if (p_>1) then
    Edit62.Text:= Edit62.Text
  else
    Edit62.Text:= Edit62.Text+'.Parameter';

  s:= GetCurrentDir+'\Parameter\'+ Edit62.Text;

  if FileExists(s) then
  begin
    ResultCode := Application.MessageBox('Over write file?' + sLineBreak + '!!!', 'Confirm',MB_ICONQUESTION + MB_YESNO);
    if (ResultCode = IDYES) then
      begin  end
    else
      begin exit; end;
  end;

  //if FileExists(s) then
  //begin
    MyIni := TIniFile.Create(s);
    try
      //MyIni.WriteString('User-Settings', 'Username', 'gfgg');
      //MyIni.WriteInteger('DB-INFO', 'MaxAttempts', 255522);
      //MyIni.WriteBool('Settings', 'AutoLogin', true);
      //User := MyIni.ReadString('User-Settings', 'Username', 'Guest');
      //Attempts := MyIni.ReadInteger('DB-INFO', 'MaxAttempts', 3);
      //IsActive := MyIni.ReadBool('Settings', 'AutoLogin', False);

      for i:=1 to 10 do
      begin
        MyIni.WriteString('XY', 'X'+i.ToString, StrFloatToStr(StringGrid1.Cells[1,i]));
        MyIni.WriteString('XY', 'Y'+i.ToString, StrFloatToStr(StringGrid1.Cells[2,i]));

      end;


    finally
      // Always free the object
      MyIni.Free;
    end;
  //end
  //else
  if not FileExists(s) then
  begin
    Showmessage('Can not save file');
  end
  else
    Button11Click(Sender);

end;

procedure TForm1.Button8Click(Sender: TObject);
var
  s:string;
  ResultCode:integer;
begin
  if (ListBox1.ItemIndex<0) then begin Showmessage('No file select'); exit;  end;

  s:= GetCurrentDir+'\Parameter\'+ ListBox1.Items[ListBox1.ItemIndex];

  if not FileExists(s) then
  begin
    Showmessage('File not exists');
  end
  else
  begin

    ResultCode := Application.MessageBox('Delete parameter' + sLineBreak + '!!!', 'Confirm',MB_ICONQUESTION + MB_YESNO);
    if (ResultCode = IDYES) then
    begin  end
    else
    begin exit; end;

    if DeleteFile(PChar(s)) then
      Showmessage('File deleted successfully')
    else
      Showmessage('Error: Unable to delete file');
  end;
  ListBox1.ItemIndex:=-1;
  Button11Click(Sender);
end;

procedure TForm1.Button9Click(Sender: TObject);
var
  i:integer;
  s: string;
  p_:integer;
  MyIni: TIniFile;
  //User: string;
  //Attempts: Integer;
  //IsActive: Boolean;
  ResultCode: Integer;
begin
  //if (trim(Edit61.Text) ='') then begin Showmessage('No file to save'); exit; end;
  if (trim(Edit61.Text) ='') then begin Edit61.Text:=FormatDateTime('DD',  Now)+'_'+FormatDateTime('MM',  Now)+'_'+FormatDateTime('YYYY',  Now)+'_'+FormatDateTime('hh',  Now)+'_'+FormatDateTime('nn',  Now)+'_'+FormatDateTime('ss',  Now) end;
  p_:=pos('.',LowerCase(Edit61.Text));
  if (p_=1) then begin Showmessage('error file name'); exit; end;
  p_:=pos('<',LowerCase(Edit61.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;
  p_:=pos('>',LowerCase(Edit61.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;
  p_:=pos('?',LowerCase(Edit61.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;
  p_:=pos(':',LowerCase(Edit61.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;
  p_:=pos('/',LowerCase(Edit61.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;
  p_:=pos('\',LowerCase(Edit61.Text));
  if (p_>0) then begin Showmessage('error file name'); exit; end;

  if CheckDirectory('Parameter',Memo1) then begin Showmessage('Folder Parameter Error'); exit; end;

  p_:=pos('.parameter',LowerCase(Edit61.Text));
  if (p_>1) then
    Edit61.Text:= Edit61.Text
  else
    Edit61.Text:= Edit61.Text+'.Parameter';

  s:= GetCurrentDir+'\Parameter\'+ Edit61.Text;

  if FileExists(s) then
  begin
    ResultCode := Application.MessageBox('Over write file?' + sLineBreak + '!!!', 'Confirm',MB_ICONQUESTION + MB_YESNO);
    if (ResultCode = IDYES) then
      begin  end
    else
      begin exit; end;
  end;

  //if FileExists(s) then
  //begin
    MyIni := TIniFile.Create(s);
    try
      //MyIni.WriteString('User-Settings', 'Username', 'gfgg');
      //MyIni.WriteInteger('DB-INFO', 'MaxAttempts', 255522);
      //MyIni.WriteBool('Settings', 'AutoLogin', true);
      //User := MyIni.ReadString('User-Settings', 'Username', 'Guest');
      //Attempts := MyIni.ReadInteger('DB-INFO', 'MaxAttempts', 3);
      //IsActive := MyIni.ReadBool('Settings', 'AutoLogin', False);

      for i:=1 to 10 do
      begin
        MyIni.WriteString('XY', 'X'+i.ToString, StrFloatToStr(StringGrid1.Cells[1,i]));
        MyIni.WriteString('XY', 'Y'+i.ToString, StrFloatToStr(StringGrid1.Cells[2,i]));

      end;


    finally
      // Always free the object
      MyIni.Free;
    end;
  //end
  //else
  if not FileExists(s) then
  begin
    Showmessage('Can not save file');
  end
  else
    Button11Click(Sender);

end;

procedure TForm1.ClearName1Click(Sender: TObject);
begin
  Edit62.Caption:='';
end;

procedure TForm1.ClearName2Click(Sender: TObject);
begin
  Edit61.Caption:='';
end;

end.

