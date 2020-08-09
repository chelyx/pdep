persona(Persona):-
    creeEn(Persona, _).
persona(diego).

personaje(Personaje):-
    creeEn(_, Personaje).

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

% 2. Queremos saber si una persona es ambiciosa, esto ocurre cuando la suma de dificultades de los sueños es mayor a 20. 
% La dificultad de cada sueño se calcula como
% 6 para ser un cantante que vende más de 500.000 ó 4 en caso contrario
dificultadSuenio(cantante(Discos), 6):-
    Discos > 500000.
dificultadSuenio(cantante(Discos), 4):-
    Discos =< 500000.
% ganar la lotería implica una dificultad de 10 * la cantidad de los números apostados
dificultadSuenio(ganarLoteria(SerieNumeros), Dificultad):-
    length(SerieNumeros, CantidadN),
    Dificultad is CantidadN * 10.
% lograr ser un futbolista tiene una dificultad de 3 en equipo chico o 16 en caso contrario. Arsenal y Aldosivi son 
% equipos chicos
dificultadSuenio(futbolista(Equipo), 3):-
    equipoChico(Equipo).
dificultadSuenio(futbolista(Equipo), 16):-
    not(equipoChico(Equipo)).

equipoChico(arsenal).
equipoChico(aldosivi).

esAmbicioso(Personaje):-
    suenio(Personaje, _),
    findall(Dif, (suenio(Personaje, Suenio), dificultadSuenio(Suenio, Dif)), Dificultades),
    sum_list(Dificultades, Total),
    Total > 20.

% 3. Queremos saber si un personaje tiene química con una persona. Esto se da si la persona cree en el personaje y...
% para Campanita, la persona debe tener al menos un sueño de dificultad menor a 5.
% para el resto, todos los sueños deben ser puros (ser futbolista o cantante de menos de 200.000 discos)
% y la persona no debe ser ambiciosa

tienenQuimica(campanita, Persona):-
    creeEn(Persona, campanita),
    suenio(Persona, Suenio),
    dificultadSuenio(Suenio, Dif),
    Dif < 5.

tienenQuimica(Personaje, Persona):-
    creeEn(Persona, Personaje),
    sueniosPuros(Persona),
    not(esAmbicioso(Persona)).

sueniosPuros(Persona):-
    suenio(Persona, futbolista(_)).
sueniosPuros(Persona):-
    suenio(Persona, cantante(Discos)),
    Discos < 200000.

% 4. Sabemos que
% Campanita es amiga de los Reyes Magos y del Conejo de Pascua
% el Conejo de Pascua es amigo de Cavenaghi, entre otras amistades
amigo(campanita, reyesMagos).
amigo(campanita, conejoDePascua).
amigo(conejoDePascua, cavenaghi).
sonAmigos(A, B):-
    amigo(A, B); amigo(B,A).
% Un personaje de backup es un amigo directo o indirecto del personaje principal
backup(Principal, Directo):-
    sonAmigos(Principal, Directo).
backup(Principal, Indirecto):-
    sonAmigos(Principal, Directo),
    sonAmigos(Directo, Indirecto),
    Principal \= Indirecto.
% Necesitamos definir si un personaje puede alegrar a una persona, esto ocurre
% si una persona tiene algún sueño, el personaje tiene química con la persona y...
%   el personaje no está enfermo
%   o algún personaje de backup no está enfermo. 
cumpleRequisitos(Personaje, Persona):-
    suenio(Persona, _),
    tienenQuimica(Personaje, Persona).

puedeAlegrarla(Personaje, Persona):-
    cumpleRequisitos(Personaje, Persona),
    not(estaEnfermo(Personaje)).

puedeAlegrarla(Personaje, Persona):-
    cumpleRequisitos(Personaje, Persona),
    estaEnfermo(Personaje),
    backup(Personaje, PersonajeBackup),
    not(estaEnfermo(PersonajeBackup)).

% Suponiendo que Campanita, los Reyes Magos y el Conejo de Pascua están enfermos, 
estaEnfermo(campanita).
estaEnfermo(reyesMagos).
estaEnfermo(conejoDePascua).
% el Mago Capria alegra a Macarena, ya que tiene química con ella y no está enfermo
% Campanita alegra a Macarena; aunque está enferma es amiga del Conejo de Pascua, 
% que aunque está enfermo es amigo de Cavenaghi que no está enfermo.
