-- | Ejercicio 4: eliminar de una lista los elementos indicados en otra lista,
-- usando funciones lambda.
module Ejercicio4
  ( titulo
  , eliminar
  , noEncontrados
  , formatearTextos
  , colores
  , aBorrarEjemplo
  , ejemplo
  , personalizado
  , ejecutar
  ) where

import Control.Monad (unless)

import Consola

titulo :: String
titulo = "Ejercicio 4 - Eliminar elementos indicados de una lista"

-- | Devuelve los elementos de la lista que no aparecen en la lista de
-- elementos a borrar. 'filter' conserva solo los elementos para los que la
-- lambda devuelve True, por lo que se eliminan todas las apariciones de cada
-- elemento indicado y se respeta el orden original.
eliminar :: Eq a => [a] -> [a] -> [a]
eliminar lista aBorrar = filter (\x -> x `notElem` aBorrar) lista

-- | Elementos a borrar que no estaban en la lista original. No provocan
-- error, simplemente no hay nada que quitar (como 'café' en el ejemplo).
noEncontrados :: Eq a => [a] -> [a] -> [a]
noEncontrados lista aBorrar = eliminar aBorrar lista

-- | @['rojo', 'verde']@
formatearTextos :: [String] -> String
formatearTextos textos = entreCorchetes (map (\texto -> "'" ++ texto ++ "'") textos)

-- | Lista inicial del enunciado.
colores :: [String]
colores = ["rojo", "verde", "azul", "amarillo", "gris", "blanco", "negro"]

-- | Elementos a borrar del enunciado.
aBorrarEjemplo :: [String]
aBorrarEjemplo = ["amarillo", "café", "blanco"]

mostrar :: [String] -> [String] -> IO ()
mostrar lista aBorrar = do
  putStrLn ("Lista inicial:      " ++ formatearTextos lista)
  putStrLn ("Elementos a borrar: " ++ formatearTextos aBorrar)
  putStrLn ("Resultado:          " ++ formatearTextos (eliminar lista aBorrar))
  let ignorados = noEncontrados lista aBorrar
  unless (null ignorados) $
    putStrLn ("\nNo estaban en la lista (no había nada que borrar): " ++ formatearTextos ignorados)

-- | Ejemplo del enunciado.
ejemplo :: IO ()
ejemplo = mostrar colores aBorrarEjemplo

-- | Pide las dos listas al usuario.
personalizado :: IO ()
personalizado = do
  putStrLn "Escriba los elementos separados por comas (las comillas y corchetes son opcionales)."
  lista <- preguntar "Lista inicial: "
  aBorrar <- preguntar "Elementos a borrar: "
  putStrLn ""
  mostrar (leerListaTextos lista) (leerListaTextos aBorrar)

ejecutar :: IO ()
ejecutar = submenu titulo ejemplo personalizado
