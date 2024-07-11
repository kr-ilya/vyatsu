program main;
//Умножение с автоматической коррекцией все способы
//Масштаб 8(вводить нужно 16 разрядов, т.е первые 8 нулями заполнять)

const m=8;
type 
	sstring=string[m];
	ssstring=string[m*2];
var a: ssstring;                            
	b: ssstring;
	scp: ssstring;
	c: ssstring;
	f: text;
	
function add(a,b:ssstring):ssstring;
var i:integer;
	c:ssstring;
	e:char='0';
begin
	for i:=1 to m*2 do
	begin
		c:=c+'0';
	end;
	for i:=m*2 downto 1 do 
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
	for i:=m*2 downto 2 do
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
	for i:=1 to m*2-1 do
	begin
		a[i]:=a[i+1];
	end;
	if null then 
	begin 
		a[m*2]:='0';
	end
	else a[m*2]:='1';
	exit(a);
end;

function one():ssstring;
var c:ssstring;
	i:integer;
begin
	c:='';
	for i:=1 to m*2 do
	begin
		c:=c+'0';
	end;
	c[m*2]:='1';
	Exit(c);
end;


function otr(pk:ssstring):ssstring;//получение отрицательного
var i:integer;
	c:ssstring;
begin
	c:='';
	for i:=1 to m*2 do
	begin
		c:=c+'0';
		
	end;
	for i:=1 to m*2 do
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
	for i:=m*2 downto 1 do begin
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
	for i:=1 to m*2 do
	begin
		c:=c+'0';
	end;
	c[m*2]:='1';
	c:=sub(dk,c);
	for i:=1 to m*2 do
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

	
function mult1(a,b:ssstring;var f:text):ssstring;// умножение дк 1 способом
var i:integer;
    h:char='0';
	l:ssstring;
	scp:ssstring;
begin
	scp:='';
	for i:=1 to m*2 do
	begin
		scp:=scp+'0';
	end;
	Writeln(f,'Ishodnse dannie:', a,' ',b );
	Writeln('Ishodnse dannie:', a,' ',b );
	for i:=1 to m do
	begin
		if(a[m*2]='1') and (h='0')then
		begin
			//writeln(b);
			if(b[m+1] = '1') then
			begin
				l:=pol(b);
			end else
			begin
				l:=otr(b);
			end;
			//writeln(l);
			scp:=add(scp,sdv(l,m-1,true));
			Writeln(f,'mnozitel: ',a,' SCP: ',scp,' -b');
			Writeln('mnozitel: ',a,' SCP: ',scp,' -b');
		end 
		else if (a[m*2]='0') and (h='1') then
		begin
			//writeln(sdv(b,m-1));
			scp:=add(scp,sdv(b,m-1,true));
			Writeln(f,'mnozitel: ',a,' SCP: ',scp,' +b');
			Writeln('mnozitel: ',a,' SCP: ',scp,' +b');
		end;
		//Сдвиги
		if i<>m then begin
			h:=a[m*2];
			a:=right(a,true);
			if scp[1]='1' then 
			begin
				scp:=right(scp,false);
			end
			else
			begin
				scp:=right(scp,true);
			end;
			Writeln(f,'mnozitel: ',a,' SCP: ',scp,' sdvig');
			Writeln('mnozitel: ',a,' SCP: ',scp,' sdvig');
		end;
		
	end;
	
	Exit(scp);
end;


procedure zapolnenie(var s:ssstring);
var i:integer;
begin
	if s[m+1]='1' then begin
		for i:=1 to m do begin 
			s[i]:='1';
		end;
	end;
end;

function mult2(a,b:ssstring;var f:text):ssstring;// умножение дк 1 способом
var i:integer;
    h:char='0';
	l:ssstring;
	scp:ssstring;
begin
	l:=b;
	scp:='';
	for i:=1 to m*2 do
	begin
		scp:=scp+'0';
	end;
	Writeln(f,'Ishodnse dannie:', a,' ',b );
	Writeln('Ishodnse dannie:', a,' ',b );
	for i:=1 to m do
	begin
		if(a[m*2]='1') and (h='0')then
		begin
			//writeln(b);
			if(b[m-i+1] = '1') then
			begin
				l:=pol(b);
			end else
			begin
				l:=otr(b);
			end;
			//writeln(l);
			scp:=add(scp,sdv(l,i-1,true));
			Writeln(f,'mnozitel: ',a,' mnozimoe: ', sdv(b,i-1,true),' SCP: ',scp,' -b');
			Writeln('mnozitel: ',a,' mnozimoe: ', sdv(b,i-1,true),' SCP: ',scp,' -b');
		end 
		else if (a[m*2]='0') and (h='1') then
		begin
			//writeln(sdv(b,m-1));
			scp:=add(scp,sdv(b,i-1,true));
			Writeln(f,'mnozitel: ',a,' mnozimoe: ', sdv(b,i-1,true),' SCP: ',scp,' +b');
			Writeln('mnozitel: ',a,' mnozimoe: ', sdv(b,i-1,true),' SCP: ',scp,' +b');
		end;
		//Сдвиги
		if i<>m then begin
			h:=a[m*2];
			a:=right(a,true);
			Writeln(f,'mnozitel: ',a,' mnozimoe: ', sdv(b,i,true),' SCP: ',scp,' sdvig');
			Writeln('mnozitel: ',a,' mnozimoe: ', sdv(b,i,true),' SCP: ',scp,' sdvig');
		end;
		
	end;
	
	Exit(scp);
