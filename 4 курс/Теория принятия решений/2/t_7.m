[X, Y] = meshgrid([-1 : 1, 1 : 3]);
Z = log(1 + X.^2 + Y.^2).^2 + (X - Y - 1).^2;
plot3(X, Y, Z)

[xmin, minf] = fminsearch(@Fxy, [2;2]);

xmin
minf

function f = Fxy(x)
f = log(1 + x(1)^2 + x(2)^2)^2 + (x(1) - x(2) - 1)^2;
end
