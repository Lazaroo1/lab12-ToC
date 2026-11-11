# Laboratorio 12 — Funciones lambda en Haskell

Teoría de la Computación · Universidad del Valle de Guatemala

| Integrante    | Carné |
| ------------- | ----- |
| Lázaro Díaz   | 24713 |
| Jorge Villeda | 24932 |

Los cuatro ejercicios del laboratorio están resueltos en **Haskell**. En cada uno, la operación principal
se hace con funciones lambda (`\x -> ...`) que se pasan a funciones de orden superior como `sortBy`, `map`
y `filter`.

## Video

📺 **Demostración en YouTube (no listado):** [https://youtu.be/PENDIENTE](https://youtu.be/PENDIENTE)

## Requisitos

- **GHC 9.2 o superior** y **Cabal 3.0 o superior**. La forma más sencilla de instalar ambos es con
  [GHCup](https://www.haskell.org/ghcup/) (en Windows se usa el comando de PowerShell que aparece en esa página).
- No se descarga nada de Hackage: el proyecto solo usa `base` y `process`, que vienen incluidos con GHC.

Para verificar la instalación:

```bash
ghc --version
cabal --version
```

## Cómo ejecutar

Desde la raíz del repositorio:

```bash
cabal run lab12              # menú principal
cabal run lab12 -- 1         # abre directamente el ejercicio 1 (también 2, 3 o 4)
cabal run lab12 -- ejemplos  # corre el ejemplo del enunciado de los cuatro ejercicios
cabal test                   # corre las pruebas automáticas
```

La primera vez Cabal compila el proyecto, así que tarda unos segundos más. Si aparece el aviso
`The package list for 'hackage.haskell.org' does not exist`, se puede ignorar (o correr `cabal update` una vez).

### Sin Cabal

También se puede interpretar directamente con GHC, sin compilar:

```bash
runghc -isrc app/Main.hs       # menú principal
runghc -isrc app/Main.hs 3     # directo al ejercicio 3
runghc -isrc tests/Pruebas.hs  # pruebas
```

### Uso del menú

```
================================================
  Laboratorio 12 - Funciones lambda en Haskell
================================================
  1. Ordenar una lista de diccionarios por llave
  2. Potencia n-ésima de cada elemento de una lista
  3. Matriz transpuesta
  4. Eliminar elementos indicados de una lista
  5. Ejecutar todos los ejemplos del enunciado
  0. Salir
Opción:
```

Cada ejercicio tiene un submenú con dos opciones:

1. **Ejecutar el ejemplo del enunciado**: usa exactamente los datos del enunciado.
2. **Ingresar datos propios**: pide los datos por consola y los valida; si algo está mal escrito,
   muestra el error y vuelve a pedir el dato.

> **Windows:** al iniciar, el programa cambia la consola a UTF-8 (equivale a `chcp 65001`) para que se vean
> bien las tildes, la ñ y el símbolo ∈.

## Ejercicios

### Ejercicio 1 — Ordenar una lista de diccionarios por llave

Código: [src/Ejercicio1.hs](src/Ejercicio1.hs)

Una lista de Haskell no puede mezclar tipos, así que cada diccionario es una lista de pares `(llave, valor)` y
el valor es de tipo `Valor`, que puede ser un `Numero` o un `Texto`:

```haskell
data Valor = Numero Double | Texto String
type Diccionario = [(String, Valor)]

ordenarPor :: Orden -> String -> [Diccionario] -> Either String [Diccionario]
-- caso ascendente:
sortBy (\a b -> compare (lookup llave a) (lookup llave b)) diccionarios
```

- `lookup llave d` busca el valor de la llave en el diccionario `d`. La lambda compara ese valor en dos
  diccionarios y `sortBy` usa esa comparación para ordenar la lista.
- Los números se comparan de forma numérica y los textos en orden alfabético.
- Se puede ordenar de forma ascendente o descendente (en la descendente la lambda invierte `a` y `b`).
- `sortBy` es estable: si dos diccionarios tienen el mismo valor, conservan su orden original.
- Si algún diccionario no tiene la llave se muestra un error en lugar de ordenar (como el `KeyError` de Python).

Ejemplo del enunciado, ordenando por `'model'`:

```
D =
[{'make': 'Apple', 'model': 2, 'color': 'Silver'},
 {'make': 'Samsung', 'model': 7, 'color': 'Blue'},
 {'make': 'Huawei', 'model': 50, 'color': 'Gold'},
 {'make': 'Nokia', 'model': 216, 'color': 'Black'}]
```

**Datos propios:** un diccionario por línea con el formato `llave: valor, llave: valor` (también se acepta la
sintaxis de Python, `{'make': 'Apple', 'model': 2}`). Una línea vacía termina la lista y luego se piden la llave
y el orden.

### Ejercicio 2 — Potencia n-ésima de cada elemento

Código: [src/Ejercicio2.hs](src/Ejercicio2.hs)

```haskell
potencias :: Integer -> [Integer] -> Either String [Integer]
potencias n lista
  | n < 1     = Left "n debe ser un entero positivo (n ∈ Z+) ..."
  | otherwise = Right (map (\x -> x ^ n) lista)
```

- `map` aplica la lambda `\x -> x ^ n` a cada elemento de la lista.
- Se valida que n ∈ ℤ⁺ (n ≥ 1).
- `Integer` tiene precisión arbitraria, así que no hay desbordamiento con potencias grandes.

Ejemplo del enunciado: `[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]` con n = 3 da
`[1, 8, 27, 64, 125, 216, 343, 512, 729, 1000]`.

**Datos propios:** la lista se escribe con los números separados por comas o espacios (con o sin corchetes) y
después se pide n.

### Ejercicio 3 — Matriz transpuesta

Código: [src/Ejercicio3.hs](src/Ejercicio3.hs)

```haskell
transpuesta :: [[a]] -> Either String [[a]]
-- si todas las filas tienen el mismo tamaño:
map (\j -> map (\fila -> fila !! j) filas) [0 .. columnas - 1]
```

- Por definición, el elemento (j, i) de Xᵀ es el elemento (i, j) de X: la fila j de la transpuesta se forma
  con el elemento j de cada fila de X.
- La lambda externa recorre los índices de columna `j` y la interna toma el elemento `j` de cada fila.
- La función es polimórfica (`[[a]]`), así que sirve para matrices de cualquier tipo.
- Si las filas no tienen todas el mismo tamaño, la matriz no es válida y se muestra un error.

Ejemplo del enunciado:

```
X = [[1, 2, 3, 1],
     [4, 5, 6, 0],
     [7, 8, 9, 1]]

Y = [[1, 4, 7],
     [2, 5, 8],
     [3, 6, 9],
     [1, 0, 1]]
```

> **Nota sobre el enunciado:** la última fila de la salida esperada aparece como `[1, 0, -1]`, pero la cuarta
> columna de X tiene los elementos 1, 0 y 1. El programa devuelve `[1, 0, 1]`, que es la transpuesta correcta.

**Datos propios:** la matriz se ingresa fila por fila (números separados por comas o espacios) o completa en la
primera línea, por ejemplo `[[1, 2, 3], [4, 5, 6]]`. Una línea vacía termina la matriz.

### Ejercicio 4 — Eliminar elementos indicados de una lista

Código: [src/Ejercicio4.hs](src/Ejercicio4.hs)

```haskell
eliminar :: Eq a => [a] -> [a] -> [a]
eliminar lista aBorrar = filter (\x -> x `notElem` aBorrar) lista
```

- `filter` conserva solo los elementos para los que la lambda devuelve `True`, es decir, los que **no** están
  en la lista de elementos a borrar.
- Se eliminan todas las apariciones de cada elemento y se respeta el orden original.
- Si un elemento a borrar no está en la lista (como `'café'` en el ejemplo) simplemente se ignora; el programa
  indica cuáles fueron.
- La comparación es exacta, así que `'Rojo'` y `'rojo'` son elementos distintos.

Ejemplo del enunciado:

```
Lista inicial:      ['rojo', 'verde', 'azul', 'amarillo', 'gris', 'blanco', 'negro']
Elementos a borrar: ['amarillo', 'café', 'blanco']
Resultado:          ['rojo', 'verde', 'azul', 'gris', 'negro']
```

**Datos propios:** los elementos se escriben separados por comas; las comillas y los corchetes son opcionales.

## Casos de prueba

Estos son los casos que se muestran en el video. Todos se pueden repetir desde la opción **2. Ingresar datos
propios** de cada ejercicio.

| Ejercicio | Caso | Entrada | Resultado |
| --------- | ---- | ------- | --------- |
| 1 | Ejemplo del enunciado | opción 1 | ordenada por `model`: 2, 7, 50, 216 |
| 1 | Ordenar por texto | los 4 teléfonos, llave `make` | Apple, Huawei, Nokia, Samsung |
| 1 | Orden descendente | llave `model`, orden `d` | 216, 50, 7, 2 |
| 1 | Números decimales | `make: Nokia, model: 216.5, color: Black` | se ordena con 216.5 |
| 1 | Llave inexistente | llave `precio` | error: la llave no existe |
| 1 | Línea mal escrita | `make Apple` | error y se vuelve a pedir el diccionario |
| 1 | Llave repetida | `a: 1, a: 2` | error y se vuelve a pedir el diccionario |
| 2 | Ejemplo del enunciado | opción 1 | `[1, 8, 27, ..., 1000]` |
| 2 | Negativos y cero | `-3, 0, 3` con n = 2 | `[9, 0, 9]` |
| 2 | Número grande | `2` con n = 64 | `[18446744073709551616]` (sin desbordamiento) |
| 2 | Lista vacía | `[]` con n = 3 | `[]` |
| 2 | n no positivo | n = `0` o n = `-2` | error y se vuelve a pedir n |
| 2 | Datos que no son enteros | lista `1, dos, 3` o n = `abc` | error y se vuelve a pedir el dato |
| 3 | Ejemplo del enunciado | opción 1 | matriz 4×3 |
| 3 | Matriz cuadrada | `[[1, 2], [3, 4]]` | `[[1, 3], [2, 4]]` |
| 3 | Una sola fila | `1, 2, 3` | `[[1], [2], [3]]` |
| 3 | Filas de distinto tamaño | `1 2 3` y luego `4 5` | error: la matriz no es rectangular |
| 3 | Elementos no numéricos | fila `1, a` | error y se vuelve a pedir la fila |
| 4 | Ejemplo del enunciado | opción 1 | `['rojo', 'verde', 'azul', 'gris', 'negro']` |
| 4 | Elementos repetidos | `a, b, a, c, a` sin `a` | `['b', 'c']` |
| 4 | Borrar todo | la misma lista en ambas | `[]` |
| 4 | Nada que borrar | lista a borrar vacía | la lista queda igual |
| 4 | Mayúsculas | `rojo, verde` sin `Rojo` | no se borra nada; avisa que `'Rojo'` no estaba |

Además, `cabal test` ejecuta 46 pruebas automáticas sobre las funciones de los cuatro ejercicios y sobre la
lectura de datos.

## Estructura del proyecto

```
.
├── app/
│   └── Main.hs          menú principal y argumentos de línea de comandos
├── src/
│   ├── Consola.hs       lectura de datos, limpieza de texto y submenús
│   ├── Ejercicio1.hs    ordenar diccionarios por llave (sortBy + lambda)
│   ├── Ejercicio2.hs    potencia n-ésima (map + lambda)
│   ├── Ejercicio3.hs    matriz transpuesta (map + lambdas anidadas)
│   └── Ejercicio4.hs    eliminar elementos (filter + lambda)
├── tests/
│   └── Pruebas.hs       pruebas automáticas
├── lab12.cabal
└── README.md
```
