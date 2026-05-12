unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  TAGraph, TASeries, TASources, TATools, Types, TAChartUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    chPoints: TChart;
    chPointsLineSeries1: TLineSeries;
    ctPoints: TChartToolset;
    ctPointsDataPointDragTool1: TDataPointDragTool;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ctPointsDataPointDragTool1AfterMouseUp(ATool: TChartTool;
      APoint: TPoint);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  XY: array[0..9, 0..1] of double;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
  P_:integer;
begin
  Label1.Caption:='# X:Y';
  RandSeed := 675402;
  chPointsLineSeries1.Clear;
  for i := 1 to 10 do
  BEGIN
    P_:=i-1;
    //chPointsLineSeries1.AddXY(i, Random(20) - 10);
    chPointsLineSeries1.AddXY(P_, (i*i)-(2*P_));
    XY[P_,0]:=chPointsLineSeries1.GetXValue(i-1);
    XY[P_,1]:=chPointsLineSeries1.GetYValue(i-1);
    Label1.Caption:=Label1.Caption+chr(13)+i.ToString + ' ' + FormatFloat('0.00',chPointsLineSeries1.GetXValue(P_)) + ':' + FormatFloat('0.00',chPointsLineSeries1.GetYValue(P_));
  end;

end;

procedure TForm1.ctPointsDataPointDragTool1AfterMouseUp(ATool: TChartTool; APoint: TPoint);
var
  i: Integer;
  P_:integer;
  Check_:boolean;
begin
  Label1.Caption:='# X:Y';
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

    Label1.Caption:=Label1.Caption+chr(13)+P_.ToString + ' ' + FormatFloat('0.00',chPointsLineSeries1.GetXValue(i)) + ':' + FormatFloat('0.00',chPointsLineSeries1.GetYValue(i));
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
  P_:integer;
begin
  Label1.Caption:='# X:Y';
  chPointsLineSeries1.Clear;
  for i := 1 to 10 do
  begin
    P_:=i-1;
    chPointsLineSeries1.AddXY(P_, P_*10);
    XY[P_,0]:=chPointsLineSeries1.GetXValue(i-1);
    XY[P_,1]:=chPointsLineSeries1.GetYValue(i-1);
    Label1.Caption:=Label1.Caption+chr(13)+i.ToString + ' ' + FormatFloat('0.00',chPointsLineSeries1.GetXValue(P_)) + ':' + FormatFloat('0.00',chPointsLineSeries1.GetYValue(P_));
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i: Integer;
  P_:integer;
begin
  Label1.Caption:='# X:Y';
  chPointsLineSeries1.Clear;
  for i := 1 to 10 do
  begin
    P_:=i-1;
    chPointsLineSeries1.AddXY(P_, (i*i)-(2*P_));
    XY[P_,0]:=chPointsLineSeries1.GetXValue(i-1);
    XY[P_,1]:=chPointsLineSeries1.GetYValue(i-1);
    Label1.Caption:=Label1.Caption+chr(13)+i.ToString + ' ' + FormatFloat('0.00',chPointsLineSeries1.GetXValue(P_)) + ':' + FormatFloat('0.00',chPointsLineSeries1.GetYValue(P_));
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i: Integer;
  P_:integer;
begin
  Label1.Caption:='# X:Y';
  chPointsLineSeries1.Clear;
  for i := 1 to 10 do
  begin
    P_:=i-1;
    chPointsLineSeries1.AddXY(P_, 100-(i*i));
    XY[P_,0]:=chPointsLineSeries1.GetXValue(i-1);
    XY[P_,1]:=chPointsLineSeries1.GetYValue(i-1);
    Label1.Caption:=Label1.Caption+chr(13)+i.ToString + ' ' + FormatFloat('0.00',chPointsLineSeries1.GetXValue(P_)) + ':' + FormatFloat('0.00',chPointsLineSeries1.GetYValue(P_));
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i: Integer;
  P_:integer;
begin
  Label1.Caption:='# X:Y';
  chPointsLineSeries1.Clear;
  for i := 1 to 10 do
  begin
    P_:=i-1;
    chPointsLineSeries1.AddXY(P_, 100/(i*i));
    XY[P_,0]:=chPointsLineSeries1.GetXValue(i-1);
    XY[P_,1]:=chPointsLineSeries1.GetYValue(i-1);
    Label1.Caption:=Label1.Caption+chr(13)+i.ToString + ' ' + FormatFloat('0.00',chPointsLineSeries1.GetXValue(P_)) + ':' + FormatFloat('0.00',chPointsLineSeries1.GetYValue(P_));
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  i: Integer;
  P_:integer;
begin
  Label1.Caption:='# X:Y';
  chPointsLineSeries1.Clear;
  for i := 1 to 10 do
  begin
    P_:=i-1;
    chPointsLineSeries1.AddXY(P_, (10-P_)*10);
    XY[P_,0]:=chPointsLineSeries1.GetXValue(i-1);
    XY[P_,1]:=chPointsLineSeries1.GetYValue(i-1);
    Label1.Caption:=Label1.Caption+chr(13)+i.ToString + ' ' + FormatFloat('0.00',chPointsLineSeries1.GetXValue(P_)) + ':' + FormatFloat('0.00',chPointsLineSeries1.GetYValue(P_));
  end;
end;

end.

