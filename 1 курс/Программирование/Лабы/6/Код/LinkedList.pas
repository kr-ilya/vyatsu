unit LinkedList;

interface

type    
    TList = record
		value: integer;
		next: ^TList;
    end;
    
    TUList = record
		first: ^TList;
    end;

procedure list_create(var list: TUList);

procedure list_delete(var list: TUList);

function list_empty(list: TUList): Boolean;

procedure list_push_start(var list: TUList; value: integer);

procedure list_push_end(var list: TUList; value: integer);

procedure list_print(list: TUList);

procedure list_remove_start(var list: TUList);

procedure list_remove_end(var list: TUList);

procedure list_help;

implementation

procedure list_create(var list: TUList);
begin
    list.first := nil;
end;

procedure list_delete(var list: TUList);
var
    entList: ^TList;
begin
    while (list.first <> nil) do
    begin
		entList := list.first^.next;
		dispose(list.first);
		list.first := entList;
    end;
end;

function list_empty(list: TUList) : Boolean;
begin
    if list.first = nil then
		writeln('List is empty')
    else
		writeln('List is not empty');
    list_empty := list.first <> nil;
end;

procedure list_push_start(var list: TUList; value: integer);
var entList: ^TList;
begin
    new(entList);
    entList^.value := value;
    entList^.next := list.first;
    list.first := entList;
end;

procedure list_push_end(var list: TUList; value: integer);
type
	TLe = ^TList;
var
    entList: ^TList;
	head: ^TLe;
begin
    new(entList);
    entList^.value := value;
    entList^.next := nil;	
	head := @list.first;
	while head^ <> nil do
	begin
		head := @(head^)^.next;
	end;
	head^ := entList;
end;

procedure list_remove_start(var list: TUList);
type
	TLe = ^TList;
var
    entList: ^TList;
	head: ^TLe;
begin
	head := @list.first;
	if (head^ = nil) then
		writeln('No such values in list')
	else
	begin
		entList := (head^)^.next;
		dispose(head^);
		head^ := entList;
	end;
end;

procedure list_remove_end(var list: TUList);
type
	TLe = ^TList;
var
	head: ^TLe;
begin
	head := @list.first;

	if (head^ = nil) then
		writeln('No such values in list')
	else
	begin
		while (head^)^.next <> nil do
		begin
			head := @(head^)^.next;
		end;

		dispose(head^);
		head^ := nil;
	end;
end;

procedure list_print(list: TUList);
var
    entList : ^TList;
begin
	entList := list.first;
	while (entList <> nil) do
	begin
		write(entList^.value, ' ');
		entList := entList^.next;
	end;
	writeln;
end;

procedure list_help;
begin
	writeln('help - Show help message');
	writeln('pushstart <value> - Add element at the start');
	writeln('pushend <value> - Add element at the end');
	writeln('removestart- Remove element from start');
	writeln('removeend- Remove element from end');
	writeln('empty - Test whether list is empty');
	writeln('print - Print all elements stored in list');
	writeln('clear - Clear list');
	writeln('exit - Exit the pragramm');
end;

end.
