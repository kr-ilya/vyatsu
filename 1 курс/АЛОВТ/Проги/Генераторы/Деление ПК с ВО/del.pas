program main;

uses lib;

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
		a:=add(a,otr(b));//вычитание
		writeln(c,' ', a,' ','-delitrl'  );
		writeln(f, c,' ', a,' ','-delitrl'  );
		if a[1]='1' then
		begin
		c:=c+'0';
		a:=add(a,b);//восстановление
		writeln(c,' ', a,' ','vostanovlenie'  );
		writeln(f,c,' ', a,' ','vostanovlenie'  );
		end
		else
		begin
		c:=c+'1';
		end;
		a:=left(a,true);
		writeln(c,' ', a,' ','sdvig'  );
	end;
	a:=add(a,otr(b));//вычитание
	writeln(c,' ', a,' ','-delitrl'  );
	writeln(f, c,' ', a,' ','-delitrl'  );
	
	
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
		a:=add(a,sdv(otr(b),m-i,true));
		writeln(c,' ', a,' ',sdv(b,m-i,true),' ','-delitrl'  );
		writeln(f,c,' ', a,' ',sdv(b,m-i,true),' ','-delitrl'  );
		if a[1]='1' then
		begin
		c:=c+'0';
		a:=add(a,sdv(b,m-i,true));
		writeln(c,' ', a,' ',sdv(b,m-i,true),' ','vostanovlenie'  );
		writeln(f,c,' ', a,' ',sdv(b,m-i,true),' ','vostanovlenie'  );
		end
		else
		begin
		c:=c+'1';
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
	

	
	close(f);

end.
	
