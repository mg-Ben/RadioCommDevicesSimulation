function [fres] = obtainFresonancia(er, geometria, dimensiones, d, modoPropagacion, m, n, q)
    vp = obtainVp(er, 1);
    Kc = obtainKc(geometria, dimensiones, modoPropagacion, m, n);
    fres = vp*sqrt(Kc^2 + (q*pi/d)^2)/(2*pi);
end