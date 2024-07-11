f = @(x1, x2)3*x1.^2.*cos(x2+3);
best_type = "trimf";

for i = 1:length(mamdani.inputs)
    for j = 1:length(mamdani.inputs(i).mf)
        mamdani.inputs(i).mf(j).type = best_type;
    end
end
for i = 1:length(mamdani.outputs)
    for j = 1:length(mamdani.outputs(i).mf)
        mamdani.outputs(i).mf(j).type = best_type;
    end
end

% fuzzyLogicDesigner(mamdani);
% pause;

and_methods = ["min", "prod"];
or_methods = ["max", "probor"];
implication_methods = ["min", "prod"];
aggregation_methods = ["max", "probor"];
defuzz_methods = ["centroid", "bisector", "lom", "mom", "som"];

best_and_method = "";
best_and_error = intmax;

for i = 1:length(and_methods)
    mamdani.AndMethod = and_methods(i);
    [x1, x2, z] = gensurf(mamdani);
    
    y = f(x1, x2);
    E = immse(z, y);
    disp(and_methods(i) + " error: " + E);
    if E < best_and_error
        best_and_error = E;
        best_and_method = and_methods(i);
    end
end

mamdani.AndMethod = best_and_method;

best_or_method = "";
best_or_error = intmax;
for i = 1:length(or_methods)
    mamdani.OrMethod = or_methods(i);
    
    [x1, x2, z] = gensurf(mamdani);
    
    y = f(x1, x2);
    E = immse(z, y);
    disp(or_methods(i) + " error: " + E);
    if E < best_or_error
        best_or_error = E;
        best_or_method = or_methods(i);
    end
end

mamdani.OrMethod = best_or_method;

best_implication_method = "";
best_implication_error = intmax;

for i = 1:length(implication_methods)
    mamdani.ImplicationMethod = implication_methods(i);
    
    [x1, x2, z] = gensurf(mamdani);
    
    y = f(x1, x2);
    E = immse(z, y);
    disp(implication_methods(i) + " error: " + E);
    if E < best_implication_error
        best_implication_error = E;
        best_implication_method = implication_methods(i);
    end
end

mamdani.ImplicationMethod = best_implication_method;

best_aggregation_method = "";
best_aggregation_error = intmax;

for i = 1:length(aggregation_methods)
    mamdani.AggregationMethod = aggregation_methods(i);
    
    [x1, x2, z] = gensurf(mamdani);
    
    y = f(x1, x2);
    E = immse(z, y);
    disp(aggregation_methods(i) + " error: " + E);
    if E < best_aggregation_error
        best_aggregation_error = E;
        best_aggregation_method = aggregation_methods(i);
    end
end

mamdani.AggregationMethod = best_aggregation_method;

best_defuzz_method = "";
best_defuzz_error = intmax;
for i = 1:length(defuzz_methods)
    mamdani.DefuzzMethod = defuzz_methods(i);
    
    [x1, x2, z] = gensurf(mamdani);
    
    y = f(x1, x2);
    E = immse(z, y);
    disp(defuzz_methods(i) + " error: " + E);
    if E < best_defuzz_error
        best_defuzz_error = E;
        best_defuzz_method = defuzz_methods(i);
    end
end

mamdani.DefuzzMethod = best_defuzz_method;

fuzzyLogicDesigner(mamdani);
pause;

[x1, x2, z] = gensurf(mamdani);
y = f(x1, x2);
E = immse(z, y);

disp("Final error: " + E);
