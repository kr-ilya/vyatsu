program afine;
Uses
  wincrt, graph;

Type
    TVector = array[1..3] of extended;
    TMatrix = array[1..3,1..3] of extended;
    TPoint = record
        x: extended;
        y: extended;
    end; 
    TPointArray = array [1..6] of TPoint;

Const
    Polygon: TPointArray = ((x:500;y:300),(x:550;y:200),(x:600;y:200),
                       (x:650;y:150),(x:750;y:150),(x:750;y:300));

var
    Gd, Gm:integer;
    count: integer = 8;
    points: TPointArray;
    key:char;

// отрисовка
procedure draw(points: TPointArray);
var i:integer;
begin
    for i := 1 to count-1 do
        line(round(points[i].x), round(points[i].y), round(points[i+1].x), round(points[i+1].y));
    line(round(points[count].x),round(points[count].y),round(points[1].x),round(points[1].y));
end;

//сброс матрицы
procedure clearMatrix(var points: TMatrix);
var
  i, j: byte;
begin
  for i := 1 to 3 do
    for j := 1 to 3 do
      points[i, j] := 0;
end;

procedure pointToVector(points: TPoint; var vector: TVector);
begin
  vector[1] := points.x;
  vector[2] := points.y;
  vector[3] := 1;
end;

procedure VectorToPoint(var points: TPoint; vector: TVector);
begin
  points.x := vector[1];
  points.y := vector[2];
end;

procedure multiply(points: TVector; matrix: TMatrix; var resultV: TVector);
var
  i, j: byte;
begin
  for i := 1 to 3 do
  begin
    resultV[i] := 0;
    for j := 1 to 3 do
      resultV[i] := resultV[i] + points[j] * matrix[j, i];
  end;
end;

// сдвиг
procedure shift(var points: TPointArray; n, m: integer);
var i: integer;
    matrix: TMatrix;
    resultV, vector: TVector;
begin
  clearMatrix(matrix);
  for i := 1 to 3 do
    matrix[i,i] := 1;
  matrix[3,1] := m;
  matrix[3,2] := n;
  For i := 1 to count do
  begin
    pointToVector(points[i], vector);
    multiply(vector, matrix, resultV);
    VectorToPoint(points[i], resultV);
  end;
end;

procedure rotate(var points: TPointArray; m, n: real; g: real);
var  i: integer;
     matrix: TMatrix;
     resultV, vector: TVector;
begin
  g := (g/180)*pi;
  clearMatrix(matrix);
  matrix[1,1] := cos(g);
  matrix[1,2] := sin(g);
  matrix[2,1] := -sin(g);
  matrix[2,2] := cos(g);
  matrix[3,1] := -m*cos(g) + m + n*sin(g);
  matrix[3,2] := -m*sin(g) - n*cos(g) + n;
  matrix[3,3] := 1;
  For i := 1 to count do
  begin
    pointToVector(points[i], vector);
    multiply(vector, matrix, resultV);
    vectorToPoint(points[i], resultV);
  end;
end;

procedure scaling(var points: TPointArray; m, n: real; kx, ky: real);
var i: integer;
    matrix: TMatrix;
    resultV, vector: TVector;
begin
  clearMatrix(matrix);
  matrix[1,1] := kx;
  matrix[2,2] := ky;
  matrix[3,1] := -m*kx + m;
  matrix[3,2] := -n*ky + n;
  matrix[3,3] := 1;
  For i := 1 to count do
  begin
    pointToVector(points[i], vector);
    multiply(vector, matrix, resultV);
    vectorToPoint(points[i], resultV);
  end;
end;

procedure mirror(var points: TPointArray; oX, oY: byte);
var i: integer;
    matrix: TMatrix;
    resultV, vector: TVector;
begin
  clearMatrix(matrix);
  matrix[3,3] := 1;
  if (oX = 0) and (oY = 1) then
    begin
      matrix[1,1] := -1;
      matrix[2,2] := 1;
      matrix[3,1] := 1200;
    end;
  if (oX = 1) and (oY = 0) then
    begin
      matrix[1,1] := 1;
      matrix[2,2] := -1;
      matrix[3,2] := 650;
    end;
  for i := 1 to count do
  begin
    pointToVector(points[i], vector);
    multiply(vector, matrix, resultV);
    vectorToPoint(points[i], resultV);
  end;
end;


begin
  Gd := detect;
  Initgraph(Gd,Gm,'');
  points := Polygon;
  count := 6;


  draw(points);
  repeat
  key := readkey;
  case key of
    '2': begin // Вниз
            ClearDevice;
            shift(points, 10, 0);
            draw(points);
            end;
    '8': begin // вверх
            ClearDevice;
            shift(points, -10, 0);
            draw(points);
            end;
    '6': begin // вправо
            ClearDevice;
            shift(points, 0, 10);
            draw(points);
            end;
    '4': begin // влево
            ClearDevice;
            shift(points, 0, -10);
            draw(points);
            end;
    '9': begin // поворот по часовой
            ClearDevice;
            rotate(points, 650, 350, 10);
            scaling(points, 650, 350, 1.1, 1.1);
            draw(points);
            end;
    '3': begin // поворот против часовой
            ClearDevice;
            rotate(points, 650, 350, -10);
            scaling(points, 650, 350, 0.9, 0.9);
            draw(points);
            end;
    '7': begin // отзеркаливание по X
            ClearDevice;
            mirror(points, 1, 0);
            draw(points);
            end;
    '1': begin // отзеркаливание по Y
            ClearDevice;
            mirror(points, 0, 1);
            draw(points);
            end;
    '-': begin // масштаб -
            ClearDevice;
            scaling(points, 650, 350, 0.8, 0.6);
            Circle(650, 350, 1);
            draw(points);
            end;
    '+': begin // масштаб +
            ClearDevice;
            scaling(points, 650, 350, 1.2, 1.4);
            Circle(650, 350, 1);
            draw(points);
            end;
    end;
    until key = #27;
  closegraph;
end.