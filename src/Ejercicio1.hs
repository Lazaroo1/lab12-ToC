-- | Ejercicio 1: ordenar una lista de diccionarios con respecto a una llave
-- indicada, usando funciones lambda.
module Ejercicio1
  ( Valor (..)
  , Diccionario
  , titulo
  ) where

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
