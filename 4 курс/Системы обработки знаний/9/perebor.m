f = @(x1, x2)3*x1.^2.*cos(x2+3);

best_type = "trimf";

for i = 1:length(sugeno.inputs)
    for j = 1:length(sugeno.inputs(i).mf)
        sugeno.inputs(i).mf(j).type = best_type;
    end
end

% fuzzyLogicDesigner(sugeno);
% pause;
and_methods = ["min", "prod"];
or_methods = ["max", "probor", "sum"];
implication_methods = ["prod"];
aggregation_methods = "sum";
defuzz_methods = ["wtaver", "wtsum"];

best_methods = [];
best_error = intmax;

for and_method = and_methods
    for or_method = or_methods
        for implication_method = implication_methods
            for aggregation_method = aggregation_methods
                for defuzz_method = defuzz_methods
                    sugeno.AndMethod = and_method;
                    sugeno.OrMethod = or_method;
                    sugeno.ImplicationMethod = implication_method;
                    sugeno.AggregationMethod = aggregation_method;
                    sugeno.DefuzzMethod = defuzz_method;
                    
                    [x1, x2, z] = gensurf(sugeno);
                    y = f(x1, x2);
                    error = immse(z, y);
                    
                    if error < best_error
                        best_error = error;
                        best_methods = [and_method, or_method, implication_method, aggregation_method, defuzz_method];
                    end
                end
            end
        end
    end
end

sugeno.AndMethod = best_methods(1);
sugeno.OrMethod = best_methods(2);
sugeno.ImplicationMethod = best_methods(3);
sugeno.AggregationMethod = best_methods(4);
sugeno.DefuzzMethod = best_methods(5);

fuzzyLogicDesigner(sugeno);
pause;

[x1, x2, z] = gensurf(sugeno);
y = f(x1, x2);
E = immse(z, y);
disp("Final error: " + E);
