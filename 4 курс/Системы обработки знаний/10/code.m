f = @(x1, x2)3*x1.^2.*cos(x2+3);

sugeno_anfis = readfis('anfis_model.fis');
[x1, x2, z] = gensurf(sugeno_anfis);
y = f(x1, x2);
error = immse(z, y);
disp("ANFIS Sugeno error: " + error)
