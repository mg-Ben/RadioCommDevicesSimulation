function [fc] = fcmodo(geometria, dimensiones, modoPropagacion, m, n, er)
    vp = obtainVp(er, 1);
    Kc = obtainKc(geometria, dimensiones, modoPropagacion, m, n);
    fc = vp*Kc/(2*pi);
end