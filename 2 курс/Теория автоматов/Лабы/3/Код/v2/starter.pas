program starter;

uses bot1, bot2, math;

type
    TMapRow = array of integer;
    TMap = array of TMapRow;
    TCoordinates = array of integer;

var
i:integer;
num_sets:integer = 20;
log_set:integer = 0;
count_in_set: integer;
count_games: integer;
shots_count:integer = 0;
bot1Cord:TCoordinates;
bot2Cord:TCoordinates;
map1:TMap;
map2:TMap;
dc1:integer = 0;
dc2:integer = 0;
r:integer;
xod:integer;
count_shots1:integer;
count_shots2:integer;

function checkShipDamage(m:TMap; y,x:integer):integer;
var
i: integer;
t: boolean = False;
begin
    // X - i
    i := 1;
    while ((i < 4) and (t = False)) do
    begin
        if (x - i >= 0) then
        begin
            if(m[y, x-i] = 1) then
            begin
                checkShipDamage := 2;
                t := True;
            end
            else if (m[y, x-i] = 0) then
            begin
                break;
            end
            else if (m[y, x-i] = 2) then
            begin
                inc(i);
            end;
        end
        else
        break;
    end;
    // X + i
    i := 1;
    while ((i < 4) and (t = False)) do
    begin
        if (x + i <= 9) then
        begin
            if(m[y, x+i] = 1) then
            begin
                checkShipDamage := 2;
                t := True;
            end
            else if (m[y, x+i] = 0) then
            begin
                break;
            end
            else if (m[y, x+i] = 2) then
            begin
                inc(i);
            end;
        end
        else
        break;
    end;
    // y - i
    i := 1;
    while ((i < 4) and (t = False)) do
    begin
        if (y - i >= 0) then
        begin
            if(m[y-i, x] = 1) then
            begin
                checkShipDamage := 2;
                t := True;
            end
            else if (m[y-i, x] = 0) then
            begin
                break;
            end
            else if (m[y-i, x] = 2) then
            begin
                inc(i);
            end;
        end
        else
        break;
    end;
    // y + i
    i := 1;
    while ((i < 4) and (t = False)) do
    begin
        if (y + i <= 9) then
        begin
            if(m[y+i, x] = 1) then
            begin
                checkShipDamage := 2;
                t := True;
            end
            else if (m[y+i, x] = 0) then
            begin
                i := 6;
            end
            else if (m[y+i, x] = 2) then
            begin
                inc(i);
            end;
        end
        else
        break;
    end;
    if t = False then
    checkShipDamage := 3;
end;


begin

    writeln('Count SETs:');
    readln(num_sets);
    writeln('Logs sets (0/1):');
    readln(log_set);

    bot1.setParameters(num_sets);
    bot2.setParameters(num_sets);

    bot1.onGameStart();
    bot2.onGameStart();

    
    count_games := 0;
    for i := 1 to num_sets do
    begin
        count_in_set := 0;
        shots_count := 0;
        dc1 := 0;
        dc2 := 0;
        xod := 1;
        count_shots1 := 0;
        count_shots2 := 0;

        inc(count_in_set);
        inc(count_games);

        bot1.onSetStart();
        bot2.onSetStart();

        map1 := bot1.getMap();
        map2 := bot2.getMap();

        if log_set = 1 then
            writeln('SET STARTED');

        while max(dc1, dc2) < 10 do
        begin
            if xod = 1 then
            begin
                inc(count_shots1);

                bot1Cord := bot1.shoot();
                // if log_set = 1 then
                    // writeln('               BOT1 XOD: ', bot1Cord[0], ' ', bot1Cord[1]);
                bot2.onOpponentShot(bot1Cord);
                if (map2[bot1Cord[0], bot1Cord[1]] = 1) then
                begin  
                    r := checkShipDamage(map2, bot1Cord[0], bot1Cord[1]);
                    bot1.shotResult(r);
                    // если убили
                    if r = 3 then
                    begin
                        inc(dc2);
                        // if log_set = 1 then
                        // writeln('BOT #1 KILLLLLLLLLLLLLLLL');
                    end;
                        
                    map2[bot1Cord[0], bot1Cord[1]] := 2;

                end
                else
                begin
                    bot1.shotResult(0);
                    xod := 2;
                end;

            end
            else
            begin
                inc(count_shots2);

                bot2Cord := bot2.shoot();
                // writeln('BOT2 XOD: ', bot2Cord[0], ' ', bot2Cord[1]);
                bot1.onOpponentShot(bot2Cord);
                if (map1[bot2Cord[0], bot2Cord[1]] = 1) then
                begin
                    r := checkShipDamage(map1, bot2Cord[0], bot2Cord[1]);
                    bot2.shotResult(r);
                    // если убили
                    if r = 3 then
                    begin
                        inc(dc1);
                        if log_set = 1 then
                        // writeln('BOT #2 KILL');
                    end;
                    map1[bot2Cord[0], bot2Cord[1]] := 2;
                end
                else
                begin
                    bot2.shotResult(0);
                    xod := 1;
                end;

            end;
            
            
            inc(shots_count);
        end;

        bot1.onSetEnd();
        bot2.onSetEnd();
        if log_set = 1 then
        begin
            writeln();
            writeln('SET FINISHED ', i);
            writeln('(SET) Count Shots BOT #1: ', count_shots1);
            writeln('(SET) Count Shots BOT #2: ', count_shots2);
            writeln('(SET) Count Kills BOT #1: ', dc2);
            writeln('(SET) Count Kills BOT #2: ', dc1);
            // writeln('(SET) Count WINs BOT #1: ', win1_in_set);
            // writeln('(SET) Count WINs BOT #2: ', win2_in_set);
            // writeln('(SET) Winrate BOT #1: ', win1_in_set/count_in_set:2:2);
            // writeln('(SET) Winrate BOT #2: ', win2_in_set/count_in_set:2:2);
            writeln;
        end;

    end;
    writeln;
    // writeln('(GAME) ROUNDS: ', count_games);
    // writeln('(GAME) Winrate BOT #1: ', win1/count_games:2:2);
    // writeln('(GAME) Winrate BOT #2: ', win2/count_games:2:2);

    bot1.onGameEnd();
    bot2.onGameEnd();
    
    
end.