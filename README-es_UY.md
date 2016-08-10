
# Biblioteca de Internacionalización para Minetest

Por Diego Martínez (kaeza).
Lanzada bajo WTFPL.

Éste mod es un intento de proveer soporte para internacionalización para otros mods
(lo cual Minetest carece actualmente).

## Cómo usar

### Para usuarios finales

Para usar éste mod, simplemente [instálalo](http://wiki.minetest.net/Installing_Mods)
y habilítalo en la interfaz.

Éste mod intenta detectar el idioma del usuario, pero ya que no existe una solución
portable para hacerlo, éste intenta varias alternativas, y utiliza la primera
encontrada:

  * Opción `language` en `minetest.conf`.
  * Si ésta no está definida, usa la variable de entorno `LANG` (ésta está
    siempre definida en SOs como Unix).
  * Si todo falla, usa `en` (lo cual básicamente significa textos sin traducir).

En todo caso, el resultado final debe ser el In any case, the end result should be the
[Código de Idioma ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
del idioma deseado. Tenga en cuenta tambien que (de momento) solo los dos primeros
caracteres son usados, así que por ejemplo, las opciones `de_DE.UTF-8`, `de_DE`,
y `de` son iguales.

Algunos códigos comúnes: `es` para Español, `pt` para Portugués, `fr` para Francés,
`it` para Italiano, `de` para Aleman.

### Para desarrolladores

Para habilitar funcionalidad en tu mod, copia el siguiente fragmento de código y pégalo
al comienzo de tus archivos fuente:

```lua
-- Boilerplate to support localized strings if intllib mod is installed.
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	-- Si no requieres patrones de reemplazo (@1, @2, etc) usa ésto:
	S = function(s) return s end

	-- Si requieres patrones de reemplazo, pero no escapes, usa ésto:
	S = function(s,a,...)a={a,...}return s:gsub("@(%d+)",function(n)return a[tonumber(n)]end)end

	-- Usa ésto si necesitas funcionalidad completa:
	S = function(s,a,...)if a==nil then return s end a={a,...}return s:gsub("(@?)@(%(?)(%d+)(%)?)",function(e,o,n,c)if e==""then return a[tonumber(n)]..(o==""and c or"")else return"@"..o..n..c end end) end
end
```

Tambien necesitarás depender opcionalmente de intllib. Para hacerlo, añade `intllib?`
a tu archivo `depends.txt`. Ten en cuenta tambien que si intllib no está instalado,
la función `S` es definida para regresar la cadena sin cambios. Ésto se hace para
evitar la necesidad de llenar tu código con montones de `if`s (o similar) para verificar
que la biblioteca está instalada.

Luego, para cada cadena de texto a traducir en tu código, usa la función `S`
(definida en el fragmento de arriba) para regresar la cadena traducida. Por ejemplo:

```lua
minetest.register_node("mimod:minodo", {
	-- Cadena simple:
	description = S("My Fabulous Node"),
	-- Cadena con patrones de reemplazo:
	description = S("@1 Car", "Blue"),
	-- ...
})
```

Nota: Las cadenas en el código fuente por lo general deben estar en ingles ya que
es el idioma que más se habla. Es perfectamente posible especificar las cadenas
fuente en español y proveer una traducción al ingles, pero no se recomienda.

Luego, crea un directorio llamado `locale` dentro del directorio de tu mod, y crea
un archivo "plantilla" (llamado `template.txt` por lo general) con todas las cadenas
a traducir (ver *Formato de archivo de traducciones* más abajo). Los traductores
traducirán las cadenas en éste archivo para agregar idiomas a tu mod.

### Para traductores

Para traducir un mod que tenga soporte para intllib al idioma deseado, copia el
archivo `locale/template.txt` a `locale/IDIOMA.txt` (donde `IDIOMA` es el
[Código de Idioma ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
de tu idioma (`es` para español).

Abre el archivo en tu editor favorito, y traduce cada línea colocando el texto
traducido luego del signo de igualdad.

Ver *Formato de archivo de traducciones* más abajo.

## Formato de archivo de traducciones

He aquí un ejemplo de archivo de idioma para el español (`es.txt`):

```cfg
# Un comentario.
# Otro comentario.
Ésta línea es ignorada porque no tiene un signo de igualdad.
Hello, World! = Hola, Mundo!
String with\nnewlines = Cadena con\nsaltos de linea
String with an \= equals sign = Cadena con un signo de \= igualdad
```

Archivos de idioma (o traducción) son archivos de texto sin formato que consisten de
líneas con el formato `texto fuente = texto traducido`. El archivo debe ubicarse en el
subdirectorio `locale` del mod, y su nombre debe ser las dos letras del
[Código de Idioma ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
del lenguaje al cual se desea traducir.

Los archivos deben usar la codificación UTF-8.

Las líneas que comienzan en el símbolo numeral (`#`) son comentarios y son ignoradas
por el lector. Tenga en cuenta que los comentarios terminan al final de la línea;
no hay soporte para comentarios multilínea. Las líneas que no contengan un signo
de igualdad (`=`) tambien son ignoradas.

## Palabras finales

Gracias por leer hasta aquí.
Si tienes algún comentario/sugerencia, por favor publica en el
[tema en los foros](https://forum.minetest.net/viewtopic.php?id=4929). Para
reportar errores, usa el [rastreador](https://github.com/minetest-mods/intllib/issues/new)
en Github.

¡Que se hagan las traducciones! :P

\--

Suyo,
Kaeza
