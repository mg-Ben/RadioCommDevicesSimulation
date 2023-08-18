function [Dprima] = obtainDeltaPrima(f1, f2, er, geometria, dimensiones, modoPropagacion, m, n)
    f0 = (f1+f2)/2;
    Dprima = (beta(f2, er, geometria, dimensiones, modoPropagacion, m, n) - beta(f1, er, geometria, dimensiones, modoPropagacion, m, n))/beta(f0, er, geometria, dimensiones, modoPropagacion, m, n);
end