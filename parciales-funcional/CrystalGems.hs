module CrystalGems where
-- Modelo Inicial
data Aspecto = UnAspecto {
  tipoDeAspecto :: String,
  grado :: Float
} deriving (Show, Eq)

type Situacion = [Aspecto]

mejorAspecto mejor peor = grado mejor < grado peor
mismoAspecto aspecto1 aspecto2 = tipoDeAspecto aspecto1 == tipoDeAspecto aspecto2
buscarAspecto aspectoBuscado = head.filter (mismoAspecto aspectoBuscado)
buscarAspectoDeTipo tipo = buscarAspecto (UnAspecto tipo 0)
reemplazarAspecto aspectoBuscado situacion =
    aspectoBuscado : (filter (not.mismoAspecto aspectoBuscado) situacion)

-- Trabajando con Situaciones: 
-- Definir modificarAspecto que dada una función de tipo (Float -> Float) y un aspecto, 
-- modifique el aspecto alterando su grado en base a la función dada.

modificarAspecto :: (Float -> Float) -> Aspecto -> Aspecto
modificarAspecto funcion original = original {grado = funcion (grado original)}

-- Saber si una situación es mejor que otra: esto ocurre cuando, para la primer situación, 
-- cada uno de los aspectos, es mejor que ese mismo aspecto en la segunda situación.
-- Nota: recordar que los aspectos no necesariamente se encuentran en el mismo orden para 
-- ambas situaciones. Sin embargo, las situaciones a comparar siempre tienen los mismos aspectos.

evaluarAspectoEnSituacion :: Situacion -> Aspecto -> Bool
evaluarAspectoEnSituacion situacion aspecto= mejorAspecto aspecto resultadoBusqueda
    where 
        resultadoBusqueda = buscarAspecto aspecto situacion

esMejorSituacion :: Situacion -> Situacion -> Bool
esMejorSituacion mejorSit peorSit = length sonMejores == length mejorSit
    where
        sonMejores = takeWhile (evaluarAspectoEnSituacion peorSit) mejorSit

aspectoUno = UnAspecto "tension" 10
otroAspectoUno = UnAspecto "tension" 12
aspectoDos = UnAspecto "peligro" 20
otroAspectoDos = UnAspecto "peligro" 22
aspectoTres = UnAspecto "incertidumbre" 30
otroAspectoTres = UnAspecto "incertidumbre" 32
aspectoCuatro = UnAspecto "Cuatro" 40
otroAspectoCuatro = UnAspecto "Cuatro" 42

s1 = [aspectoUno, aspectoDos, aspectoTres]
-- Definir una función modificarSituacionTipoAspecto que a partir de una situación permita obtener otra de modo que
-- se modifique de cierta forma el grado correspondiente a un tipo de aspecto buscado.La alteración a
-- realizar sobre el grado actual de ese aspecto debe poder ser indicada al usar la función.

modificarSituacionTipoAspecto :: Situacion -> (Float -> Float) -> String -> Situacion
modificarSituacionTipoAspecto situacion funcion tipoAspecto = reemplazarAspecto aspectoModificado situacion

    where
        aspectoOriginal = buscarAspectoDeTipo tipoAspecto situacion
        aspectoModificado = modificarAspecto funcion aspectoOriginal

-- Modelar a las Gemas de modo que estén compuestas por su nombre, la fuerza que tienen y la personalidad. 
-- La personalidad de una Gema debe representar cómo reacciona ante una situación, derivando de ese modo 
-- a una situación diferente.
type Personalidad = Situacion -> Situacion

data Gemas = Gemas {
    nombre :: String,
    fuerza :: Int,
    personalidad :: Personalidad
} 

-- Definir las siguientes personalidades:
-- vidente: ante una situación disminuye a la mitad la incertidumbre y baja en 10 la tensión.
-- relajada: disminuye en 30 la tensión de la situación y, dependiendo de qué tan relajada sea la Gema, 
-- aumenta el peligro en tantas unidades como nivel de relajamiento tenga.
modificarIncertidumbre :: (Float -> Float) -> Situacion -> Situacion
modificarIncertidumbre funcion situacion = modificarSituacionTipoAspecto situacion funcion "incertidumbre"

modificarTension :: (Float -> Float) -> Situacion -> Situacion
modificarTension funcion situacion = modificarSituacionTipoAspecto situacion funcion "tension"

modificarPeligro :: (Float -> Float) -> Situacion -> Situacion
modificarPeligro funcion situacion = modificarSituacionTipoAspecto situacion funcion "peligro"

