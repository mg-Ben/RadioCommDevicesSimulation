function [S] = ABCDtoS(T, Z01, Z02)
%     A = ABCD(1, 1); B = ABCD(1, 2); C = ABCD(2, 1); D = ABCD(2, 2);
%     S11 = (A + B/Z0 - C*Z0 - D)/(A + B/Z0 + C*Z0 + D);
%     S12 = 2*(A*D - B*C)/(A + B/Z0 + C*Z0 + D);
%     S21 = 2/(A + B/Z0 + C*Z0 + D);
%     S22 = (-A + B/Z0 -C*Z0 + D)/(A + B/Z0 + C*Z0 + D);
%     S = [S11 S12; S21 S22];

    %%
    A=T(1,1);
    B=T(1,2);
    C=T(2,1);
    D=T(2,2);
    
    denom1=A+B/Z02+C*Z01+D*Z01/Z02;
    
    S11=(A+B/Z02-C*Z01-D*Z01/Z02)/denom1;
    S21=2*sqrt(Z01/Z02)/denom1;
    
    denom2=D+B/Z01+C*Z02+A*Z02/Z01;
    
    S22=(D+B/Z01-C*Z02-A*Z02/Z01)/denom2;
    S12=2*sqrt(Z02/Z01)*(A*D-B*C)/denom2;
    
    S = [S11 S12; S21 S22];
end