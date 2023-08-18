function [vg,gL,textodis]=calc_vg(tipodis,varargin)
% Calcular elementos gi del prototipo paso bajo
%=====================================================
%
% PROPÓSITO: 
% Calcular elementos del prototipo paso bajo normalizado
%
% ARGUMENTOS: 
% [vg,gL,textodis]=calc_vg(tipodis,N,rip)
% tipodis: string con el tipo de diseño que se quiere
% N: orden
% rip: equirrizado
% vg: elementos del prototipo paso bajo
% gL: carga normalizada
% textodis: string con un identificador del diseño y sus parámetros
%
% DESCRIPCIÓN:
% Dado un identificador de tipo de idseño y sus parámetros correpondientes
% (tipicamente el orden y las perdidas de retorno máximas) se calculan los
% elementos del prototipo paso bajo normalizado
%
% EJEMPLOS:
% [vgobj,gL,textodis]=calc_vg('Butterworth',5);
% [vgobj,gL,textodis]=calc_vg('Bessel',3);
% [vgobj,gL,textodis]=calc_vg('Chebychev',6,-20);
% [vgobj,gL,textodis]=calc_vg('Chebychev',3,-15);
%
% jorge.ruizcruz@uam.es
% $Revision: 0.0 $  $Date: 2014/12/04 12:00:00 $
%
%=====================================================

switch tipodis

%==============================================    
case 'Butterworth'
% Maximalmente plano: Pozar, pag. 597   
%==============================================

if length(varargin)~=1, error('Numero de argumentos de entrada erroneos'); end
N=varargin{1}; % Orden
vk=1:N;
vg=2*sin((2*vk-1)/(2*N)*pi);    
gL=1;
textodis=sprintf('Butterworth N=%d',N);

%==============================================    
case 'Chebychev'
% Equirrizado: Pozar, pag. 597     
%==============================================

if length(varargin)~=2, error('Numero de argumentos de entrada erroneos'); end
N=varargin{1};     % Orden
RLdB=varargin{2};  % Perdidas de retorno mas desafvorables en dB´s
if N~=floor(N) | N<0 | RLdB>0, error('N o RL equivocados'); end
s11max=10^(RLdB/20);
kriz=sqrt(1/(1-s11max^2)-1);
beta=log((sqrt(1+kriz^2)+1)/(sqrt(1+kriz^2)-1));
for k=1:N
    va(k)=sin((2*k-1)/(2*N)*pi);
    vb(k)=sinh(beta/(2*N)).^2+sin(k*pi/N).^2;
    if k==1
        vg(k)=2*va(1)/sinh(beta/(2*N));
    else
        vg(k)=4*va(k-1)*va(k)/(vb(k-1)*vg(k-1));
    end    
end
if N~=2*floor(N/2)
    gL=1;
else    
    %gL=2*kriz^2+1-2*kriz*sqrt(1+kriz^2); % Valor de Collin: falta un inverso
    gL=coth(beta/4)^2; % Valor del Mattaei=Valor del Hong =  1 / (Valor del Collin);
end    
textodis=sprintf('Chebychev N=%d, RLdB=%g',N,RLdB);

%==============================================    
case 'Bessel'
% retardo de grupo maximalmente plano: Tabla 8.5, pag. 454, Collin (también en Mattaei)    
%==============================================

if length(varargin)~=1, error('Numero de argumentos de entrada erroneos'); end
N=varargin{1};     % Orden

if     N==1,  vg=[2.0000];
elseif N==2,  vg=[1.5774 0.4226 ];
elseif N==3,  vg=[1.2550 0.5528 0.1922];
elseif N==4,  vg=[1.0598 0.5116 0.3181 0.1104];
elseif N==5,  vg=[0.9303 0.4577 0.3312 0.2090 0.0718];
elseif N==6,  vg=[0.8377 0.4116 0.3158 0.2364 0.1480 0.0505];
elseif N==7,  vg=[0.7677 0.3744 0.2944 0.2378 0.1778 0.1104 0.0375];
elseif N==8,  vg=[0.7125 0.3446 0.2735 0.2297 0.1867 0.1387 0.0855 0.0289];
elseif N==9,  vg=[0.6678 0.3203 0.2547 0.2184 0.1859 0.1506 0.1111 0.0682 0.0230];
elseif N==10, vg=[0.6305 0.3002 0.2384 0.2066 0.1808 0.1539 0.1240 0.0911 0.0057 0.0187];
else, error('Caso de tipodis=%s con N=%d no implementado',tipodis,N);
end  
gL=1;
textodis=sprintf('Bessel N=%d',N);

%==============================================    
otherwise
% Error por caso no implemetado
%==============================================
    error('tipo=%s no implementado',tipodis);
end    
    
%========================================================
%========================================================
%========================================================
%========================================================