vidente :: Personalidad
vidente situacion = modificarTension ((-) 10) . modificarIncertidumbre (/2) $ situacion

relajada :: Float -> Personalidad
relajada nivel situacion = modificarTension ((-) 30) . modificarPeligro (+nivel) $ situacion

-- Mostrar ejemplos de cómo se crean una Gema vidente y una Gema descuidada.
gemaVidente :: Int -> Gemas
gemaVidente fuerz = Gemas "Vidente" fuerz vidente

gemaDescuidada :: Int -> Float -> Gemas
gemaDescuidada fuerz nivel=  Gemas "Descuidada" fuerz (relajada nivel)

-- Saber si una Gema le gana a otra dada una situación, que se cumple si la primera es más o igual de 
-- fuerte que la segunda y además entre las dos personalidades, la situación resultante de la primera 
-- ante la situación dada es mejor que la que genera la segunda personalidad ante la misma situación.

leGana :: Gemas -> Gemas -> Situacion -> Bool
leGana gema1 gema2 situacion= esMasFuerte && esMejorPersonalidad
    where
        esMasFuerte = fuerza gema1 > fuerza gema2
        situacionResultante1 = (personalidad gema1) situacion
        situacionResultante2 = (personalidad gema2) situacion
        esMejorPersonalidad = esMejorSituacion situacionResultante1 situacionResultante2

-- Fusión: como dijimos antes, dos Gemas pueden fusionarse entre ellas. La fusión de dos Gemas en una 
-- determinada situación produce una Gema enteramente nueva que cumple con las siguientes pautas:
-- Su nombre o bien es el mismo de las Gemas que se fusionaron si las mismas se llaman igual, 
-- o bien es la concatenación de los nombres de dichas Gemas.
-- Su personalidad fusionada va a producir el mismo efecto que producirían las gemas individuales 
-- actuando en sucesión, luego de bajar en 10 todos los aspectos de la situación a la que deban enfrentarse.
-- Para saber cómo va a ser la fuerza de la fusión necesitamos saber si son compatibles entre ellas, 
-- lo cual se cumple si, para la situación ante la cual se están fusionando, la personalidad fusionada 
-- produce una mejor situación que las personalidades individuales de cada gema. 
-- Si son compatibles, la fuerza de la fusión va a ser la suma de la fuerza de las gemas individuales 
-- multiplicada 10.En caso contrario, su fuerza es 7 veces la fuerza de la gema dominante (si la primera 
-- le gana a la otra es la dominante, sino es la segunda).
fusionarNombres :: Gemas -> Gemas -> String
fusionarNombres g1 g2 
    | nombre g1 == nombre g2 = nombre g1
    | otherwise = nombre g1 ++ nombre g2

reducirGradoAspecto :: Aspecto -> Aspecto
reducirGradoAspecto original = original { grado = grado original - 10}

reducirAspectos :: Personalidad
reducirAspectos situacion = map (reducirGradoAspecto) situacion

sonCompatibles :: Personalidad -> Personalidad -> Personalidad -> Situacion -> Bool
sonCompatibles p1 p2 pf sit = esMejorSituacion (pf sit) (p1 sit) && esMejorSituacion (pf sit) (p2 sit)

gemaDominante :: Gemas -> Gemas -> Situacion -> Gemas
gemaDominante g1 g2 sit
    | leGana g1 g2  sit = g1
    | otherwise = g2

fusionarFuerzas :: Gemas -> Gemas -> [Aspecto] -> Bool -> Int
fusionarFuerzas gema1 gema2 situacion compatibles
    | compatibles = (f1 + f2) * 10
    | otherwise = (*7) . fuerza $ (dominante)
    where
        f1 = fuerza gema1
        f2 = fuerza gema2
        dominante = gemaDominante gema1 gema2 situacion

fusion :: Situacion -> Gemas -> Gemas -> Gemas
fusion situacion gema1 gema2 = Gemas {
    nombre = fusionarNombres gema1 gema2,
    personalidad = pFusionada,
    fuerza = fusionarFuerzas gema1 gema2 situacion compatibles
}
    where
        p1 = personalidad gema1
        p2 = personalidad gema2
        pFusionada =  p1. p2 . reducirAspectos
        compatibles = sonCompatibles p1 p2 pFusionada situacion

fusionGrupal :: [Gemas] -> Situacion -> Gemas
fusionGrupal lista situacion = foldr (fusion situacion) primera lasDemas
    where
        primera = head lista
        lasDemas = tail lista
