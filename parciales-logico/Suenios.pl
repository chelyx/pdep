% Queremos reflejar que 
% Gabriel cree en Campanita, el Mago de Oz y Cavenaghi
creeEn(gabriel, campanita).
creeEn(gabriel, magoDeOz).
creeEn(gabriel, cavenaghi).
% Juan cree en el Conejo de Pascua
creeEn(juan, conejoDePascua).
% Macarena cree en los Reyes Magos, el Mago Capria y Campanita
creeEn(macarena, reyesMagos).
creeEn(macarena, magoCapria).
creeEn(macarena, campanita).
% Diego no cree en nadie

% Conocemos tres tipos de sueño
% suenio(quien, cantante(CantidadDiscos)).
% suenio(quien, futbolista(Equipo)).
% suenio(quien, ganarLoteria([SerieNumeros])).

% Queremos reflejar entonces que
% Gabriel quiere ganar la lotería apostando al 5 y al 9, y también quiere ser un futbolista de Arsenal
suenio(gabriel, ganarLoteria([5, 9])).
suenio(gabriel, futbolista(arsenal)).
% Juan quiere ser un cantante que venda 100.000 “discos”
suenio(juan, cantante(100000)).
% Macarena no quiere ganar la lotería, sí ser cantante estilo “Eruca Sativa” y vender 10.000 discos
suenio(macarena, cantante(10000)).
