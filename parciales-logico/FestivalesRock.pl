anioActual(2015).
nacional(ar).

%festival(nombre, lugar, bandas, precioBase).
%lugar(nombre, capacidad).
festival(lulapaluza, lugar(hipodromo,40000), [miranda, paulMasCarne, muse], 500).
festival(mostrosDelRock, lugar(granRex, 10000), [kiss, judasPriest, blackSabbath], 1000).
festival(personalFest, lugar(geba, 5000), [tanBionica, miranda, muse, pharrellWilliams], 300).
festival(cosquinRock, lugar(aerodromo, 2500), [erucaSativa, laRenga], 400).

%banda(nombre, año, nacionalidad, popularidad).
banda(paulMasCarne,1960, uk, 70).
banda(muse,1994, uk, 45).
banda(kiss,1973, us, 63).
banda(erucaSativa,2007, ar, 60).
banda(judasPriest,1969, uk, 91).
banda(tanBionica,2012, ar, 71).
banda(miranda,2001, ar, 38).
banda(laRenga,1988, ar, 70).
banda(blackSabbath,1968, uk, 96).
banda(pharrellWilliams,2014, us, 85).

entrada(plateaNumerada(1)).
entrada(plateaNumerada(2)).
entrada(plateaNumerada(3)).
entrada(plateaNumerada(4)).
entrada(plateaNumerada(5)).
entrada(plateaNumerada(6)).
entrada(plateaNumerada(7)).
entrada(plateaNumerada(8)).
entrada(plateaNumerada(9)).
entrada(plateaNumerada(10)).
entrada(plateaGeneral(zona1)).
entrada(plateaGeneral(zona2)).
entrada(campo).

%entradasVendidas(nombreDelFestival, tipoDeEntrada, cantidadVendida).
% tipos de entrada: campo, plateaNumerada(numero de fila), plateaGeneral(zona).
entradasVendidas(lulapaluza,campo, 600).
entradasVendidas(lulapaluza,plateaGeneral(zona1), 200).
entradasVendidas(lulapaluza,plateaGeneral(zona2), 300).
entradasVendidas(mostrosDelRock,campo,20000).
entradasVendidas(mostrosDelRock,plateaNumerada(1),40).
entradasVendidas(mostrosDelRock,plateaNumerada(2),0).
% … y asi para todas las filas
entradasVendidas(mostrosDelRock,plateaNumerada(10),25).
entradasVendidas(mostrosDelRock,plateaGeneral(zona1),300).
entradasVendidas(mostrosDelRock,plateaGeneral(zona2),500).

plusZona(hipodromo, zona1, 55).
plusZona(hipodromo, zona2, 20).
plusZona(granRex, zona1, 45).
plusZona(granRex, zona2, 30).
plusZona(aerodromo, zona1, 25).

% 1)  estaDeModa/1. Se cumple para las bandas recientes (que surgieron en 
% los últimos 5 años) que tienen una popularidad mayor a 70.

estaDeModa(Banda):-
    banda(Banda, Anio, _, Popularidad),
    anioActual(Actual),
    Anio >= Actual - 5,
    Popularidad >= 70.

% 2) esCareta/1. Se cumple para todo festival que cumpla alguna de las siguientes condiciones:
% que participen al menos 2 bandas que estén de moda.
esCareta(Festival):-
    festival(Festival, _, Bandas, _),
    member(Banda1, Bandas),
    member(Banda2, Bandas),
    estaDeModa(Banda1),
    estaDeModa(Banda2),
    Banda1 \= Banda2.
% si toca Miranda.
esCareta(Festival):-
    festival(Festival, _, Bandas, _),
    member(miranda, Bandas).

% que no tenga entradas razonables (ver punto 3).
esCareta(Festival):-
    festival(Festival, _, Bandas, _),
    not(entradaRazonable(Festival, _)).

% 3)entradaRazonable/2. Relaciona un festival con una entrada del mismo si se cumple:  

precioEntrada(Fest, campo, Precio):-
    festival(Fest, _, _, Precio).

precioEntrada(Fest, plateaNumerada(Fila), Precio):-
    festival(Fest, _, _, PrecioBase),
    entrada(plateaNumerada(Fila)),
    Div is div(200, Fila),
    Precio is PrecioBase + Div.

