program starter;

uses bot1, bot2, math;


var
win1, win2, win1_in_set, win2_in_set:integer;
i:integer;
inp1, inp2:integer;
prev1, prev2:integer;
win_in_set:integer = 20;
num_sets:integer = 20;
log:integer = 0;
log_set:integer = 0;
count_in_set: integer;
count_games: integer;


function getWin(out, inp:integer):integer;
begin
    getWin := (inp - out + 3) mod 3;
end;

function getWinText(out, inp:integer):string;
var
win:integer;
begin
    win := (inp - out + 3) mod 3;
    case win of
        1: getWinText := 'WIN #1';
        2: getWinText := 'WIN #2';
        0: getWinText := 'DRAW';
    end;
end;


function fromIndexToSymbol(id:integer):string;
begin
    case id of
        1: fromIndexToSymbol := 'K';
        2: fromIndexToSymbol := 'B';
        3: fromIndexToSymbol := 'H';
    end;
end;


begin

    writeln('Count WIN in set:');
    readln(win_in_set);
    writeln('Count SETs:');
    readln(num_sets);
    writeln('Logs rounds (0/1):');
    readln(log);
    writeln('Logs sets (0/1):');
    readln(log_set);

    bot1.setParameters(num_sets, win_in_set);
    bot2.setParameters(num_sets, win_in_set);

    bot1.onGameStart();
    bot2.onGameStart();

    

    win1 := 0;
    win2 := 0;
    prev1 := 0;
    prev2 := 0;
    count_games := 0;
    i := 0;
    for i := 1 to num_sets do
    begin
        count_in_set := 0;
        win1_in_set := 0;
        win2_in_set := 0;

        if log_set = 1 then
            writeln('SET STARTED');

        while max(win1_in_set, win2_in_set) < win_in_set do
        begin
            inc(count_in_set);
            inc(count_games);
            inp1 := bot1.choose(prev2);
            inp2 := bot2.choose(prev1);
            

            if getWin(inp2, inp1) = 1 then
            begin
                inc(win1);
                inc(win1_in_set)
            end;

            if getWin(inp1, inp2) = 1 then
            begin
                inc(win2);
                inc(win2_in_set)
            end;

            if log = 1 then
                writeln('BOT #1: ', fromIndexToSymbol(inp1), ' - ', fromIndexToSymbol(inp2), ': ', getWinText(inp2, inp1));
            
            prev1 := inp1;
            prev2 := inp2;
        end;

        if log_set = 1 then
        begin
            writeln();
            writeln('SET FINISHED');
            writeln('(SET) ROUNDRS: ', count_in_set);
            writeln('(SET) Count WINs BOT #1: ', win1_in_set);
            writeln('(SET) Count WINs BOT #2: ', win2_in_set);
            writeln('(SET) Winrate BOT #1: ', win1_in_set/count_in_set:2:2);
            writeln('(SET) Winrate BOT #2: ', win2_in_set/count_in_set:2:2);
            writeln;
        end;

    end;
    writeln;
    writeln('(GAME) ROUNDS: ', count_games);
    writeln('(GAME) Winrate BOT #1: ', win1/count_games:2:2);
    writeln('(GAME) Winrate BOT #2: ', win2/count_games:2:2);

    bot1.onGameEnd();
    bot2.onGameEnd();
    
    
end.