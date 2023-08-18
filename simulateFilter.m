function [S11, S12, S21, S22, fsim] = simulateFilter(fmin, fmax, fpoints, descriptor, Zo, ZL)
    %Entradas: frecuencias mínima, máxima y número de puntos de simulación
    %params: impedancias del filtro (condensadores, bobinas, resonadores)
    fstep = (fmax-fmin)/(fpoints - 1);
    fsim = [fmin:fstep:fmax]; %[Hz] Frecuencias de simulación
    S11 = zeros(1, length(fsim)); S12 = zeros(1, length(fsim)); S21 = zeros(1, length(fsim)); S22 = zeros(1, length(fsim));
    
    Sf = zeros(2, 2);
    for p=1:length(fsim)
        f = fsim(p);
        Sf = obtainStot(descriptor, f, Zo, ZL);
        S11(p) = Sf(1, 1); S12(p) = Sf(1, 2); S21(p) = Sf(2, 1); S22(p) = Sf(2, 2);
    end
end