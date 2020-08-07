personaje(pumkin, ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent, mafioso(maton)).
personaje(jules, mafioso(maton)).
personaje(marsellus, mafioso(capo)).
personaje(winston, mafioso(resuelveProblemas)).
personaje(mia, actriz([foxForceFive])).
personaje(butch, boxeador).

nombre(Personaje):-
    personaje(Personaje, _).

pareja(marsellus, mia).
pareja(pumkin, honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

% 1. esPeligroso/1. Nos dice si un personaje es peligroso. Eso ocurre cuando:
% realiza alguna actividad peligrosa: ser matón, o robar licorerías. O tiene empleados peligrosos
actividadPeligrosa(mafioso(maton)).
actividadPeligrosa(ladron(Lista)):-
    member(licorerias, Lista).

esPeligroso(Nombre):-
    personaje(Nombre, Actividad),
    actividadPeligrosa(Actividad).

esPeligroso(Nombre):-
    trabajaPara(Nombre, Peligroso),
    esPeligroso(Peligroso).

% 2. duoTemible/2 que relaciona dos personajes cuando son peligrosos y además son pareja o amigos. 
% Considerar que Tarantino también nos dió los siguientes hechos:
amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

sonPareja(PersonajeA, PersonajeB):-
    pareja(PersonajeA, PersonajeB); pareja(PersonajeB, PersonajeA).

sonAmigos(PersonajeA, PersonajeB):-
    amigo(PersonajeA, PersonajeB); amigo(PersonajeB, PersonajeA).

sonPeligrosos(PersonajeA, PersonajeB):-
    esPeligroso(PersonajeA),
    esPeligroso(PersonajeB),
    PersonajeA \= PersonajeB.

sonDuo(PersonajeA, PersonajeB):-
sonPareja(PersonajeA, PersonajeB); sonAmigos(PersonajeA, PersonajeB).

duoTemible(PersonajeA, PersonajeB):-
    sonPeligrosos(PersonajeA, PersonajeB),
    sonDuo(PersonajeA, PersonajeB).

% 3.  estaEnProblemas/1: un personaje está en problemas cuando 
% el jefe es peligroso y le encarga que cuide a su pareja o bien, tiene que ir a buscar a un boxeador. 
% Además butch siempre está en problemas.
% encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).
encargo(marsellus, vincent, buscar(alguien, losAngeles)).

estaEnProblemas(butch).
estaEnProblemas(Personaje):-
    trabajaPara(Jefe, Personaje),
    esPeligroso(Jefe),
    encargo(Jefe, Personaje, cuidar(Pareja)),
    sonPareja(Jefe, Pareja).

estaEnProblemas(Personaje):-
    encargo(_, Personaje, buscar(Boxeador, _)),
    personaje(Boxeador, boxeador).

% 4.  sanCayetano/1:  es quien a todos los que tiene cerca les da trabajo (algún encargo). 
% Alguien tiene cerca a otro personaje si es su amigo o empleado. 
loTieneCerca(Uno, Otro):-
    sonAmigos(Uno, Otro); trabajaPara(Uno, Otro).

sanCayetano(Personaje):-
    nombre(Personaje),
    loTieneCerca(Personaje, _),
    forall(loTieneCerca(Personaje, Cercano), encargo(Personaje, Cercano, _)).

% 5. masAtareado/1. Es el más atareado aquel que tenga más encargos que cualquier otro personaje
encargosTotales(Personaje, Cantidad):-
    findall(C, encargo(_, Personaje, C), Lista),
    length(Lista, Cantidad).

masAtareado(Personaje):-
    nombre(Personaje),
    encargosTotales(Personaje, Cantidad),
    forall((nombre(Otro), Otro \= Personaje, encargosTotales(Otro, Cant2)), Cantidad > Cant2).

% 6. personajesRespetables/1: genera la lista de todos los personajes respetables. 
% Es respetable cuando su actividad tiene un nivel de respeto mayor a 9. Se sabe que:
% Las actrices tienen un nivel de respeto de la décima parte de su cantidad de peliculas.
nivelRespeto(Personaje, Nivel):-
    personaje(Personaje, actriz(Peliculas)),
    length(Peliculas, Cantidad),
    Nivel is div(Cantidad, 10).
% Los mafiosos que resuelven problemas tienen un nivel de 10 de respeto, los matones 1 y los capos 20.
nivelRespeto(Personaje, 10):-
    personaje(Personaje, mafioso(resuelveProblemas)).
nivelRespeto(Personaje, 1):-
    personaje(Personaje, mafioso(maton)).
nivelRespeto(Personaje, 20):-
    personaje(Personaje, mafioso(capo)).
% Al resto no se les debe ningún nivel de respeto. 

personajesRespetables(Lista):-
    findall(P, (nivelRespeto(P, Nivel), Nivel > 9), Lista).

% 7. hartoDe/2: un personaje está harto de otro, cuando todas las tareas asignadas al primero requieren 
% interactuar con el segundo (cuidar, buscar o ayudar) o un amigo del segundo.
interactuan(Otro, cuidar(Otro)).
interactuan(Otro, ayudar(Otro)).
interactuan(Otro, buscar(Otro, _)).
interactuan(Otro, cuidar(Amigo)):-
    sonAmigos(Otro, Amigo).
interactuan(Otro, ayudar(Amigo)):-
    sonAmigos(Otro, Amigo).
interactuan(Otro, buscar(Amigo, _)):-
    sonAmigos(Otro, Amigo).

hartoDe(Personaje, Otro):-
    nombre(Personaje),
    nombre(Otro),
    Otro \= Personaje,
    encargo(_, Personaje, _),
    forall(encargo(_, Personaje, Tarea), interactuan(Otro, Tarea)).

% Desarrollar duoDiferenciable/2, que relaciona a un dúo (dos amigos o una pareja) 
% en el que uno tiene al menos una característica que el otro no
caracteristicas(vincent,  [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,    [tieneCabeza, muchoPelo]).
caracteristicas(marvin,   [negro]).

duoDiferenciable(Uno, Otro):-
    sonDuo(Uno, Otro),
    caracteristicas(Uno, Lista1),
    caracteristicas(Otro, Lista2),
    member(Caract, Lista1),
    not(member(Caract, Lista2)).
