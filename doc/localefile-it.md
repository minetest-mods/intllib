
# Formato del file di traduzione

*Nota: Questo documento spiega il vecchio formato in stile conf/ini.
La nuova interfaccia usa file [gettext][gettext] `.po`.
Si veda [Il formato dei file PO][PO-Files] per ulteriori informazioni.*

Questo è un esempio per un file di traduzione in Italiano (`it.txt`):

	# Un commento.
	# Un altro commento.
	Questa riga viene ignorata dato che non ha il segno di uguale.
	Hello, World! = Ciao, Mondo!
	String with\nnewlines = Stringa con\na capo
	String with an \= equals sign = Stringa con un segno di uguaglianza \=

I file "locale" (o di traduzione) sono file di testo semplice formati da righe
nel formato `testo originale = testo tradotto`. Il file deve stare nella
sottocartella `locale` del modulo, e il suo nome deve essere lo stesso del
[codice di lingua ISO 639-1][ISO639-1] della lingua che volete fornire.

I file di traduzione dovrebbero usare la codifica UTF-8.

Le righe che iniziano con un cancelletto sono commenti e vengono ignorate dal
lettore. Si noti che i commenti si estendono solo fino al termine della riga;
non c'è nessun supporto per i commenti multiriga. Le righe senza un segno di
uguale sono anch'esse ignorate.

I caratteri che sono considerati "speciali" possono essere "escaped" di modo
che siano presi letteralmente. Inoltre esistono molte sequenze di escape che
possono essere utilizzate:

  * Qualsiasi `#`, `=` può essere escaped di modo da essere preso letteralmente.
    La sequenza `\#` è utile se il vostro testo sorgente inizia con `#`.
  * Le sequenze di escape comuni `\n` e `\t`, significano rispettivamente
    newline (a capo) e tabulazione orizzontale.
  * La sequenza speciale di escape`\s` rappresenta il carattere di spazio.
    È utile principalmente per aggiungere spazi prefissi o suffissi ai testi
    originali o tradotti, perché altrimenti quegli spazi verrebbero rimossi.

[gettext]: https://www.gnu.org/software/gettext
[PO-Files]: https://www.gnu.org/software/gettext/manual/html_node/PO-Files.html
[ISO639-1]: https://it.wikipedia.org/wiki/ISO_639-1
