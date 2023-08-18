function [beta] = beta(f, er, geometria, dimensiones, modoPropagacion, m, n)
    vp = obtainVp(er, 1);
    fc = fcmodo(geometria, dimensiones, modoPropagacion, m, n, er);
    beta = (2*pi*f/vp)*sqrt(1-(fc/f)^2);
end