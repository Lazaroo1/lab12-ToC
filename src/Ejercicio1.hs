-- | Ejercicio 1: ordenar una lista de diccionarios con respecto a una llave
-- indicada, usando funciones lambda.
module Ejercicio1
  ( Valor (..)
  , Diccionario
  , titulo
  , ordenarPor
  , mostrarValor
  , formatearDiccionario
  , formatearLista
  ) where

import Data.List (intercalate, sortBy)
import Data.Maybe (isNothing)

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

titulo :: String
titulo = "Ejercicio 1 - Ordenar una lista de diccionarios por llave"

-- | Ordena la lista de diccionarios con respecto a la llave indicada.
--
-- La función de comparación es una lambda que busca la llave en los dos
-- diccionarios y compara los valores encontrados. 'sortBy' es estable, así
-- que los diccionarios con el mismo valor conservan su orden original.
--
-- Si algún diccionario no tiene la llave se devuelve un error, igual que
-- Python lanzaría un KeyError.
ordenarPor :: String -> [Diccionario] -> Either String [Diccionario]
ordenarPor llave diccionarios
  | not (null faltantes) =
      Left
        ( "La llave '" ++ llave ++ "' no existe en " ++ show (length faltantes)
            ++ " de los " ++ show (length diccionarios) ++ " diccionarios."
        )
  | otherwise = Right (sortBy (\a b -> compare (lookup llave a) (lookup llave b)) diccionarios)
  where
    faltantes = filter (\d -> isNothing (lookup llave d)) diccionarios

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
