module MiniGolfito where
-- Modelo inicial
data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

-- Jugadores de ejemplo
bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
  velocidad :: Int,
  precision :: Int,
  altura :: Int
} deriving (Eq, Show)

type Puntos = Int

-- Funciones útiles
between n m x = elem x [n .. m]

maximoSegun f = foldl1 (mayorSegun f)
mayorSegun f a b
  | f a > f b = a
  | otherwise = b
-- PUNTO 1

type PaloDeGolf = Habilidad -> Tiro

paloPutter :: PaloDeGolf
paloPutter habilidad = UnTiro 10 ((precisionJugador habilidad)*2) 0

paloMadera :: PaloDeGolf
paloMadera habilidad = UnTiro 100 ((precisionJugador habilidad) `div` 2) 5

paloHierros :: Int -> PaloDeGolf
paloHierros n habilidad = UnTiro {
  velocidad = n * (fuerzaJugador habilidad),
  precision = (precisionJugador habilidad) `div` n,
  altura = max 0 (n - 3)
}

palos = [paloPutter, paloMadera] ++ map paloHierros [1..10]

-- PUNTO 2
golpe :: Jugador -> PaloDeGolf -> Tiro
golpe jugador palo = palo (habilidad jugador)

-- PUNTO 3
type Supera = Tiro -> Bool
type Efecto = Tiro -> Tiro
rasDelSuelo tiro = (altura tiro) == 0
tiroEnCero = UnTiro 0 0 0

superaRampita :: Supera 
superaRampita tiro =  (precision tiro) > 90 && (rasDelSuelo tiro)

efectoRampita :: Efecto
efectoRampita tiro = UnTiro (vel*2) 100 0
  where
    vel = velocidad tiro

superaLaguna :: Supera
superaLaguna tiro = (velocidad tiro) > 80 && between 1 5 (altura tiro)

efectoLaguna :: Int -> Efecto
efectoLaguna largo tiro = tiro {altura = nuevaAltura}
  where
    nuevaAltura = (altura tiro) `div` largo

superaHoyo :: Supera
superaHoyo tiro = between 5 20 (velocidad tiro) && (rasDelSuelo tiro) && (precision tiro) > 95

efectoHoyo :: Efecto
efectoHoyo _ = tiroEnCero

data Obstaculo = Obstaculo {
  condicion :: Supera,
  efecto :: Efecto
}

rampa :: Obstaculo
rampa = Obstaculo superaRampita efectoRampita

hoyo :: Obstaculo
hoyo = Obstaculo superaHoyo efectoHoyo

laguna :: Int -> Obstaculo
laguna largo = Obstaculo superaLaguna (efectoLaguna largo)

intentarObstaculo :: Tiro -> Obstaculo -> Tiro
intentarObstaculo tiro obstaculo 
  | (condicion obstaculo) tiro = (efecto obstaculo) tiro
  | otherwise = tiroEnCero

--PUNTO 4
-- A)
leSirve :: Jugador -> Obstaculo -> PaloDeGolf -> Bool
leSirve j o p = (condicion o) (golpe j p)

palosUtiles :: Jugador -> Obstaculo -> [PaloDeGolf]
palosUtiles jugador obstaculo = filter (leSirve jugador obstaculo)  palos
-- b)
cuantosPuedeSuperar :: Tiro -> [Obstaculo] -> Int
cuantosPuedeSuperar _ [] = 0
cuantosPuedeSuperar tiro array
  | (intentarObstaculo tiro obs) == tiroEnCero = 0
  | otherwise = 1 + (cuantosPuedeSuperar tiro restoObs)
  where
    obs = head array
    restoObs = tail array

tej = UnTiro 10 95  0
obs = [rampa, rampa, hoyo]


---BONUS
tiroNoEsCero :: Tiro -> Bool
tiroNoEsCero tiro = tiro /= tiroEnCero 

obtenerTiros :: Tiro -> [Obstaculo] -> [Tiro]
obtenerTiros _ [] = []
obtenerTiros t array = tiroResultado : obtenerTiros tiroResultado (tail array)
  where 
    tiroResultado = intentarObstaculo t (head array)

cuantosPuedeSuperar' :: Tiro -> [Obstaculo] -> Int
cuantosPuedeSuperar' tiro array = length . takeWhile (tiroNoEsCero) . (obtenerTiros tiro) $ array

-- c)
-- eliminarCeros ::  [(PaloDeGolf, Int)] ->  [(PaloDeGolf, Int)]
-- eliminarCeros [] = []
-- eliminarCeros tuplas
--   | snd (head tuplas) == 0 = eliminarCeros (tail tuplas)
--   | otherwise = head tuplas : eliminarCeros (tail tuplas)

-- armarTuplas :: Jugador -> [Obstaculo] -> [(PaloDeGolf, Int)]
-- armarTuplas jugador obstaculos = zip palos cuantoSuperaCadaUno
--   where
--     tirosIniciales = map (golpe jugador) palos
--     cuantoSuperaCadaUno = map (flip cuantosPuedeSuperar obstaculos) tirosIniciales

-- paloMasUtil :: Jugador -> [Obstaculo] -> PaloDeGolf
-- paloMasUtil player obst =  fst (mayorSegun snd palosQueSirven)
--   where
--     palosQueSirven = eliminarCeros (armarTuplas player obst)

paloMasUtil' :: Jugador -> [Obstaculo] -> PaloDeGolf
paloMasUtil' jugador obstaculos
  = maximoSegun (flip cuantosPuedeSuperar obstaculos.golpe jugador) palos

padresPerdedores :: [(Jugador, Int)] -> [String]
padresPerdedores listaJugadores = (map padre) . (map fst) . (filter (/= ganador listaJugadores)) $ listaJugadores

ganador :: [(Jugador, Int)] -> (Jugador, Int)
ganador lista = maximoSegun snd lista
