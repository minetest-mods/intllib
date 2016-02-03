Internacionalização Lib para Minetest
Por Diego Martínez (a.k.a. "Kaeza").
Lançado como WTFPL.

Este mod é uma tentativa de fornecer suporte de internacionalização para mods
(algo que Minetest atualmente carece).

Como posso usá-lo?
A fim de habilitá-lo para o seu mod, copie o seguinte trecho de código e cole no início de seu(s) arquivo(s) fonte:

	-- Padronizado para suportar cadeias (strings) locais se o mod intllib estiver instalado
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
	
Você também vai precisar depender opcionalmente do mod intllib, adicionando "intllib?"
em uma linha vazia de seu depends.txt. Observe também que se intllib não estiver
instalado, a função S() é definido para retornar a string inalterada. Isto é feito
para que você não tenha que regar toneladas de 'if's (ou de estruturas semelhantes)
para verificar se a lib está realmente instalada.

Em seguida, para cada string "traduzível" em suas fontes, use a função S()
(definida no trecho anterior) para retornar uma string traduzida. Por exemplo:

	minetest.register_node("meu_mod:meu_node", {
		description = S("Meu Fabuloso Node"),
		<...>
	})
	
Em seguida, dentro do diretório do seu mod, crie um diretório chamado 'locale'
no qual você deve colocar os arquivos nomeados com duas letras ( de acordo
com a ISO para códigos de idiomas) para os idiomas que seu mod vai suportar.
Aqui vai um exemplo de arquivo para idioma espanhol ('es.txt'):

	# As linhas que começam com um sinal de libra '#' são comentários e
	# efetivamente ignorados pelo carregamento.
	# Note-se que comentários duram apenas até o fim da linha;
	# Não há nenhum suporte para comentários de várias linhas.
	Ola, Mundo! = Hola, Mundo!
	String com\npulo de linha = Cadena con\nsaltos de linea
	String com um sinal de \= igualdade = Cadena con un signo de \= igualdad

Como atualmente não existe nenhuma maneira portátil para detectar o idioma,
esta biblioteca tenta várias alternativas, e usa o primeiro encontrado:
  - Valor de 'language' definido em 'minetest.conf'
  - Variavel de ambiente 'LANG' (normalmente definida em Unix-like SO's).
  - Padrão "en".

Note que, em qualquer caso, apenas até os dois primeiros caracteres são usados
para cada idioma, por exemplo, as definições de "pt_BR.UTF-8", "pt_BR", e "pt"
são todos iguais.
Os usuários do Windows não têm a variavel de ambiente 'LANG' por padrão.
Para adicioná-lo, faça o seguinte:
  - Clique em Iniciar > Configurações > Painel de Controle.
  - Iniciar o aplicativo "System".
  - Clique na aba "Avançado".
  - Clique no botão "Variáveis ​​de Ambiente"
  - Clique em "Novo".
  - Tipo "LANG" (sem aspas) com o nome e o código de linguagem como valor.
  - Clique em OK até que todas as caixas de diálogo estão fechadas.
Como alternativa para todas as plataformas, se você não quiser modificar as
configurações do sistema, você pode adicionar a seguinte linha ao seu
arquivo 'minetest.conf':
	language = <código de idioma>

Note também que existem alguns problemas com o uso acentos gráficos e, em geral
caracteres não-latinos em strings. Até que uma correção seja encontrada,
por favor, limite-se a usar apenas caracteres da US-ASCII.


Obrigado por ler até este ponto.
Se você tiver quaisquer comentários/sugestões, por favor poste no tópico do fórum.

Haja textos traduzidos! :P
--
Tutorial criado por Kaeza
Traduzido para Português do Brasil por BrunoMine
