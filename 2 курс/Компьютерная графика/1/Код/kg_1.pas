program kg_1;
uses math, graph, sysutils;
var Gd, Gm, x1, x2, y1, y2,j,r,xw1,yw1, tt:integer;
slp:integer = 2; // задержка в мс


procedure drawSimpleLine(x1, y1, x2, y2, col: integer);
var
x:integer;
m,y:real;

begin
    if(x1 <> x2) then
        begin
            m:= (y2-y1)/(x2-x1);
            y := y1;
            for x := x1 to x2 do
            begin
                PutPixel(x, round(y), col);
                y := y + m;
                sleep(slp);
            end;
        end
    else
        begin
            if(y1 = y2) then
                begin
                    PutPixel(x1,y1,col);
                    sleep(slp);
                end
            else
                writeln('Vertical');
        end;
end;


procedure drawLineBrhm8(x1, y1, x2, y2, col: integer);
var
x,y,dx,dy,s1,s2,tmp, i, e:integer;
l:boolean;

begin
    x:= x1;
    y:= y1;
    dx := abs(x2-x1);
    dy := abs(y2-y1);
    s1 := sign(x2-x1);
    s2 := sign(y2-y1);

    if(dy > dx) then
        begin
            tmp := dy;
            dy := dx;
            dx := tmp;
            l := true;
        end
    else
        l := false;

    e  := 2 * dy - dx;

    for i := 1 to dx do
    begin
        PutPixel(x,y,col);
        sleep(slp);
        while(e >= 0) do
        begin
            if(l = true) then
                x := x + s1
            else 
                y := y + s2;
            
            e := e - 2 * dx;
        end;

        if(l = true) then
            y := y + s2
        else 
            x := x + s1;

        e := e + 2 * dy;
    end;
    PutPixel(x, y, col);
    sleep(slp)
end;

procedure drawLineBrhm4(x1, y1, x2, y2, col: integer);
var x, y, dx, dy, s1, s2, i, e: integer;
l: boolean;
begin
	x := x1;
	y := y1;
	dx := abs(x2 - x1);
	dy := abs(y2 - y1);
	s1 := sign(x2 - x1);
	s2 := sign(y2 - y1);
	if (dy < dx) then
		l := false
	else
		begin
			dx := abs(y2 - y1);
			dy := abs(x2 - x1);
			l := true;
		end;
	e := 2 * dy - dx;
	for i := 1 to dx + dy do
	begin
        sleep(slp);
		PutPixel(x, y, col);
		if (e < 0) then
		begin
			if (l = true) then
				y := y + s2
			else
				x := x + s1;
			e := e + 2*dy;
		end
		else
			begin
				if (l = true) then
					x := x + s1
				else
					y := y + s2;
				e := e - 2*dx;
			end;
	end;
    sleep(slp);
	PutPixel(x, y, col);
end;

procedure drawCirle(x1, y1, rad, col: integer);
var x, y, e: integer;
begin
    x := 0;
    y := rad;
    e := 3 - 2 * rad;
    while (x < y) do
    begin
        PutPixel(x1 + x, y1 + y, col);
        PutPixel(x1 + y, y1 + x, col);
        PutPixel(x1 + y, y1 - x, col);
        PutPixel(x1 + x, y1 - y, col);
        PutPixel(x1 - x, y1 - y, col);
        PutPixel(x1 - y, y1 - x, col);
        PutPixel(x1 - y, y1 + x, col);
        PutPixel(x1 - x, y1 + y, col);
        sleep(slp);

    if (e < 0) then
        e := e + 4 * x + 6
    else
    begin
        e := e + 4*(x - y) + 10;
        y := y - 1;
    end;
    x := x + 1;
    end;

    if (x = y) then
    begin
        PutPixel(x1 + x, y1 + y, col);
        PutPixel(x1 + y, y1 + x, col);
        PutPixel(x1 + y, y1 - x, col);
        PutPixel(x1 + x, y1 - y, col);
        PutPixel(x1 - x, y1 - y, col);
        PutPixel(x1 - y, y1 - x, col);
        PutPixel(x1 - y, y1 + x, col);
        PutPixel(x1 - x, y1 + y, col);
        sleep(slp);
    end;
end;

begin
Gd := Detect;

j := -180;
r := 150; // радиус

writeln('Input x1');
readln(xw1);
writeln('Input y1');
readln(yw1);
writeln('Input radius');
readln(r);
writeln('1) простая линия');
writeln('2) Линия Брезенхема 4');
writeln('3) Линия Брезенхема 8');
writeln('4) радиальные прямые (простая линия)');
writeln('5) радиальные прямые (Линия Брезенхема 4)');
writeln('6) радиальные прямые (Линия Брезенхема 8)');
writeln('7) Окружность (простой линией)');
writeln('8) Окружность (Брезенхема)');
readln(tt);
InitGraph(Gd, Gm, '');

if(tt = 1) then
  begin
// простая линия
drawSimpleLine(xw1, yw1, xw1+r, yw1, 15);
end
else if tt = 2 then
  begin
// Брезенхема 4
drawLineBrhm4(xw1, yw1, xw1+r, yw1, 2);
end
else if tt = 3 then
  begin
//// Брезенхема 8
drawLineBrhm8(xw1, yw1, xw1+r, yw1, 5);
end
else if ((tt >= 4) and (tt <= 6)) then
  begin

// радиальные прямые
while (j <= 180) do
begin
    x1 := Round(xw1 + r * cos(j*2*pi/360));
    y1 := Round(yw1 + r * sin(j*2*pi/360));
    x2 := Round(xw1 - r * cos(j*2*pi/360));
    y2 := Round(yw1 - r * sin(j*2*pi/360));
    if tt = 4 then
    drawSimpleLine(x1, y1, x2, y2, 15) // белый
    else if tt = 5 then
    drawLineBrhm4(x1, y1, x2, y2, 2) // зеленый
    else
    drawLineBrhm8(x1, y1, x2, y2, 5); // фиол
    
    j := j + 10;
end;
// вертикаль
for y1 := yw1 - r to yw1 + r do
begin
    drawSimpleLine(xw1, y1, xw1, y1, 15);
end;

end
else if tt = 7 then
  begin 


// окружность
for j := 0 to 3600 do
begin
    x2 := Round(r * cos(j*2*pi/3600));
    y2 := round(sqrt(r*r - x2*x2));
    PutPixel(xw1 + x2, yw1 + y2, 5);
    y2 := -round(sqrt(r*r - x2*x2));
    PutPixel(xw1 + x2, yw1 + y2, 5);
    y2 := Round(r * cos(j*2*pi/3600));
    x2 := round(sqrt(r*r - y2*y2));
    PutPixel(xw1 + x2, yw1 + y2, 5);
    x2 := -round(sqrt(r*r - y2*y2));
    PutPixel(xw1 + x2, yw1 + y2, 5);
    sleep(slp);
end;

end
else if tt = 8 then
  begin
//окружность Брезенхема
drawCirle(xw1, yw1, r, 15);
end;
readln();


end. 