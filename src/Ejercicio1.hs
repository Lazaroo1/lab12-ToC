-- | Ejercicio 1: ordenar una lista de diccionarios con respecto a una llave
-- indicada, usando funciones lambda.
module Ejercicio1
  ( Valor (..)
  , Diccionario
  , Orden (..)
  , titulo
  , ordenarPor
  , mostrarValor
  , formatearDiccionario
  , formatearLista
  , leerValor
  , leerDiccionario
  , telefonos
  , ejemplo
  , personalizado
  , ejecutar
  ) where

import Data.Char (toLower)
import Data.List (intercalate, nub, sortBy)
import Data.Maybe (isNothing)
import Text.Read (readMaybe)

import Consola

-- | Valor guardado en un diccionario. Una lista de Haskell no puede mezclar
-- tipos, así que cada valor es un número o un texto (en el ejemplo, 'model'
-- es número mientras que 'make' y 'color' son texto).
--
-- El orden derivado compara números entre sí de forma numérica y textos de
-- forma alfabética; si se mezclan, los números van antes que los textos.
data Valor
  = Numero Double
  | Texto String
  deriving (Eq, Ord, Show)

-- | Un diccionario es una lista de pares (llave, valor), como un dict de Python.
type Diccionario = [(String, Valor)]

data Orden = Ascendente | Descendente
  deriving (Eq, Show)

titulo :: String
titulo = "Ejercicio 1 - Ordenar una lista de diccionarios por llave"

-- | Ordena la lista de diccionarios con respecto a la llave indicada.
--
-- La función de comparación es una lambda que busca la llave en los dos
-- diccionarios y compara los valores encontrados; para el orden descendente
-- solo se invierte el orden de los argumentos. 'sortBy' es estable, así que
-- los diccionarios con el mismo valor conservan su orden original.
--
-- Si algún diccionario no tiene la llave se devuelve un error, igual que
-- Python lanzaría un KeyError.
ordenarPor :: Orden -> String -> [Diccionario] -> Either String [Diccionario]
ordenarPor orden llave diccionarios
  | not (null faltantes) =
      Left
        ( "La llave '" ++ llave ++ "' no existe en " ++ show (length faltantes)
            ++ " de los " ++ show (length diccionarios) ++ " diccionarios."
        )
  | otherwise = Right (sortBy comparar diccionarios)
  where
    faltantes = filter (\d -> isNothing (lookup llave d)) diccionarios
    comparar = case orden of
      Ascendente -> \a b -> compare (lookup llave a) (lookup llave b)
      Descendente -> \a b -> compare (lookup llave b) (lookup llave a)

-- | Muestra un valor como lo haría Python: textos entre comillas simples y
-- números enteros sin decimales.
mostrarValor :: Valor -> String
mostrarValor (Texto texto) = "'" ++ texto ++ "'"
mostrarValor (Numero numero)
  | numero == fromInteger entero = show entero
  | otherwise = show numero
  where
    entero = round numero :: Integer

-- | @{'make': 'Apple', 'model': 2, 'color': 'Silver'}@
formatearDiccionario :: Diccionario -> String
formatearDiccionario diccionario =
  "{" ++ intercalate ", " (map (\(llave, valor) -> "'" ++ llave ++ "': " ++ mostrarValor valor) diccionario) ++ "}"

-- | Un diccionario por línea, con el mismo formato del enunciado.
formatearLista :: [Diccionario] -> String
formatearLista diccionarios = "[" ++ intercalate ",\n " (map formatearDiccionario diccionarios) ++ "]"

-- | Convierte el texto ingresado en un valor: si se puede leer como número es
-- 'Numero', si no es 'Texto'. Un número entre comillas (por ejemplo @'7'@) se
-- queda como texto.
leerValor :: String -> Valor
leerValor texto = case readMaybe limpio :: Maybe Double of
  Just numero | not (isNaN numero || isInfinite numero) -> Numero numero
  _ -> Texto (quitarComillas limpio)
  where
    limpio = recortar texto

