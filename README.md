# Laboratorio 12 — Funciones lambda en Haskell

Teoría de la Computación · Universidad del Valle de Guatemala

| Integrante    | Carné |
| ------------- | ----- |
| Lázaro Díaz   | 24713 |
| Jorge Villeda | 24932 |

Los cuatro ejercicios del laboratorio están resueltos en **Haskell**. En cada uno, la operación principal
se hace con funciones lambda (`\x -> ...`) que se pasan a funciones de orden superior como `sortBy`, `map`
y `filter`.

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
