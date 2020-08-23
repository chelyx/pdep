%tarea(agente, tarea, ubicacion)
%tareas:
%  ingerir(descripcion, tamaño, cantidad)
%  apresar(malviviente, recompensa)
%  asuntosInternos(agenteInvestigado)
%  vigilar(listaDeNegocios)

tarea(vigilanteDelBarrio, ingerir(pizza, 1.5, 2),laBoca).
tarea(vigilanteDelBarrio, vigilar([pizzeria, heladeria]), barracas).
tarea(canaBoton, asuntosInternos(vigilanteDelBarrio), barracas).
tarea(sargentoGarcia, vigilar([pulperia, haciendaDeLaVega, plaza]),puebloDeLosAngeles).
tarea(sargentoGarcia, ingerir(vino, 0.5, 5),puebloDeLosAngeles).
tarea(sargentoGarcia, apresar(elzorro, 100), puebloDeLosAngeles). 
tarea(vega, apresar(neneCarrizo,50),avellaneda).
tarea(jefeSupremo, vigilar([congreso,casaRosada,tribunales]),laBoca).

ubicacion(puebloDeLosAngeles).
ubicacion(avellaneda).
ubicacion(barracas).
ubicacion(marDelPlata).
ubicacion(laBoca).
ubicacion(uqbar).

%jefe(jefe, subordinado)
jefe(jefeSupremo,vega ).
jefe(vega, vigilanteDelBarrio).
jefe(vega, canaBoton).
jefe(jefeSupremo,sargentoGarcia).

agente(Agente):-
    tarea(Agente, _, _).
% 1) Hacer el predicado frecuenta/2 que relaciona un agente con una ubicación en la que suele estar.
% Los agentes frecuentan las ubicaciones en las que realizan tareas
frecuenta(Agente, Ubicacion):-
    tarea(Agente, _, Ubicacion).
% Todos los agentes frecuentan buenos aires.
frecuenta(Agente, buenosAires):-
    agente(Agente).
% Vega frecuenta quilmes.
frecuenta(vega, quilmes).
% Si un agente tiene como tarea vigilar un negocio de alfajores, frecuenta Mar del Plata.
frecuenta(Agente, marDelPlata):-
    tarea(Agente, vigilar(Lugares), _),
    member(alfajores, Lugares).

% 2) Hacer el predicado que permita averiguar algún lugar inaccesible, es decir, al que nadie frecuenta. 
lugarInaccesible(Ubicacion):-
    ubicacion(Ubicacion),
    forall(agente(Agente), not(frecuenta(Agente, Ubicacion))).

% 3) Hacer el predicado afincado/1, que permite deducir si un agente siempre realiza sus tareas en la misma ubicación
afincado(Agente):-
    tarea(Agente, _, Ubicacion),
    forall(tarea(Agente, _, Ubi2), Ubi2 == Ubicacion).

% 4) Hacer el predicado cadenaDeMando/1 que verifica si la lista recibida se trata de una cadena de mando válida, 
% lo que significa que el primero es jefe del segundo y el segundo del tercero y así sucesivamente. 
% Debe estar hecho de manera tal que permita generar todas las cadenas de mando posibles, de dos o más agentes. 

cadenaDeMando([Jefe, Segundo]):-
    jefe(Jefe, Segundo).

cadenaDeMando([Jefe, Seg | Lista]):-
    jefe(Jefe, Seg),
    cadenaDeMando([Seg |Lista]),
    length(Lista, Int),
    Int >= 1.


% 5) Hacer un predicado llamado agentePremiado/1 que permite deducir el agente que recibe el premio por tener la 
% mejor puntuación. La puntuación de un agente es la sumatoria de los puntos de cada tarea que el agente realiza, 
% que puede ser positiva o negativa. Se calcula de la siguiente manera:
% vigilar: 5 puntos por cada negocio que vigila
puntos(Agente, Puntos):-
    tarea(Agente, vigilar(Negocios), _),
    length(Negocios, Int),
    Puntos is Int * 5.
% ingerir: 10 puntos negativos por cada unidad de lo que ingiera. Las unidades ingeridas se calculan como tamaño x 
% cantidad.
puntos(Agente, Puntos):-
    tarea(Agente, ingerir(_, Tamanio, Cant), _),
    Puntos is -(Tamanio*Cant).
% apresar: tantos puntos como la mitad de la recompensa.
% apresar(malviviente, recompensa)
puntos(Agente, Puntos):-
    tarea(Agente, apresar(_, Recompensa), _),
    Puntos is Recompensa / 2.
%  asuntosInternos(agenteInvestigado)
% asuntosInternos: el doble de la puntuación del agente al que investiga.
puntos(Agente, Puntos):-
    tarea(Agente, asuntosInternos(Investigado), _),
    puntos(Investigado, PInv),
    Puntos is 2 * PInv.

puntosTotales(Agente, Puntos):-
    agente(Agente),
    findall(P, puntos(Agente,P), ListaPuntos),
    sum_list(ListaPuntos, Puntos).
    
agentePremiado(Agente):-
    puntosTotales(Agente, Puntos),
    forall((agente(Ag2), puntosTotales(Ag2, P2), Ag2\=Agente), Puntos > P2).
