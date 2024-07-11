% Определение исходной функции
fun = @(x) (3*x(:,1).^2).*cos(x(:,2)+3);

% Фиксированное значение для x2
fixed_x2 = 3.4;

% Значения для x2 от до с шагом 1
% x1_values = -6:1:-3;
% x1_values = -3:1:2;
x1_values = 2:1:5;

% Создание матрицы для x1 и x2
[x1, x2] = meshgrid(x1_values, fixed_x2);

% Преобразование в столбцы
x1 = x1(:);
x2 = x2(:);

% Вычисление y для новых значений x1 и x2
y = fun([x1, x2]);

% Создание таблицы данных
tbl = table(x1, x2, y, 'VariableNames', {'x1', 'x2', 'y'});

% Линейная аппроксимация
lm = fitlm(tbl, 'y ~ x1 + x2');

% Получение коэффициентов аппроксимации
coefficients = lm.Coefficients.Estimate;

disp(coefficients);


