unit pushers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, defSets;
  type
  TPusher = class (TObject)
    private
      x, y: integer;
    public
      Constructor Create(x0, y0: Integer);
      procedure move;
      procedure moveYPlus;
      procedure moveYMinus;
      function getX: Integer;
      function getY: Integer;

      var
      active:boolean;
  end;

implementation

Constructor TPusher.Create(x0, y0: Integer);
begin
     x := x0;
     y := y0;
     active := True;
end;

function TPusher.getX: integer;
begin
     Result := x;
end;

function TPusher.getY: integer;
begin
     Result := y;
end;

procedure TPusher.move;
begin
     x := x + 10;
end;

procedure TPusher.moveYPlus;
begin
     y := y + 10;
end;

procedure TPusher.moveYMinus;
begin
     y := y - 10;
end;

end.

