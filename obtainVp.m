function [vp] = obtainVp(er, mur)
    c0 = 3e8;
    vp = c0/sqrt(er*mur);
end