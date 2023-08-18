function [descriptor] = createLPPrototypeDescriptor(gs, ramaSerieParalelo)
    N = length(gs);
    descriptor = cell(3, N);
    %Fila 1: tipo de elemento (L o C)
    %Fila 2: valor de ese elemento
    %Fila 3: si está en rama serie o rama paralelo
    
    if(ramaSerieParalelo == 2)
        for x=1:N
            if(mod(x,2) == 1)
                descriptor{1, x} = 'C';
                descriptor{2, x} = gs(x);
                descriptor{3, x} = 'P';
            else
                descriptor{1, x} = 'L';
                descriptor{2, x} = gs(x);
                descriptor{3, x} = 'S';
            end
        end
    end
        
    if(ramaSerieParalelo == 1)
        for x=1:N
            if(mod(x,2) == 1)
                descriptor{1, x} = 'L';
                descriptor{2, x} = gs(x);
                descriptor{3, x} = 'S';
            else
                descriptor{1, x} = 'C';
                descriptor{2, x} = gs(x);
                descriptor{3, x} = 'P';
            end
        end
    end
end