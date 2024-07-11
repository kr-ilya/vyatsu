unit shell;

interface

uses
    crt, sysutils, LinkedList;

const 
    // Количество команд
	cmdlist_size = 9;
    // Список команд
    cmdlist: array[0..(cmdlist_size - 1)] of string = (
        'clear',
        'exit',
        'empty',
        'help',
        'pushend',
        'pushstart',
        'removestart',
        'removeend',
        'print'
    );

    // Количество аргументов у каждой команды
    arg_num: array[0..(cmdlist_size - 1)] of integer = (
        0, 0, 0, 0, 1, 1, 0, 0, 0
    );

    // Максимальное количество элементов в истории команд
    max_hist_elems = 100;
    // Максимальная длина строки
    string_size = 50;
    st : string = '> ';

type 
    THistory = record
        cmds: array of string;
        size: integer;
        current: integer;
        deep: integer;
        last: integer;
    end;
    
    TArgs = array of string;
    TVals = array [0..1] of integer;

var
    hr: THistory; // История команд
    list: TUList;
    cmd: string; // текущая команда
    p: integer; // количество символов в строке
    pc: integer; // вспомогательная переменная

procedure start();

implementation

procedure history_init;
var
    i: integer;
begin
    setlength(hr.cmds, 1);
    hr.size := 1;
    for i := 0 to hr.size - 1 do
        hr.cmds[i] := '';
    hr.current := hr.size - 1;
    hr.last := hr.size - 1;
    hr.deep := 0;
end;

//  Удаление старой записи из истории для добаления новой, если записей максимальное количество
function history_shift(v, sz, sh: integer): integer;
begin
    history_shift := (v + sz + sh) mod sz;
end;

procedure history_update;
begin
    hr.cmds[hr.current] := cmd;
end;

// Добавление записи в историю
procedure history_push;
begin
    hr.cmds[hr.last] := cmd;
    if hr.size < max_hist_elems then
    begin
		setlength(hr.cmds, hr.size + 1);
		hr.last := hr.size;
		inc(hr.size);
	end
	else
		hr.last := history_shift(hr.last, hr.size, 1);
    hr.deep := 0;
    hr.current := hr.last;
end;

procedure str_update(offset, pre_compl: integer; str_pre_coml: string);
var
    x, y: integer;
begin
    x := wherex;
    y := wherey;
    write(chr(13));
    clreol;
    if pre_compl = 0 then
        write(chr(13), st, cmd)
    else
        begin
            write(chr(13), st, cmd);
            Textbackground(3);
            Textcolor(0);
            write(str_pre_coml);
            Textbackground(0);
            Textcolor(15);
        end;
    history_update;
    if x + offset > 0 then
        gotoxy(x + offset, y);
end;

//Удаление пробелов
procedure str_skip_whitesp(var str: string);
var i : integer;
begin
    i := 1;
    while i <= length(str) do
        if str[i] = ' ' then
            delete(str, i, 1)
        else
            break;
end;

procedure str_goto_begin;
var
    x, y: integer;
begin
    p := 0;
    write(chr(13));
    x := wherex;
    y := wherey;
    gotoxy(x + length(st), y);
end;

procedure str_goto_end;
var
    x, y, offset : integer;
begin
    x := wherex;
    y := wherey;
    offset := length(cmd) - p;
    p := length(cmd);
    if x + offset > 0 then
        gotoxy(x + offset, y);
end;

procedure str_pre_complete;
    var
    i, offset, cnt, k: integer;
    cp, rm: string;
begin
    cp := cmd;
    str_skip_whitesp(cp);
    offset := length(cmd) - length(cp);
    cnt := 0; k := -1;
    for i := 0 to cmdlist_size - 1 do
        if pos(cp, cmdlist[i]) = 1 then
        begin
            if k = -1 then k := i;
            inc(cnt);
        end;
    if cnt = 1 then
    begin
        pc := 1;
        // str_goto_begin;
        // cmd := copy(cmd, 0, offset) + cmdlist[k];
        rm := copy(cmdlist[k], length(cp)+1, length(cmdlist[k]));
        str_update(0, 1, rm);
        // str_goto_end;
    end;
end;

procedure str_add_char(c: Char);
begin
    if length(cmd) < string_size then
    begin
        cmd := copy(cmd, 1, p) + c + copy(cmd, p + 1, length(cmd));
        inc(p);
        str_update(1, 0, '');
        str_pre_complete;
    end;
end;

procedure str_delete_char;//**//
begin
    if p < length(cmd) then
    begin
        delete(cmd, p + 1, 1);
        str_update(0, 0, '');
    end;
end;

procedure str_backsp_char;//**//
begin
    if p > 0 then
    begin
        delete(cmd, p, 1);
        dec(p);
        write(chr(8), ' ');
        str_update(-1, 0, '');
    end;
end;

procedure str_shift_left; //**//
begin
    if p > 0 then
    begin
        dec(p);
        str_update(-1, 0, '');
    end;    
