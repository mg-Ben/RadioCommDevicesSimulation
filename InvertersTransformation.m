function [descriptorOut] = InvertersTransformation(descriptorIn, transformacion, fdis, Zc, dimensionesGuias, dref, t)
    %Función que transforma los bloques inversores en lo que se envíe por
    %argumento ('LTlambda_4', 'piL', 'piC', 'TL', 'TC')
    %Donde 'piL' es un circuito en pi conformado por bobinas y TL es el
    %circuito en T conformado por bobinas, por ejemplo
    %El último argumento (Zc) SOLO es para cuando queramos transformar el
    %inversor a LT + bobinaParalelo/CondensadorSeria + LT
    
    %El parámetro "dimensionesGuias" son las dimensiones de las guías del
    %circuito (las que comprenden entre una y otra los írises) y son una
    %cell con las anchuras y alturas, en ese orden

    %El parámetro "t" es el grosor o también longitud (d) en Z de la guía y
    %suele ser dato del enunciado.
    
    %El parámetro "dref" es la longitud de las guías de referencia que se
    %usan para simular con calculaMM el iris y encontrar así su anchura
    %asociada al K
    
    %NOTA: no tiene sentido hacer estas transformaciones a no ser que el
    %filtro que se esté intentando sintetizar tenga una frecuencia de
    %diseño a la que queramos que se cumplan las igualdades del circuito
    %inversor con el circuito transformado. Por ejemplo, no podemos hacer
    %que un inversor equivalga a una LT lambda/4 a todas las frecuencias,
    %porque su longitud es lambda/4 a la frecuencia de diseño. Lo mismo con
    %los circuitos en pi y en T; queremos que wL = K del inversor a f =
    %fdis. Por ello, estas transformaciones se hacen con filtros paso banda
    %donde la fdis = fcentral o f0.
    
    descriptorOut = descriptorIn;
    nElementos = size(descriptorIn, 2);
    for i=1:nElementos
        elementType = descriptorIn{1, i};
        if(strcmp(elementType, 'INV'))
            if(strcmp(transformacion, 'CircuitPiL|CircuitTL'))
                K = descriptorIn{2, i};
                L = K/(2*pi*fdis);
                descriptorOut{1, i} = 'CircuitPiL|CircuitTL';
                descriptorOut{2, i} = L;
            end
            if(strcmp(transformacion, 'CircuitPiC|CircuitTC'))
                K = descriptorIn{2, i};
                C = 1/(2*pi*fdis*K);
                descriptorOut{1, i} = 'CircuitPiC|CircuitTC';
                descriptorOut{2, i} = C;
            end
            if(strcmp(transformacion, 'LTlambda_4')) %Para las líneas de transmisión, almacenamos Zc, E (long. eléctrica en radianes) y fdis (frecuencia a la cual mide lambda/4)
                K = descriptorIn{2, i};
                Zc = K; E = pi/2; fcentral = fdis;
                descriptorOut{1, i} = 'LTlambda_4';
                descriptorOut{2, i} = [Zc E fcentral];
            end
            if(strcmp(transformacion, 'LT_LParalell_LT')) %Para las líneas de transmisión, almacenamos Zc, E (long. eléctrica en radianes) y fdis (frecuencia a la cual mide lambda/4)
                K = descriptorIn{2, i};
                E = atan(K/Zc); fcentral = fdis; X = (Zc/2)*tan(2*E);
                descriptorOut{1, i} = 'LT_LParalell_LT';
                L = X/(2*pi*fdis);
                descriptorOut{2, i} = [Zc -E fcentral L Zc -E fcentral];
            end
            if(strcmp(transformacion, 'LT_CSerial_LT')) %Para las líneas de transmisión, almacenamos Zc, E (long. eléctrica en radianes) y fdis (frecuencia a la cual mide lambda/4)
                K = descriptorIn{2, i};
                E = atan(Zc/K); fcentral = fdis; X = (Zc*2)/tan(2*E);
                descriptorOut{1, i} = 'LT_CSerial_LT';
                C = 1/(X*2*pi*fdis);
                descriptorOut{2, i} = [Zc -E fcentral C Zc -E fcentral];
            end
            if(strcmp(transformacion, 'IRIS_WG'))
                K = descriptorIn{2, i};
                descriptorOut{1, i} = 'IRIS_WG';
                %CÁLCULO DEL ANCHO DE LA GUÍA: No se pude hacer
                %analíticamente, pero sí probando con varias anchuras hasta
                %que se encuentre una que de un K muy parecido al del
                %inversor
                amin = 1; %[mm]
                amax = 12; %[mm]
                apoints = 7001;
                astep = (amax-amin)/(apoints - 1); asim = [amin:astep:amax];
                %Por cada anchura de prueba, se obtienen los parámetros S
                %mediante la función calculaMM, que simula guías de onda:
                %Es importante mencionar que para pasar un inversor a iris,
                %es necesario conocer también la anchura y longitud de las
                %líneas de transmisión de entrada y salida del iris. Esas guías son
                %las de referencia, así que podemos poner que su longitud
                %d = 0, pero eso sí, la anchura no puede ser 0, tiene que
                %ser la de las guías del circuito.
                %EL PRIMER PARÁMETRO DE calculaMM ES LA FRECUENCIA CENTRAL
                %EN [GHz]
                %Los demás parámetros se pasan en [mm]
                %EL ÚLTIMO PARÁMETRO DE calculaMM ES EL ALTO DEL IRIS EN mm (que
                %es igual al alto de la guía)
                anchoGuia = dimensionesGuias{1}*1000; altoGuia = dimensionesGuias{2}*1000;
                Ktest = zeros(1, length(asim));
                Theta = zeros(1, length(asim));
                for p=1:length(asim)
                    a = asim(p);
                    [K_res, Theta_res] = obtainKandThetaFromW_IRIS(a, t*1000, {anchoGuia, altoGuia}, dref, fdis/(10^9), Zc);
%                     aGuia_aIris_aGuia = [anchoGuia a anchoGuia];
%                     dGuia_tIris_dGuia = [dref t*1000 dref];
%                     fdis_GHz = fdis/(10^9);
%                     [S11, S21, S22] = calculaMM(fdis_GHz, aGuia_aIris_aGuia, dGuia_tIris_dGuia, altoGuia);
%                     %Con el S11 concretamente se puede obtener K y el
%                     %desfase del iris:
%                     K2 = Zc*sqrt((1 - abs(S11))/(1 + abs(S11)));
%                     Theta2 = -angle(S11)/2 + pi/2;
                    Ktest(p) = K_res;
                    Theta(p) = Theta_res;
                end
                %Con los Ktest obtenemos el más parecido a K:
                [~,index] = min(abs(Ktest - K));
                
                aIris = asim(index);
                thetaIris = Theta(index);
                fprintf("Inversor transformado a guía de onda. Kestimada = %f | Anchura = %f [mm] | Theta = %f\n", Ktest(index), aIris, thetaIris);
                
                descriptorOut{2, i} = [aIris/1000 altoGuia/1000 t thetaIris];
                descriptorOut{3, i} = ["Anchura del Iris [m]", "Altura del Iris [m]", "Grosor (longitud d) del Iris [m]", "Theta del Iris"];
            end
        end
    end
end