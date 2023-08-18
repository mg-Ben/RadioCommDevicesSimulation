function [descriptorOut] = designFilterWithInvAndWaveGuide(condicion, gs, g0, gL, Zc, Dprima, er, geometria, dimensiones, d, modoPropagacion, m, n, q)
    fres = obtainFresonancia(er, geometria, dimensiones, d, modoPropagacion, m, n, q);
    N = length(gs);
    descriptorOut = cell(3, 2*N+1);
    if(strcmp(condicion, 'INVsANDLambda_2WAVEGUIDE'))
        for x=1:2*N+1
            if(mod(x, 2) ~= 0) %Impar
                if(x == 1)
                    K = sqrt(Dprima*q*pi/(2*g0*gs(1)))*Zc;
                elseif(x == 2*N+1)
                    K = sqrt(Dprima*q*pi/(2*gL*gs(end)))*Zc;
                else
                    K = Dprima*q*(pi/2)/(sqrt(gs((x-1)/2 + 1)*gs((x-1)/2)))*Zc;
                end
                descriptorOut{1, x} = 'INV';
                descriptorOut{2, x} = K;
                descriptorOut{3, x} = 'S';
            else %Par
                descriptorOut{1, x} = 'LTlambda_2_WG'; %WaveGuide
                E = q*pi; fcentral = fres;
                fc = fcmodo(geometria, dimensiones, modoPropagacion, m, n, er);
                descriptorOut{2, x} = [Zc E fcentral fc dimensiones{1} dimensiones{2} d];
                descriptorOut{3, x} = ["Zc" "E" "fres" "fcmodo" "Anchura (a) [m]" "Altura (b) [m]" "Longitud (d) [m]"];
            end
        end
    end
end