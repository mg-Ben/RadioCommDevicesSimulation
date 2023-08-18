function [ds] = getLengths(descriptor)
    N = size(descriptor, 2);
    ds = zeros(1, N);
    for x=1:N
        component = descriptor{1, x};
        if(strcmp(component, 'IRIS_WG'))
            Values = descriptor{2, x};
            ds(x) = Values(3);
        end
        if(strcmp(component, 'LTlambda_2_WG'))
            Values = descriptor{2, x};
            ds(x) = Values(7);
        end
    end
end