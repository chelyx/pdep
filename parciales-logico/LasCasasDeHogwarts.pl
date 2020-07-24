%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parte 1 - Sombrero Seleccionador  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mago(harry, mestiza, [coraje, amistad, orgullo, inteligencia]).
mago(draco, pura, [inteligencia, orgullo]).
mago(hermione, impura, [inteligencia, orgullo, responsabilidad]).

odia(harry, slytherin).
odia(draco, hufflepuff).

casa(gryffindor, [coraje]).
casa(slytherin, [inteligencia, orgullo]).
casa(ravenclaw, [inteligencia, responsabilidad]).
casa(hufflepuff, [amistad]).

permiteEntrar(Mago, Casa):-
    mago(Mago, _, _),
    casa(Casa, _),
    Casa \= slytherin.

permiteEntrar(Mago, slytherin):-
    mago(Mago, Sangre, _),
    Sangre \= impura.

cumpleCaracteristicas(Mago, Casa):-
    mago(Mago, _, Caracteristicas),
    casa(Casa, Requisitos),
    forall(member(Req, Requisitos), member(Req, Caracteristicas)).

sombreroSeleccionador(Mago, Casa):-
    mago(Mago, _, _),
    odia(Mago, Odia),
    permiteEntrar(Mago, Casa),
    cumpleCaracteristicas(Mago, Casa),
    Casa \= Odia.

sombreroSeleccionador(hermione, gryffindor).

esAmistoso(Mago):-
    mago(Mago, _, Caract),
    member(amistad, Caract).

cadenaDeAmistades(ListaMagos):-
    member(M, ListaMagos),
    sombreroSeleccionador(M, Casa),
    forall(member(Mago, ListaMagos), (esAmistoso(Mago), sombreroSeleccionador(Mago, Casa))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parte 2 - La copa de las casas %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% esDe/2 relaciona al mago con la casa en la que quedo.
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

malaAccion(andarDeNoche, 50).
malaAccion(irBosque, 50).
malaAccion(biblioteca, 10).
malaAccion(tercerPiso, 75).

% registro/2 relaciona al mago con la accion que hizo.
registro(harry, andarDeNoche).
registro(harry, irBosque).
registro(harry, tercerPiso).
registro(hermione, tercerPiso).
registro(hermione, biblioteca).
registro(draco, mazmorras).
registro(ron, ganoPuntos(partidaAjedrez, 50)).
registro(hermione, ganoPuntos(salvarAmigos, 50)).
registro(harry, ganoPuntos(ganarleAVoldemort, 60)).
registro(hermione, responderPregunta(dondeBezoar, 20, snape)).
registro(hermione, responderPregunta(levitarPluma, 25, flitwick)).

esBuenAlumno(Mago):-
    registro(Mago, _),
    forall(registro(Mago, Accion), not(malaAccion(Accion, _))).

accionRecurrente(Accion):-
    registro(M1, Accion),
    registro(M2, Accion),
    M1 \= M2.

puntosRespuestas(Alumno, Puntos):-
    registro(Alumno, responderPregunta(_, Dif, snape)),
    Puntos is div(Dif, 2).
puntosRespuestas(Alumno, Puntos):-
    registro(Alumno, responderPregunta(_,Puntos, Prof)),
    Prof \= snape.

puntosAlumno(Alumno, Total):-
    findall(P, registro(Alumno, ganoPuntos(_, P)), Suman),
    findall(PR, puntosRespuestas(Alumno, PR), SumanResp),
    findall(M, (registro(Alumno, Accion), malaAccion(Accion, M)), Restan),
    sum_list(Suman, Ganados),
    sum_list(SumanResp, GanaResp),
    sum_list(Restan, PierdeTotal),
    Total is Ganados + GanaResp - PierdeTotal. 

puntajeTotal(Casa, Total):-
    casa(Casa, _),
    findall(PAlumnos, (esDe(Alumno, Casa), puntosAlumno(Alumno, PAlumnos)), ListPuntos),
    sum_list(ListPuntos, Total).

casaGanadora(Casa):-
    puntajeTotal(Casa, Total),
    forall(casa(C, _), (puntajeTotal(C, T), T =< Total)).
