-- | Menú principal del Laboratorio 12.
module Main (main) where

import Consola

main :: IO ()
main = menu

menu :: IO ()
menu = do
  encabezado "Laboratorio 12 - Funciones lambda en Haskell"
  putStrLn "  0. Salir"
  eleccion <- preguntar "Opción: "
  case eleccion of
    "0" -> putStrLn "¡Hasta luego!"
    _ -> putStrLn "Opción no válida." >> menu
