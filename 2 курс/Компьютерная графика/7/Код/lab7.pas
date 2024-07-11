program lab7;
uses
	wincrt, graph;
type
	TXYZ = record
		x, y, z: real;
	end;
	TXY = record
		x, y: integer;
	end;
	
const										
  CoordinateHat:array [0..7] of TXYZ = ((x:-175; y:-600; z: 0),
											(x:-175; y: -550; z: 0),
											(x:  125; y:-550; z: 0),
											(x:  125; y:-600; z: 0),
											(x:  125; y:-600; z:50),
											(x:  125; y:-550; z:50),
											(x:-175; y:-550; z:50),
											(x:-175; y:-600; z:50));
	
	pp = 45;
	ff = 35.264;
var
	gD, gM: integer;
	xx, xy, exit: integer;
	bufHat: array [0..7] of TXYZ;
	prPolyhedronHat: array [0..7] of TXY;
	key: char;
	e:real; 
	
//Для шапки
procedure findProjectionHat(k, p: real);
var i: byte;
begin
	for i := 0 to 7 do
	begin
		prPolyhedronHat[i].x := round(CoordinateHat[i].x*cos(p) + CoordinateHat[i].z*sin(p));
		prPolyhedronHat[i].y := round(-CoordinateHat[i].x*sin(k)*sin(p) + CoordinateHat[i].y*cos(k) + CoordinateHat[i].z*sin(k)*cos(p));
	end;
end;

procedure drawHat;
begin
	setColor(12);
	line(prPolyhedronHat[0].x+xx, prPolyhedronHat[0].y+xy, prPolyhedronHat[1].x+xx, prPolyhedronHat[1].y+xy);
	line(prPolyhedronHat[1].x+xx, prPolyhedronHat[1].y+xy, prPolyhedronHat[2].x+xx, prPolyhedronHat[2].y+xy);
	line(prPolyhedronHat[2].x+xx, prPolyhedronHat[2].y+xy, prPolyhedronHat[3].x+xx, prPolyhedronHat[3].y+xy);
	line(prPolyhedronHat[3].x+xx, prPolyhedronHat[3].y+xy, prPolyhedronHat[4].x+xx, prPolyhedronHat[4].y+xy);
	line(prPolyhedronHat[4].x+xx, prPolyhedronHat[4].y+xy, prPolyhedronHat[5].x+xx, prPolyhedronHat[5].y+xy);
	line(prPolyhedronHat[5].x+xx, prPolyhedronHat[5].y+xy, prPolyhedronHat[6].x+xx, prPolyhedronHat[6].y+xy);
	line(prPolyhedronHat[6].x+xx, prPolyhedronHat[6].y+xy, prPolyhedronHat[7].x+xx, prPolyhedronHat[7].y+xy);
	line(prPolyhedronHat[7].x+xx, prPolyhedronHat[7].y+xy, prPolyhedronHat[0].x+xx, prPolyhedronHat[0].y+xy);
	line(prPolyhedronHat[0].x+xx, prPolyhedronHat[0].y+xy, prPolyhedronHat[3].x+xx, prPolyhedronHat[3].y+xy);
	line(prPolyhedronHat[2].x+xx, prPolyhedronHat[2].y+xy, prPolyhedronHat[5].x+xx, prPolyhedronHat[5].y+xy);
	line(prPolyhedronHat[1].x+xx, prPolyhedronHat[1].y+xy, prPolyhedronHat[6].x+xx, prPolyhedronHat[6].y+xy);
	line(prPolyhedronHat[4].x+xx, prPolyhedronHat[4].y+xy, prPolyhedronHat[7].x+xx, prPolyhedronHat[7].y+xy);
end;

procedure shiftHat(dx, dy, dz: real);
var i: byte;
begin
	for i := 0 to 7 do
	begin
		CoordinateHat[i].x := CoordinateHat[i].x + dx;
		CoordinateHat[i].y := CoordinateHat[i].y + dy;
		CoordinateHat[i].z := CoordinateHat[i].z + dz;
	end;
	findProjectionHat(pp*pi/180, ff*pi/180);
