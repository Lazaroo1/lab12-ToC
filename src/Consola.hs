-- | Utilidades de consola compartidas por los cuatro ejercicios: lectura de
-- datos, limpieza del texto ingresado y el submenú de cada ejercicio.
module Consola
  ( -- * Consola y menús
    preguntar
  , pausa
  , encabezado
  , submenu
    -- * Limpieza de texto
  , recortar
  , separarPor
  , quitarDelimitadores
  , quitarCorchetes
  , quitarComillas
  , entreCorchetes
    -- * Lectura de datos
  , leerEntero
  , leerListaEnteros
  , leerListaTextos
  ) where

import Control.Monad (void)
import Data.Char (isSpace)
import Data.List (dropWhileEnd, intercalate)
import System.IO (hFlush, stdout)
import Text.Read (readMaybe)

-- | Muestra un mensaje, lee una línea y la devuelve sin espacios sobrantes.
preguntar :: String -> IO String
preguntar mensaje = do
  putStr mensaje
  hFlush stdout
  recortar <$> getLine

-- | Espera a que el usuario presione Enter.
pausa :: IO ()
pausa = void (preguntar "\nPresione Enter para continuar...")

-- | Imprime un título enmarcado.
encabezado :: String -> IO ()
encabezado texto = do
  putStrLn ""
  putStrLn linea
  putStrLn ("  " ++ texto)
  putStrLn linea
  where
    linea = replicate (length texto + 4) '='

-- | Submenú común a todos los ejercicios: correr el ejemplo del enunciado o
-- ingresar datos propios.
submenu :: String -> IO () -> IO () -> IO ()
submenu nombre ejemplo personalizado = ciclo
  where
    ciclo = do
      encabezado nombre
      putStrLn "  1. Ejecutar el ejemplo del enunciado"
      putStrLn "  2. Ingresar datos propios"
      putStrLn "  0. Regresar"
      opcion <- preguntar "Opción: "
      case opcion of
        "1" -> putStrLn "" >> ejemplo >> pausa >> ciclo
        "2" -> putStrLn "" >> personalizado >> pausa >> ciclo
        "0" -> pure ()
        _ -> putStrLn "Opción no válida." >> ciclo

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

-- | Lee un número entero.
leerEntero :: String -> Maybe Integer
leerEntero = readMaybe . recortar

-- | Lee una lista de enteros separados por comas o espacios, con o sin
-- corchetes: @"1, 2, 3"@, @"[1, 2, 3]"@ o @"1 2 3"@.
leerListaEnteros :: String -> Maybe [Integer]
leerListaEnteros texto
  | null contenido = Just []
  | ',' `elem` contenido = mapM leerEntero (separarPor ',' contenido)
  | otherwise = mapM leerEntero (words contenido)
  where
    contenido = quitarCorchetes texto

-- | Lee una lista de textos separados por comas, con o sin corchetes y
-- comillas: @"rojo, verde"@ o @"['rojo', 'verde']"@.
leerListaTextos :: String -> [String]
leerListaTextos = filter (not . null) . map quitarComillas . separarPor ',' . quitarCorchetes