end;

procedure str_shift_right;
begin
    if p < length(cmd) then
    begin
        inc(p);
        str_update(1, 0, '');
    end;    
end;

procedure history_prev_cmd;
begin
    if hr.deep < hr.size - 1 then
    begin
        hr.current := history_shift(hr.current, hr.size, -1);
        inc(hr.deep);
        str_goto_begin;
        cmd := hr.cmds[hr.current];
        str_update(0, 0, '');
        str_goto_end;
    end;
end;

procedure history_next_cmd;
begin
    if hr.deep > 0 then
    begin
        hr.current := history_shift(hr.current, hr.size, 1);
        dec(hr.deep);
        str_goto_begin;
        cmd := hr.cmds[hr.current];
        str_update(0, 0, '');
        str_goto_end;
    end;
end;

//Автодополнение
procedure str_autocomplete;
var
    i, offset, cnt, k : integer;
    cp: string;
begin
    cp := cmd;
    str_skip_whitesp(cp);
    offset := length(cmd) - length(cp);
    cnt := 0; k := -1;
    for i := 0 to cmdlist_size - 1 do
        if pos(cp, cmdlist[i]) = 1 then
        begin
            if k = -1 then k := i;
            inc(cnt);
        end;
    if cnt = 1 then
    begin
        str_goto_begin;
        cmd := copy(cmd, 1, offset) + cmdlist[k];
        str_update(0, 0, '');
        str_goto_end;
    end;
end;

function str_tokenize(str : string) : TArgs;
var
    i, len : integer;
    arg : string;
    args : TArgs;
begin
    setlength(args, 0);
    len := 0;
    while true do
    begin
        str_skip_whitesp(str);
        arg := '';
        i := 1;
        while (i <= length(str)) and (str[i] <> ' ') do
        begin
            arg := arg + str[i];
            inc(i);
        end;
        str := copy(str, i, length(str));
        if length(arg) > 0 then
        begin
            setlength(args, len + 1);
            args[len] := arg;
            inc(len);
        end;
        if length(str) = 0 then
            break;
    end;
    str_tokenize := args;
end;

procedure str_parse(str: string; var vals: TVals; var _cmd: string; var err: integer);
var
    tokens : TArgs;
    i, j, pp : integer;
begin
    tokens := str_tokenize(str);
    if length(tokens) = 0 then exit;
    _cmd := tokens[0];
    pp := 0;
    while pp < cmdlist_size do
        if _cmd = cmdlist[pp] then 
            break
        else 
            inc(pp);
    if pp = cmdlist_size then
    begin
        writeln('Undefined command: ', _cmd);
        err := 0;
        exit;
    end;
    
    for i := 1 to length(tokens) - 1 do
    begin
        val(tokens[i], vals[i - 1], j);
        if j <> 0 then
        begin
            writeln('Undefined arg: ', tokens[i]);
            err := i;
            exit;
        end;
    end;
    if arg_num[pp] <> length(tokens) - 1 then
    begin
        writeln('Invalid count of args');
        err := 0;
        exit;
    end;
    err := -1;
end;

procedure str_clear;//**//
begin
    cmd := '';
    p := 0;
    str_update(length(st), 0, '');
end;

procedure hotkeys;
var
    code : integer;
begin		
    code := ord(readkey);
    case code of
    75 : //left
        str_shift_left;
    77 : //right
        str_shift_right;
    72 : //up
        history_prev_cmd;
    80 : //down
        history_next_cmd;
    83 : //delete
        str_delete_char;
    79 : //end
        str_goto_end;
    71 : //home
        str_goto_begin;
    end;
end;

function shell_eval: integer;
var
    err : integer;
    arg0 : string;
    vals : TVals;
begin
    history_push;
    str_goto_begin;
    shell_eval := 1;
    writeln;
    str_parse(cmd, vals, arg0, err);
    if err <> -1 then
    begin
        str_clear;
        exit;
    end;
    
    case arg0 of
    'clear' :
        list_delete(list);
    'exit' : 
        shell_eval := 0;
    'empty' :
        list_empty(list);
    'help' : 
		list_help;
    'pushend' : 
        list_push_end(list, vals[0]);
    'pushstart' : 
        list_push_start(list, vals[0]);
    'removestart':
        list_remove_start(list);
    'removeend':
        list_remove_end(list);
    'print' : 
        list_print(list);
    end;
    str_clear;
end;

procedure start();//**//
var
    ch: char;
    code: integer;
begin
    clrscr;
    history_init;
    str_clear;
    list_create(list);
    while true do
    begin
        ch := readkey;
        code := ord(ch);
        
        case code of
        13, 10: //enter
            if shell_eval = 0 then 
                break;
        8: str_backsp_char; //backspace
        9: str_autocomplete; //tab (autocomplete)
        0: hotkeys
        else
            str_add_char(ch);
        end;
    end;
    list_delete(list);
end;

end.
