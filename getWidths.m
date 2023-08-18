function [as] = getWidths(descriptor)
    N = size(descriptor, 2);
    as = zeros(1, N);
    for x=1:N
        component = descriptor{1, x};
        if(strcmp(component, 'IRIS_WG'))
            Values = descriptor{2, x};
            as(x) = Values(1);
        end
        if(strcmp(component, 'LTlambda_2_WG'))
            Values = descriptor{2, x};
            as(x) = Values(5);
        end
    end
end