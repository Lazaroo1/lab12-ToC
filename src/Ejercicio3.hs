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
transpuesta :: [[a]] -> [[a]]
transpuesta [] = []
transpuesta filas@(primera : _) =
  map (\j -> map (\fila -> fila !! j) filas) [0 .. length primera - 1]

-- | Matriz del enunciado.
matrizEjemplo :: [[Integer]]
matrizEjemplo =
  [ [1, 2, 3, 1]
  , [4, 5, 6, 0]
  , [7, 8, 9, 1]
  ]
