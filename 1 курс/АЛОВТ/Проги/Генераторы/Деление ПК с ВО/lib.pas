unit lib;

interface


const m=5;
type 
	ssstring=string[m];


function add(a,b:ssstring):ssstring;//сложение
function right(a:ssstring;null:boolean):ssstring;
function left(a:ssstring;null:boolean):ssstring;
function otr(pk:ssstring):ssstring;//получение отрицательного
function sub(a,b:ssstring):ssstring;//вычитание
function pol(dk:ssstring):ssstring;//получение положительногоs
function sdv(a:ssstring; i:integer;null:boolean):ssstring;//сдвигвлево на шаг
function sdvr(a:ssstring; i:integer; null:boolean):ssstring;//сдвиг

Implementation

function add(a,b:ssstring):ssstring;
var i:integer;
	c:ssstring;
	e:char='0';
begin
	for i:=1 to m do
	begin
		c:=c+'0';
	end;
	for i:=m downto 1 do 
	begin
		c[i]:='1';
		if(a[i]='1') and (b[i]='1') then
		begin
			if e='1' then
			begin
				c[i]:=e;
			end 
			else
			begin
				c[i]:='0';
				e:='1';
			end;
		end
		else if (a[i]='0') and (b[i]='0') then
		begin
			c[i]:=e;
			e:='0';
		end
		else 
		begin
			if e = '1' then
			begin
				c[i]:='0';
			end 
			else
			begin
				c[i]:='1';
			end;
		end;
	end;
	exit(c);
end;

function right(a:ssstring;null:boolean):ssstring;
var i:integer;
begin
	for i:=m downto 2 do
	begin
		a[i]:=a[i-1];
	end;
	if null then 
	begin 
		a[1]:='0';
	end
	else a[1]:='1';
	exit(a);
end;

function left(a:ssstring;null:boolean):ssstring;
var i:integer;
begin
	for i:=1 to m-1 do
	begin
		a[i]:=a[i+1];
	end;
	if null then 
	begin 
		a[m]:='0';
	end
	else a[m]:='1';
	exit(a);
end;

function one():ssstring;
var c:ssstring;
	i:integer;
begin
	c:='';
	for i:=1 to m do
	begin
		c:=c+'0';
	end;
	c[m]:='1';
	Exit(c);
end;


function otr(pk:ssstring):ssstring;//получение отрицательного
var i:integer;
	c:ssstring;
begin
	c:='';
	for i:=1 to m do
	begin
		c:=c+'0';
		
	end;
	for i:=1 to m do
	begin
		if pk[i] = '0' then
		begin
			c[i]:='1';
		end
		else
		begin
			c[i]:='0';
		end;
	end;
	
	//writeln(add(c,one()));
	Exit(add(c,one()));
end;

function sub(a,b:ssstring):ssstring;
var i,j:integer;
	s:ssstring;
begin
	for i:=m downto 1 do begin
       case a[i] of
        '1': if b[i]='0' then s:='1'+s else s:='0'+s;
        '0': if b[i]='0' then s:='0'+s else begin
                s:='1'+s;
                if (a[i-1]='1') then a[i-1]:='0' else begin
                   j:=1;
                   while (i-j>0) and (a[i-j]='0') do begin
                         a[i-j]:='1';
                         inc(j);
                   end;
                   a[i-j]:='0';
                end;
             end;
       end;
    end;
	exit(s);
end;

function pol(dk:ssstring):ssstring;//получение положительного
var i:integer;
	c:ssstring;
begin
	c:='';
	for i:=1 to m do
	begin
		c:=c+'0';
	end;
	c[m]:='1';
	c:=sub(dk,c);
	for i:=1 to m do
	begin
		if(c[i] = '0') then
		begin
			c[i]:='1';
		end
		else
		begin
			c[i]:='0';
		end;
	end;
	
	Exit(c);
end;

function sdv(a:ssstring; i:integer;null:boolean):ssstring;//сдвиг
begin
	for i:=1 to i do
	begin
		a:=left(a,null);
	end;
	Exit(a);
end;

function sdvr(a:ssstring; i:integer; null:boolean):ssstring;//сдвиг
begin
	for i:=1 to i do
	begin
		a:=right(a,null);
	end;
	Exit(a);
end;

end.