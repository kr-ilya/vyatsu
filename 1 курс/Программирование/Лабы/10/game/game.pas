unit game;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

type
TBlock = class (TObject)
  private
    x, y: integer;

    //speed_H: Integer;
  public
    speed: integer;
    color: Tcolor;
    hp: integer;
    Constructor Create(x0, y0: Integer);
    procedure move;
    function getX: Integer;
    function getY: Integer;
end;

TBoll = class (TObject)
  private
    x, y: integer;
  public
    xn, yn, dx, dy, lb, ldx, ldy: integer;
    n, rbd: boolean;
    vis, started, finished: boolean;
    Constructor Create(x0, y0: Integer);
    procedure move;
    function getX: Integer;
    function getY: Integer;
    procedure setX(xsn:integer);
    procedure setY(ysn:integer);
end;

TDopBoll = class (TObject)
  private
    x, y: integer;
  public
    speed: integer;
    Constructor Create(x0, y0: Integer);
    procedure move;
    function getX: Integer;
    function getY: Integer;
end;

implementation

Constructor TBlock.Create(x0, y0: Integer);
begin
     x := x0;
     y := y0;
end;

procedure TBlock.move;
begin
     y := y + speed;
end;

function TBlock.getX: integer;
begin
     Result := x;
end;

function TBlock.getY: integer;
begin
     Result := y;
end;


Constructor TBoll.Create(x0, y0: Integer);
begin
     x := x0;
     y := y0;
end;

procedure TBoll.move;
begin
     x := x + dx;
     y := y + dy;
end;

function TBoll.getX: integer;
begin
     Result := x;
end;

function TBoll.getY: integer;
begin
     Result := y;
end;

procedure TBoll.setX(xsn:integer);
begin
     x := xsn;
end;

procedure TBoll.setY(ysn:integer);
begin
     y := ysn;
end;

Constructor TDopBoll.Create(x0, y0: Integer);
begin
     x := x0;
     y := y0;
end;

procedure TDopBoll.move;
begin
     y := y + speed;
end;

function TDopBoll.getX: integer;
begin
     Result := x;
end;

function TDopBoll.getY: integer;
begin
     Result := y;
end;
end.

