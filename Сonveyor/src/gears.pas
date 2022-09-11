unit gears;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Math, defSets;
  type
  TGear = class (TObject)
    private
      x, y: integer;
      procedure generate;
    public
      hp: integer;
      img:TBitmap;
      gearType:string;
      color:string;
      tp:string;
      target:string;
      Constructor Create(x0, y0, av: Integer);
      procedure move;
      procedure moveY;
      function getX: Integer;
      function getY: Integer;
  end;

implementation

Constructor TGear.Create(x0, y0, av: Integer);
var cl, it: string;
begin
     x := x0;
     y := y0;
     if av = 0 then
       begin
            generate;
       end
     else
       begin
            cl := 'black';
            it := items[RandomRange(0, 3)];
            Self.img := TBitmap.Create;
            Self.img.LoadFromFile('img/'+it+'_'+cl+'.bmp');
            Self.gearType := it+'_'+cl;
            Self.color := cl;
            Self.tp := it;
            Self.target := 'trash';
       end;
end;

procedure TGear.move;
begin
     x := x + 10;
end;

procedure TGear.moveY;
begin
     y := y + 10;
end;

function TGear.getX: integer;
begin
     Result := x;
end;

function TGear.getY: integer;
begin
     Result := y;
end;

// генерация деталей
procedure TGear.generate;
var cl, it: string;
begin
    cl := clrs[RandomRange(0, 3)];
    it := items[RandomRange(0, 3)];
    Self.img := TBitmap.Create;
    Self.img.LoadFromFile('img/'+it+'_'+cl+'.bmp');
    Self.gearType := it+'_'+cl;
    Self.color := cl;
    Self.tp := it;
    Self.target := '';
end;

end.

