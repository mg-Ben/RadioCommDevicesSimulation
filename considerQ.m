function [descriptorOut] = considerQ(descriptorIn, Q, er)
    %Función que considera el factor de calidad Q para los resonadores
    descriptorOut = descriptorIn;
    nElementos = size(descriptorIn, 2);
    for i=1:nElementos
        elementType = descriptorIn{1, i};
        if(strcmp(elementType, 'RESS'))
            Values = descriptorIn{2, i};
            L = Values(1); C = Values(2); x = sqrt(L/C);
            R = x/Q;
            descriptorOut{1, i} = 'RESSwithR';
            descriptorOut{2, i} = [descriptorIn{2, i}, R];
        end
        if(strcmp(elementType, 'RESP'))
            Values = descriptorIn{2, i};
            L = Values(1); C = Values(2); x = sqrt(L/C);
            R = x*Q;
            descriptorOut{1, i} = 'RESPwithR';
            descriptorOut{2, i} = [descriptorIn{2, i}, R];
        end
        if(strcmp(elementType, 'LTlambda_2'))
            Values = descriptorIn{2, i};
            Zc = Values(1); E = Values(2); fdis = Values(3);
            lambda0 = (1/sqrt(er))*(3e8)/fdis; d = lambda0/2; a = E/(2*Q*d);
            descriptorOut{1, i} = 'LossyLTlambda_2';
            descriptorOut{2, i} = [Zc E fdis a d];
        end
    end
end