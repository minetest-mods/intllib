
# Intllib developer documentation

## Enabling internationalization

In order to enable internationalization for your mod, you will need to copy the
file `lib/intllib.lua` into the root directory of your mod, then include this
boilerplate code in files needing localization:

    -- Load support for intllib.
    local MP = minetest.get_modpath(minetest.get_current_modname())
    local S, NS = dofile(MP.."/intllib.lua")

You will also need to optionally depend on intllib, to do so add `intllib?`
to an empty line in your `depends.txt`. Also note that if intllib is not
installed, the getter functions are defined so they return the string
unchanged. This is done so you don't have to sprinkle tons of `if`s (or
similar constructs) to check if the lib is actually installed.

Once you have the code in place, you need to mark strings that need
translation. For each translatable string in your sources, use the `S`
function (see above) to return the translated string. For example:

    minetest.register_node("mymod:mynode", {
        -- Simple string:
        description = S("My Fabulous Node"),
        -- String with insertions:
        description = S("@1 Car", "Blue"),
        -- ...
    })

The `NS` function is the equivalent of `ngettext`. It should be used when the
string to be translated has singular and plural forms. For example:

    -- The first `count` is for `ngettext` to determine which form to use.
    -- The second `count` is the actual replacement.
    print(NS("You have one item.", "You have @1 items.", count, count))

## Generating and updating catalogs

This is the basic workflow for working with [gettext][gettext]

Each time you have new strings to be translated, you should do the following:

    cd /path/to/mod
    /path/to/intllib/tools/xgettext.sh file1.lua file2.lua ...

The script will create a directory named `locale` if it doesn't exist yet,
and will generate the file `template.pot` (a template with all the translatable
strings). If you already have translations, the script will proceed to update
all of them with the new strings.

The script passes some options to the real `xgettext` that should be enough
for most cases. You may specify other options if desired:

    xgettext.sh -o file.pot --keyword=blargh:4,5 a.lua b.lua ...

NOTE: There's also a Windows batch file `xgettext.bat` for Windows users,
but you will need to install the gettext command line tools separately. See
the top of the file for configuration.

[gettext]: https://www.gnu.org/software/gettext/
