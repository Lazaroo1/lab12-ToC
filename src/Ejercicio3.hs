-- | Ejercicio 3: calcular la matriz transpuesta de una matriz definida como
-- lista de listas, usando funciones lambda.
module Ejercicio3
  ( titulo
  , transpuesta
  , matrizEjemplo
  ) where

titulo :: String
titulo = "Ejercicio 3 - Matriz transpuesta"

-- | Calcula la transpuesta de una matriz representada como lista de filas.
--
-- Por definición, el elemento (j, i) de X^T es el elemento (i, j) de X: la
-- fila j del resultado se forma tomando el elemento j de cada fila de X. La
-- lambda externa recorre los índices de columna j y la interna extrae el
-- elemento j de cada fila.
--
-- Si las filas no tienen todas el mismo tamaño la matriz no es válida y se
-- devuelve un error.
transpuesta :: [[a]] -> Either String [[a]]
transpuesta [] = Right []
transpuesta filas@(primera : _)
  | all (\fila -> length fila == columnas) filas =
      Right (map (\j -> map (\fila -> fila !! j) filas) [0 .. columnas - 1])
  | otherwise =
      Left "La matriz no es rectangular: todas las filas deben tener la misma cantidad de elementos."
  where
    columnas = length primera

-- | Matriz del enunciado.
matrizEjemplo :: [[Integer]]
matrizEjemplo =
  [ [1, 2, 3, 1]
  , [4, 5, 6, 0]
  , [7, 8, 9, 1]
  ]