end;

function mult3(a,b:ssstring;var f:text):ssstring;// умножение дк 3 способом
var i:integer;
    h:char;
	l:ssstring;
	scp:ssstring;
begin
	h:=a[m+1];
	l:=b;
	scp:='';
	for i:=1 to m*2 do
	begin
		scp:=scp+'0';
	end;
	Writeln(f,'Ishodnse dannie:', a,' ',b );
	Writeln('Ishodnse dannie:', a,' ',b );
	for i:=1 to m do
	begin
		if(a[m+2]='0') and (h='1')then
		begin
			//writeln(b);
			if(b[1] = '1') then
			begin
				l:=pol(b);
			end else
			begin
				l:=otr(b);
			end;
			//writeln(l);
			scp:=add(scp,l);
			Writeln(f,'mnozitel: ',a,' mnozimoe: ', b,' SCP: ',scp,' -b');
			Writeln('mnozitel: ',a,' mnozimoe: ', b,' SCP: ',scp,' -b');
		end 
		else if (a[m+2]='1') and (h='0') then
		begin
			//writeln(sdv(b,m-1));
			scp:=add(scp,b);
			Writeln(f,'mnozitel: ',a,' mnozimoe: ', b,' SCP: ',scp,' +b');
			Writeln('mnozitel: ',a,' mnozimoe: ', b,' SCP: ',scp,' +b');
		end;
		//Сдвиги
		if i<>m then begin
			h:=a[m+2];
			a:=left(a,true); 
			scp:=left(scp,true);
			Writeln(f,'mnozitel: ',a,' mnozimoe: ', b,' SCP: ',scp,' sdvig');
			Writeln('mnozitel: ',a,' mnozimoe: ', b,' SCP: ',scp,' sdvig');
		end;
		
	end;
	
	Exit(scp);
end;

function mult4(a,b:ssstring;var f:text):ssstring;// умножение дк 3 способом
var i:integer;
    h:char;
	l:ssstring;
	scp:ssstring;
begin
	//b:=right(b,true);
	h:=a[m+1];
	l:=b;
	scp:='';
	for i:=1 to m*2 do
	begin
		scp:=scp+'0';
	end;
	Writeln(f,'Ishodnse dannie:', a,' ',b );
	Writeln('Ishodnse dannie:', a,' ',b );
	for i:=1 to m do
	begin
		if(a[m+2]='0') and (h='1')then
		begin
			//writeln(b);
			if(b[1] = '1') then
			begin
				l:=pol(b);
			end else
			begin
				l:=otr(b);
			end;
			//writeln(l);
			scp:=add(scp,sdv(l,m-i,true));
			Writeln(f,'mnozitel: ',a,' mnozimoe: ', sdv(b,m-i,true),' SCP: ',scp,' -b');
			Writeln('mnozitel: ',a,' mnozimoe: ', sdv(b,m-i,true),' SCP: ',scp,' -b');
		end 
		else if (a[m+2]='1') and (h='0') then
		begin
			//writeln(sdv(b,m-1));
			scp:=add(scp,sdv(b,m-i,true));
			Writeln(f,'mnozitel: ',a,' mnozimoe: ', sdv(b,m-i,true),' SCP: ',scp,' +b');
			Writeln('mnozitel: ',a,' mnozimoe: ', sdv(b,m-i,true),' SCP: ',scp,' +b');
		end;
		//Сдвиги
		if i<>m then begin
			h:=a[m+2];
			a:=left(a,true); 
			Writeln(f,'mnozitel: ',a,' mnozimoe: ', sdv(b,m-i,true),' SCP: ',scp,' sdvig');
			Writeln('mnozitel: ',a,' mnozimoe: ', sdv(b,m-i,true),' SCP: ',scp,' sdvig');
		end;
		
	end;
	
	Exit(scp);
end;



begin 
	Assign(f, '.\text.txt');
	Rewrite(f);
	readln(a);
	readln(b);
	Writeln('1 sposob');
	Writeln(f,'1 sposob');
	c:=mult1(a,b,f);
	
	//writeln(c);
	//right(c);
	//readln(c);
	//c:=pol(c);
	writeln(f,c);
	writeln(f,'    ');
	Writeln('2 sposob');
	Writeln(f,'2 sposob');
	c:=mult2(a,b,f);
	writeln(c);
	
	Writeln('3 sposob');
	Writeln(f,'3 sposob');
	c:=mult3(a,b,f);
	writeln(c);
	
	Writeln('4 sposob');
	Writeln(f,'4 sposob');
	c:=mult4(a,b,f);
	writeln(c);
	
	Close(f);

end.
