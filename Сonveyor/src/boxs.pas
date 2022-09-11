unit boxs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;
  type
  TBox = class (TObject)
    private
      x, y: integer;
    public
      labelImg, boxImg:TBitmap;
      boxType:string;
      itemsCount:integer;
      hiddenItemsCount:integer;
      boxVal:integer;
      limit:integer;
      btt:string;
      color:string;
      Constructor Create(x0, y0: Integer; limage, bimage:TBitmap; bt:string; ic, boxtp, lm:integer; boxt, boxclr:string);
      function getX: Integer;
      function getY: Integer;
  end;
implementation

Constructor TBox.Create(x0, y0: Integer; limage, bimage:TBitmap; bt:string; ic, boxtp, lm:integer; boxt, boxclr:string);
begin
     x := x0;
     y := y0;
     labelImg := limage;
     boxImg := bimage;
     boxType := bt;
     itemsCount := ic;
     hiddenItemsCount := ic;
     boxVal := boxtp; //1 - ящик, 2 - корзина
     limit := lm;
     btt := boxt;
     color := boxclr;
end;

function TBox.getX: integer;
begin
     Result := x;
end;

function TBox.getY: integer;
begin
     Result := y;
end;

end.
