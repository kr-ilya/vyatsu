program lab1011;
uses
	WINCRT, GRAPH;
var
	gD, Gm: integer;
	x11, y11, x21 ,y21: real;
	xl1, ya1, xr1, yb1 : integer;

	x12, y12, x22 ,y22: real;

	x13, y13, x23 ,y23: real;

	x14, y14, x24 ,y24: real;	

function kod (x, y: real; xl, ya, xr, yb: integer): byte;
var kp: byte;
begin
	kp := 0;
  	if x < xl then kp := kp or $01;
  	if y < ya then kp := kp or $02;
  	if x > xr then kp := kp or $04;
  	if y > yb then kp := kp or $08;
 	kod := kp;
end;

procedure otsech(xl, ya, xr, yb: integer; x1, y1, x2, y2: real);
var p1, p2: byte;
	x, y: real;
begin
  repeat
  begin
    {Присваиваем двоичные коды концам отрезка}
    p1 := kod(x1,y1,xl,ya,xr,yb);
    p2 := kod(x2,y2,xl,ya,xr,yb);
    if (p1 and p2) <> 0 then 
    	exit; {Если отрезок полностью невидим, выходим из цикла}
    {Если отрезок полностью видим, то рисуем этот отрезок и выходим из цикла}
    if (p1=0) and (p2=0) then
    begin
      setColor(Green);
      line(round(x1),round(y1),round(x2),round(y2));
      exit;
    end
    {-----------------------}
    else
    begin
      {Если начало отрезка находится в окне, то меняем начало и конец отрезка местами}
      if (p1 = 0) then
      begin
        x  := x1; 
        x1 := x2; 
        x2 := x;
        y  := y1; 
        y1 := y2; 
        y2 := y;
        p1 := p2;
      end;
      {начало слева от окна}
      if (p1 = $01) then
      begin
        y1 := y1 + (y2 - y1)*(xl - x1)/(x2 - x1);
        x1 := xl;
      end
      else
      begin
        {начало выше окна}
        if (p1 = $02) then
        begin
          x1 := x1 + (x2 - x1)*(ya - y1)/(y2 - y1); {находим его новые координаты}
          y1 := ya;
        end
        else
        begin
          {начало справо от окна}
          if (p1 = $04) then
          begin
            y1 := y1 + (y2 - y1)*(xr - x1)/(x2 - x1); {находим его новые координаты}
            x1 := xr;
          end
          else
          begin
            {начало ниже окна}
            if (p1 = $08) then
            begin
              x1 := x1 + (x2 - x1)*(yb - y1)/(y2 - y1); {находим его новые координаты}
              y1 := yb;
            end;
          end;
        end;
      end;
    end;
  end
  until (p1 = 0) and (p2 = 0); {…пока коды концов отрезка не равны нулям}
end;

begin
	gD := detect;
	initGraph(gD, gM, '');
	xl1 := 200; ya1 := 80; xr1 := 800; yb1 := 500; {Задаём координаты окна}
  	x11 := 50; y11 := 100; x21 := 320; y21 := 240; {Задаём координаты отрезка}
  	x12 := 400; y12 := 150; x22 := 500; y22 := 490; {Задаём координаты отрезка}
  	x13 := 600; y13 := 700; x23 := 600; y23 := 30; {Задаём координаты отрезка}
  	x14 := 700; y14 := 600; x24 :=	850; y24 := 150; {Задаём координаты отрезка}
  	rectangle(xl1, ya1, xr1, yb1); {Рисуем окно}
  	line(round(x11), round(y11), round(x21), round(y21)); {Рисуем отрезок}
  	line(round(x12), round(y12), round(x22), round(y22)); {Рисуем отрезок}
  	line(round(x13), round(y13), round(x23), round(y23)); {Рисуем отрезок}
  	line(round(x14), round(y14), round(x24), round(y24)); {Рисуем отрезок}
  	ReadKey;
  	otsech(xl1, ya1, xr1, yb1, x11, y11, x21, y21); {Рисуем отсечённый отрезок}
  	otsech(xl1, ya1, xr1, yb1, x12, y12, x22, y22);
  	otsech(xl1, ya1, xr1, yb1, x13, y13, x23, y23);
  	otsech(xl1, ya1, xr1, yb1, x14, y14, x24, y24);
  	ReadKey;
  	CloseGraph;
end.