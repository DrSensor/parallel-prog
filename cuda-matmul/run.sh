#!/usr/bin/env bash
./generate_matrix.sh

echo "compile..."
echo
make
echo
echo "calculate..."
echo
MATRIX_SIZES=(
	128
	256
	512
	1024
	2048
	4096
	8192
	# 16384
)

rm -f time_old.txt
rm -f time_summary_old.txt

[ -f "time.txt" ] && cp time.txt time_old.txt
[ -f "time_summary.txt" ] && cp time_summary.txt time_summary_old.txt

echo -n >time.txt
echo -n >time_summary.txt

echo "* * * * * * * sequential"
for SZ in "${MATRIX_SIZES[@]}"; do
	OUTPUT=$(./sequential "data/mat_${SZ}x${SZ}.txt" "data/mat_${SZ}x${SZ}b.txt")
	echo "${OUTPUT}" >>time.txt
	echo "${OUTPUT}" | LC_ALL=id_ID.UTF-8 awk '
    {
      compute += $5;
      comm += $8;
    } END  {
      comm = int(comm);
      compute = int(compute);
      printf "%-16s compute: %-10'"'"'d comm: %-14'"'"'d (%'"'"'d/%'"'"'d)\n", $2, compute, comm, compute, comm;
    }' | tee -a time_summary.txt
	# echo "" | tee -a time.txt
	# echo "" | tee -a time_summary.txt
done

echo "* * * * * * * avx"
for SZ in "${MATRIX_SIZES[@]}"; do
	OUTPUT=$(./avx "data/mat_${SZ}x${SZ}.txt" "data/mat_${SZ}x${SZ}b.txt")
	echo "${OUTPUT}" >>time.txt
	echo "${OUTPUT}" | LC_ALL=id_ID.UTF-8 awk '
    {
      compute += $5;
      comm += $8;
    } END  {
      comm = int(comm);
      compute = int(compute);
      printf "%-16s compute: %-10'"'"'d comm: %-14'"'"'d (%'"'"'d/%'"'"'d)\n", $2, compute, comm, compute, comm;
    }' | tee -a time_summary.txt
done

echo "* * * * * * * naive cuda"
for SZ in "${MATRIX_SIZES[@]}"; do
	OUTPUT=$(./naive "data/mat_${SZ}x${SZ}.txt" "data/mat_${SZ}x${SZ}b.txt")
	echo "${OUTPUT}" >>time.txt
	echo "${OUTPUT}" | LC_ALL=id_ID.UTF-8 awk '
    {
      compute += $5; 
      comm += $8;
    } END  {  
      comm = int(comm);
      compute = int(compute);
      printf "%-16s compute: %-10'"'"'d comm: %-14'"'"'d (%'"'"'d/%'"'"'d)\n", $2, compute, comm, compute, comm;
    }' | tee -a time_summary.txt
done

echo "* * * * * * * shared cuda"
for SZ in "${MATRIX_SIZES[@]}"; do
	OUTPUT=$(./shared "data/mat_${SZ}x${SZ}.txt" "data/mat_${SZ}x${SZ}b.txt")
	echo "${OUTPUT}" >>time.txt
	echo "${OUTPUT}" | LC_ALL=id_ID.UTF-8 awk '
    {
      compute += $5; 
      comm += $8;
    } END  {  
      comm = int(comm);
      compute = int(compute);
      printf "%-16s compute: %-10'"'"'d comm: %-14'"'"'d (%'"'"'d/%'"'"'d)\n", $2, compute, comm, compute, comm;
    }' | tee -a time_summary.txt
done

echo "* * * * * * * cublas cuda"
for SZ in "${MATRIX_SIZES[@]}"; do
	OUTPUT=$(./cublas "data/mat_${SZ}x${SZ}.txt" "data/mat_${SZ}x${SZ}b.txt")
	echo "${OUTPUT}" >>time.txt
	echo "${OUTPUT}" | LC_ALL=id_ID.UTF-8 awk '
    {
      compute += $5; 
      comm += $8;
    } END  {  
      comm = int(comm);
      compute = int(compute);
      printf "%-16s compute: %-10'"'"'d comm: %-14'"'"'d (%'"'"'d/%'"'"'d)\n", $2, compute, comm, compute, comm;
    }' | tee -a time_summary.txt
done
