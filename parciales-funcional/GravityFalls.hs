module GravityFalls where
import Text.Show.Functions

-- Primera parte: Las Rarezas
type Condicion = Person -> Bool
data Person = Person {
    edad :: Int,
    items :: [String],
    experiencia :: Int
} deriving (Show, Eq)

data Criatura = Criatura {
    peligrosidad :: Int,
    deshacer :: [Condicion]
} deriving (Show)

gnomoDeshacer :: Condicion
gnomoDeshacer persona = elem "soplador de hojas" . items $ persona

siempreDetras :: Criatura
siempreDetras = Criatura {
    peligrosidad = 0,
    deshacer = [(\_ -> False)]
}

gnomo :: Int -> Criatura
gnomo cantidad = Criatura {
    peligrosidad = 2^cantidad,
    deshacer = [gnomoDeshacer]
}
categoria3 :: Condicion
categoria3 persona = (edad persona < 13) && (elem "disfraz de oveja" (items persona))
categoria10 :: Condicion
categoria10 persona = experiencia persona > 10

fantasma :: Int -> [Condicion] -> Criatura
fantasma categoria condiciones = Criatura {
    peligrosidad = 20 * categoria,
    deshacer = condiciones
}

fantasma3 :: Criatura
fantasma3 = fantasma 3 [categoria3]

fantasma10 :: Criatura
fantasma10 = fantasma 10 [categoria10]

aumentarExperiencia :: Int -> Person -> Person
aumentarExperiencia cant persona = persona { experiencia = (experiencia persona) + cant}
-------
cumpleCondicion :: Person -> Condicion -> Bool
cumpleCondicion p c = c p

puedeDeshacerse :: Person -> Criatura -> Bool
puedeDeshacerse p c = length (filter (cumpleCondicion p) (deshacer c)) == length (deshacer c)

pejemplo = Person 20 [] 30

personaVScriatura :: Person -> Criatura -> Person
personaVScriatura persona criatura
    | puedeDeshacerse persona criatura = aumentarExperiencia (peligrosidad criatura) persona
    | otherwise = aumentarExperiencia 1 persona

-- Segunda parte: Mensajes ocultos

zipWithIf :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b] 
zipWithIf _ _ [] _ = []
zipWithIf _ _ _ [] = []
zipWithIf f1 g2 lista1 lista2
    | not primerElementoCumpleCondicion = (head lista2) : (zipWithIf f1 g2 lista1 (tail lista2))  
    | otherwise = aplicarF : (zipWithIf f1 g2 (tail lista1) (tail lista2))
    where
        primerElementoCumpleCondicion = g2 . head $ lista2
        aplicarF = f1 (head lista1) $ (head lista2)

abecedarioDesde :: Char -> [Char]
abecedarioDesde letra = [letra .. 'z'] ++ (init  ['a' .. letra])

buscarLetra :: [Char] -> [Char] -> Char -> Char
buscarLetra abcNormal abcNuevo letra 
    | abcNormal == [] = letra
    | letra == (head abcNuevo) = head abcNormal
    | otherwise = buscarLetra (tail abcNormal) (tail abcNuevo) letra

desencriptarLetra :: Char -> Char -> Char
desencriptarLetra clave letra = buscarLetra  abc abc' letra
    where 
        abc = ['a' .. 'z']
        abc' = abecedarioDesde clave

esLetra :: Char -> Bool
esLetra caracter = elem caracter ['a' .. 'z']

cesar :: Char -> String -> String
cesar clave texto = zipWithIf desencriptarLetra esLetra (repeat clave) texto

vigenere :: String -> String -> String
vigenere txtClave txtEncriptado = zipWithIf desencriptarLetra esLetra (cycle txtClave) txtEncriptado

desencriptar :: String -> String -> String
desencriptar clave encriptado = zipWithIf desencriptarLetra esLetra clave encriptado

cesar' :: Char -> String -> String
cesar' clave texto = desencriptar (repeat clave) texto

vigenere' :: String -> String -> String
vigenere' clave texto = desencriptar (cycle clave) texto

