program kgLab45;
uses
	wincrt, graph, sysutils;
type
	PStack = ^TStack;	
	TStack = record
		x, y: integer;
		prev: PStack;
	end;
	Point = record
		x, y: integer;
	end;
var
	gD, gM, x, y: integer;
	ci, cb: integer;
	stack, tmp: PStack;
	points: array [1..11] of Point;
	x1, y1, x2, y2, x3, y3: integer;
	Ymax, Ymin, Ymid: Integer;
  	Xmax, Xmin, Xmid: Integer;


procedure push(x, y: integer);
begin
	tmp := stack;
	new(stack);
	stack^.x := x;
	stack^.y := y;
	stack^.prev := tmp;
end;

procedure pop(var x, y: integer);
begin	
	x := stack^.x;
	y := stack^.y;
	tmp := stack;
	stack := stack^.prev;
	dispose(tmp);
end;

procedure drawBrush(x0, y0, ci, cb: integer);
var x, y, xw, xb, xr, xl, j: integer;
	fl: boolean;
begin
	push(x0, y0);
	while stack^.prev <> nil do
	begin
		pop(x, y);
		putPixel(x, y, ci);
		xw := x;
		inc(x);
		// заполняем справа от затравки
		while getPixel(x, y) <> cb do
		begin
			putPixel(x, y, ci);
			inc(x);
		end;
		xr := x - 1;
		x := xw;
		dec(x);	
		// заполняем слева от затравки
		while getPixel(x, y) <> cb do
		begin
			putPixel(x, y, ci);
			dec(x);
		end;
		xl := x + 1;
		j := -1;
		repeat
			x := xl;
			y := y + j;
			while x <= xr do
			begin
				fl := false;
				while (getPixel(x, y) <> cb) and (getPixel(x, y) <> ci) and (x < xr) do
				begin
					inc(x);
					fl := true;
				end;
				if fl then
				begin
					if(x = xr) and (getPixel(x, y) <> cb) and (getPixel(x, y) <> ci) then
						push(x, y)
					else
						push(x - 1, y);
					fl := false;
				end;
				xb := x;
				while(getPixel(x, y) = cb) or (getPixel(x, y) = ci) and (x < xr) do
					inc(x);
				if (x = xb) then
					inc(x);
			end;
			j := j + 3;
		until j > 2;
	end;		
end;

procedure triangleBrush(x1, y1, x2, y2, x3, y3: Integer);
var
  wx1,wx2: Real;
  dx01, dx02, dx21: Real;
  i: Integer;
begin
  if y1 = y3 then
  	dx01 := 0
  else 
  	dx01 := (x1 - x3)/(y1 - y3);
  if y2 = y3 then 
  	dx02 := 0
  else 
  	dx02 := (x2 - x3)/(y2 - y3);
  if y1 = y2 then 
  	dx21 := 0
  else 
  	dx21 := (x1 - x2)/(y1 - y2);
  wx1 := x3;
  wx2 := wx1;
  if y2 = y3 then 
  	wx2 := x2;
  for i := y3 + 1 to y2 do
    begin
      wx1 := wx1 + dx01;
      wx2 := wx2 + dx02;
      line(round(wx1), i, round(wx2), i);
    end;
  for i := y2 + 1 to y1 do
    begin
      wx1 := wx1 + dx01;
      wx2 := wx2 + dx21;
      line(round(wx1), i, round(wx2), i);
    end;
end;

procedure swap(var x, y, xh, yh: integer);
var
  tmp: Integer;
begin
  tmp:=x; x:=xh; xh:=tmp;
  tmp:=y; y:=yh; yh:=tmp;
end;


begin
	gD := detect;
	initGraph(gD, gM, '');
	ci := 5;
	cb := 15;
	// фигура с отверстиями
	setColor(cb);
	points[1].x := 50;
	points[1].y := 300;

	points[2].x := 250;
	points[2].y := 100;

	points[3].x := 450;
	points[3].y := 300;

	points[4].x := 350;
	points[4].y := 300;

	points[5].x := 350;
	points[5].y := 400;

	points[6].x := 450;
	points[6].y := 400;

	points[7].x := 250;
	points[7].y := 600;

	points[8].x := 50;
	points[8].y := 400;

	points[9].x := 150;
	points[9].y := 400;

	points[10].x := 150;
	points[10].y := 300;

	points[11].x := 50;
	points[11].y := 300;

	drawPoly(11, points);

	// Внутренние отверстия
	line(250, 200, 300, 250);
	line(300, 250, 200, 250);
	line(200, 250, 250, 200);

	line(250, 500, 200, 450);
	line(200, 450, 300, 450);
	line(300, 450, 250, 500);


  	  Xmin:=1000;  Ymin:=600;
  Xmid:=1300;  Ymid:=250;
  Xmax:=800;   Ymax:=50;

 Line(Xmax,Ymax,Xmid,Ymid);
  Line(Xmid,Ymid,Xmin,Ymin);
  Line(Xmax,Ymax,Xmin,Ymin);

if Ymax < Ymin then swap(Xmax,Ymax,Xmin,Ymin);
  if Ymax < Ymid then swap(Xmax,Ymax,Xmid,Ymid);
  if Ymid < Ymin then swap(Xmid,Ymid,Xmin,Ymin);
  ReadKey;
  SetColor(5);
  triangleBrush(Xmax,Ymax,Xmid,Ymid,Xmin,Ymin);
  SetColor(15);
  Line(Xmax,Ymax,Xmid,Ymid);
  Line(Xmid,Ymid,Xmin,Ymin);
  Line(Xmax,Ymax,Xmin,Ymin);


	new(stack);
	stack^.Prev := nil;
	x:=200; y:=300; {Координаты затравочного пиксела}
	drawBrush(x, y, ci, cb);
	dispose(stack);
	readKey;
end.