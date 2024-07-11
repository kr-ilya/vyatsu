unit carpet;

interface
uses graph;

var
t: integer; // глубина рекурсии
r: real; // масштаб

ws:integer; // ширина и высота начального квадрата
dx, dy: real;
Gd, Gm: integer;

// procedure Draw(x1, y1, x2, y2, dl, ddx, ddy: Real; n: Integer);
procedure left;
procedure right;
procedure up;
procedure down;
procedure zoomin;
procedure zoomout;
procedure stepup;
procedure stepdown;
procedure init;

implementation

procedure Draw(x1, y1, x2, y2, dl, ddx, ddy: Real; n: Integer);
var
x1n, y1n, x2n, y2n, x0, y0, xx0, yy0, mx, my: Real;

begin
if n > 0 then
begin

mx := getmaxX div 2;
my := getmaxY div 2;

if n = t then
begin
	x0 := mx - dl;
	y0 := my - dl;
	xx0 := mx + dl;
	yy0 := my + dl;

	x1 := x0;
	y1 := y0;
	x2 := xx0;
	y2 := yy0;
end
else
begin
	x0 := x1;
	y0 := y1;
	xx0 := x2;
	yy0 := y2;
end;
x1n := 2*x0/3 + xx0/3;
x2n := x0/3 + 2*xx0/3;
y1n := 2*y0/3 + yy0/3;
y2n := y0/3+2*yy0/3;

Rectangle(Round(x1n + ddx), Round(y1n + ddy), Round(x2n + ddx), Round(y2n + ddy));

Draw(x1, y1, x1n, y1n, dl, ddx, ddy, n-1);
Draw(x1n, y1, x2n, y1n, dl, ddx, ddy, n-1);
Draw(x2n, y1, x2, y1n, dl, ddx, ddy, n-1);
Draw(x1, y1n, x1n, y2n, dl, ddx, ddy, n-1);
Draw(x2n, y1n, x2, y2n, dl, ddx, ddy, n-1);
Draw(x1, y2n, x1n, y2,dl, ddx, ddy, n-1);
Draw(x1n, y2n, x2n, y2, dl, ddx, ddy, n-1);
Draw(x2n, y2n, x2, y2, dl, ddx, ddy, n-1)
end
end;

procedure clear;
begin
setcolor(0);
bar(0, 0 , getmaxX, getmaxY);
setcolor(15);
end;

procedure left; // Смещение влево
begin
	if dx > -500 then
	begin
		clear;
		dx := dx - 20;
		Draw(0, 0, 0, 0, ws*r, dx, dy, t);
	end;
end;

procedure right; // Смещение вправо
begin
	if dx < getmaxX/2 then
	begin
		clear;
		dx := dx + 20;
		Draw(0, 0, 0, 0, ws*r, dx, dy, t);
	end;
end;

procedure up; // Смещение вверх
begin
	if dy > -500 then
	begin
	clear;
	dy := dy - 20;
	Draw(0, 0, 0, 0, ws*r, dx, dy, t);
	end;
end;

procedure down; // Смещение вниз
begin
	if dy < getmaxY/2 then
	begin
		clear;
		dy := dy + 20;
		Draw(0, 0, 0, 0, ws*r, dx, dy, t);
	end;
end;

procedure zoomin;
begin
	if r <= 5 then
	begin
		r := r + 0.1;
		clear;
		Draw(0, 0, 0, 0, ws*r, dx, dy, t);
	end;
end;

procedure zoomout;
begin
	if r > 0.3 then
	begin
		r := r - 0.1;
		clear;
		Draw(0, 0, 0, 0, ws*r, dx, dy, t);
	end;
end;

procedure stepup; // увеличить глубину рекурсии
begin
	if t < 4 then
	begin
		t := t + 1;
		clear;
		Draw(0, 0, 0, 0, ws*r, dx, dy, t);
	end;
end;

procedure stepdown; // уменьшить глубину рекурсии
begin
	if t > 1 then
	begin
		t := t - 1;
		clear;
		Draw(0, 0, 0, 0, ws*r, dx, dy, t);
	end;
end;

procedure init; // иницализация
begin
	r := 1; // масштаб
    t := 1; // глубина
    dx := 0; // смещение по OX
    dy := 0; // смещение по OY
    ws := 200;
    Gd := Detect;
    InitGraph(Gd, Gm, '');

    Draw(0, 0, 0, 0, ws, dx, dy, t);
end;


end.
