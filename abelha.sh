#!/usr/bin/env bash
# abelha.sh
#
# Lucas Mendes, Janeiro de 2021

# Ferramenta que procura por arquivos e diretórios
# em sites
#
# Modo de uso: abelha.sh [url] [lista]
#
# Versão 0.1 - procura por nomes passados em uma lista
# Versão 0.2 - adicionada opções -V, --version, -h, --help,
#              -u, --url, -w, --wordlist
#

url=""
wordlist=""

MENSAGEM_USO="
USO:
	-u, --url           Define a url
	-w, --wordlist      Define a wordlist

	-h, --help          Mostra essa mensagem de ajuda
	-V, --version       Mostra a versão
"

banner(){
	echo "                      __"
	echo "                     // \\"
	echo "                     \\\_/ //"
	echo "sjw''-.._.-''-.._.. -(||)(')"
	echo "                     '''      abelha.sh"
	echo
}

while test -n "$1"; do
	case "$1" in
		-u | --url)
			shift
			url=$1

			if test -z "$url"; then
				echo "Falhou o argumento para -z/--wordlist"
				exit 1
			fi
		;;

		-w | --wordlist)
			shift
			wordlist=$1

			if test -z "$wordlist"; then
				echo "Falhou o argumento para -w/--wordlist"
				exit 1
			fi
		;;

		-h | --help)
			echo "$MENSAGEM_USO"
			exit 0
		;;

		-V | --version)
			echo -n $(basename "$0")
			grep '^# Versão ' "$0" | tail -1 | cut -d - -f 1 | tr -d \#
			exit 0
		;;

		*)
			echo "Opção inválida: [$1]"
			exit 1
		;;
	esac
	shift
done

banner

for palavra in $(cat $wordlist); do
	echo -n "$url$palavra - "
	resposta=$(curl -o /dev/null -s -w "%{http_code}" "$url/$palavra")
	if [ $resposta = "200" ]; then
		echo -e "\033[0;32m FOUND \033[0m"
	else
		echo -e "\033[0;31m NOT FOUND \033[0m"
	fi
done
