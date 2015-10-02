#!/bin/bash

QTDE_FILES_ARRAY=(10 50 100)
SIZES=(1 3 5)

QTDE_FILES=10
SIZE=1
SIZE_OF_FILE=$(du -h files/heavy_file | awk '{print $1}')
CPU_INFO=$(cat /proc/cpuinfo | fgrep "model name" | uniq | cut -d : -f2)

TIME_SEQUENCIAL=""

OUTPUT_FILE=output_times.csv

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
	TIME_SEQUENCIAL=$({ time python CompactadorSequencial.py; } 2>&1 | grep "real" | awk '{print $2}')

	echo "Limpando arquivos .zip gerados"
	rm output/*

	echo "Executando Compactador Paralelo"
	TIME_PARALELO=$({ time python CompactadorParalelo.py; } 2>&1 | grep "real" | awk '{print $2}')

	echo "Limpando arquivos .zip gerados"
	rm output/*

	echo $SIZE_NUMBER","$QTDE_FILES","$TIME_SEQUENCIAL","$TIME_PARALELO >> $OUTPUT_FILE
}

do_action(){
	echo -e "Gerando \e[33m$QTDE_FILES\e[0m arquivos de \e[33m$SIZE_NUMBER\e[0m"
	prepare_ambient 2> /dev/null 
	run_tests
	rm input/*
}

mkdir input 2> /dev/null/
mkdir output 2> /dev/null/
rm $OUTPUT_FILE 2> /dev/null/
touch $OUTPUT_FILE

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
		SIZE_NUMBER=$(echo ${SIZE_OF_FILE:0:-1} | xargs -I{} echo "$SIZE*{}" | xargs -I{} python -c "print str({})+'M'")
		#echo "Tamanho "$SIZE
		#echo "Qtde "$QTDE_FILES
		#echo $SIZE_NUMBER
		do_action
	done
done
