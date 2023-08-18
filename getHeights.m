function [bs] = getHeights(descriptor)
    N = size(descriptor, 2);
    bs = zeros(1, N);
    for x=1:N
        component = descriptor{1, x};
        if(strcmp(component, 'IRIS_WG'))
            Values = descriptor{2, x};
            bs(x) = Values(2);
        end
        if(strcmp(component, 'LTlambda_2_WG'))
            Values = descriptor{2, x};
            bs(x) = Values(6);
        end
    end
end