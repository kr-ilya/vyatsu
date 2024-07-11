program radix_u;

type
massiv = array[1..1000000] of longint;

var
i,j,k,u,n,x,max,z,p:longint;
plus,minus:massiv;
inp, out:text;

procedure sort(var a:massiv; kol:longint);
var
i, mm:longint;
t, l:integer;
f:longint;
vs:massiv;
begin
    for i := 1 to kol do
        vs[i] := a[i];
    f := 1;
    j := 0;
    mm := max;
    if kol > 0 then
    begin
        while mm <> 0 do
        begin
            for l := 0 to 9 do
            begin
                for z := 1 to kol do
                begin
                    t := vs[z] div f mod 10;
                    if t = l then
                    begin
                        inc(j);
                        a[j] := vs[z];
                    end;
                end;
            end;
            for p := 1 to kol do
                vs[p] := a[p];
            j := 0;
            f := f * 10;
            mm := mm div 10;
        end;
    end;
end;

begin
    k := 0;
    u := 0;
    max := 0;
    assign(inp, 'input.txt');
    assign(out, 'output.txt');
    reset(inp);
    reWrite(out);
    readln(inp,n);

    for i := 1 to n do
    begin
        read(inp, x);

        if abs(x) > max then 
            max := x;
        if x < 0 then
        begin
            inc(k);
            minus[k] := abs(x);
        end
        else
        begin
            inc(u);
            plus[u] := x;
        end;
    end;

    max := max * 10;
    sort(plus,u);

    for i := u downto 1 do
        write(out, plus[i], ' ');
    sort(minus, k);

    for i := 1 to k do
        write(out, -minus[i], ' ');
    close(inp);
    close(out);
end.
