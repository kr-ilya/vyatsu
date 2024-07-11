// 2 Деление без восстановления остатоков. Делал по лекции опять же.
// во втором сопособе не надо нуль в начале. В первом способе почему-то в знаковом два рязряда, поэтому не стал под второй переделывать. Воот

program main;

uses lib2;

type itog=record
	chas:ssstring;
	ost:ssstring;
	
end;


var a: ssstring;                            
	b: ssstring;
	scp: ssstring;
	c: itog;
	f: text;
	
	
	
	
function delete1(a,b:ssstring;var f:text):itog;
var 
c:ssstring;
i:integer;
g:itog;
begin
	c:='';
	for i:=1 to m do begin
		a:=left(a,true);
		writeln(c,' ', a,' ','sdvig'  );
		writeln(f,c,' ', a,' ','sdvig'  );
		if a[1]='0' then
		begin
			a:=add(a,sdv(otr(b),m,true));
			if a[1]='1' then
			begin
			c:=c+'0';
			
			end
			else
			begin
			c:=c+'1';
			end;
			writeln(c,' ', a,' ','-delitrl'  );
		end
		else
		begin
			a:=add(a,sdv(b,m,true));
			if a[1]='1' then
			begin
			c:=c+'0';
			end
			else
			begin
			c:=c+'1';
			end;
			writeln(c,' ', a,' ','+delitrl'  );
		end;
		
		
		
		
		
	
	end;
	
	g.chas:=c;
	g.ost:=a;
	delete1:=g;
end;


function delete2(a,b:ssstring;var f:text):itog;
var 
c:ssstring;
i:integer;
g:itog;
begin
	c:='';
	for i:=1 to m do begin
		//a:=left(a,true);
		writeln(c,' ', a,' ',sdv(b,m-i,true),' ','sdvig'  );
		writeln(f,c,' ', a,' ',sdv(b,m-i,true),' ','sdvig'  );
		if a[1]='0' then
		begin
			a:=add(a,sdv(otr(b),m-i,true));
			if a[1]='1' then
			begin
			c:=c+'0';
			
			end
			else
			begin
			c:=c+'1';
			end;
			writeln(c,' ', a,' ',sdv(b,m-i,true),' -delitrl'  );
			writeln(f,c,' ', a,' ',sdv(b,m-i,true),' -delitrl'  );
		end
		else
		begin
			a:=add(a,sdv(b,m-i,true));
			if a[1]='1' then
			begin
			c:=c+'0';
			end
			else
			begin
			c:=c+'1';
			end;
			writeln(c,' ', a,' ',sdv(b,m-i,true),' +delitrl'  );
			writeln(f,c,' ', a,' ',sdv(b,m-i,true),' +delitrl'  );
		end;
		
	
	end;
	
	g.chas:=c;
	g.ost:=a;
	delete2:=g;
end;


begin
	Assign(f, '.\text.txt');
	Rewrite(f);
	readln(a);
	readln(b);
	Writeln('1 sposob');
	c:=delete1(a,b,f);
	writeln(c.chas, ' ', c.ost);
	
	Writeln('2 sposob');
	c:=delete2(a,b,f);
	writeln(c.chas, ' ', c.ost);
	
	close(f);

end.
	
