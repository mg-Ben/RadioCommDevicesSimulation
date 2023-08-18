function [S] = obtainStot(descriptor, f, Zo, ZLoad, vp, fcmodo)
    %f: frecuencia a la que se está evaluando la matriz S
    secciones = size(descriptor, 2);
    ABCDs = cell(1, secciones); %Parámetros ABCD de cada componente
    
    for x=1:secciones
        ElementType = descriptor{1,x};
        Value = descriptor{2, x};
        Colocation = descriptor{3, x};
        
        if(strcmp(ElementType, 'L'))
            ZL = 1i*2*pi*f*Value;
            if(strcmp(Colocation, 'S'))
                ABCDs{x} = [1, ZL; 0, 1];
            end
            if(strcmp(Colocation, 'P'))
                ABCDs{x} = [1 0; 1/ZL 1];
            end
        end
        
        if(strcmp(ElementType, 'C'))
            YC = 1i*2*pi*f*Value;
            if(strcmp(Colocation, 'S'))
                ABCDs{x} = [1 1/YC; 0 1];
            end
            if(strcmp(Colocation, 'P'))
                ABCDs{x} = [1 0; YC 1];
            end
        end
        
        if(strcmp(ElementType, 'RESS'))
            L = Value(1); C = Value(2);
            ZL = 1i*2*pi*f*L; YC = 1i*2*pi*f*C;
            Z = ZL + 1/YC;
            if(strcmp(Colocation, 'S'))
                ABCDs{x} = [1, Z; 0, 1];
            end
            if(strcmp(Colocation, 'P'))
                ABCDs{x} = [1 0; 1/Z 1];
            end
        end
        
        if(strcmp(ElementType, 'RESP'))
            L = Value(1); C = Value(2);
            ZL = 1i*2*pi*f*L; YC = 1i*2*pi*f*C;
            Y = 1/ZL + YC;
            if(strcmp(Colocation, 'S'))
                ABCDs{x} = [1 1/Y; 0 1];
            end
            if(strcmp(Colocation, 'P'))
                ABCDs{x} = [1 0; Y 1];
            end
        end
        
        if(strcmp(ElementType, 'INV'))
            K = Value;
            ABCDs{x} = [0 1i*K; 1i*(1/K) 0];
        end
        
        if(strcmp(ElementType, 'CircuitPiL|CircuitTL')) %Circuito en T o en pi de bobinas
            L = Value;
            ZL = 1i*2*pi*f*L;
            ABCDs{x} = [0 -ZL; 1/ZL 0];
        end
        
        if(strcmp(ElementType, 'CircuitPiC|CircuitTC')) %Circuito en T o en pi de condensadores
            C = Value;
            ZC = 1/(1i*2*pi*f*C);
            ABCDs{x} = [0 -ZC; 1/ZC 0];
        end
        
        if(strcmp(ElementType, 'LTlambda_4') || strcmp(ElementType, 'LTlambda_2'))
            Zc = Value(1); E = Value(2); fdis = Value(3);
            ABCDs{x} = [cos(E*f/fdis) 1i*Zc*sin(E*f/fdis); 1i*(1/Zc)*sin(E*f/fdis) cos(E*f/fdis)];
        end
        
        if(strcmp(ElementType, 'LossyLTlambda_2'))
            Zc = Value(1); E = Value(2); fdis = Value(3); a = Value(4); d = Value(5);
            Gamma_d = a*d + 1i*E*f/fdis;
            ABCDs{x} = [cosh(Gamma_d) Zc*sinh(Gamma_d); (1/Zc)*sinh(Gamma_d) cosh(Gamma_d)];
        end
        
        if(strcmp(ElementType, 'LTlambda_2_WG'))
            Zc = Value(1); E = Value(2); fres = Value(3); fc = Value(4);
            if(f < fc)
                Gamma_d = E*(f/fres)*(sqrt(1-(fc/f)^2))/(sqrt(1-(fc/fres)^2));
            else
                Gamma_d = 1i*E*(f/fres)*(sqrt(1-(fc/f)^2))/(sqrt(1-(fc/fres)^2));
            end
            
            ABCDs{x} = [cosh(Gamma_d) Zc*sinh(Gamma_d); (1/Zc)*sinh(Gamma_d) cosh(Gamma_d)];
        end
        
        if(strcmp(ElementType, 'RESSwithR'))
            L = Value(1); C = Value(2); R = Value(3);
            ZL = 1i*2*pi*f*L; YC = 1i*2*pi*f*C;
            Z = ZL + 1/YC + R;
            if(strcmp(Colocation, 'S'))
                ABCDs{x} = [1, Z; 0 1];
            end
            if(strcmp(Colocation, 'P'))
                ABCDs{x} = [1 0; 1/Z 1];
            end
        end
        
        if(strcmp(ElementType, 'RESPwithR'))
            L = Value(1); C = Value(2); R = Value(3);
            ZL = 1i*2*pi*f*L; YC = 1i*2*pi*f*C;
            Y = 1/ZL + YC + 1/R;
            if(strcmp(Colocation, 'S'))
                ABCDs{x} = [1 1/Y; 0 1];
            end
            if(strcmp(Colocation, 'P'))
                ABCDs{x} = [1 0; Y 1];
            end
        end
        
        
        if(strcmp(ElementType, 'LTlambda_2SerialCC')) %Línea de transmisión que equivale a una impedancia serie
            Zc = Value(1); E = Value(2); fdis = Value(3);
            ZIN = 1i*Zc*tan(E*f/fdis);
            ABCDs{x} = [1, ZIN; 0, 1];
        end
        if(strcmp(ElementType, 'LTlambda_2SerialCA')) %Línea de transmisión que equivale a una impedancia serie
            Zc = Value(1); E = Value(2); fdis = Value(3);
            Yc = 1/Zc;
            YIN = 1i*Yc*tan(E*f/fdis);
            ABCDs{x} = [1, 1/YIN; 0, 1];
        end
        if(strcmp(ElementType, 'LossyLTlambda_2SerialCC')) %Línea de transmisión que equivale a una impedancia serie
            Zc = Value(1); E = Value(2); fdis = Value(3); a = Value(4); d = Value(5);
            Gamma_d = a*d + 1i*E*f/fdis;
            ZIN = Zc*tanh(Gamma_d);
            ABCDs{x} = [1, ZIN; 0, 1];
        end
        if(strcmp(ElementType, 'LossyLTlambda_2SerialCA')) %Línea de transmisión que equivale a una impedancia serie
            Zc = Value(1); E = Value(2); fdis = Value(3); a = Value(4); d = Value(5);
            Yc = 1/Zc;
            Gamma_d = a*d + 1i*E*f/fdis;
            YIN = Yc*tanh(Gamma_d);
            ABCDs{x} = [1, 1/YIN; 0, 1];
        end
        
        
        if(strcmp(ElementType, 'LTlambda_4SerialCC')) %Línea de transmisión que equivale a una impedancia serie
            Zc = Value(1); E = Value(2); fdis = Value(3);
            ZIN = 1i*Zc*tan(E*f/fdis);
            ABCDs{x} = [1, ZIN; 0, 1];
        end
        if(strcmp(ElementType, 'LTlambda_4SerialCA')) %Línea de transmisión que equivale a una impedancia serie
            Zc = Value(1); E = Value(2); fdis = Value(3);
            Yc = 1/Zc;
            YIN = 1i*Yc*tan(E*f/fdis);
            ABCDs{x} = [1, 1/YIN; 0, 1];
        end
        if(strcmp(ElementType, 'LossyLTlambda_4SerialCC')) %Línea de transmisión que equivale a una impedancia serie
            Zc = Value(1); E = Value(2); fdis = Value(3); a = Value(4); d = Value(5);
            Gamma_d = a*d + 1i*E*f/fdis;
            ZIN = Zc*tanh(Gamma_d);
            ABCDs{x} = [1, ZIN; 0, 1];
        end
        if(strcmp(ElementType, 'LossyLTlambda_4SerialCA')) %Línea de transmisión que equivale a una impedancia serie
            Zc = Value(1); E = Value(2); fdis = Value(3); a = Value(4); d = Value(5);
            Yc = 1/Zc;
            Gamma_d = a*d + 1i*E*f/fdis;
            YIN = Yc*tanh(Gamma_d);
            ABCDs{x} = [1, 1/YIN; 0, 1];
        end
        
        if(strcmp(ElementType, 'LTlambda_2ParalellCA')) %Línea de transmisión que equivale a una impedancia paralelo
            Zc = Value(1); E = Value(2); fdis = Value(3);
            Yc = 1/Zc;
            YIN = 1i*Yc*tan(E*f/fdis);
            ABCDs{x} = [1 0; YIN 1];
        end
        if(strcmp(ElementType, 'LTlambda_2ParalellCC')) %Línea de transmisión que equivale a una impedancia paralelo
            Zc = Value(1); E = Value(2); fdis = Value(3);
            ZIN = 1i*Zc*tan(E*f/fdis);
            ABCDs{x} = [1 0; 1/ZIN 1];
        end
        if(strcmp(ElementType, 'LossyLTlambda_2ParalellCA')) %Línea de transmisión que equivale a una impedancia paralelo
            Zc = Value(1); E = Value(2); fdis = Value(3); a = Value(4); d = Value(5);
            Yc = 1/Zc;
            Gamma_d = a*d + 1i*E*f/fdis;
            YIN = Yc*tanh(Gamma_d);
            ABCDs{x} = [1 0; YIN 1];
        end
        if(strcmp(ElementType, 'LossyLTlambda_2ParalellCC')) %Línea de transmisión que equivale a una impedancia paralelo
            Zc = Value(1); E = Value(2); fdis = Value(3); a = Value(4); d = Value(5);
            Gamma_d = a*d + 1i*E*f/fdis;
            ZIN = Zc*tanh(Gamma_d);
            ABCDs{x} = [1 0; 1/ZIN 1];
        end
        
        
        if(strcmp(ElementType, 'LTlambda_4ParalellCA')) %Línea de transmisión que equivale a una impedancia paralelo
            Zc = Value(1); E = Value(2); fdis = Value(3);
            Yc = 1/Zc;
            YIN = 1i*Yc*tan(E*f/fdis);
            ABCDs{x} = [1 0; YIN 1];
        end
        if(strcmp(ElementType, 'LTlambda_4ParalellCC')) %Línea de transmisión que equivale a una impedancia paralelo
            Zc = Value(1); E = Value(2); fdis = Value(3);
            ZIN = 1i*Zc*tan(E*f/fdis);
            ABCDs{x} = [1 0; 1/ZIN 1];
        end
        if(strcmp(ElementType, 'LossyLTlambda_4ParalellCA')) %Línea de transmisión que equivale a una impedancia paralelo
            Zc = Value(1); E = Value(2); fdis = Value(3); a = Value(4); d = Value(5);
            Yc = 1/Zc;
            Gamma_d = a*d + 1i*E*f/fdis;
            YIN = Yc*tanh(Gamma_d);
            ABCDs{x} = [1 0; YIN 1];
        end
        if(strcmp(ElementType, 'LossyLTlambda_4ParalellCC')) %Línea de transmisión que equivale a una impedancia paralelo
            Zc = Value(1); E = Value(2); fdis = Value(3); a = Value(4); d = Value(5);
            Gamma_d = a*d + 1i*E*f/fdis;
            ZIN = Zc*tanh(Gamma_d);
            ABCDs{x} = [1 0; 1/ZIN 1];
        end
        
        if(strcmp(ElementType, 'LT_LParalell_LT')) %Línea de transmisión que equivale a una impedancia paralelo
            Zc = Value(1); E = Value(2); fdis = Value(3);
            ABCD = [cos(E*f/fdis) 1i*Zc*sin(E*f/fdis); 1i*(1/Zc)*sin(E*f/fdis) cos(E*f/fdis)];
            L = Value(4); ZL = 1i*2*pi*f*L;
            ABCD = ABCD*[1 0; 1/ZL 1];
            Zc = Value(5); E = Value(6); fdis = Value(7);
            ABCD = ABCD*[cos(E*f/fdis) 1i*Zc*sin(E*f/fdis); 1i*(1/Zc)*sin(E*f/fdis) cos(E*f/fdis)];
            ABCDs{x} = ABCD;
        end
        if(strcmp(ElementType, 'LT_CSerial_LT')) %Línea de transmisión que equivale a una impedancia paralelo
            Zc = Value(1); E = Value(2); fdis = Value(3);
            ABCD = [cos(E*f/fdis) 1i*Zc*sin(E*f/fdis); 1i*(1/Zc)*sin(E*f/fdis) cos(E*f/fdis)];
            C = Value(4); YC = 1i*2*pi*f*C;
            ABCD = ABCD*[1 1/YC; 0 1];
            Zc = Value(5); E = Value(6); fdis = Value(7);
            ABCD = ABCD*[cos(E*f/fdis) 1i*Zc*sin(E*f/fdis); 1i*(1/Zc)*sin(E*f/fdis) cos(E*f/fdis)];
            ABCDs{x} = ABCD;
        end
    end
    
    S = circuitCascade(ABCDs, Zo, ZLoad);
end