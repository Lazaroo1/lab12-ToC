-- | Menú principal del Laboratorio 12.
module Main (main) where

import Consola
import qualified Ejercicio1
import qualified Ejercicio2
import qualified Ejercicio3
import qualified Ejercicio4

data Ejercicio = Ejercicio
  { opcion :: String
  , descripcion :: String
  , abrir :: IO ()
  }

ejercicios :: [Ejercicio]
ejercicios =
  [ Ejercicio "1" "Ordenar una lista de diccionarios por llave" Ejercicio1.ejecutar
  , Ejercicio "2" "Potencia n-ésima de cada elemento de una lista" Ejercicio2.ejecutar
  , Ejercicio "3" "Matriz transpuesta" Ejercicio3.ejecutar
  , Ejercicio "4" "Eliminar elementos indicados de una lista" Ejercicio4.ejecutar
  ]

buscar :: String -> Maybe Ejercicio
buscar clave = case filter (\e -> opcion e == clave) ejercicios of
  (encontrado : _) -> Just encontrado
  [] -> Nothing

main :: IO ()
main = menu

menu :: IO ()
menu = do
  encabezado "Laboratorio 12 - Funciones lambda en Haskell"
  mapM_ (\e -> putStrLn ("  " ++ opcion e ++ ". " ++ descripcion e)) ejercicios
  putStrLn "  0. Salir"
  eleccion <- preguntar "Opción: "
  case eleccion of
    "0" -> putStrLn "¡Hasta luego!"
    _ -> case buscar eleccion of
      Just ejercicio -> abrir ejercicio >> menu
      Nothing -> putStrLn "Opción no válida." >> menu
