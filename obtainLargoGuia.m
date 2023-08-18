function [d] = obtainLargoGuia(fres, er, geometria, dimensiones, modoPropagacion, m, n, q)
    %Función que obtiene la longitud de la guía para que resuene a una fres
    %dada
    d = q*pi/beta(fres, er, geometria, dimensiones, modoPropagacion, m, n);
end