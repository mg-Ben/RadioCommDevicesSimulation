function [Kc] = obtainKc(geometria, dimensiones, modoPropagacion, m, n)
    if(strcmp(geometria, 'Rectangular'))
        a = dimensiones{1}; b = dimensiones{2};
        Kc = sqrt((m*pi/a)^2 + (n*pi/b)^2);
    end
end