unit bot2;

interface

type
    TMapRow = array of integer;
    TMap = array of TMapRow;
    TCoordinates = array of integer;

const
    // Коды результатов выстрела:
    SHOT_RESULT_EMPTY: integer = 0; // Промах
    SHOT_RESULT_DAMAGE: integer = 2; // Корабль соперника ранен (подбит)
    SHOT_RESULT_KILL: integer = 3; // Корабль соперника убит (подбиты все палубы)

{
    Вызывается один раз перед началом игры.

    Передаёт параметры, с которыми запущен турнир:
    - setCount: максимальное количество сетов в игре
}
procedure setParameters(setCount: integer);

{
    Вызывается один раз в начале игры.
}
procedure onGameStart();

{
    Вызывается один раз в начале сета.
}
procedure onSetStart();

{
    Возвращает карту с расстановкой кораблей.
    Вызывается в начале каждого сета (каждый сет можно делать новую расстановку).

    Карта должна иметь размер 10х10 и быть заполнена следующим образом:
    - 0 - пустая клетка
    - 1 - клетка с палубой корабля

    На карте должно быть четыре 1-палубника, три 2-палубника, два 3-палубника и один 4-палубник.
    Корабли должны быть расположены строго вертикально или горизонтально (т.е., не иметь изгибов).
    Корабли не должны соприкасаться.
}
function getMap(): TMap;

{
    Возвращает координаты клетки, в которую на текущем ходу стреляет бот.

    Координаты задаются массивом из двух целых чисел.
    Первая соответствует строке (координата по вертикали), вторая - столбцу (координата по горизонтали).
    Отсчёт ведётся с левого верхнего угла.
    Т.е., чтобы выстрелить в клетку map[i][j], необходимо вернуть [i, j].

    Результат выстрела будет гарантированно передан следующим вызовом через shotResult.
}
function shoot(): TCoordinates;

{
    Вызывается сразу после shoot, чтобы передать результат выстрела.
    Возможные значения resultCode:
    - 0 - Промах
    - 2 - Корабль соперника ранен (подбит)
    - 3 - Корабль соперника убит (подбиты все палубы)
}
procedure shotResult(resultCode: integer);

{
    Вызывается после выстрела соперника.
    Параметр cell - координаты клетки, в которую выстрелил соперник.
}
procedure onOpponentShot(cell: TCoordinates);

{
    Вызывается один раз в конце сета.
}
procedure onSetEnd();

{
    Вызывается один раз в конце игры.
}
procedure onGameEnd();

implementation

var
    lastShotIdx: integer;
    idx,idy, mid:integer;
    maps: array[0..2] of TMap;

procedure setParameters(setCount: integer);
begin
end;

procedure onGameStart();
begin
mid := 0;

end;

procedure onSetStart();
begin
    lastShotIdx := 0;
    idx := 0;
    idy := 0;

    maps[0] := TMap.Create(// 2  3  4  5  6  7  8  9
        TMapRow.Create(1, 0, 1, 0, 1, 0, 1, 0, 0, 0), //0
        TMapRow.Create(0, 0, 1, 0, 1, 0, 1, 0, 0, 0), //1
        TMapRow.Create(1, 0, 0, 0, 1, 0, 1, 0, 0, 0), //2
        TMapRow.Create(0, 0, 0, 0, 0, 0, 1, 0, 0, 0), //3
        TMapRow.Create(1, 0, 1, 0, 0, 0, 0, 0, 0, 0), //4
        TMapRow.Create(0, 0, 1, 0, 1, 0, 0, 0, 0, 0), //5
        TMapRow.Create(1, 0, 0, 0, 1, 0, 0, 0, 0, 0), //6
        TMapRow.Create(0, 0, 1, 0, 1, 0, 0, 0, 0, 0), //7
        TMapRow.Create(0, 0, 1, 0, 0, 0, 0, 0, 0, 0), //8
        TMapRow.Create(0, 0, 0, 0, 0, 0, 0, 0, 0, 0) //9
    );

    maps[1] := TMap.Create(// 2  3  4  5  6  7  8  9
        TMapRow.Create(0, 1, 0, 1, 0, 0, 0, 0, 0, 0), //0
        TMapRow.Create(0, 0, 0, 0, 0, 0, 0, 1, 0, 0), //1
        TMapRow.Create(0, 0, 0, 0, 0, 1, 0, 1, 0, 1), //2
        TMapRow.Create(0, 0, 0, 0, 0, 0, 0, 0, 0, 1), //3
        TMapRow.Create(0, 0, 1, 1, 1, 0, 0, 0, 0, 0), //4
        TMapRow.Create(0, 0, 0, 0, 0, 0, 1, 1, 0, 0), //5
        TMapRow.Create(0, 1, 0, 0, 0, 0, 0, 0, 0, 0), //6
        TMapRow.Create(0, 1, 0, 0, 0, 0, 0, 0, 1, 0), //7
        TMapRow.Create(0, 1, 0, 0, 0, 0, 0, 0, 0, 0), //8
        TMapRow.Create(0, 0, 0, 0, 1, 1, 1, 1, 0, 0) //9
    );

    maps[2] := TMap.Create(// 2  3  4  5  6  7  8  9
        TMapRow.Create(1, 0, 0, 0, 0, 0, 1, 0, 0, 1), //0
        TMapRow.Create(0, 0, 0, 0, 1, 0, 1, 0, 0, 0), //1
        TMapRow.Create(0, 0, 0, 0, 1, 0, 1, 0, 0, 0), //2
        TMapRow.Create(1, 1, 0, 0, 1, 0, 0, 0, 0, 0), //3
        TMapRow.Create(0, 0, 0, 0, 1, 0, 0, 1, 1, 1), //4
        TMapRow.Create(0, 0, 0, 0, 0, 0, 0, 0, 0, 0), //5
        TMapRow.Create(0, 0, 1, 1, 0, 0, 0, 0, 0, 0), //6
        TMapRow.Create(0, 0, 0, 0, 0, 0, 1, 0, 0, 0), //7
        TMapRow.Create(0, 0, 0, 0, 0, 0, 1, 0, 0, 0), //8
        TMapRow.Create(1, 0, 0, 0, 0, 0, 0, 0, 0, 1) //9
    );
    
end;

function getMap(): TMap;
begin
    getMap := maps[mid];
    
    if mid < 2 then
        inc(mid)
    else
        mid := 0;
end;

function shoot(): TCoordinates;
begin
    shoot := TCoordinates.Create(idy, idx);
    
    if(idx = 9) then
    begin
        if(idy = 9) then
            idy := 0
        else
            inc(idy);
        idx := 0;
    end
    else
        inc(idx);
    
    // shoot := TCoordinates.Create(random(9), random(9));
    // lastShotIdx := lastShotIdx + 1;
end;

procedure shotResult(resultCode: integer);
begin
end;

procedure onOpponentShot(cell: TCoordinates);
begin
end;

procedure onSetEnd();
begin
end;

procedure onGameEnd();
begin
end;

end.