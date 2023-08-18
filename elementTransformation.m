function [ElementTypeOut, ValueOut] = elementTransformation(ElementType, ValueIn, Transformation, Ro, fc, f1, f2)
    f0 = (f1+f2)/2;
    D = (f2-f1)/f0;
    if(strcmp(Transformation, 'LP'))
        if(strcmp(ElementType, 'C'))
            ValueOut = ValueIn/(Ro*(2*pi*fc));
            ElementTypeOut = 'C';
        end
        if(strcmp(ElementType, 'L'))
            ValueOut = ValueIn*Ro/(2*pi*fc);
            ElementTypeOut = 'L';
        end
    end
    if(strcmp(Transformation, 'HP'))
        if(strcmp(ElementType, 'C'))
            ValueOut = Ro/(ValueIn*(2*pi*fc));
            ElementTypeOut = 'L';
        end
        if(strcmp(ElementType, 'L'))
            ValueOut = 1/((2*pi*fc)*ValueIn*Ro);
            ElementTypeOut = 'C';
        end
    end
    if(strcmp(Transformation, 'BP'))
        if(strcmp(ElementType, 'C'))
            ValueOut = [D*Ro/(ValueIn*(2*pi*f0)) ValueIn/(Ro*D*(2*pi*f0))];
            ElementTypeOut = 'RESP'; %RESP: Resonador Paralelo
        end
        if(strcmp(ElementType, 'L'))
            ValueOut = [ValueIn*Ro/(D*(2*pi*f0)) D/(Ro*ValueIn*(2*pi*f0))];
            ElementTypeOut = 'RESS'; %RESS: Resonador Serie
        end
    end
    if(strcmp(Transformation, 'RP'))
        if(strcmp(ElementType, 'C'))
            ValueOut = [Ro/(ValueIn*(2*pi*f0)*D) ValueIn*D/(Ro*(2*pi*f0))];
            ElementTypeOut = 'RESS';
        end
        if(strcmp(ElementType, 'L'))
            ValueOut = [ValueIn*Ro*D/(2*pi*f0) 1/(D*Ro*ValueIn*(2*pi*f0))];
            ElementTypeOut = 'RESP';
        end
    end
end