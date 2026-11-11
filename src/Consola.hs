-- | Utilidades de consola compartidas por los cuatro ejercicios: lectura de
-- datos, limpieza del texto ingresado y el submenú de cada ejercicio.
module Consola
  ( -- * Consola y menús
    preguntar
  , encabezado
    -- * Limpieza de texto
  , recortar
  , separarPor
  , quitarDelimitadores
  , quitarCorchetes
  , quitarComillas
  , entreCorchetes
  ) where

import Data.Char (isSpace)
import Data.List (dropWhileEnd, intercalate)
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

-- | Separa un texto en partes usando el carácter indicado y recorta cada parte.
separarPor :: Char -> String -> [String]
separarPor separador = map recortar . partir
  where
    partir texto = case break (== separador) texto of
      (parte, []) -> [parte]
      (parte, _ : resto) -> parte : partir resto

-- | Quita un par de delimitadores externos si el texto empieza y termina con
-- ellos. Por ejemplo, @quitarDelimitadores '{' '}' "{a: 1}" == "a: 1"@.
quitarDelimitadores :: Char -> Char -> String -> String
quitarDelimitadores abre cierra texto = case recortar texto of
  (inicio : resto)
    | inicio == abre
    , (final : medio) <- reverse resto
    , final == cierra ->
        recortar (reverse medio)
  limpio -> limpio

-- | Quita los corchetes externos: @"[1, 2]"@ queda como @"1, 2"@.
quitarCorchetes :: String -> String
quitarCorchetes = quitarDelimitadores '[' ']'

-- | Quita comillas simples o dobles al inicio y al final de un texto.
-- Tolera comillas sin pareja, como @negro'@ en el enunciado.
quitarComillas :: String -> String
quitarComillas = recortar . dropWhileEnd esComilla . dropWhile esComilla . recortar
  where
    esComilla c = c == '\'' || c == '"'

-- | Une textos al estilo de una lista de Python: @[a, b, c]@.
entreCorchetes :: [String] -> String
entreCorchetes elementos = "[" ++ intercalate ", " elementos ++ "]"
