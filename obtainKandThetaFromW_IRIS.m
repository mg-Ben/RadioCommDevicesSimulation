function [K, Theta] = obtainKandThetaFromW_IRIS(a, t, dimensiones, dref, fdis, Zc)
    %a: ancho del iris [mm]
    %t: grosor del iris [mm]
    %dimensiones: {ancho, alto} de la guía [mm]
    %dref: longitud de la guía de referencia [mm]
    %fdis: frecuencia central de diseño del iris [GHz]
    %Zc: impedancia Zc de referencia [Ohmios]
    anchoGuia = dimensiones{1}; altoGuia = dimensiones{2};
    
    aGuia_aIris_aGuia = [anchoGuia a anchoGuia];
    dGuia_tIris_dGuia = [dref t dref];
    [S11] = calculaMM(fdis, aGuia_aIris_aGuia, dGuia_tIris_dGuia, altoGuia);
    %Con el S11 concretamente se puede obtener K y el
    %desfase del iris:
    K = Zc*sqrt((1 - abs(S11))/(1 + abs(S11)));
    Theta = -angle(S11)/2 + pi/2;
end