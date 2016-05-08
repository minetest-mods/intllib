
# Internationalization Lib for Minetest

By Diego Martínez (kaeza).
Released as WTFPL.

This mod is an attempt at providing internationalization support for mods
(something Minetest currently lacks).

## How to use

### For end users

To use this mod, just [install it](http://wiki.minetest.net/Installing_Mods)
and enable it in the GUI.

The mod tries to detect the user's language, but since there's currently no
portable way to do this, it tries several alternatives, and uses the first one
found:

  * `language` setting in `minetest.conf`.
  * If that's not set, it uses the `LANG` environment variable (this is
    always set on Unix-like OSes).
  * If all else fails, uses `en` (which basically means untranslated strings).

In any case, the end result should be the
[ISO 639-1 Language Code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
of the desired language. Also note that (currently) only up to the first two
characters are used, so for example, the settings `de_DE.UTF-8`, `de_DE`,
and `de` are all equal.

Some common codes are `es` for Spanish, `pt` for Portuguese, `fr` for French,
`it` for Italian, `de` for German.

### For mod developers

In order to enable it for your mod, copy the following code snippet and paste
it at the beginning of your source file(s):

```lua
-- Boilerplate to support localized strings if intllib mod is installed.
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	-- If you don't use insertions (@1, @2, etc) you can use this:
	S = function(s) return s end

	-- If you use insertions, but not insertion escapes this will work:
	S = function(s,a,...)a={a,...}return s:gsub("@(%d+)",function(n)return a[tonumber(n)]end)end

	-- Use this if you require full functionality
	S = function(s,a,...)if a==nil then return s end a={a,...}return s:gsub("(@?)@(%(?)(%d+)(%)?)",function(e,o,n,c)if e==""then return a[tonumber(n)]..(o==""and c or"")else return"@"..o..n..c end end) end
end
```

You will also need to optionally depend on intllib, to do so add `intllib?` to
an empty line in your `depends.txt`. Also note that if intllib is not installed,
the `S` function is defined so it returns the string unchanged. This is done
so you don't have to sprinkle tons of `if`s (or similar constructs) to check
if the lib is actually installed.

Next, for each translatable string in your sources, use the `S` function
(defined in the snippet) to return the translated string. For example:

```lua
minetest.register_node("mymod:mynode", {
	-- Simple string:
	description = S("My Fabulous Node"),
	-- String with insertions:
	description = S("@1 Car", "Blue"),
	-- ...
})
```

Then, you create a `locale` directory inside your mod directory, and create
a "template" file (by convention, named `template.txt`) with all the
translatable strings (see *Locale file format* below). Translators will
translate the strings in this file to add languages to your mod.

### For translators

To translate an intllib-supporting mod to your desired language, copy the
`locale/template.txt` file to `locale/LANGUAGE.txt` (where `LANGUAGE` is the
[ISO 639-1 Language Code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
of your language.

Open up the new file in your favorite editor, and translate each line putting
the translated text after the equals sign.

See *Locale file format* below for more information about the file format.

## Locale file format

Here's an example for a Spanish locale file (`es.txt`):

```cfg
# A comment.
# Another comment.
This line is ignored since it has no equals sign.
Hello, World! = Hola, Mundo!
String with\nnewlines = Cadena con\nsaltos de linea
String with an \= equals sign = Cadena con un signo de \= igualdad
```

Locale (or translation) files are plain text files consisting of lines of the
form `source text = translated text`. The file must reside in the mod's `locale`
subdirectory, and must be named after the two-letter
[ISO 639-1 Language Code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
of the language you want to support.

The translation files should use the UTF-8 encoding.

Lines beginning with a pound sign are comments and are effectively ignored
by the reader. Note that comments only span until the end of the line;
there's no support for multiline comments. Lines without an equals sign are
also ignored.

Characters that are considered "special" can be "escaped" so they are taken
literally. There are also several escape sequences that can be used:

  * Any of `#`, `=` can be escaped to take them literally. The `\#`
    sequence is useful if your source text begins with `#`.
  * The common escape sequences `\n` and `\t`, meaning newline and
    horizontal tab respectively.
  * The special `\s` escape sequence represents the space character. It
    is mainly useful to add leading or trailing spaces to source or
    translated texts, as these spaces would be removed otherwise.

## Final words

Thanks for reading up to this point.
Should you have any comments/suggestions, please post them in the
[forum topic](https://forum.minetest.net/viewtopic.php?id=4929). For bug
reports, use the [bug tracker](https://github.com/minetest-mods/intllib/issues/new)
on Github.

Let there be translated texts! :P

\--

Yours Truly,
Kaeza
