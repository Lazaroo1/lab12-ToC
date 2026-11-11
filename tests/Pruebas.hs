-- | Pruebas de las funciones de los cuatro ejercicios. No usan bibliotecas
-- externas: cada prueba compara el resultado obtenido con el esperado.
module Main (main) where

import Control.Monad (unless)
import Data.Either (isLeft)
import System.Exit (exitFailure)

import Consola
import Ejercicio1
import Ejercicio2 (potencias)

-- | Compara el resultado obtenido con el esperado e imprime OK o FALLA.
verificar :: (Eq a, Show a) => String -> a -> a -> IO Bool
verificar nombre obtenido esperado
  | obtenido == esperado = putStrLn ("  OK     " ++ nombre) >> pure True
  | otherwise = do
      putStrLn ("  FALLA  " ++ nombre)
      putStrLn ("         esperado: " ++ show esperado)
      putStrLn ("         obtenido: " ++ show obtenido)
      pure False

-- Ejercicio 1 -----------------------------------------------------------------

apple, samsung, nokia, huawei :: Diccionario
apple = [("make", Texto "Apple"), ("model", Numero 2), ("color", Texto "Silver")]
samsung = [("make", Texto "Samsung"), ("model", Numero 7), ("color", Texto "Blue")]
nokia = [("make", Texto "Nokia"), ("model", Numero 216), ("color", Texto "Black")]
huawei = [("make", Texto "Huawei"), ("model", Numero 50), ("color", Texto "Gold")]

pruebasEjercicio1 :: [IO Bool]
pruebasEjercicio1 =
  [ verificar "ordena por 'model' (ejemplo del enunciado)"
      (ordenarPor Ascendente "model" telefonos)
      (Right [apple, samsung, huawei, nokia])
  , verificar "ordena por 'make' en orden alfabético"
      (ordenarPor Ascendente "make" telefonos)
      (Right [apple, huawei, nokia, samsung])
  , verificar "ordena por 'color'"
      (ordenarPor Ascendente "color" telefonos)
      (Right [nokia, samsung, huawei, apple])
  , verificar "ordena por 'model' en orden descendente"
      (ordenarPor Descendente "model" telefonos)
      (Right [nokia, huawei, samsung, apple])
  , verificar "conserva el orden original cuando los valores empatan"
      (ordenarPor Ascendente "k" [[("k", Numero 1), ("id", Texto "a")], [("k", Numero 0)], [("k", Numero 1), ("id", Texto "b")]])
      (Right [[("k", Numero 0)], [("k", Numero 1), ("id", Texto "a")], [("k", Numero 1), ("id", Texto "b")]])
  , verificar "una llave inexistente produce error"
      (isLeft (ordenarPor Ascendente "precio" telefonos))
      True
  , verificar "una lista vacía queda vacía"
      (ordenarPor Ascendente "model" [])
      (Right [])
  , verificar "formatea un diccionario como en Python"
      (formatearDiccionario apple)
      "{'make': 'Apple', 'model': 2, 'color': 'Silver'}"
  , verificar "muestra decimales solo cuando hacen falta"
      (map mostrarValor [Numero 7, Numero 2.5, Numero (-3)])
      ["7", "2.5", "-3"]
  , verificar "lee un diccionario con el formato llave: valor"
      (leerDiccionario "make: Apple, model: 2, color: Silver")
      (Right apple)
  , verificar "lee un diccionario con sintaxis de Python"
      (leerDiccionario "{'make': 'Apple', 'model': 2, 'color': 'Silver'}")
      (Right apple)
  , verificar "un número entre comillas se lee como texto"
      (leerValor "'7'")
      (Texto "7")
  , verificar "rechaza un par sin separador"
      (isLeft (leerDiccionario "make Apple"))
      True
  , verificar "rechaza llaves repetidas"
      (isLeft (leerDiccionario "a: 1, a: 2"))
      True
  ]

-- Ejercicio 2 -----------------------------------------------------------------

pruebasEjercicio2 :: [IO Bool]
pruebasEjercicio2 =
  [ verificar "cubos de 1 a 10 (ejemplo del enunciado)"
      (potencias 3 [1 .. 10])
      (Right [1, 8, 27, 64, 125, 216, 343, 512, 729, 1000])
  , verificar "n = 1 deja la lista igual"
      (potencias 1 [4, 5, 6])
      (Right [4, 5, 6])
  , verificar "cuadrados de negativos y cero"
      (potencias 2 [-3, 0, 3])
      (Right [9, 0, 9])
  , verificar "potencia impar de un negativo"
      (potencias 3 [-2])
      (Right [-8])
  , verificar "sin desbordamiento con números grandes"
      (potencias 3 [10000000000])
      (Right [10 ^ (30 :: Int)])
  , verificar "una lista vacía queda vacía"
      (potencias 5 [])
      (Right [])
  , verificar "n = 0 no es entero positivo"
      (isLeft (potencias 0 [1, 2, 3]))
      True
  , verificar "n negativo no es entero positivo"
      (isLeft (potencias (-2) [1, 2, 3]))
      True
  ]

main :: IO ()
main = do
  configurarConsola
  resultados <-
    mapM
      (\(nombre, pruebas) -> putStrLn ("\n" ++ nombre) >> sequence pruebas)
      [ ("Ejercicio 1", pruebasEjercicio1)
      , ("Ejercicio 2", pruebasEjercicio2)
      ]
  let todas = concat resultados
      fallas = length (filter not todas)
  putStrLn ("\n" ++ show (length todas - fallas) ++ " de " ++ show (length todas) ++ " pruebas pasaron.")
  unless (fallas == 0) exitFailure
