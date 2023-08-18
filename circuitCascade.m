function [S] = circuitCascade(ABCDs, Zo, ZL)
    %Hace lo mismo que circuitConcat (pr1), solo que usando el producto de
    %parámetros ABCD, ya que en principio funciona mejor.
    %Recibe una cell con los ABCDs que encadenar
    nCuadripolos = size(ABCDs, 2);
    
    ABCD_tot = ABCDs{1}*ABCDs{2};
    if(nCuadripolos >= 3)
        for c=3:nCuadripolos
            ABCD_tot = ABCD_tot*ABCDs{c};
        end
    end
    S = ABCDtoS(ABCD_tot, Zo, ZL);
end