jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).

persona(Persona):-
    jugador(Persona, _,_).

% 1) Jugando con los ítems 
% a. Relacionar un jugador con un ítem que posee. tieneItem/2
tieneItem(Persona, Item):-
    jugador(Persona, Lista, _),
    member(Item, Lista).
% b. Saber si un jugador se preocupa por su salud, esto es si tiene entre sus ítems más de un tipo de comestible. 
% (Tratar de resolver sin findall) sePreocupaPorSuSalud/1
tieneItemComestible(Persona, Elem):-
    tieneItem(Persona, Elem),
    comestible(Elem).
sePreocupaPorSuSalud(Persona):-
    persona(Persona),
    tieneItemComestible(Persona, Comida1),
    tieneItemComestible(Persona, Comida2),
    Comida1\=Comida2.
% c. Relacionar un jugador con un ítem que existe (un ítem existe si lo tiene alguien), y la cantidad que tiene de ese ítem. 
% Si no posee el ítem, la cantidad es 0. cantidadDeItem/3
existe(Item):-
    tieneItem(_, Item).

cantidadDeItem(Persona, Item, 0):-
    jugador(Persona, _,_),
    existe(Item),
    not(tieneItem(Persona, Item)).

cantidadDeItem(Persona, Item, Cantidad):-
    jugador(Persona, _,_),
    existe(Item),
    findall(Item, tieneItem(Persona, Item), Veces),
    length(Veces, Cantidad).
% d. Relacionar un jugador con un ítem, si de entre todos los jugadores, es el que más cantidad tiene de ese ítem. tieneMasDe/2
tieneMasDe(Persona, Item):-
    cantidadDeItem(Persona, Item, Cantidad),
    forall((persona(OtraPersona), cantidadDeItem(OtraPersona, Item, Cantidad2), Persona \= OtraPersona), Cantidad > Cantidad2).

% 2) Alejarse de la oscuridad 
% a. Obtener los lugares en los que hay monstruos. Se sabe que los monstruos aparecen en los lugares cuyo nivel de oscuridad es más de 6. 
% hayMonstruos/1
hayMonstruos(Lugar):-
    lugar(Lugar, _, Oscuridad),
    Oscuridad > 6.
% b. Saber si un jugador corre peligro. Un jugador corre peligro si se encuentra en un lugar donde hay monstruos; o si está hambriento 
% (hambre < 4) y no cuenta con ítems comestibles. correPeligro/1
hambriento(Persona):-
    jugador(Persona, _, Hambre),
    Hambre > 4.
correPeligro(Persona):-
    persona(Persona),
    lugar(Lugar, Jugadores, _),
    hayMonstruos(Lugar),
    member(Persona, Jugadores).

correPeligro(Persona):-
    hambriento(Persona),
    not(tieneItemComestible(Persona, _)).
% c. Obtener el nivel de peligrosidad de un lugar, el cual es un número de 0 a 100 y se calcula:
% - Si no hay monstruos, es el porcentaje de hambrientos sobre su población total.
nivelPeligrosidad(Lugar, Nivel):-
    lugar(Lugar, Personas, _),
    not(hayMonstruos(Lugar)),
    findall(Hambriento, (member(Hambriento, Personas), hambriento(Hambriento)), ListaHambrientos),
    length(ListaHambrientos, CantidadHambrientos),
    length(Personas, CantidadPersonas),
    CantidadPersonas \= 0,
    Nivel is (CantidadHambrientos * 100) / CantidadPersonas.
% - Si hay monstruos, es 100.
nivelPeligrosidad(Lugar, 100):-
    hayMonstruos(Lugar).
% - Si el lugar no está poblado, sin importar la presencia de monstruos, es su nivel de oscuridad * 10. 
nivelPeligrosidad(Lugar, Nivel):-
    lugar(Lugar, Personas, Oscuridad),
    length(Personas, 0),
    Nivel is Oscuridad * 10.


% El aspecto más popular del juego es la construcción. Se pueden construir nuevos ítems a partir de otros, cada uno tiene ciertos requisitos 
% para poder construirse:
% - Puede requerir una cierta cantidad de un ítem simple, que es aquel que el jugador tiene o puede recolectar. Por ejemplo, 8 unidades de piedra.
% - Puede requerir un ítem compuesto, que se debe construir a partir de otros (una única unidad).
% Con la siguiente información, se pide relacionar un jugador con un ítem que puede construir. puedeConstruir/2

item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).


tieneMaterial(Jugador, itemSimple(Item, Cant)):-
    cantidadDeItem(Jugador, Item, Cantidad),
    Cantidad >= Cant.

tieneMaterial(Jugador, itemCompuesto(Item)):-
    puedeConstruir(Jugador, Item).

puedeConstruir(Jugador, Item):-
    persona(Jugador),
    item(Item, ListaMateriales),
    forall(member(Material, ListaMateriales), tieneMaterial(Jugador, Material)).