precioEntrada(Fest, plateaGeneral(Zona), Precio):-
    festival(Fest, lugar(Lugar, _) , _, PrecioBase),
    entrada(plateaGeneral(Zona)),
    plusZona(Lugar, Zona, Plus),
    plus(PrecioBase, Plus, Precio).

popularidadTotal(Lista, Total):-
    findall(P, (member(B, Lista), banda(B,_,_, P)), Popus), 
    sum_list(Popus, Total).

% para la platea general, si el plus de la zona es menos del 10% del precio de la entrada.  
entradaRazonable(Festival, plateaGeneral(Zona)):-
    festival(Festival, lugar(Lugar, _), _, _),
    precioEntrada(Festival, plateaGeneral(Zona), Precio),
    plusZona(Lugar, Zona, Plus),
    Plus < (Precio * 0.1).

% para campo, el precio de la entrada es menor a la popularidad total del festival. La popularidad total es la suma 
% de la popularidad de todas las bandas que participan.
entradaRazonable(Festival, campo):-
    festival(Festival,_, Bandas, _),
    popularidadTotal(Bandas, Popularidad),
    precioEntrada(Festival, campo, Precio),
    Precio < Popularidad.

% para la platea numerada, si ninguna de las bandas que tocan está de moda, el precio no puede superar los $750;
% de lo contrario, el precio deberá ser menor a la capacidad del estadio / la popularidad total del festival.
entradaRazonable(Festival, plateaNumerada(Fila)):-
    festival(Festival,_, Bandas, _),
    forall(member(Banda, Bandas), not(estaDeModa(Banda))),
    precioEntrada(Festival, plateaNumerada(Fila), Precio),
    Precio < 750.

entradaRazonable(Festival, plateaNumerada(Fila)):-
    festival(Festival,lugar(_, Capacidad), Bandas, _),
    popularidadTotal(Bandas, Popularidad),
    precioEntrada(Festival, plateaNumerada(Fila), Precio),
    Coc is div(Capacidad, Popularidad),
    Precio < Coc.

% 4) nacanpop/1. Se cumple para un festival si todas las bandas que participan del mismo son nacionales y alguna de
% sus entradas disponibles es razonable.
nacanpop(Festival):-
    festival(Festival, _, Bandas, _),
    nacional(Pais),
    forall(member(B, Bandas), banda(B, _, Pais, _)),
    entradaRazonable(Festival, _).

% 5) recaudacion/2. Relaciona un festival con su recaudación, que se calcula como la suma del precio de todas las entradas 
% vendidas (multiplicar el valor de una entrada por la cantidad vendida de la misma).
recaudacion(Festival, Recaudacion):-
    festival(Festival, _, _, _),
    findall(T, (entradasVendidas(Festival, Entrada, Cantidad), precioEntrada(Festival, Entrada, Precio), T is Precio*Cantidad), Lista),
    sum_list(Lista, Recaudacion).

% 6) estaBienPlaneado/1. Se cumple si las bandas que participan van creciendo en popularidad, y la banda que cierra el festival 
% (es decir, la última) es legendaria. Una banda es legendaria cuando surgió antes de 1980, es internacional y tiene una popularidad 
% mayor a la de todas las bandas de moda.

esLegendaria(Banda):-
    banda(Banda, Anio, Nac, Pop),
    Anio =< 1980,
    not(nacional(Nac)),
    forall((estaDeModa(B), banda(B,_,_,P)), Pop > P).

paraDosElem(ListaBanda, Elem1, Elem2):-
    nth1(Index1, ListaBanda, Elem1),
    nth1(Index2, ListaBanda, Elem2),
    Index1 < Index2.

esMasPopular(MasPopular, OtraBanda):-
    banda(MasPopular, _, _, Pop1),
    banda(OtraBanda, _, _, Pop2),
    Pop1 > Pop2.

vaCreciendo(ListaBanda):-
    forall(paraDosElem(ListaBanda, Banda1, Banda2), esMasPopular(Banda2, Banda1)).

estaBienPlaneado(Festival):-
    festival(Festival, _, Bandas, _),
    vaCreciendo(Bandas),
    last(Bandas, Ultima),
    esLegendaria(Ultima).
