program podschet_u;
type
massivA = array[0..1000] of longint;
massivB = array[-10000..10000] of longint;

procedure sort(var a:massivA; b:massivB; n:longint);
var
i,j,idx:integer;
begin
    for i := 0 to n-1 do
    begin
    inc(b[a[i]]);
    end;
    idx := 0;
    for i:=-10000 to 10000 do
    begin
        j := 0;
        while(j < b[i]) do
        begin
            a[idx] := i;
            inc(idx);
            inc(j);
        end;
    end;
end;

var
a:massivA;
b:massivB;
i:integer;
inp, out:text;
n:longint;
begin
    assign(inp, 'input.txt');
    assign(out, 'output.txt');
    reset(inp);
    rewrite(out);
    readln(inp, n);
    b[0] := 0;
    for i := 0 to n - 1 do
        read(inp, a[i]);
    sort(a, b, n);
    for i := n-1 downto 0 do
        write(out, a[i], ' ');
    close(inp);
    close(out);
end.