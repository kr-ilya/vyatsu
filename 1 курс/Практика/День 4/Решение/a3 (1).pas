type po=record a,b:integer; end;

var f:text;
b:array of boolean; int:array of integer;
gr:array of po;
io,io1,i,i1,po2:longint;
po1:int64;
bar:byte; s:string;

begin
for bar:=1 to 3 do begin
s:='task'+bar+'.txt';
Assign(f,s);
reset(f);
read(f,io);
setlength(b,io);setlength(int,io);
for i:= 0 to io-1 do begin b[i]:=false; read(f,io1); int[i]:=io1; end;
read(f,io);
setlength(gr,io);
for i:= 0 to io-1 do begin read(f,io1); gr[i].a:=io1;read(f,io1); gr[i].b:=io1; end;
close(f);
s:='z'+bar+'.txt';
Assign(f,s);rewrite(f); write(f,'0'); close(f);

for i:=b.Length-1 downto 0 do 
if not(b[i]) then 
for i1:=0 to gr.Length-1 do 
if (gr[i1].a-1=i)or(gr[i1].b-1=i) then 
if gr[i1].a-1=i then b[gr[i1].b-1]:=true else b[gr[i1].a-1]:=true;
po1:=0; po2:=0; 
for i:=0 to b.Length-1 do if not(b[i]) then begin po1:=po1+int[i]; inc(po2); end;
reset(f);
read(f,io);
close(f);
if po1>io then begin 
rewrite(f);
writeln(f,po1);
writeln(f,po2);
for i:=0 to b.Length-1 do if not(b[i]) then write(f,int[i],' ');
close(f); end;

for i:=b.Length-1 downto 0 do b[i]:=false;
b[b.Length-1]:=true;
for i:=b.Length-1 downto 0 do 
if not(b[i]) then 
for i1:=0 to gr.Length-1 do 
if (gr[i1].a-1=i)or(gr[i1].b-1=i) then 
if gr[i1].a-1=i then b[gr[i1].b-1]:=true else b[gr[i1].a-1]:=true;
po1:=0; po2:=0; 
for i:=0 to b.Length-1 do if not(b[i]) then begin po1:=po1+int[i]; inc(po2); end;
reset(f);
read(f,io);
close(f);
if po1>io then begin 
rewrite(f);
writeln(f,po1);
writeln(f,po2);
for i:=0 to b.Length-1 do if not(b[i]) then write(f,int[i],' ');
close(f); end;
end;
end.