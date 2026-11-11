-- | Ejercicio 2: calcular la potencia n-ésima de cada elemento de una lista de
-- enteros, usando funciones lambda.
module Ejercicio2
  ( titulo
  , potencias
  ) where

titulo :: String
titulo = "Ejercicio 2 - Potencia n-ésima de cada elemento de una lista"

-- | Eleva cada elemento de la lista a la potencia n. La lambda @\\x -> x ^ n@
-- se aplica a cada elemento con 'map'.
--
-- Se usa 'Integer' (precisión arbitraria), así que no hay desbordamiento con
-- potencias grandes. Si n no es un entero positivo (n ∈ Z+) se devuelve un error.
potencias :: Integer -> [Integer] -> Either String [Integer]
potencias n lista
  | n < 1 = Left ("n debe ser un entero positivo (n ∈ Z+); se recibió n = " ++ show n ++ ".")
  | otherwise = Right (map (\x -> x ^ n) lista)
