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
# Versão 0.3 - Consertado mensagem de erro do --wordlist
#              O -u e --url foram trocados por -h e --host
#              Adicionado pesquisa de informações sobre ip
#              com a opção --ipinfo
#

ipinfo=0
host=""
comando=""
wordlist=""

MENSAGEM_USO="
USO:
	-h, --host          Define a url
	-w, --wordlist      Define a wordlist
	--ipinfo			Mostra informações do host
		--ip, --hostname, --city, --region, --country,
        --loc, --org, --postal

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

ipinfoloop(){
	[ -z "$host" ] && echo "O host não foi passado" && exit 1
	curl -s ipinfo.io/$host | grep $comando | cut -d : -f 2
	exit 0
}

while test -n "$1"; do
	case "$1" in
		-h | --host)
			shift
			host=$1

			if test -z "$host"; then
				echo "Falhou o argumento para -/--wordlist"
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

 		--ipinfo)
			ipinfo=1
            shift
            [ -z "$1" ] && echo "--ipinfo espera argumento" && exit 1
            while test -n "$1"; do
                case "$1" in
                    --ip)       comando="ip";;
                    --hostname) comando="hostname" ;;
                    --city)     comando="city"     ;;
                    --region)   comando="region"   ;;
                    --country)  comando="country"  ;;
                    --loc)      comando="loc"      ;;
                    --org)      comando="org"      ;;
                    --postal)   comando="postal"   ;;
                esac
                shift
            done
        ;;

		*)
			echo "Opção inválida: [$1]"
			exit 1
		;;
	esac
	shift
done

banner

[ "$ipinfo" -eq "1" ]  && ipinfoloop

for palavra in $(cat $wordlist); do
	echo -n "$url$palavra - "
	resposta=$(curl -o /dev/null -s -w "%{http_code}" "$host/$palavra")
	if [ $resposta = "200" ]; then
		echo -e "\033[0;32m FOUND \033[0m"
	else
		echo -e "\033[0;31m NOT FOUND \033[0m"
	fi
done
