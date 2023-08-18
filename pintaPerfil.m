function pintaPerfil( va , vd )
% pintaPerfil( va , vd )
%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%
% PROPÓSITO: 
% Pinta el perfil
%
% jorge.ruizcruz@uam.es
% $Revision: 0.0 $  $Date: 2014/12/04 12:00:00 $
%
%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

for ii=1:numel(va)
   vy(2*ii-1) = va(ii);  vy(2*ii) = va(ii); 
end

vzc  = [ 0 cumsum( vd ) ];
for ii=1:numel(vd)
   vx(2*ii-1) = vzc(ii);  vx(2*ii) = vzc(ii+1); 
end

% Representacion
hfig1 = figure;
hp = plot( vx , vy/2 ,'b-s', 'Linewidth' , 2 ); grid on; hold on;
hp = plot( vx , -vy/2 ,'b-s', 'Linewidth' , 2 ); grid on; hold on;
xlabel('(mm)');
ylabel('(mm)');
axis equal

