-- | Utilidades de consola compartidas por los cuatro ejercicios: lectura de
-- datos, limpieza del texto ingresado y el submenú de cada ejercicio.
module Consola
  ( -- * Consola y menús
    preguntar
  , encabezado
    -- * Limpieza de texto
  , recortar
  ) where

import Data.Char (isSpace)
import System.IO (hFlush, stdout)

-- | Muestra un mensaje, lee una línea y la devuelve sin espacios sobrantes.
preguntar :: String -> IO String
preguntar mensaje = do
  putStr mensaje
  hFlush stdout
  recortar <$> getLine

-- | Imprime un título enmarcado.
encabezado :: String -> IO ()
encabezado texto = do
  putStrLn ""
  putStrLn linea
  putStrLn ("  " ++ texto)
  putStrLn linea
  where
    linea = replicate (length texto + 4) '='

-- | Quita los espacios al inicio y al final de un texto.
recortar :: String -> String
recortar = quitarFinal . quitarFinal
  where
    quitarFinal = reverse . dropWhile isSpace
