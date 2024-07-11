f = @(x1, x2)3*x1.^2.*cos(x2+3);

types = ["gaussmf", "gauss2mf", "trimf", "trapmf", "gbellmf"];
types_errors = {};

for i = 1:length(types)
    for j = 1:length(mamdani.inputs)
        for k = 1:length(mamdani.inputs(j).mf)
            mamdani.inputs(j).mf(k).type = types(i);
        end
    end
    for j = 1:length(mamdani.outputs)
        for k = 1:length(mamdani.outputs(j).mf)
            mamdani.outputs(j).mf(k).type = types(i);
        end
    end
    
    % fuzzyLogicDesigner(mamdani);
    fuzzy(mamdani)
    pause;
    
    [x1, x2, z] = gensurf(mamdani);
    
    y = f(x1, x2);
    E = immse(z, y);
    disp(types(i) + " " + E);
    
    types_errors{end+1} = [types(i), E];
end

best_type = types_errors{1};
for i = 2:length(types_errors)
    if types_errors{i}(2) < best_type(2)
        best_type = types_errors{i};
    end
end

disp("Best type: " + best_type(1) + " " + best_type(2));
for j = 1:length(mamdani.inputs)
    for k = 1:length(mamdani.inputs(j).mf)
        mamdani.inputs(j).mf(k).type = best_type(1);
    end
end
for j = 1:length(mamdani.outputs)
    for k = 1:length(mamdani.outputs(j).mf)
        mamdani.outputs(j).mf(k).type = best_type(1);
    end
end

fuzzyLogicDesigner(mamdani);
