unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, game;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure GenLine;
    procedure Draw;
  private

  public

  end;

var
  Form1: TForm1;
  // Цвета блока в зависимотсти от его массы: 1, 2-5, 6-9, 10-15, 16-25, 25+
  Clrs: array of Tcolor = ($63FF8D, $52ffd7, $00ffe1, $ff00e6, $ffe100, $ff0000);
  Blocks: array[0..63] of TBlock;
  dx:integer = 5; // Расстояние между блоками по OX
  dy:integer = 5; // Расстояние между блоками по OY
  sizeBlock = 50; // Ширина и высота блока
  level: integer = 1; //Уровень

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.FormCreate(Sender: TObject);
begin
     // Заливка фона
     Image1.Canvas.Brush.Color := $808000;
     Image1.Canvas.Fillrect(Image1.Canvas.ClipRect);

     GenLine;
     Draw;
     //Image1.Canvas.Brush.Color := clLime;
     //Image1.Canvas.Brush.Color := RGBToColor(99, 255, 141);
     //Image1.Canvas.rectangle(50, 50, 100, 100);
     //Image1.Canvas.rectangle(105, 50, 155, 100)

end;

procedure TForm1.GenLine;
var
  i, j, m, n, x:integer;
  xpos: array[0..7] of integer;
  color: Tcolor;
begin
     // Заполняем массив координат блоков
     m := 7;
     for i:= 0 to 7 do
     begin
          // n * dx + (n-1) * WitdhBlock
          xpos[i] := (i+1) * dx + n * sizeBlock;
     end;

     randomize;
     n := random(7)+2; // Количество блоков от 2 до 8

     // Удаляем рандомные координаты блоков, до правильного количества блоков
     for i:= 0 to 7-n do
     begin
          for j := random(8) to m-1 do
              xpos[j] := xpos[j+1];
          dec(m);
     end;


     x := 0;
     while (i <= 63) and (x < n) do
     begin
       if Blocks[i] = nil then
       begin
         case level of
           1: color := Clrs[0];
           2..5: color := Clrs[1];
           6..9: color := Clrs[2];
           10..15: color := Clrs[3];
           16..25: color := Clrs[4];
           else color := Clrs[5];
         end;

         Blocks[i] := TBlock.Create(xpos[x], dy, color);
         inc(x);
       end;

       inc(i);
     end;
end;


procedure TForm1.Draw;
var i:integer;
begin

// New Block line
for i:= 0 to 63 do
begin
     if Blocks[i].getY = dy do
     begin
          Image1.Canvas.Brush.Color := Blocks[i].color;
          Image1.Canvas.rectangle(Blocks[i].getX, Blocks[i].getY, Blocks[i].getX+sizeBlock, Blocks[i].getY+sizeBlock);
     end;
end;


end;

end.

