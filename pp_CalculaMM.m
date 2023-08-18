% pp_CalculaMM: programa principal (pp_) de Ejemplo de CalculaMM.
% jorge.ruizcruz@uam.es
% $Revision: 0.0 $  $Date: 2014/11/30 12:00:00 $
%================================================
clear all; close all; clc;
%% Ejemplo 1: filtro a 11 GHz de 300 MHz de banda de orden 4

% Datos Usuario
a0 = 22.86 ; 
t = 2 ; % grosor de los irises
b0_mm = 10.16 ; lref = 20;
w1 = 10.499 ; w2 = 6.706 ; w3 = 6.147 ; % anchura irises
d1 = 14.0293 ; d2 = 15.6192 ; % longitud cavidades (calculadas para tener en cuenta la correccion de fase del iris)
vfrec_GHz = linspace( 8 , 13 , 201); % vector de frecuencias del barrido

% Ejecucion
va_mm = [a0,w1,a0,w2,a0,w3,a0,w2,a0,w1,a0];  % anchura de las 11 guias del filtro
vd_mm = [lref,t,d1,t,d2,t,d2,t,d1,t,lref];  % longitud de las 11 guias del filtro   
pintaPerfil( va_mm , vd_mm  );
[ vS11 , vS21 , vS22 ] = calculaMM( vfrec_GHz , va_mm , vd_mm , b0_mm ) ;

% Representacion
hfig = figure;
hp = plot( vfrec_GHz , dB( vS11 ),'b', vfrec_GHz , dB( vS21 ), 'r--' , 'Linewidth' , 2 ); grid on;
legend( hp, {'S_{11}','S_{21}'});
xlabel('Frecuencia (GHz)')
ylabel('|S_{ij}| (dB)')


%% Ejemplo 2: Calculo del inversor asociado a un iris

% Datos Usuario
a0 = 22.86 ; 
t = 2 ;  % grosor del iris
b0_mm = 10.16 ; 
lref = 0 ;
w = 10.499 ; % anchura del iris
f0d = 11 ; % frecuencia a la que se quiere ver el inversor equivalente
vfrec_GHz = linspace( 8 , 13 , 201); % vector de frecuencias del barrido

% Ejecucion
va_mm = [a0,w,a0];  % anchura guias 
vd_mm = [lref,t,lref];  % longitud guias    
pintaPerfil( va_mm , vd_mm  );
[ vS11 , vS21 , vS22 ] = calculaMM( vfrec_GHz , va_mm , vd_mm , b0_mm ) ;

% Representacion
hfig1 = figure;
hp = plot( vfrec_GHz , dB( vS11 ),'c', vfrec_GHz , dB( vS21 ), 'm' , 'Linewidth' , 2 ); grid on;
legend( hp, {'S_{11}','S_{21}'});
xlabel('Frecuencia (GHz)')
ylabel('|S_{ij}| (dB)')

% Inversor equivalente a la frecuencia calculada más cercana a la elegida
[~,indf0c] = min( abs( vfrec_GHz - f0d ));
f0c = vfrec_GHz(indf0c);
S11c = vS11( indf0c ) ;
K_equiv_nor = sqrt( ( 1 - abs(S11c) )/(1 + abs(S11c) ) ) ;
theta_equiv_rad = -angle(S11c)/2 + pi/2 ;
disp( sprintf('K=%4.4f y theta=%3.4f (rad) para f0c=%3.4f (GHz) (con a=%4.4f mm,t=%4.4f mm)' , K_equiv_nor , theta_equiv_rad , f0c , a0 , t  ));

% Variacion con la frecuencia del inversor
vK_equiv_nor = sqrt( ( 1 - abs(vS11) )./(1 + abs(vS11) ) );
vtheta_equiv_rad = -angle(vS11)/2 + pi/2 ;

% Representacion
hfig2 = figure;
subplot(2,1,1);
hp = plot( vfrec_GHz , vK_equiv_nor , 'r' , 'Linewidth' , 2 ); grid on;
xlabel('Frecuencia (GHz)')
ylabel(' K/Z_c (Inversor normalizado.)');
title(' Inversor normalizado del cto. equivalente formado por linea+inv+linea');
vline( f0c ); hline( K_equiv_nor );

subplot(2,1,2);
hp = plot( vfrec_GHz , vtheta_equiv_rad*180/pi , 'c' , 'Linewidth' , 2 ); grid on;
xlabel('Frecuencia (GHz)')
ylabel(' \theta (º) (longitud eléct.)')
title(' Longitud eléct. de la línea a cada lado del inversor')
vline( f0c ); hline( theta_equiv_rad*180/pi );




%% Ejemplo 3: Creacion Tabla de inversores a un frecuencia de diseño (tipicamente la central del filtro)

% Datos Usuario
a0 = 19.05 ;
t = 1.5 ;  % grosor del iris
b0_mm = 9.525 ; 
lref = 0;
vw = linspace( 1 , 12 ,  7001 ) ; % anchura del iris
f0d = 10 ; % frecuencia a la que se quiere hacer la tabla de inversores 

