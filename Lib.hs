{-
Nombre: Araceli Soffulto
Legajo: 167.315-4
-}

module Lib where
import Text.Show.Functions

----------------------
-- Código inicial
----------------------

maximoSegun :: Ord a => (b -> a) -> [b] -> b
maximoSegun f = foldl1 (mayorSegun f)

mayorSegun :: Ord a => (p -> a) -> p -> p -> p
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

-- Esto inicialmente es esperable que no compile
-- porque no existen los tipos Rol y Participante.
-- Definilos en el punto 1a
data Desafio = Desafio {
    rolesDisponibles :: [Rol],
    pruebaASuperar :: Participante -> Bool
  }

----------------------------------------------
-- Definí tus tipos de datos y funciones aquí
-- indicando a qué punto pertenecen
----------------------------------------------

-- Punto 1a
data Participante = Participante {
  nombre :: String,
  experiencia :: Int,
  inteligencia :: Int,
  destrezaFisica :: Int,
  rol :: Rol
} deriving (Show)

type Aptitud = Participante -> Int
type PotenciaArma = Int
data Rol = Rol {
  tipo :: String,
  aptitud :: Aptitud
} deriving (Show)

indeterminado :: Aptitud
indeterminado participante = inteligencia participante + destrezaFisica participante

soporte :: Aptitud
soporte participante = inteligencia participante * 7 + experiencia participante

primeraLinea :: Int -> Aptitud
primeraLinea potencia participante = (destrezaFisica participante + potencia) * (experiencia participante `div` 100)

rolIndeterminado :: Rol 
rolIndeterminado = Rol {
  tipo = "Indeterminado",
  aptitud = indeterminado
}

rolSoporte :: Rol
rolSoporte = Rol {
  tipo = "Soporte",
  aptitud = soporte
}

rolPrimeraLinea :: PotenciaArma -> Rol
rolPrimeraLinea potenciaArma = Rol {
  tipo = "Primera Linea",
  aptitud = primeraLinea potenciaArma 
}

-- Punto 1b
participanteEjemplo :: Participante
participanteEjemplo = Participante {
  nombre = "Araceli",
  experiencia = 10,
  inteligencia = 20,
  destrezaFisica = 12,
  rol = rolIndeterminado
}

-- Punto 1c
calcularAptitudParaRol :: Rol -> Aptitud
calcularAptitudParaRol rol participante = aptitud rol $ participante

poder :: Participante -> Int
poder participante = aptitud * exp
  where
    aptitud = calcularAptitudParaRol (rol participante) participante
    exp = experiencia participante

-- Punto 1d
saltar :: Aptitud
saltar participante = destrezaFisica participante * 50 + experiencia participante

rolSaltar :: Rol
rolSaltar = Rol {
  tipo = "saltar",
  aptitud = saltar
}
-- No tuve que modificar nada en lo que ya tenia porque cada Rol se crea a partir de la aptitud que lo
-- define, y son independientes unos de otros. 

-----
-- maximoSegun :: Ord a => (b -> a) -> [b] -> b
-- maximoSegun f = foldl1 (mayorSegun f)

-- mayorSegun :: Ord a => (p -> a) -> p -> p -> p
-- mayorSegun f a b
--   | f a > f b = a
--   | otherwise = b
-------

-- Punto 2

rolMasApto :: Participante -> [Rol] -> Rol
rolMasApto participante roles = maximoSegun (flip calcularAptitudParaRol participante) roles

reemplazarPorMejorRol :: Participante -> [Rol] -> Participante
reemplazarPorMejorRol participante roles = participante {
  rol = rolMasApto participante roles
}

rolesEjemplo = [rolIndeterminado, (rolPrimeraLinea 20), rolSoporte, rolSaltar]

-- Punto 3a
participantes = [participanteEjemplo, participante2, participante3]
participante2 = Participante {
  nombre = "Juan",
  experiencia = 20,
  inteligencia = 10,
  destrezaFisica = 2,
  rol = rolSaltar
}
participante3 = Participante {
  nombre = "Agustin",
  experiencia = 0,
  inteligencia = 30,
  destrezaFisica = 50,
  rol = rolSoporte
}

perteneceAlGrupo :: [Participante] -> Participante ->  Bool
perteneceAlGrupo grupo participante  = elem (nombre participante) todosLosNombres  
  where
    todosLosNombres = map nombre grupo

-- Punto 3b
experienciaPerdedores :: [Participante] -> Int
experienciaPerdedores perdedores = sum . map (experiencia) $ perdedores

traerPerdedores :: [Participante] -> [Participante] -> [Participante]
traerPerdedores ganadores todos = filter (not.perteneceAlGrupo ganadores) todos

experienciaAGanar :: [Participante] -> [Participante] -> Int
experienciaAGanar ganadores todos = (+100) . div (experienciaPerdedores perdedores) . length $ ganadores
  where
    perdedores = traerPerdedores ganadores todos

-- Punto 3c
sumarExperiencia :: Int -> Participante -> Participante
sumarExperiencia expGanada participante = participante { experiencia = experiencia participante + expGanada}

repartirExperiencia :: [Participante] -> [Participante] -> [Participante]
repartirExperiencia ganadores todos = ganadoresExperimentados
  where
    experienciaGanada = experienciaAGanar ganadores todos
    ganadoresExperimentados = map (sumarExperiencia experienciaGanada) ganadores

-- Punto 4a
mejorarRolesGrupo :: [Rol] -> [Participante] -> [Participante]
mejorarRolesGrupo roles grupo = map (flip reemplazarPorMejorRol roles) grupo

enfrentarDesafio :: Desafio -> [Participante] ->  [Participante]
enfrentarDesafio desafio grupo  = repartirExperiencia ganadores grupo
  where
    grupoMejorado = mejorarRolesGrupo (rolesDisponibles desafio) grupo
    ganadores = filter (pruebaASuperar desafio) grupoMejorado

-- Punto 4b
-- Consulta para saber si alguno de los ganadores de un desafío tiene más de 1000 puntos de experiencia.
--      any (==True ) . map ((>1000). experiencia) $ (repartirExperiencia ganadores participantes)
-- Saber quién es el más poderoso de aquellos que hayan ganado un desafío
--      maximoSegun (poder) (repartirExperiencia ganadores participantes)

-- Punto 4c
-- Para la primer consulta, se podrian evaluar listas infinitas ya que el any funciona como
-- un OR y Haskell adopta la evaluacion lazy. Es decir, que ante el primer True que aparezca,
-- como sabe que (True || cualquier cosa = True ) devuelve True.
-- En cambio, para la segunda consulta quiere conocer el maximo absoluto de todos los elementos de la lista,
-- y no puede asumir nada respecto a los que todavia no evaluo. Por lo tanto, para esta consulta no se 
-- completaria.

-- Punto 5
type Torneo = [Desafio]

enfrentarTorneo :: [Participante] -> Torneo -> [Participante]
enfrentarTorneo participantes torneo = foldr enfrentarDesafio participantes torneo

