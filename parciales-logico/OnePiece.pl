% Relaciona Pirata con Tripulacion
tripulante(luffy, sombreroDePaja).
tripulante(zoro, sombreroDePaja).
tripulante(nami, sombreroDePaja).
tripulante(ussop, sombreroDePaja).
tripulante(sanji, sombreroDePaja).
tripulante(chopper, sombreroDePaja).

tripulante(law, heart).
tripulante(bepo, heart).

tripulante(arlong, piratasDeArlong).
tripulante(hatchan, piratasDeArlong).

% Relaciona Pirata, Evento y Monto
impactoEnRecompensa(luffy, arlongPark, 30000000).
impactoEnRecompensa(luffy,baroqueWorks, 70000000).
impactoEnRecompensa(luffy,eniesLobby, 200000000).
impactoEnRecompensa(luffy, marineford, 100000000).
impactoEnRecompensa(luffy, dressrosa, 100000000).
impactoEnRecompensa(zoro, baroqueWorks, 60000000).
impactoEnRecompensa(zoro, eniesLobby, 60000000).
impactoEnRecompensa(zoro, dressrosa, 200000000).
impactoEnRecompensa(nami, eniesLobby, 16000000).
impactoEnRecompensa(nami, dressrosa, 50000000).
impactoEnRecompensa(ussop, eniesLobby, 30000000).
impactoEnRecompensa(ussop, dressrosa, 170000000).
impactoEnRecompensa(sanji, eniesLobby, 77000000).
impactoEnRecompensa(sanji, dressrosa, 100000000).
impactoEnRecompensa(chopper, eniesLobby, 50).
impactoEnRecompensa(chopper, dressrosa, 100).
impactoEnRecompensa(law, sabaody, 200000000).
impactoEnRecompensa(law, descorazonamientoMasivo,240000000).
impactoEnRecompensa(law, dressrosa, 60000000).
impactoEnRecompensa(bepo,sabaody,500).
impactoEnRecompensa(arlong, llegadaAEastBlue, 20000000).
impactoEnRecompensa(hatchan, llegadaAEastBlue, 3000).

% 1. Relacionar a dos tripulaciones y un evento si ambas participaron del mismo, lo cual sucede si dicho evento impactó 
% en la recompensa de al menos un pirata de cada tripulación.
estuvoEn(Tripulacion, Evento):-
    tripulante(Alguien, Tripulacion),
    impactoEnRecompensa(Alguien, Evento, _).

participaron(Tripulacion, OtraTrip, Evento):-
    estuvoEn(Tripulacion, Evento),
    estuvoEn(OtraTrip, Evento),
    Tripulacion \= OtraTrip.

% 2. Saber quién fue el pirata que más se destacó en un evento, en base al impacto que haya tenido su recompensa.
seDestacoMas(Pirata, Evento):-
    impactoEnRecompensa(Pirata, Evento, Recompensa),
    forall((impactoEnRecompensa(OtroPirata, Evento, Rec),  OtroPirata \= Pirata), (Rec < Recompensa)).

% 3. Saber si un pirata pasó desapercibido en un evento, que se cumple si su recompensa no se vio impactada por dicho 
% evento a pesar de que su tripulación participó del mismo.
pasoDesapercibido(Pirata, Evento):-
    tripulante(Pirata, Tripulacion),
    estuvoEn(Tripulacion, Evento),
    not(impactoEnRecompensa(Pirata, Evento, _)).

% 4. Saber cuál es la recompensa total de una tripulación, que es la suma de las recompensas actuales de sus miembros.
recompensaPirataTotal(Pirata, Recompensa):-
    tripulante(Pirata, _),
    findall(Rec, impactoEnRecompensa(Pirata, _, Rec), Lista),
    sum_list(Lista, Recompensa).

recompensaTripulacionTotal(Tripulacion, RecTotal):-
    tripulante(_, Tripulacion),
    findall(Rec, (tripulante(Pirata, Tripulacion), recompensaPirataTotal(Pirata, Rec)), Lista),
    sum_list(Lista, RecTotal).

% 5. Saber si una tripulación es temible. Lo es si todos sus integrantes son peligrosos o si la recompensa total de la 
% tripulación supera los $500.000.000. Consideramos peligrosos a piratas cuya recompensa actual supere los $100.000.000.

tripulacionPeligrosa(Tripulacion):-
    tripulante(_, Tripulacion),
    forall(tripulante(Pirata, Tripulacion), pirataPeligroso(Pirata)).

tripulacionPeligrosa(Tripulacion):-
    recompensaTripulacionTotal(Tripulacion, RecTotal),
    RecTotal > 500000000.

%%%%%%%%%%%
% PARTE 2 %
%%%%%%%%%%%

especieFeroz(lobo).
especieFeroz(leopardo).
especieFeroz(anaconda).
% paramecia(peligrosa/noPeligrosa).
% zoan(Animal). 
% logia(ElementoNatural). %todas peligrosas
% comioFruta(Quien, TipoFruta).

comioFruta(luffy, paramecia(noPeligrosa)).
comioFruta(buggy, paramecia(noPeligrosa)).
comioFruta(law, paramecia(peligrosa)).
comioFruta(chopper, zoan(humano)).
comioFruta(lucci, zoan(leopardo)).
comioFruta(smoker, logia(humo)).

% 6A. Necesitamos modificar la funcionalidad anterior, porque ahora hay otra forma en la cual una persona puede 
% considerarse peligrosa: alguien que comió una fruta peligrosa se considera peligroso, independientemente de cuál 
% sea el precio sobre su cabeza.
frutaPeligrosa(logia(_)).
frutaPeligrosa(paramecia(peligrosa)).
frutaPeligrosa(zoan(Especie)):-
    especieFeroz(Especie).

pirataPeligroso(Pirata):-
    recompensaPirataTotal(Pirata, Total),
    Total > 100000000.
pirataPeligroso(Alguien):-
    comioFruta(Alguien, Fruta),
    frutaPeligrosa(Fruta).

% 6B. decidi usar functores para modelar los tipos de fruta y asi poder analizar la peligrosidad de cada una 
% independientemente de las demas. Para registrar quien comio qué, no guarde los nombres de las frutas sino solo el tipo
% ya que era info extra.

% 7. Saber si una tripulación es de piratas de asfalto, que se cumple si ninguno de sus miembros puede nadar.
tripulacionDeAsfalto(Tripulacion):-
    tripulante(_, Tripulacion),
    forall(tripulante(Pirata, Tripulacion), comioFruta(Pirata, _)).