end;


procedure resizeMinusHat(k: real);
var i: byte;
begin
	for i := 0 to 7 do
	begin
		CoordinateHat[i].x := round(CoordinateHat[i].x/k);
		CoordinateHat[i].y := round(CoordinateHat[i].y/k);
		CoordinateHat[i].z := round(CoordinateHat[i].z/k);
	end;
end;

procedure saveBufHat;
var i: byte;
begin
	for i := 0 to 7 do
	begin
		bufHat[i].x := CoordinateHat[i].x;
		bufHat[i].y := CoordinateHat[i].y;
		bufHat[i].z := CoordinateHat[i].z;
	end;
end;

procedure loadBufHat;
var i: byte;
begin
	for i := 0 to 7 do
	begin
		CoordinateHat[i].x := bufHat[i].x;
		CoordinateHat[i].y := bufHat[i].y;
		CoordinateHat[i].z := bufHat[i].z;
	end;
end;

procedure rotationOZHat(u: real);
var i: byte;
begin
	saveBufHat;
	for i := 0 to 7 do
	begin
		CoordinateHat[i].x := round(bufHat[i].x*cos(u)+bufHat[i].z*sin(u));
        CoordinateHat[i].y := round(CoordinateHat[i].y);
        CoordinateHat[i].z := round(-bufHat[i].x*sin(u)+bufHat[i].z*cos(u));
	end;
	findProjectionHat(pp*Pi/180,ff*Pi/180);
	drawHat;
	loadBufHat;
end;


begin

	gD := detect;
	initGraph(gD,gM,'');
	e := 0;
	xx:=getMaxX div 2; 
	xy:=getMaxY div 2;
	findProjectionHat(pp*Pi/180,ff*Pi/180);
  drawHat;
	repeat
		key := readkey;
		writeln(ord(key));
		if (key = #32) then
		begin
			for exit := 0 downto -70 do
			begin
				cleardevice;
				shiftHat(0, 6.2, 0);
				drawHat;
				delay(50);
			end;
			for exit := 0 to 63 do
			begin
				cleardevice;
				e := e + 0.1;
				rotationOZHat(e);
				delay(100);
			end;
			for exit := 0 to 35 do
			begin
				cleardevice;
				resizeMinusHat(1.1);
				findProjectionHat(pp*Pi/180,ff*Pi/180);
				drawHat;
				if exit = 35 then
					cleardevice;
				delay(80);
			end;
		end // up
		else if (key = #119) then
    begin
      cleardevice;
      shiftHat(0, -5, 0);
			drawHat;
    end // down
    else if (key = #115) then
    begin
      cleardevice;
      shiftHat(0, 5, 0);
			drawHat;
    end // left
    else if (key = #97) then
    begin
      cleardevice;
      shiftHat(-6.2, 0, 0);
			drawHat;
    end  // right
    else if (key = #100) then
    begin
      cleardevice;
      shiftHat(6.2, 0, 0);
			drawHat;
    end // rotate -
    else if (key = #113) then
    begin
      cleardevice;
        e := e + 0.1;
				rotationOZHat(e);
			drawHat;
    end // rotate +
    else if (key = #101) then
    begin
      cleardevice;
       e := e - 0.1;
			rotationOZHat(e);
			drawHat;
    end // zoom -
    else if (key = #122) then
    begin
      cleardevice;
       resizeMinusHat(1.1);
			 findProjectionHat(pp*Pi/180,ff*Pi/180);
			drawHat;
    end // zoom +
    else if (key = #120) then
    begin
      cleardevice;
       resizeMinusHat(0.9);
			  findProjectionHat(pp*Pi/180,ff*Pi/180);
			drawHat;
    end;
    
	until (key = #27);
	readln;
end.
