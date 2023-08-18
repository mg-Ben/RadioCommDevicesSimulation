function [descriptorOut] = designFilterWithInv(condicion, values, gs, RA, RB, fc, f1, f2, g0, gL, n, Zc)
    %Nota: el penúltimo parámetro (n) y el último (Zc) es solo para cuando se quiera diseñar el
    %filtro paso banda con inversores y líneas lambda/2
    %Zc es la impedancia de referencia (ver diapos)
    wc = 2*pi*fc;
    f0 = (f1+f2)/2;
    D = (f2-f1)/f0;
    %Crea un descriptor de filtro con inversores
    %condicion: si queremos todo bobinas en rama serie, todo condensadores
    %en rama paralelo...
    %values: cell con los valores de bobinas o condensadores que escoge el diseñador (o resonadores
    %distribuidos). VER NOTA IMPORTANTE ABAJO.
    %gs: valores g del prototipo paso bajo normalizado
    
    %MUY IMPORTANTE!! Cuando se quiera hacer un filtro con todo resonadores
    %(de lo que sea, ya sean en serie o paralelo), envíe como "values" los
    %parámetros x0 únicamente (si quiere mandar las bs, estas serían las inversas de las x0). Se ha comprobado que enviar los
    %parámetros como Ls y Cs no funciona, pues no se puede escoger una L y
    %una C al mismo tiempo libremente (si se escoge una L, la C queda en
    %función de la L), pero sí se puede escoger la x0 (o b0 en caso de
    %resonadores paralelo) libremente y entonces las Ls y Cs quedan en
    %función de esas x0 y b0. Esto se debe a que la frecuencia de
    %resonancia de cada resonador no es la que tendría que tener, sino la
    %f0 del filtro completo.
    
    %CONDICIONES:
    %'LS': todo bobinas serie
    %'CS': todo condensadores serie
    %'LP': todo bobinas paralelo
    %'CP': todo condensadores paralelo
    %'RESSS': todo resonadores serie en serie
    %'RESPS': todo resonadores paralelo en serie
    %'RESPS': todo resonadores paralelo en serie
    %'RESPP': todo resonadores paralelo en paralelo
    
    N = length(gs);
    if(length(gs) ~= size(values, 2))
        fprintf('ERROR en designFilterWithInv: asegúrese de que está enviando el número correcto de valores (debe enviar N valores) para realizar el filtro con inversores\n');
        return;
    end
    descriptorOut = cell(3, 2*N+1);
    if(strcmp(condicion, 'LS')) %Si el usuario quiere diseñar un filtro con solo bobinas serie es porque es un Paso Bajo
        for x=1:2*N+1
            if(mod(x, 2) ~= 0) %Impar
                if(x == 1)
                    K = sqrt((wc*RA*values{1})/(g0*gs(1)));
                elseif(x == 2*N+1)
                    K = sqrt((wc*RB*values{end})/(gL*gs(end)));
                else
                    K = wc*sqrt((values{(x-1)/2}*values{(x+1)/2})/(gs((x-1)/2)*gs((x+1)/2)));
                end
                descriptorOut{1, x} = 'INV';
                descriptorOut{2, x} = K;
                descriptorOut{3, x} = 'S';
            else %Par
                descriptorOut{1, x} = 'L';
                descriptorOut{2, x} = values{x/2};
                descriptorOut{3, x} = 'S';
            end
        end
    end
    if(strcmp(condicion, 'CS')) %Entonces es Paso Alto
        for x=1:2*N+1
            if(mod(x, 2) ~= 0) %Impar
                if(x == 1)
                    K = sqrt(RA/(wc*g0*gs(1)*values{1}));
                elseif(x == 2*N+1)
                    K = sqrt(RB/(wc*gL*gs(end)*values{end}));
                else
                    K = (1/wc)*sqrt(1/(values{(x-1)/2}*values{(x+1)/2}*gs((x-1)/2)*gs((x+1)/2)));
                end
                descriptorOut{1, x} = 'INV';
                descriptorOut{2, x} = K;
                descriptorOut{3, x} = 'S';
            else %Par
                descriptorOut{1, x} = 'C';
                descriptorOut{2, x} = values{x/2};
                descriptorOut{3, x} = 'S';
            end
        end
    end
    if(strcmp(condicion, 'LP')) %Paso alto
        for x=1:2*N+1
            if(mod(x, 2) ~= 0) %Impar
                if(x == 1)
                    K = sqrt(RA*wc*g0*gs(1)*values{1});
                elseif(x == 2*N+1)
                    K = sqrt(RB*wc*gL*gs(end)*values{end});
                else
                    K = wc*sqrt(values{(x-1)/2}*values{(x+1)/2}*gs((x-1)/2)*gs((x+1)/2));
                end
                descriptorOut{1, x} = 'INV';
                descriptorOut{2, x} = K;
                descriptorOut{3, x} = 'S';
            else %Par
                descriptorOut{1, x} = 'L';
                descriptorOut{2, x} = values{x/2};
                descriptorOut{3, x} = 'P';
            end
        end
    end
    if(strcmp(condicion, 'CP')) %Paso bajo
        for x=1:2*N+1
            if(mod(x, 2) ~= 0) %Impar
                if(x == 1)
                    K = sqrt((g0*gs(1)*RA)/(wc*values{1}));
                elseif(x == 2*N+1)
                    K = sqrt((gL*gs(end)*RB)/(wc*values{end}));
                else
                    K = (1/wc)*sqrt((gs((x-1)/2)*gs((x+1)/2))/(values{(x-1)/2}*values{(x+1)/2}));
                end
                descriptorOut{1, x} = 'INV';
                descriptorOut{2, x} = K;
                descriptorOut{3, x} = 'S';
            else %Par
                descriptorOut{1, x} = 'C';
                descriptorOut{2, x} = values{x/2};
                descriptorOut{3, x} = 'P';
            end
        end
    end
    if(strcmp(condicion, 'RESSS')) %Paso banda
        for x=1:2*N+1
            if(mod(x, 2) ~= 0) %Impar
                if(x == 1)
                    K = sqrt((D*RA*values{1})/(g0*gs(1)));
                elseif(x == 2*N+1)
                    K = sqrt((D*RB*values{end})/(gL*gs(end)));
                else
                    K = D*sqrt((values{(x-1)/2}*values{(x+1)/2})/(gs((x-1)/2)*gs((x+1)/2)));
                end
                descriptorOut{1, x} = 'INV';
                descriptorOut{2, x} = K;
                descriptorOut{3, x} = 'S';
            else %Par
                descriptorOut{1, x} = 'RESS';
                x0 = values{x/2};
                L = x0/(2*pi*f0); C = 1/(2*pi*f0*x0);
                descriptorOut{2, x} = [L C];
                descriptorOut{3, x} = 'S';
            end
        end
    end
    if(strcmp(condicion, 'RESSP'))
        for x=1:2*N+1
            if(mod(x, 2) ~= 0) %Impar
                if(x == 1)
                    K = sqrt(D*values{1}*g0*gs(1)*RA);
                elseif(x == 2*N+1)
                    K = sqrt(D*values{end}*gL*gs(end)*RB);
                else
                    K = D*sqrt(values{(x-1)/2}*values{(x+1)/2}*gs((x-1)/2)*gs((x+1)/2));
                end
                descriptorOut{1, x} = 'INV';
                descriptorOut{2, x} = K;
                descriptorOut{3, x} = 'S';
            else %Par
                descriptorOut{1, x} = 'RESS';
                x0 = values{x/2};
                L = x0/(2*pi*f0); C = 1/(2*pi*f0*x0);
                descriptorOut{2, x} = [L C];
                descriptorOut{3, x} = 'P';
            end
        end
    end
    if(strcmp(condicion, 'RESPS'))
        for x=1:2*N+1
            if(mod(x, 2) ~= 0) %Impar
                if(x == 1)
                    K = sqrt(RA*values{1}/(D*g0*gs(1)));
                elseif(x == 2*N+1)
                    K = sqrt(RB*values{end}/(D*gL*gs(end)));
                else
                    K = (1/D)*sqrt(values{(x-1)/2}*values{(x+1)/2}/(gs((x-1)/2)*gs((x+1)/2)));
                end
                descriptorOut{1, x} = 'INV';
                descriptorOut{2, x} = K;
                descriptorOut{3, x} = 'S';
            else %Par
                descriptorOut{1, x} = 'RESP';
                x0 = values{x/2};
                L = x0/(2*pi*f0); C = 1/(2*pi*f0*x0);
                descriptorOut{2, x} = [L C];
                descriptorOut{3, x} = 'S';
            end
        end
    end
    if(strcmp(condicion, 'RESPP'))
        for x=1:2*N+1
            if(mod(x, 2) ~= 0) %Impar
                if(x == 1)
                    K = sqrt((values{1}*g0*gs(1)*RA)/D);
                elseif(x == 2*N+1)
                    K = sqrt((values{end}*gL*gs(end)*RB)/D);
                else
                    K = (1/D)*sqrt(values{(x-1)/2}*values{(x+1)/2}*gs((x-1)/2)*gs((x+1)/2));
                end
                descriptorOut{1, x} = 'INV';
                descriptorOut{2, x} = K;
                descriptorOut{3, x} = 'S';
            else %Par
                descriptorOut{1, x} = 'RESP';
                x0 = values{x/2};
                L = x0/(2*pi*f0); C = 1/(2*pi*f0*x0);
                descriptorOut{2, x} = [L C];
                descriptorOut{3, x} = 'P';
            end
        end
    end
    if(strcmp(condicion, 'INVsANDLambda_2'))
        for x=1:2*N+1
            if(mod(x, 2) ~= 0) %Impar
                if(x == 1)
                    K = sqrt(D*n*pi/(2*g0*gs(1)))*Zc;
                elseif(x == 2*N+1)
                    K = sqrt(D*n*pi/(2*gL*gs(end)))*Zc;
                else
                    K = D*n*(pi/2)/(sqrt(gs((x-1)/2 + 1)*gs((x-1)/2)))*Zc;
                end
                descriptorOut{1, x} = 'INV';
                descriptorOut{2, x} = K;
                descriptorOut{3, x} = 'S';
            else %Par
                descriptorOut{1, x} = 'LTlambda_2';
                E = n*pi; fcentral = f0;
                descriptorOut{2, x} = [Zc E fcentral];
                descriptorOut{3, x} = 'S';
            end
        end
    end
end