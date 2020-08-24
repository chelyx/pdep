herramienta(ana, circulo(50,3)).
herramienta(ana, cuchara(40)).
herramienta(beto, circulo(20,1)).
herramienta(beto, libro(inerte)).
herramienta(cata, libro(vida)).
herramienta(cata, circulo(100,5)).
% Los círculos alquímicos tienen diámetro en cms y cantidad de niveles.
% Las cucharas tienen una longitud en cms.
% Hay distintos tipos de libro.

% 1. Modelar los jugadores y elementos y agregarlos a la base de conocimiento, utilizando los ejemplos provistos.
% Ana tiene agua, vapor, tierra y hierro. Beto tiene lo mismo que Ana. Cata tiene fuego, tierra, agua y aire, 
% pero no tiene vapor. 
tieneElemento(ana, agua).
tieneElemento(ana, vapor).
tieneElemento(ana, tierra).
tieneElemento(ana, hierro).
tieneElemento(beto, Elemento):- tieneElemento(ana, Elemento).
tieneElemento(cata, agua).
tieneElemento(cata, tierra).
tieneElemento(cata, fuego).
tieneElemento(cata, aire).
% Para construir pasto hace falta agua y tierra, para construir hierro hace falta fuego, agua y tierra, y 
% para hacer huesos hace falta pasto y agua. Para hacer presión hace falta hierro y vapor (que se construye 
% con agua y fuego).
% Por último, para hacer una play station hace falta silicio (que se construye sólo con tierra), hierro y 
% plástico (que se construye con huesos y presión).

construir(pasto, [agua, tierra]).
construir(hierro, [fuego, agua, tierra]).
construir(hueso, [pasto, agua]).
construir(presion, [hierro, vapor]).
construir(vapor, [agua, fuego]).
construir(playStation, [silicio,hierro, plastico]).
construir(plastico, [huesos, presion]).
construir(silicio, [tierra]).

% 2. Saber si un jugador tieneIngredientesPara construir un elemento, que es cuando tiene ahora en su inventario todo lo que hace falta.
tieneIngredientesPara(Jugador, Elemento):-
    % ingredientesBase(Elemento, ListaIng),
    construir(Elemento, ListaIng),
    tieneElemento(Jugador, _),
    forall(member(Ing, ListaIng), tieneElemento(Jugador, Ing)).

% ingredientesBase(Elemento, Lista):-
%     construir(Elemento, Lista),
%     not((member(Elemento, Lista), construir(Elemento, _))).
% ingredientesBase(Elemento, Lista):-
%     construir(Elemento, Lista),
%     forall(member(El, Lista), contruir())

% 3. Saber si un elemento estaVivo. Se sabe que el agua, el fuego y todo lo que fue construido a partir de ellos, están vivos. 
% Debe funcionar para cualquier nivel.

estaVivo(agua).
estaVivo(fuego).
estaVivo(Elemento):-
    construir(Elemento, Lista),
    member(Base, Lista),
    estaVivo(Base).

% 4. Conocer las personas que puedeConstruir un elemento, para lo que se necesita tener los ingredientes ahora en el inventario y
% además contar con una o más herramientas que sirvan para construirlo. Para los elementos vivos sirve el libro de la vida (y para los 
% elementos no vivos el libro inerte). Además, las cucharas y círculos sirven cuando soportan la cantidad de ingredientes del elemento 
% (las cucharas soportan tantos ingredientes como centímetros de longitud/10, y los círculos alquímicos soportan tantos ingredientes como 
% metros de diámetro * cantidad de niveles).
herramientaRequerida(Elemento, libro(vida)):-
    estaVivo(Elemento).

herramientaRequerida(Elemento, libro(inerte)):-
    not(estaVivo(Elemento)).

herramientaRequerida(Elemento, cuchara(Longitud)):-
    herramienta(_, cuchara(Longitud)),
    findall(E, construir(Elemento, E), Lista),
    length(Lista, Int),
    Int < Longitud / 10.
herramientaRequerida(Elemento, circulo(Diam, Niveles)):-
    herramienta(_, circulo(Diam, Niveles)),
    findall(E, construir(Elemento, E), Lista),
    length(Lista, Int),
    Int < Diam * Niveles.

puedeConstruir(Jugador, Elemento):-
    tieneIngredientesPara(Jugador, Elemento),
    forall(herramientaRequerida(Elemento, Herramienta),
    herramienta(Jugador, Herramienta)).