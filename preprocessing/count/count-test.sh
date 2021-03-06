#!/bin/bash
#
# Count all label in test dataset
#
#$ -S /bin/bash
#$ -N MLSECU_count_test
#$ -wd ~/
#$ -j y
#$ -pe mpi 8
#$ -o /media/silver/corentin/mlsecu/std
#$ -t 1-6
echo "Task id : $SGE_TASK_ID"
declare -i id=$SGE_TASK_ID-1
echo "Id : $id"

month_list=(
	july
	august
	august
	august
	august
	august
)

week_list=(
	week5
	week1
	week2
	week3
	week4
	week5
)
# download/attack/july/week5/july_week5_csv.tar.gz
base_link_list="https://nesg.ugr.es/nesg-ugr16/download/attack"

# Creer le dossier temporaire
mkdir /tmp/mlsecu

week=${week_list[$id]}
month=${month_list[$id]}
url="$base_link_list/$month/$week/$month"_"$week"_"csv.tar.gz"

wget -O /tmp/mlsecu/mlsecu_data.tar.gz $url
pv /tmp/mlsecu/mlsecu_data.tar.gz | tar xz -C /tmp/mlsecu

# Cas particulier
# Après décompression, le august.week1 ne setrouve pas dans un dossier "uniq"
if [ $month = "august" ] && [ $week = "week1" ]
then
	data_path="/tmp/mlsecu/$month.$week.csv"
else
	data_path="/tmp/mlsecu/uniq/$month.$week.csv.uniqblacklistremoved"
fi

export_path="/media/silver/corentin/mlsecu/count/test-$month.$week.json"

/media/gold/corentin/mlsecu/venv/bin/python /media/gold/corentin/mlsecu/count.py --data $data_path --export $export_path

rm -rf /tmp/mlsecu