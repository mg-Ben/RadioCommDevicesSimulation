function [descriptorOut] = ResonatorsTransformation(descriptorIn, transformacion, fdis, n, er)
    descriptorOut = descriptorIn;
    nElementos = size(descriptorIn, 2);
    for i=1:nElementos
        elementType = descriptorIn{1, i};
        if(strcmp(elementType, 'RESS'))
            colocation = descriptorIn{3, i};
            if(strcmp(colocation, 'S'))
                if(strcmp(transformacion, 'LTlambda_4SerialCA'))
                    descriptorOut{1, i} = transformacion;
                    Values = descriptorIn{2, i};
                    L = Values(1); C = Values(2); x = sqrt(L/C);
                    E = (2*n - 1)*pi/2; fcentral = fdis; Zc = x*2/E;
                    descriptorOut{2, i} = [Zc E fcentral];
                end
                if(strcmp(transformacion, 'LTlambda_2SerialCC'))
                    descriptorOut{1, i} = transformacion;
                    Values = descriptorIn{2, i};
                    L = Values(1); C = Values(2); x = sqrt(L/C);
                    E = n*pi; fcentral = fdis; Zc = x*2/E;
                    descriptorOut{2, i} = [Zc E fcentral];
                end
            end
            if(strcmp(colocation, 'P'))
                if(strcmp(transformacion, 'LTlambda_4ParalellCA'))
                    descriptorOut{1, i} = transformacion;
                    Values = descriptorIn{2, i};
                    L = Values(1); C = Values(2); x = sqrt(L/C);
                    E = (2*n - 1)*pi/2; fcentral = fdis; Zc = x*2/E;
                    descriptorOut{2, i} = [Zc E fcentral];
                end
                if(strcmp(transformacion, 'LTlambda_2ParalellCC'))
                    descriptorOut{1, i} = transformacion;
                    Values = descriptorIn{2, i};
                    L = Values(1); C = Values(2); x = sqrt(L/C);
                    E = n*pi; fcentral = fdis; Zc = x*2/E;
                    descriptorOut{2, i} = [Zc E fcentral];
                end
            end
        end
        
        if(strcmp(elementType, 'RESP'))
            colocation = descriptorIn{3, i};
            if(strcmp(colocation, 'S'))
                if(strcmp(transformacion, 'LTlambda_4SerialCC'))
                    descriptorOut{1, i} = transformacion;
                    Values = descriptorIn{2, i};
                    L = Values(1); C = Values(2); x = sqrt(L/C);
                    E = (2*n - 1)*pi/2; fcentral = fdis; Zc = x*E/2;
                    descriptorOut{2, i} = [Zc E fcentral];
                end
                if(strcmp(transformacion, 'LTlambda_2SerialCA'))
                    descriptorOut{1, i} = transformacion;
                    Values = descriptorIn{2, i};
                    L = Values(1); C = Values(2); x = sqrt(L/C);
                    E = n*pi; fcentral = fdis; Zc = x*E/2;
                    descriptorOut{2, i} = [Zc E fcentral];
                end
            end
            if(strcmp(colocation, 'P'))
                if(strcmp(transformacion, 'LTlambda_4ParalellCC'))
                    descriptorOut{1, i} = transformacion;
                    Values = descriptorIn{2, i};
                    L = Values(1); C = Values(2); x = sqrt(L/C);
                    E = (2*n - 1)*pi/2; fcentral = fdis; Zc = x*E/2;
                    descriptorOut{2, i} = [Zc E fcentral];
                end
                if(strcmp(transformacion, 'LTlambda_2ParalellCA'))
                    descriptorOut{1, i} = transformacion;
                    Values = descriptorIn{2, i};
                    L = Values(1); C = Values(2); x = sqrt(L/C);
                    E = n*pi; fcentral = fdis; Zc = x*E/2;
                    descriptorOut{2, i} = [Zc E fcentral];
                end
            end
        end
        
        %% Con pérdidas
        if(strcmp(elementType, 'RESSwithR'))
            colocation = descriptorIn{3, i};
            if(strcmp(colocation, 'S'))
                if(strcmp(transformacion, 'LTlambda_4SerialCA'))
                    descriptorOut{1, i} = 'LossyLTlambda_4SerialCA';
                    Values = descriptorIn{2, i};
                    L = Values(1); C = Values(2); R = Values(3);
                    x = sqrt(L/C);
                    Q = x/R; lambda0 = (1/sqrt(er))*(3e8)/fdis; d = (2*n - 1)*lambda0/4;
                    E = (2*n - 1)*pi/2; fcentral = fdis; Zc = x*2/E; a = E/(2*Q*d);
                    descriptorOut{2, i} = [Zc E fcentral a d];
                end
                if(strcmp(transformacion, 'LTlambda_2SerialCC'))
                    descriptorOut{1, i} = 'LossyLTlambda_2SerialCC';
                    Values = descriptorIn{2, i};
                    L = Values(1); C = Values(2); R = Values(3);
                    x = sqrt(L/C);
                    Q = x/R; lambda0 = (1/sqrt(er))*(3e8)/fdis; d = n*lambda0/2;
                    E = n*pi; fcentral = fdis; Zc = x*2/E; a = E/(2*Q*d);
                    descriptorOut{2, i} = [Zc E fcentral a d];
                end
            end
            if(strcmp(colocation, 'P'))
                if(strcmp(transformacion, 'LTlambda_4ParalellCA'))
                    descriptorOut{1, i} = 'LossyLTlambda_4ParalellCA';
                    Values = descriptorIn{2, i};
                    L = Values(1); C = Values(2); R = Values(3);
                    x = sqrt(L/C);
                    Q = x/R; lambda0 = (1/sqrt(er))*(3e8)/fdis; d = (2*n - 1)*lambda0/4;
                    E = (2*n - 1)*pi/2; fcentral = fdis; Zc = x*2/E; a = E/(2*Q*d);
                    descriptorOut{2, i} = [Zc E fcentral a d];
                end
                if(strcmp(transformacion, 'LTlambda_2ParalellCC'))
                    descriptorOut{1, i} = 'LossyLTlambda_2ParalellCC';
                    Values = descriptorIn{2, i};
                    L = Values(1); C = Values(2); R = Values(3);
                    x = sqrt(L/C);
                    Q = x/R; lambda0 = (1/sqrt(er))*(3e8)/fdis; d = n*lambda0/2;
                    E = n*pi; fcentral = fdis; Zc = x*2/E; a = E/(2*Q*d);
                    descriptorOut{2, i} = [Zc E fcentral a d];
                end
            end
        end
        
        if(strcmp(elementType, 'RESPwithR'))
            colocation = descriptorIn{3, i};
            if(strcmp(colocation, 'S'))
                if(strcmp(transformacion, 'LTlambda_4SerialCC'))
                    descriptorOut{1, i} = 'LossyLTlambda_4SerialCC';
                    Values = descriptorIn{2, i};
                    L = Values(1); C = Values(2); R = Values(3); x = sqrt(L/C);
                    Q = R/x; lambda0 = (1/sqrt(er))*(3e8)/fdis; d = (2*n - 1)*lambda0/4;
                    E = (2*n - 1)*pi/2; fcentral = fdis; Zc = x*E/2; a = E/(2*Q*d);
                    descriptorOut{2, i} = [Zc E fcentral a d];
                end
                if(strcmp(transformacion, 'LTlambda_2SerialCA'))
                    descriptorOut{1, i} = 'LossyLTlambda_2SerialCA';
                    Values = descriptorIn{2, i};
                    L = Values(1); C = Values(2); R = Values(3); x = sqrt(L/C);
                    Q = R/x; lambda0 = (1/sqrt(er))*(3e8)/fdis; d = n*lambda0/2;
                    E = n*pi; fcentral = fdis; Zc = x*E/2; a = E/(2*Q*d);
                    descriptorOut{2, i} = [Zc E fcentral a d];
                end
            end
            if(strcmp(colocation, 'P'))
                if(strcmp(transformacion, 'LTlambda_4ParalellCC'))
                    descriptorOut{1, i} = 'LossyLTlambda_4ParalellCC';
                    Values = descriptorIn{2, i};
                    L = Values(1); C = Values(2); R = Values(3); x = sqrt(L/C);
                    Q = R/x; lambda0 = (1/sqrt(er))*(3e8)/fdis; d = (2*n - 1)*lambda0/4;
                    E = (2*n - 1)*pi/2; fcentral = fdis; Zc = x*E/2; a = E/(2*Q*d);
                    descriptorOut{2, i} = [Zc E fcentral a d];
                end
                if(strcmp(transformacion, 'LTlambda_2ParalellCA'))
                    descriptorOut{1, i} = 'LossyLTlambda_2ParalellCA';
                    Values = descriptorIn{2, i};
                    L = Values(1); C = Values(2); R = Values(3); x = sqrt(L/C);
                    Q = R/x; lambda0 = (1/sqrt(er))*(3e8)/fdis; d = n*lambda0/2;
                    E = n*pi; fcentral = fdis; Zc = x*E/2; a = E/(2*Q*d);
                    descriptorOut{2, i} = [Zc E fcentral a d];
                end
            end
        end
    end
end