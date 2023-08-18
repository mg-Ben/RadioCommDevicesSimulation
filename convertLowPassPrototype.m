function [descriptorOut] = convertLowPassPrototype(descriptorIn, transformacion, Ro, fc, f1, f2)
    N = size(descriptorIn, 2);
    descriptorOut = cell(3, N);

    for x=1:N
        [descriptorOut{1, x}, descriptorOut{2, x}] = elementTransformation(descriptorIn{1:2, x}, transformacion, Ro, fc, f1, f2);
    end
    descriptorOut(end, :) = descriptorIn(end, :);
end