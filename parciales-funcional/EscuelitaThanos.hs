module EscuelitaThanos where

type Habilidades = [String]

data Personaje = Personaje {
  eda :: Int, 
  energia :: Int,
  habilidades :: Habilidades,
  nombre :: String,
  planeta :: String
} deriving (Show, Eq)

type Gema =  Personaje -> Personaje

data Guantelete = Guantelete {
  material :: String,
  gemas :: [Gema]
} 

data Universo = Universo {
  habitantes :: [Personaje]
} deriving (Show, Eq)

ironwoman = Personaje 59 300 ["controlar", "otras"] "iron woman" "tierra"
spiderwoman = Personaje 58 500 [] "spider woman" "otro"
drStrange = Personaje 29 1000 [] "Dr Strange" "tierra"
universo = Universo [ironwoman, spiderwoman, drStrange]

guanteCompleto :: Guantelete -> Bool
guanteCompleto g = esDeUru && tiene6Gemas
  where 
    esDeUru = material g == "uru"
    tiene6Gemas =  length (gemas g) == 6

primerosNelem :: Int -> [Personaje] -> [Personaje]
primerosNelem n array 
    | length array == n = array
    | otherwise = primerosNelem n (init array)

-- reducirMitad :: Universo -> Universo
-- reducirMitad universo = take (length universo `div` 2) universo 

chasquidoUniverso :: Guantelete -> Universo -> Universo
chasquidoUniverso g u 
  | guanteCompleto g = Universo ( primerosNelem nro (habitantes u) )
  | otherwise = u
  where 
      nro = length (habitantes u) `div` 2

aptoParaPendex :: Universo -> Bool
aptoParaPendex u = length pendex > 0
    where
        edades = map eda (habitantes u)
        pendex = filter (<45) edades

energiaTotalUniverso :: Universo -> Int
energiaTotalUniverso u = sum energiaPersonajesHabilidosos
    where
        energiaPersonajesHabilidosos = map energia (filter ((>1). length . habilidades) (habitantes u))

-- Segunda Parte

quitarEnergia :: Int -> Gema
quitarEnergia x enemigo = enemigo {
    energia = (energia enemigo) - x 
}

quitarHabilidad :: String -> Gema
quitarHabilidad x enemigo = enemigo {
    habilidades = filter (/= x) (habilidades enemigo)
}
cambiarPlaneta :: String -> Gema
cambiarPlaneta x enemigo = enemigo {
    planeta = x
}

gemaMente :: Int -> Gema
gemaMente = quitarEnergia

gemaAlma :: String -> Gema
gemaAlma hab = (quitarHabilidad hab) . (quitarEnergia 10)

gemaEspacio ::  String -> Gema
gemaEspacio planeta = (cambiarPlaneta planeta) . (quitarEnergia 20)

evaluarHabilidades:: Habilidades -> Habilidades
evaluarHabilidades hab 
    | length hab > 2 = hab
    | otherwise = []

gemaPoder :: Gema
gemaPoder enemigo = enemigo {
    energia = 0,
    habilidades = evaluarHabilidades (habilidades enemigo)
}

calcularEdad :: Int -> Int
calcularEdad nro
    | nro `div` 2 < 18 = 18
    | otherwise = nro `div` 2

gemaTiempo :: Gema
gemaTiempo enemigo = enemigo {
    eda = calcularEdad (eda enemigo)
}

gemaLoca :: Gema -> Gema
gemaLoca gema = gema . gema

guanteEjemplo = Guantelete "goma" [gemaTiempo,(gemaAlma "usar mjolnir"), (gemaLoca (gemaAlma "programacion"))]

utilizar :: [Gema] -> Personaje -> Personaje
utilizar gemas enemigo = foldr ($) enemigo $ gemas 

calcularPerdidaEnergia :: Personaje -> Personaje -> Int
calcularPerdidaEnergia personajev1 personajev2 = (energia personajev1) - (energia personajev2)

-- aplicar :: Personaje -> Gema -> Personaje
-- aplicar personaje gema = gema personaje

-- versionesPersonajeGemas :: [Gema] -> Personaje -> [Personaje]
-- versionesPersonajeGemas gemas personaje = map (flip aplicar personaje) gemas

-- gemaMasPoderosa :: Guantelete -> Personaje -> Gema
-- gemaMasPoderosa guante enemigo = 
