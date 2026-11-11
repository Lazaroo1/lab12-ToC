-- | Ejercicio 4: eliminar de una lista los elementos indicados en otra lista,
-- usando funciones lambda.
module Ejercicio4
  ( titulo
  , eliminar
  , noEncontrados
  , formatearTextos
  , colores
  , aBorrarEjemplo
  ) where

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
