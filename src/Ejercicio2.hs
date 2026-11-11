-- | Ejercicio 2: calcular la potencia n-ésima de cada elemento de una lista de
-- enteros, usando funciones lambda.
module Ejercicio2
  ( titulo
  , potencias
  , ejemplo
  , personalizado
  , ejecutar
  ) where

import Consola

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

mostrar :: Integer -> [Integer] -> IO ()
mostrar n lista = do
  putStrLn ("Lista inicial: " ++ entreCorchetes (map show lista))
  putStrLn ("n = " ++ show n)
  case potencias n lista of
    Left err -> putStrLn ("Error: " ++ err)
    Right resultado -> putStrLn ("Resultado:     " ++ entreCorchetes (map show resultado))

-- | Ejemplo del enunciado: [1..10] con n = 3.
ejemplo :: IO ()
ejemplo = mostrar 3 [1 .. 10]

-- | Pide la lista y la potencia al usuario, validando cada dato.
personalizado :: IO ()
personalizado = do
  lista <- pedirLista
  n <- pedirN
  putStrLn ""
  mostrar n lista
  where
    pedirLista = do
      texto <- preguntar "Lista de enteros (ej. 1, 2, 3): "
      case leerListaEnteros texto of
        Just numeros -> pure numeros
        Nothing -> putStrLn "  La lista solo puede contener números enteros." >> pedirLista
    pedirN = do
      texto <- preguntar "Potencia n (entero positivo): "
      case leerEntero texto of
        Just potencia
          | potencia >= 1 -> pure potencia
          | otherwise -> putStrLn "  n debe ser mayor o igual a 1 (n ∈ Z+)." >> pedirN
        Nothing -> putStrLn "  n debe ser un número entero." >> pedirN

ejecutar :: IO ()
ejecutar = submenu titulo ejemplo personalizado
