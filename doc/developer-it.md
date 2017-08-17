
# Intllib - documentazione per sviluppatrici/tori

## Abilitare l'internazionalizzazione

Per abilitare l'internazionalizzazione del vostro modulo, dovete copiare il file
`lib/intllib.lua` nella cartella principale del vostro modulo, poi inserite
questo codice standard nei file che necessitano la traduzione:

    -- Load support for intllib.
    local MP = minetest.get_modpath(minetest.get_current_modname())
    local S, NS = dofile(MP.."/intllib.lua")

Dovrete anche aggiungere la dipendenza facoltativa da intllib per il vostro
modulo, per farlo aggiungete `intllib?` su una riga vuota nel vostro
`depends.txt`. Si noti anche che se intllib non è installata, le funzioni di
acquisizione del testo sono fatte in modo da restituire la stringa di testo
originale. Questo è stato fatto in modo che non dobbiate spargere tonnellate
di `if` (o costrutti simili) per controllare se la libreria è installata.

Dopo avere messo il codice, dovete marcare le stringhe di testo che necessitano
una traduzione. Per ciascuna stringa traducibile nei vostri codici sorgenti,
usate la funzione `S` (si veda sopra) per restituire la stringa tradotta.
Per esempio:

    minetest.register_node("miomod:mionodo", {
        -- Stringa semplice:
        description = S("Il mio fantastico nodo"),
        -- Stringa con inserti:
        description = S("Macchina @1", "Blu"),
        -- ...
    })

La funzione `NS` è l'equivalente di `ngettext`. Dovrebbe essere usata quando la
stringa da tradurre ha forma singolare e plurale. Per esempio:

    -- Il primo `count` è per consentire a `ngettext` di stabilire quale forma
    -- usare. Il secondo `count` è per il sostituto effettivo.

    print(NS("Avete un oggetto.", "Avete @1 oggetti.", count, count))

## Generare e aggiornare cataloghi

Questo è il procedimento di base per lavorare con [gettext][gettext]

Ogni volta che avete nuove stringhe da tradurre, dovreste fare quanto segue:

    cd /percorso/del/modulo
    /percorso/degli/strumenti/intllib/xgettext.sh file1.lua file2.lua ...

Lo script creerà una cartella chiamata `locale` se non esiste già, e genererà
il file `template.pot` (un modello con tutte le stringhe traducibili). Se avete
già delle traduzioni, lo script provvederà al loro aggiornamento con le nuove
stringhe.

Lo script fornisce alcune opzioni al vero `xgettext` che dovrebbero essere
sufficienti per la maggior parte dei casi. Se lo desiderate potete specificare
altre opzioni:

    xgettext.sh -o file.pot --keyword=blaaaah:4,5 a.lua b.lua ...

NOTA: C'è anche un file batch di Windows `xgettext.bat` per gli utenti di
Windows, ma dovrete installare separatamente gli strumenti di gettext per la
riga di comando. Si veda la parte superiore del file per la configurazione.

[gettext]: https://www.gnu.org/software/gettext/
