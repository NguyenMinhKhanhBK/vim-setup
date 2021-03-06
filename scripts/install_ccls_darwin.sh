#!/usr/bin/env bash

LLVM_DIR=/usr/local/Cellar/llvm
OUTPUT_DIR=../output

if ! type brew &> /dev/null
then
	echo "brew not found"
	exit 1
fi

brew install ccls

llvm_num=$(ls ${LLVM_DIR} | wc -l)
if [[ llvm_num -eq 0 ]]
then
	echo "llvm library not found"
	exit 1
fi

latest_dir=""
for d in ${LLVM_DIR}/*
do
	if [[ $latest_dir < $d  ]]
	then 
		latest_dir=$d
	fi
done

if [[ latest_dir == "" ]]
then
	echo "latest llvm library not found"
	exit 1
fi

echo ${latest_dir}

mkdir -p ${OUTPUT_DIR}

cat >> ${OUTPUT_DIR}/ccls << EOF
clang
-ccc-install-dir
${latest_dir}/bin
%cpp -std=c++11
%cpp -stdlib=libc++
EOF
