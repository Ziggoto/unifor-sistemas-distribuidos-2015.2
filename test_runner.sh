#!/bin/bash

QTDE_FILES_ARRAY=(10 50 100)
SIZES=(1 3 5)

QTDE_FILES=10
SIZE=1
SIZE_OF_FILE=$(du -h files/heavy_file | awk '{print $1}')
CPU_INFO=$(cat /proc/cpuinfo | fgrep "model name" | uniq | cut -d : -f2)

prepare_ambient(){
	cp files/heavy_file input/
	cd input/
	for i in $(seq $QTDE_FILES)
	do
		dd if=heavy_file of=heavy_file$i.obj
		for n in $(seq $SIZE)
		do
			#dd if=heavy_file of=heavy_part$n
			cat heavy_file >> heavy_file$i.obj
		done

	done
	rm heavy_file #Apaga o original
	cd ..
}

run_tests(){
	echo "Executando Compactador Sequencial"
	(time python CompactadorSequencial.py) 2>> times.txt

	echo "Limpando arquivos .zip gerados"
	rm output/*

	echo "Executando Compactador Paralelo"
	(time python CompactadorParalelo.py) 2>> times.txt

	echo "Limpando arquivos .zip gerados"
	rm output/*

	echo "============================" >> times.txt
}

do_action(){
	echo -e "Gerando \e[33m$QTDE_FILES\e[0m arquivos de \e[33m$SIZE_OF_FILE\e[0m"
	prepare_ambient 2> /dev/null 
	run_tests
	rm input/*
}

touch times.txt

cat <<JOB
###########################################
#### Trabalho de Sistemas Distribuidos ####
####                                   ####
#### Equipe:                           ####
####  - Fábio Theophilo                ####
####  - Alan Lucas                     ####
####  - Fábio Gomes                    ####
####                                   ####
###########################################

JOB

echo -e "Testes Realizados numa máquina: \e[33m$CPU_INFO\e[0m"
echo "--------------------------------------------"

for i in $(seq 3)
do
	SIZE=${SIZES[$i-1]}
	for j in $(seq 3)
	do
		QTDE_FILES=${QTDE_FILES_ARRAY[$j-1]}
		#echo "Tamanho "$SIZE
		#echo "Qtde "$QTDE_FILES
		do_action
	done
done
