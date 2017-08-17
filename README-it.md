
# Libreria di internazionalizzazione per Minetest

Di Diego Martínez (kaeza).
Rilasciata sotto licenza Unlicense. Si veda `LICENSE.md` per i dettagli.

Questo modulo è un tentativo per fornire il supporto di internazionalizzazione
per i moduli (cosa che attualmente manca a Minetest).

Se aveste qualunque commento o suggerimento, per piacere scriveteli nella
[discussione sul forum][topic]. Per i rapporti sui bug, usate il
[tracciatore di bug][bugtracker] su Github.

## Come usarla

Se siete un* giocatrice/tore che vuole i testi tradotti,
[installate][installing_mods] questo modulo come qualunque altro,
poi abilitatelo tramite l'interfaccia grafica.

Il modulo tenta di rilevare la vostra lingua, ma dato che al momento non c'è
un metodo portabile per farlo, prova diverse alternative:

* `language` impostazione in `minetest.conf`.
* `LANGUAGE` variabile d'ambiente.
* `LANG` variabile d'ambiente.
* Se nessuna funziona, usa `en`.

In ogni caso, il risultato finale dovrebbe essere il
[codice di lingua ISO 639-1][ISO639-1] del linguaggio desiderato.

### Sviluppatrici/tori di moduli

Se siete un* sviluppatrice/tore di moduli desideros* di aggiungere il supporto
per l'internazionalizzazione al vostro modulo, leggete `doc/developer-it.md`.

### Traduttrici/tori

Se siete un* traduttrice/tore, leggete `doc/translator-it.md`.

[topic]: https://forum.minetest.net/viewtopic.php?id=4929
[bugtracker]: https://github.com/minetest-mods/intllib/issues
[installing_mods]: https://wiki.minetest.net/Installing_mods
[ISO639-1]: https://it.wikipedia.org/wiki/ISO_639-1
