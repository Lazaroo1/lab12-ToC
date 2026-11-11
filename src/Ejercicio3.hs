-- | Ejercicio 3: calcular la matriz transpuesta de una matriz definida como
-- lista de listas, usando funciones lambda.
module Ejercicio3
  ( titulo
  , transpuesta
  , formatearMatriz
  , matrizEjemplo
  , ejemplo
  , personalizado
  , ejecutar
  ) where

import Data.List (intercalate)
import Text.Read (readMaybe)

import Consola

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

-- | Imprime la matriz con una fila por línea y las columnas alineadas:
--
-- > X = [[1, 2, 3, 1],
-- >      [4, 5, 6, 0],
-- >      [7, 8, 9, 1]]
formatearMatriz :: Show a => String -> [[a]] -> String
formatearMatriz nombre filas =
  nombre ++ " = [" ++ intercalate (",\n" ++ sangria) (map formatearFila textos) ++ "]"
  where
    textos = map (map show) filas
    ancho = maximum (0 : map length (concat textos))
    alinear texto = replicate (ancho - length texto) ' ' ++ texto
    formatearFila fila = entreCorchetes (map alinear fila)
    sangria = replicate (length nombre + 4) ' '

-- | "filas×columnas" de una matriz.
dimensiones :: [[a]] -> String
dimensiones [] = "0×0"
dimensiones filas@(primera : _) = show (length filas) ++ "×" ++ show (length primera)

-- | Matriz del enunciado.
matrizEjemplo :: [[Integer]]
matrizEjemplo =
  [ [1, 2, 3, 1]
  , [4, 5, 6, 0]
  , [7, 8, 9, 1]
  ]

mostrar :: [[Integer]] -> IO ()
mostrar x = do
  putStrLn (formatearMatriz "X" x)
  putStrLn ""
  case transpuesta x of
    Left err -> putStrLn ("Error: " ++ err)
    Right y -> do
      putStrLn (formatearMatriz "Y" y)
      putStrLn ("\nDimensiones: X es " ++ dimensiones x ++ " y Y = X^T es " ++ dimensiones y ++ ".")

-- | Ejemplo del enunciado.
ejemplo :: IO ()
ejemplo = mostrar matrizEjemplo

-- | Pide la matriz al usuario, fila por fila o completa en una sola línea.
personalizado :: IO ()
personalizado = do
  putStrLn "Ingrese la matriz fila por fila (enteros separados por comas o espacios)."
  putStrLn "También puede escribirla completa en la primera línea: [[1, 2], [3, 4]]"
  putStrLn "Deje la línea vacía para terminar."
  filas <- leerFilas 1
  if null filas
    then putStrLn "No se ingresó ninguna fila."
    else putStrLn "" >> mostrar filas
  where
    leerFilas :: Int -> IO [[Integer]]
    leerFilas i = do
      texto <- preguntar ("  Fila " ++ show i ++ ": ")
      if null texto
        then pure []
        else case (readMaybe texto, leerListaEnteros texto) of
          (Just matriz, _) | i == 1 -> pure matriz
          (_, Just fila) -> (fila :) <$> leerFilas (i + 1)
          _ -> putStrLn "  Solo se permiten números enteros." >> leerFilas i

ejecutar :: IO ()
ejecutar = submenu titulo ejemplo personalizado