% Bucle para las distintas anchuras
Nw = numel(vw); % numero de puntos de la tabla (numero de anchuras)
vK_equiv_nor = nan(1,Nw);
vtheta_equiv_rad = nan(1,Nw);
for ii = 1 : numel(vw)
    w = vw(ii);
    va_mm = [a0,w,a0];  % anchura guias 
    vd_mm = [lref,t,lref];  % longitud guias    
    vfrec_GHz = f0d ;
    [ vS11 , vS21 , vS22 ] = calculaMM( vfrec_GHz , va_mm , vd_mm , b0_mm ) ;

    S11c = vS11 ;
    vK_equiv_nor(ii) = sqrt( ( 1 - abs(S11c) )/(1 + abs(S11c) ) ) ;
    vtheta_equiv_rad(ii) = -angle(S11c)/2 + pi/2 ;
end

% Representacion
hfig = figure;
subplot(2,1,1);
hp = plot( vw , vK_equiv_nor , 'r' , 'Linewidth' , 2 ); grid on;
xlabel('Anchura Iris (mm)')
ylabel(' K/Z_c (Inversor normalizado)');
title(' Inversor normalizado del cto. equivalente formado por linea+inv+linea');

subplot(2,1,2);
hp = plot( vw , vtheta_equiv_rad*180/pi  , 'c'  , 'Linewidth' , 2 ); grid on;
xlabel('Anchura Iris (mm)')
ylabel(' \theta (º) (longitud eléctrica en grados)')
title(' Longitud eléct. de la línea a cada lado del inversor')

% Buscar en la tabla un valor determinado
Kdis = 0.3863 ; 
[~,indKdis] = min( abs( vK_equiv_nor - Kdis ));
disp( sprintf('EJEMPLO 3: Kdis=%4.4f ; K=%4.4f y theta=%3.4f rad para w=%3.4f mm (en f0d=%4.4f GHz,a=%4.4f mm,t=%4.4f mm)' , Kdis , vK_equiv_nor(indKdis) , vtheta_equiv_rad(indKdis) , vw(indKdis) , f0d , a0 , t ) );
subplot(2,1,1);hline( vK_equiv_nor(indKdis) ); vline( vw(indKdis) );
subplot(2,1,2);hline(  vtheta_equiv_rad(indKdis)*180/pi  );  vline( vw(indKdis) );

%Calcular por mode matching (por lo que entiendo, el ejercicio 16 hay que hacerlo con CalculaMM.m también): hay tres trozos en el código ...calculaMM.m que son
%independientes, la salida de uno no depende de la otra. Lo primero del
%código es un ejemplo de prueba. Es un filtro con su perfil. Las
%dimensiones no las sabemos, pero desde el punto de vista de analizar, una
%cosa es que para nosotros haya guías que son cavidades, írises etc. Desde
%el punto de vista de CST o de matlab nos da igual:; las tres cosas son
%guías. Tanto las guías de entrada y salida como la de los írises son
%rectangulares con su altura, anchura y longitud. La altura es b0 y es la
%misma, pero para el resto de anchuras y longitudes se especifican con
%vectores. Se ponen las 11 anchuras que tenemos (a0, w1, a1...) a0 es el
%valor de la anchura estándar y hay otras que van variando porque son las
%de los írises. Para las longirudes igual (la primera y la última son la de
%los planos de referencias: 20 y luego viene anchura cavidad/grosor de iris
%etc). eL CÓDIGO EN resumen simula una concatenación de guías
%rectangulares. Tendremos primero que calcular los inversores (K). Lo que
%queremos es tener una fucnión que, dado un inversor (el valor K) nos de el
%valor de su anchura, pero eso no es analítico, no existe. Por tanto, no se
%sabe a priori la anchura, pero lo que podemos hacer es intentar ver si por
%análisis existe (Dada una anchura, hallamos K). Así probamos con varias
%anchuras hasta lograr el K adecuado y luego vamos a automatizar eso (Eso
%es el ejemplo 3), pero antes hay que entender cómo sale esa función. Esa
%función sale con el paralelismo que hay en el documento de Moodle, Si
%simulamos una estructura + trozo + trozo (pág 4) es como tener línea +
%inversor + línea. Por esto, el ejemplo 2 de calculaMM tiene los parámetros
%S de línea + inversor + línea. Por tanto, cuando tenemos una estructura
%como la de la pág 4, el código ejemplo2 de calculaMM hace eso: calcular K a partir de W (la longitud de
%referencia es 0 porque ahora tenemos que estar en el plano de referencia).
%Con el trozo de código, si ponemos una anchura de 2.5 por ejemplo
%tendremos que nos saca K y theta. Nosotros queremos que dado un inversor K
%calcular su anchura W. Por ello, construimos una curva de W y K para
%muchos puntos de W y gráficamente sacamos W a partir de nuestro K. Para
%esto sirve el ejemplo 3: definimos un conjunto de anchuras para el iris y
%para cada anchura calculamos el K y lo pintamos y obtener W a partir de
%una W ya lo hace solo. Simplemente hay que ejecutar el código 3 veces. Eso
%sí, para cada anchura tenemos un inversor, pero también tenemos un trozo
%de fase. Por tanto, para nuestro K tenemos que tener en cuenta la fase
%d línea que hay que tener en cuenta (recordar diapositiva 13 de írises) y
%esa fase hay que compensarla. Lambdag = 2pi/betag, donde betag es el beta de la guía TE10 a
%fc