-- | Lee un diccionario escrito como @make: Apple, model: 2@. También acepta la
-- sintaxis de Python: @{'make': 'Apple', 'model': 2}@, y el signo @=@ en
-- lugar de @:@.
leerDiccionario :: String -> Either String Diccionario
leerDiccionario linea = do
  pares <- mapM leerPar (separarPor ',' (quitarDelimitadores '{' '}' linea))
  let llaves = map fst pares
  if length (nub llaves) /= length llaves
    then Left "Hay llaves repetidas en el diccionario."
    else Right pares
  where
    leerPar texto = case break (\c -> c == ':' || c == '=') texto of
      (llave, _ : valor)
        | not (null (quitarComillas llave)) -> Right (quitarComillas llave, leerValor valor)
      _ -> Left ("No se pudo leer \"" ++ texto ++ "\". Use el formato llave: valor.")

-- | Lista de diccionarios del enunciado.
telefonos :: [Diccionario]
telefonos =
  [ [("make", Texto "Apple"), ("model", Numero 2), ("color", Texto "Silver")]
  , [("make", Texto "Samsung"), ("model", Numero 7), ("color", Texto "Blue")]
  , [("make", Texto "Nokia"), ("model", Numero 216), ("color", Texto "Black")]
  , [("make", Texto "Huawei"), ("model", Numero 50), ("color", Texto "Gold")]
  ]

-- | Ordena e imprime el resultado (o el error, si la llave no existe).
mostrarOrdenado :: Orden -> String -> [Diccionario] -> IO ()
mostrarOrdenado orden llave diccionarios =
  case ordenarPor orden llave diccionarios of
    Left err -> putStrLn ("\nError: " ++ err)
    Right ordenados -> do
      putStrLn ("\nOrdenada por la llave '" ++ llave ++ "' (" ++ nombreOrden ++ "):")
      putStrLn "D ="
      putStrLn (formatearLista ordenados)
  where
    nombreOrden = if orden == Ascendente then "ascendente" else "descendente"

-- | Ejemplo del enunciado: ordenar por la llave 'model'.
ejemplo :: IO ()
ejemplo = do
  putStrLn "Lista original:"
  putStrLn "D ="
  putStrLn (formatearLista telefonos)
  mostrarOrdenado Ascendente "model" telefonos

-- | Pide los diccionarios, la llave y el orden al usuario.
personalizado :: IO ()
personalizado = do
  putStrLn "Ingrese un diccionario por línea con el formato  llave: valor, llave: valor"
  putStrLn "Ejemplo: make: Apple, model: 2, color: Silver"
  putStrLn "Deje la línea vacía para terminar."
  diccionarios <- leerDiccionarios 1
  if null diccionarios
    then putStrLn "No se ingresó ningún diccionario."
    else do
      putStrLn "\nLista ingresada:"
      putStrLn "D ="
      putStrLn (formatearLista diccionarios)
      putStrLn ("\nLlaves disponibles: " ++ intercalate ", " (nub (concatMap (map fst) diccionarios)))
      llave <- preguntar "Llave para ordenar: "
      orden <- preguntar "Orden ascendente (a) o descendente (d) [a]: "
      mostrarOrdenado (leerOrden orden) (quitarComillas llave) diccionarios
  where
    leerDiccionarios :: Int -> IO [Diccionario]
    leerDiccionarios i = do
      linea <- preguntar ("  Diccionario " ++ show i ++ ": ")
      if null linea
        then pure []
        else case leerDiccionario linea of
          Left err -> putStrLn ("  " ++ err) >> leerDiccionarios i
          Right diccionario -> (diccionario :) <$> leerDiccionarios (i + 1)
    leerOrden texto
      | map toLower texto `elem` ["d", "desc", "descendente"] = Descendente
      | otherwise = Ascendente

ejecutar :: IO ()
ejecutar = submenu titulo ejemplo personalizado
