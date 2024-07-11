program lab6;
uses
	wincrt, graph, math;

type 
	TXYZ = record
		x, y, z: integer;
	end;

	TCoord = record
		x, y: integer;
	end;
var
	gD, gM: integer;
	xy: array [0..7] of TCoord;
	key: char;
	p1, f1: real;

const
	Coordinate: array [0..7] of TXYZ = (
(x:-80;y: 45;z:-25),//0
(x:-80;y:-45;z:-25),//1
(x: 80;y:-45;z:-25),//2
(x: 80;y: 45;z:-25),//3

(x: 80;y: 45;z: 25),//4
(x: 80;y:-45;z: 25),//5
(x:-80;y:-45;z: 25),//6
(x:-80;y: 45;z: 25) //7

);

Procedure Draw(dx, dy: word);
var i: byte;
begin
  SetColor(White);
  for i:=0 to 6 do line(dx+xy[i].x,dy+xy[i].y,dx+xy[i+1].x,dy+xy[i+1].y);

	line(dx+xy[0].x, dy+xy[0].y, dx+xy[3].x, dy+xy[3].y);
    line(dx+xy[0].x, dy+xy[0].y, dx+xy[7].x, dy+xy[7].y);
    line(dx+xy[1].x, dy+xy[1].y, dx+xy[6].x, dy+xy[6].y);
    line(dx+xy[2].x, dy+xy[2].y, dx+xy[5].x, dy+xy[5].y);
    line(dx+xy[4].x, dy+xy[4].y, dx+xy[7].x, dy+xy[7].y);

end;

// вид спереди
procedure frontView();
var i: byte;
begin
	for i := 0 to 7 do
	begin
		xy[i].x := Coordinate[i].x;
		xy[i].y := Coordinate[i].y;
	end;
	draw(270,365);
end;

// вид сверху
procedure viewFormTop();
var i: byte;
begin
	for i := 0 to 7 do
	begin
		xy[i].x := Coordinate[i].x;
		xy[i].y := Coordinate[i].z;
	end;
	draw(500,365);
end;

// вид сбоку
procedure sideView();
var i: byte;
begin
	for i := 0 to 7 do
	begin
		xy[i].x := Coordinate[i].z;
		xy[i].y := Coordinate[i].y;
	end;
	draw(670, 365); 
end;

// Изометрия, диметрия, триметрия
procedure drawAxonometricProjection(p, f: real);
var i: byte;
begin
	for i := 0 to 7 do
	begin
		xy[i].x := round(Coordinate[i].x*cos(p) + Coordinate[i].z*sin(p));
		xy[i].y := round(Coordinate[i].x*sin(p)*sin(f) + Coordinate[i].y*cos(f) - Coordinate[i].z*sin(f)*cos(p)); 
	end;
	draw(400, 350); 
end;

// Кавалье, Кабине
procedure drawKosAxonometricProjection(l: real);
var i: byte;
begin
	for i := 0 to 7 do
	begin
		xy[i].x := round(Coordinate[i].x + Coordinate[i].z*l*cos(pi/4));
		xy[i].y := round(Coordinate[i].y + Coordinate[i].z*l*sin(pi/4));
	end;
	draw(400, 350); 
end;

// Одноточечная центральная проекция бруска
procedure  centralProjection();
var i: byte;
begin
	for i := 0 to 7 do
	begin
		xy[i].x:=round( Coordinate[i].x/(Coordinate[i].z/150+1) );
        xy[i].y:=round( Coordinate[i].y/(Coordinate[i].z/150+1) );
	end;
	Draw(300,250); 
end;

begin
	gD := detect;
	initGraph(gD, gM, '');
	
	repeat
		key := readkey;
		case key of
		'1': begin
			ClearDevice;
			OutTextXY(270,250,'Front view');
			frontView();
			OutTextXY(470,250,'View from top');
			viewFormTop();
			OutTextXY(670,250,'Side view');
			sideView();
		end;
		'2': begin
			ClearDevice;
			p1 := 45 * pi/180;
			f1 := 35.264 * pi/180;
			OutTextXY(400,200,'Isometry');
			drawAxonometricProjection(p1, f1);
		end;
		'3': begin
			ClearDevice;
			p1 := 22.208 * pi/180;
			f1 := 20.705  * pi/180;
			OutTextXY(400,200,'Dimetry');
			drawAxonometricProjection(p1, f1);
		end;
		'4': begin
			ClearDevice;
			p1 := 150 * pi/180;
			f1 := 40 * pi/180;
			OutTextXY(400,200,'Trimetry');
			drawAxonometricProjection(p1, f1);
		end;
		'5': begin
			ClearDevice;
			OutTextXY(400,200,'Cavale');
			drawKosAxonometricProjection(1);
		end;
		'6': begin
			ClearDevice;
			OutTextXY(400,200,'Cabine');
			drawKosAxonometricProjection(0.5);
		end;
		'7': begin
			ClearDevice;
			OutTextXY(300, 150,'Central rojection');
			centralProjection();
		end;
		end;
    until key = #27;
	readkey;
	closeGraph(); 
end.
