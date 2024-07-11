unit bot;

interface

const
    ROCK: integer = 1; // Камень
    PAPER: integer = 2; // Бумага
    SCISSORS: integer = 3; // Ножницы

{
    Вызывается один раз перед началом игры.

    Передаёт параметры, с которыми запущен турнир:
    - setCount: максимальное количество сетов в игре
    - winsPerSet: требуемое количество побед в сете
}
procedure setParameters(setCount: integer; winsPerSet: integer);

{
    Вызывается один раз в начале игры.
}
procedure onGameStart();

{
    Функция должна вернуть число от 1 до 3, соответствующее фигуре, которую выбрал бот
    (1 - Камень, 2 - Бумага, 3 - Ножницы).

    Передаваемый параметр previousOpponentChoice - число от 1 до 3, выбор противника на предыдущем ходу.
    Самый первый раз за игру, при первом вызове choose, previousOpponentChoice равен 0
    (т.к. предыдущих ходов ещё не было).
}
function choose(previousOpponentChoice: integer): integer;

{
    Вызывается один раз в конце игры.
}
procedure onGameEnd();


implementation

uses math, sysutils;

type
    matr = array[1..9, 1..3, 1..2] of double;
    matrHist = array[1..27, 1..3, 1..2] of double;
    matrIO = array[1..3, 1..3, 1..2] of double;
    shortMatr = array[1..3, 1..2] of double;
    MarkovChain = object
        var
        matrix: matr; 
        memory: double;
        constructor Create(mem:double);
        procedure updateMatrix(pair, inp: integer);
    end;
    IOChain = object
        var
        matrix: matrIO; 
        memory: double;
        constructor Create(mem:double);
        procedure updateMatrix(dir, inp: integer);
    end;
    HistChain = object
        var
        matrix: matrHist; 
        memory: double;
        constructor Create(mem:double);
        procedure updateMatrix(pair, inp: integer);
  end;


var 
beat: array[1..3] of integer = (2, 3, 1);
model:MarkovChain;
modelI:IOChain;
modelO:IOChain;
modeHist:HistChain;
pref1:integer = 0;
pref2:integer = 0;
prefI1:integer = 0;
prefI2:integer = 0;
prefI3:integer = 0;
prefI4:integer = 0;
prefO1:integer = 0;
prefO2:integer = 0;
prefHist:integer;
prefHist1:integer;
inp: integer;
out: integer;
firstGame:boolean = True;

function predict(mtrIO, mrtI, mtrO:shortMatr):integer;
var
preRes, i:integer;
sumMas:array[1..3]of double;
begin

    for i := 1 to 3 do
    begin
        sumMas[i] := (mtrIO[i, 1] + mrtI[i, 1] + mtrO[i,1])/3; // среднее арифметическое коэффициентов каждого знака моделей
    end;
    
    if(sumMas[1] >= sumMas[2]) then
        preRes := 1
    else
        preRes := 2;

    if(sumMas[preRes] >= sumMas[3]) then
        predict := preRes
    else 
        predict := 3;
end;

// predict with hist model
function predictWH(mtrIO, mrtI, mtrO, mtrHist:shortMatr):integer;
var
preRes, i:integer;
sumMas:array[1..3]of double;
begin

    for i := 1 to 3 do
    begin
        sumMas[i] := (mtrIO[i, 1] + mrtI[i, 1] + mtrO[i,1] + mtrHist[i, 1])/4; // среднее арифметическое коэффициентов каждого знака моделей
    end;
    
    if(sumMas[1] >= sumMas[2]) then
        preRes := 1
    else
        preRes := 2;

    if(sumMas[preRes] >= sumMas[3]) then
        predictWH := preRes
    else 
        predictWH := 3;
end;

constructor MarkovChain.Create(mem:double);
var
i, j:integer;
begin

    // Заполнение начальной матрицы
    for i := 1 to 9 do
    begin
        for j := 1 to 3 do
        begin
            matrix[i, j, 1] := 1/3; //chance
            matrix[i, j, 2] := 0; // n
        end;
    end;

    memory := mem;
end;

// Обновление матрицы
procedure MarkovChain.updateMatrix(pair, inp: integer);
var
j:integer;
total:double;
begin
    for j := 1 to 3 do
    begin
        matrix[pair, j, 2] := matrix[pair, j, 2] * memory
    end;

    matrix[pair, inp, 2] := matrix[pair, inp, 2] + 1;

    total := 0;
    for j := 1 to 3 do
    begin
        total := total + matrix[pair, j, 2]
    end;

    for j := 1 to 3 do
    begin
        matrix[pair, j, 1] := matrix[pair, j, 2] / total;
        
    end;
end;

// I/O
constructor IOChain.Create(mem:double);
var
i, j:integer;
begin

    // Заполнение начальной матрицы
    for i := 1 to 3 do
    begin
        for j := 1 to 3 do
        begin
            matrix[i, j, 1] := 1/3; //chance
            matrix[i, j, 2] := 0; // n
        end;
    end;

    memory := mem;
end;

