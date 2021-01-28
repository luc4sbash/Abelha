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
#

echo "                      __"
echo "                     // \\"
echo "                     \\_/ //"
echo "sjw''-.._.-''-.._.. -(||)(')"
echo "                     '''\"   abelha.sh V0.1"

for palavra in $(cat $2); do
	echo -n "$1$palavra - "
	resposta=$(curl -o /dev/null -s -w "%{http_code}" "$1/$palavra")
	if [ $resposta = "200" ]; then
		echo -e "\033[0;32m FOUND \033[0m"
	else
		echo -e "\033[0;31m NOT FOUND \033[0m"
	fi
done
