personaje(pumkin, ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent, mafioso(maton)).
personaje(jules, mafioso(maton)).
personaje(marsellus, mafioso(capo)).
personaje(winston, mafioso(resuelveProblemas)).
personaje(mia, actriz([foxForceFive])).
personaje(butch, boxeador).

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

duoTemible(PersonajeA, PersonajeB):-
    sonPeligrosos(PersonajeA, PersonajeB),
    sonPareja(PersonajeA, PersonajeB).

duoTemible(PersonajeA, PersonajeB):-
    sonPeligrosos(PersonajeA, PersonajeB),
    sonAmigos(PersonajeA, PersonajeB).

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
    personaje(Personaje, _),
    loTieneCerca(Personaje, _),
    forall(loTieneCerca(Personaje, Cercano), encargo(Personaje, Cercano, _)).