// Обновление матрицы I/O
procedure IOChain.updateMatrix(dir, inp: integer);
var
j:integer;
total:double;
begin
    for j := 1 to 3 do
    begin
        matrix[dir, j, 2] := matrix[dir, j, 2] * memory
    end;

    matrix[dir, inp, 2] := matrix[dir, inp, 2] + 1;

    total := 0;
    for j := 1 to 3 do
    begin
        total := total + matrix[dir, j, 2]
    end;

    for j := 1 to 3 do
    begin
        matrix[dir, j, 1] := matrix[dir, j, 2] / total;
        
    end;
end;

// History (len -3)
constructor HistChain.Create(mem:double);
var
i, j:integer;
begin

    // Заполнение начальной матрицы
    for i := 1 to 27 do
    begin
        for j := 1 to 3 do
        begin
            matrix[i, j, 1] := 1/3; //chance
            matrix[i, j, 2] := 0; // n
        end;
    end;

    memory := mem;
end;

// Обновление матрицы
procedure HistChain.updateMatrix(pair, inp: integer);
var
j:integer;
total:double;
begin
    for j := 1 to 3 do
    begin
        matrix[pair, j, 2] := matrix[pair, j, 2] * memory
    end;

    matrix[pair, inp, 2] := matrix[pair, inp, 2] + 1;

    total := 0;
    for j := 1 to 3 do
    begin
        total := total + matrix[pair, j, 2]
    end;

    for j := 1 to 3 do
    begin
        matrix[pair, j, 1] := matrix[pair, j, 2] / total;
        
    end;
end;

function encodePair(o, i:integer):integer;
var
t:integer;
begin
    t:=i;
    repeat
    o:=o*10; t:=t div 10;
    until t=0;

    encodePair:= o + i;
end;

function fromPairToSingle(pair:integer):integer;
begin
    case pair of
        11: fromPairToSingle := 1; //КК
        12: fromPairToSingle := 2; //КН
        13: fromPairToSingle := 3; //КБ
        21: fromPairToSingle := 4; //НК
        22: fromPairToSingle := 5; //НН
        23: fromPairToSingle := 6; //НБ
        31: fromPairToSingle := 7; //БК
        32: fromPairToSingle := 8; //БН
        33: fromPairToSingle := 9; //ББ
    end;
end;


function fromTrioToSingle(pair:integer):integer;
begin
    case pair of
        111: fromTrioToSingle := 1;
        112: fromTrioToSingle := 2;
        113: fromTrioToSingle := 3;
        121: fromTrioToSingle := 4;
        122: fromTrioToSingle := 5;
        123: fromTrioToSingle := 6;
        131: fromTrioToSingle := 7; 
        132: fromTrioToSingle := 8;
        133: fromTrioToSingle := 9; 
        211: fromTrioToSingle := 10;
        212: fromTrioToSingle := 11;
        213: fromTrioToSingle := 12;
        221: fromTrioToSingle := 13;
        222: fromTrioToSingle := 14;
        223: fromTrioToSingle := 15;
        231: fromTrioToSingle := 16; 
        232: fromTrioToSingle := 17;
        233: fromTrioToSingle := 18; 
        311: fromTrioToSingle := 19;
        312: fromTrioToSingle := 20;
        313: fromTrioToSingle := 21;
        321: fromTrioToSingle := 22;
        322: fromTrioToSingle := 23;
        323: fromTrioToSingle := 24;
        331: fromTrioToSingle := 25; 
        332: fromTrioToSingle := 26;
        333: fromTrioToSingle := 27; 
    end;
end;

procedure setParameters(setCount: integer; winsPerSet: integer);
begin
end;

procedure onGameStart();
begin
    model.Create(0.9); // IO
    modelI.Create(0.9); // I
    modelO.Create(0.9); // O
    modeHist.Create(0.9); // Hist
end;

function choose(previousOpponentChoice: integer): integer;
begin
    if not firstGame then
    begin
        out := prefO1; // мой предыдущий ход
        inp := previousOpponentChoice; // предыдущий ход соперника

        pref2 := pref1;
        pref1 := fromPairToSingle(encodePair(out, inp));

        prefI4 := prefI3;
        prefI3 := prefI2;
        prefI2 := prefI1;
        prefI1 := inp;
        
        prefO2 := prefO1;

        if(pref2 <> 0)then
        begin
        
            model.updateMatrix(pref2, inp);
            modelI.updateMatrix(prefI2, inp);
            modelO.updateMatrix(prefO2, inp);
            if prefI4 <> 0 then
            begin
                prefHist := fromTrioToSingle(encodePair(encodePair(prefI4,prefI3), prefI2));
                prefHist1 := fromTrioToSingle(encodePair(encodePair(prefI3,prefI2), prefI1));
                modeHist.updateMatrix(prefHist, inp);
                out := beat[predictWH(model.matrix[pref1], modelI.matrix[prefI1], modelO.matrix[prefO1], modeHist.matrix[prefHist1])];
            end
            else
                out := beat[predict(model.matrix[pref1], modelI.matrix[prefI1], modelO.matrix[prefO1])];
            prefO1 := out;
            choose := out;
        end
        else
        begin 
            prefO1 := SCISSORS;
            choose := SCISSORS;
        end;

    end
    else
    begin 
        firstGame := False;
        prefO1 := SCISSORS;
        choose := SCISSORS;
    end;
end;

procedure onGameEnd();
begin
end;

end.