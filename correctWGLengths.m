function [descriptorOut] = correctWGLengths(descriptorIn)
    descriptorOut = descriptorIn;
    N = size(descriptorIn, 2);
    for x=1:N
        component = descriptorIn{1, x};
        if(strcmp(component, 'LTlambda_2_WG'))
            PrevValues = descriptorIn{2, x-1};
            NextValues = descriptorIn{2, x+1};
            PrevE = PrevValues(4); NextE = NextValues(4);
            %Corregimos la longitud eléctrica:
            Values = descriptorIn{2, x}; E = Values(2); d = Values(7);
            Enuevo = E - PrevE - NextE; Values(2) = Enuevo;
            
            %Corregimos la longitud física 'd' de la guía:
            betaAntiguo = E/d;
            d = Enuevo/betaAntiguo; Values(7) = d;
            descriptorOut{2, x} = Values;
        end
        if(strcmp(component, 'IRIS_WG'))
            Values = descriptorIn{2, x};
            Keys = descriptorIn{3, x};
            descriptorOut{2, x} = Values(1:end-1);
            descriptorOut{3, x} = Keys(1:end-1);
        end
    end
end