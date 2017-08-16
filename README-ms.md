
# Pustaka Pengantarabangsaan untuk Minetest

Oleh Diego Martínez (kaeza).
Diterbitkan bawah Unlicense. Lihat `LICENSE.md` untuk maklumat lanjut.

Mods ini ialah suatu usaha untuk menyediakan sokongan pengantarabangsaan
kepada mods (sesuatu yang Minetest tiada ketika ini).

Jika anda mempunyai sebarang komen/cadangan, sila tulis ke dalam [topik forum][topik].
Untuk melaporkan pepijat, sila gunakan [penjejak pepijat][pepijat] Github.

## Bagaimanakah cara untuk menggunakannya?

Jika anda pemain biasa yang mencari teks terjemahan, hanya [pasangkan][pasang_mods]
mods ini seperti mods lain, kemudian bolehkannya melalui GUI.

Mods ini cuba untuk mengesan bahasa anda, tetapi oleh kerana tiada
cara mudah alih untuk melakukannya, ia cuba beberapa cara yang lain:

* Tetapan `language` di dalam fail `minetest.conf`.
* Pembolehubah sekitaran `LANGUAGE`.
* Pembolehubah sekitaran `LANG`.
* Jika semua di atas gagal, ia gunakan `en`.

Dalam apa jua keadaan, hasil akhirnya sepatutnya menjadi
[Kod Bahasa ISO 639-1][ISO639-1] untuk bahasa yang dikehendaki.

### Pembangun mods

Jika anda seorang pembangun mods yang ingin menambah sokongan
pengantarabangsaan kepada mods anda, sila lihat `doc/developer.md`.

### Penterjemah

Jika anda seorang penterjemah, sila lihat `doc/translator.md`.

[topik]: https://forum.minetest.net/viewtopic.php?id=4929
[pepijat]: https://github.com/minetest-mods/intllib/issues
[pasang_mods]: https://wiki.minetest.net/Installing_Mods/ms
[ISO639-1]: https://ms.wikipedia.org/wiki/Senarai_kod_ISO_639-1
