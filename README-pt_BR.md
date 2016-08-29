# Lib de Internacionalização para Minetest

Por Diego Martínez (kaeza).
Lançado como WTFPL.

Este mod é uma tentativa de fornecer suporte de internacionalização para mods
(algo que Minetest atualmente carece).

## Como usar

### Para usuários finais

Para usar este mod, basta [instalá-lo] (http://wiki.minetest.net/Installing_Mods) 
e habilita-lo na GUI.

O modificador tenta detectar o idioma do usuário, mas já que não há atualmente 
nenhuma maneira portátil para fazer isso, ele tenta várias alternativas, e usa 
o primeiro encontrado:

  * `language` definido em `minetest.conf`.
  * Se isso não for definido, ele usa a variável de ambiente `LANG` (isso 
    é sempre definido em SO's Unix-like).
  * Se todos falharem, usa `en` (que basicamente significa string não traduzidas).

Em todo caso, o resultado final deve ser um 
[Código de Idioma ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) 
do idioma desejado. Observe também que (atualmente) somente até os dois primeiros 
caracteres são usados, assim, por exemplo, os códigos `pt_BR.UTF-8`, `pt_BR`, e `pt` 
são todos iguais.

Alguns códigos comuns são `es` para o espanhol, `pt` para Português, `fr` para o 
francês, `It` para o italiano, `de` Alemão.

### Para desenvolvedores de mods

A fim de habilitá-lo para o seu mod, copie o seguinte trecho de código e cole no 
início de seu(s) arquivo(s) fonte(s):

```lua
-- Clichê para apoiar cadeias localizadas se mod intllib está instalado.
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	-- Se você não usar inserções (@1, @2, etc) você pode usar este:
	S = function(s) return s end

	-- Se você usar inserções, mas não usar escapes de inserção (\=, \n, etc) isso vai funcionar:
	S = function(s,a,...)a={a,...}return s:gsub("@(%d+)",function(n)return a[tonumber(n)]end)end

	-- Use isso se você precisar de funcionalidade total:
	S = function(s,a,...)if a==nil then return s end a={a,...}return s:gsub("(@?)@(%(?)(%d+)(%)?)",function(e,o,n,c)if e==""then return a[tonumber(n)]..(o==""and c or"")else return"@"..o..n..c end end) end
end
```

Você também vai precisar depender opcionalmente do mod intllib, adicionando "intllib?"
em uma linha vazia de seu depends.txt. Observe também que se intllib não estiver
instalado, a função S() é definido para retornar a string inalterada. Isto é feito
para que você não tenha que usar dezenas de 'if's (ou de estruturas semelhantes)
para verificar se a lib está realmente instalada.

Em seguida, para cada string "traduzível" em suas fontes, use a função S()
(definida no trecho anterior) para retornar uma string traduzida. Por exemplo:

```lua
minetest.register_node("mymod:meunode", {
	-- String simples
	description = S("Meu Node Fabuloso"),
	-- String com inserção de variáveis
	description = S("@1 Car", "Blue"),
	-- ...
})
```

Em seguida, crie um diretório chamado `locale` dentro do diretório do seu mod, 
e crie um arquivo modelo (por convenção, nomeado `template.txt`) contendo todas 
as strings traduzíveis (veja *Formato de arquivo Locale* abaixo). Tradutores 
irão traduzir as strings neste arquivo para adicionar idiomas ao seu mod.

### Para tradutores

Para traduzir um mod intllib-apoiado para o idioma desejado, copie o
arquivo `locale/template.txt` para`locale/IDIOMA.txt` (onde `IDIOMA` é o
[Código de Idioma ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
do idioma desejado.

Abra o novo arquivo no seu editor favorito, e traduza cada linha colocando
o texto traduzido após o sinal de igual.

Veja *Formato de arquivo Locale* abaixo para mais informações sobre o formato de arquivo.

## Formato de arquivo Locale

Aqui está um exemplo de um arquivo locale Português (`pt.txt`):

```cfg
# Um comentário.
# Outro Comentário.
Esta linha é ignorada, uma vez que não tem sinal de igual.
Hello, World! = Ola, Mundo!
String with\nnewlines = String com\nsaltos de linha
String with an \= equals sign = String com sinal de \= igual
```

Locale (ou tradução) são arquivos de texto simples que consistem em linhas da
forma `texto de origem = texto traduzido`. O arquivo deve residir no subdiretório 
`locale` do mod, e deve ser nomeado com as duas letras do 
[Código de Idioma ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
do idioma que deseja apoiar.

Os arquivos de tradução devem usar a codificação UTF-8.

As linhas que começam com um sinal de libra (#) são comentários e são efetivamente 
ignorados pelo interpretador. Note que comentários duram apenas até o fim da linha;
não há suporte para comentários de várias linhas. Linhas sem um sinal de igual são
ignoradas também.

Caracteres considerados "especiais" podem ser "escapados" para que sejam 
interpretados corretamente. Existem várias sequências de escape que podem ser usadas:

  * Qualquer `#` ou `=` pode ser escapado para ser interpretado corretamente. 
    A sequência `\#` é útil se o texto de origem começa com `#`.
  * Sequências de escape comuns são `\n` e` \t`, ou seja, de nova linha e
    guia horizontal, respectivamente.
  * A sequência de escape especial `\s` representa o caractere de espaço. isto
    pode ser útil principalmente para adicionar espaços antes ou depois de fonte ou
    textos traduzida, uma vez que estes espaços seriam removidos de outro modo.

## Palavras Finais

Obrigado por ler até este ponto.
Se você tiver quaisquer comentários/sugestões, por favor poste no
[Tópico do fórum](https://forum.minetest.net/viewtopic.php?id=4929) (em inglês). Para
relatórios de bugs, use o [Rastreador de bugs](https://github.com/minetest-mods/intllib/issues/new)
no Github.

Haja textos traduzidos! :P

\--

Atenciosamente,
Kaeza
