program kg2;
uses graph, math, sysutils;

type 
    XY = record
        x,y:integer;
end;
const 
m = 4;
var
Gm, Gd, i, j, xn, yn:integer;
t,step:real;
R, P:array[1..m] of XY;

begin
    Gd := Detect;
	InitGraph(Gd, Gm, '');
    P[1].x := 150;
    P[1].y := 400;
    P[2].x := 150;
    P[2].y := 600;
    P[3].x := 400;
    P[3].y := 400;
    P[4].x := 400;
    P[4].y := 600;
    
    xn := P[1].x;
    yn := P[1].y;
    t := 0;
    step := 0.01;

    repeat
    R := P;
    for j := m downto 2 do
    begin
        for i := 1 to j - 1 do
        begin
            R[i].x := R[i].x + round(t * (R[i+1].x - R[i].x));
            R[i].y := R[i].y + round(t * (R[i+1].y - R[i].y));
        end;
    end;
//    SetFillStyle(1, black);
    cleardevice();
//    for i := 1 to m - 1 do begin
//		line(R[i].x, R[i].y, R[i+1].x, R[i+1].y);
//	end;
    SetFillStyle(1, red); 
    
//    Circle(xn, yn, 10);
Sector(xn, yn, 0, 360, 10,10);

//    floodfill(xn,yn, white);
      setcolor(red);
      line(xn, yn, xn+9, yn);
      Circle(xn, yn, 10);
      setcolor(white);
    sleep(10);
//    line(xn, yn, R[1].x, R[1].y);
    t := t + step;
    xn := R[1].x;
    yn := R[1].y;
    until t > 1;
    readln()

end.