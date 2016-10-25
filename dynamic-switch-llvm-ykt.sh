#!/bin/sh
if [ ! "$WORKING_PATH" = "" ] ; then
	ORIGINAL_SRC_ROOT=$WORKING_PATH/llvm
	ORIGINAL_OBJ_ROOT=$WORKING_PATH/install-llvm

	SRC_ROOT=$WORKING_PATH/llvm-ykt
	OBJ_ROOT=$WORKING_PATH/install-llvm-ykt

	export SRC_ROOT
	export OBJ_ROOT


	substr="$ORIGINAL_OBJ_ROOT" # "$OBJ_ROOT/usr/local"
	replace="$OBJ_ROOT"
	# http://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash

	# deal with CPATH
	ADDR=""
	IFS=':' read -ra ADDR <<< "$CPATH"
	#while IFS=':' read -ra ADDR; do
	for i in "${ADDR[@]}"; do
		if [[ ! ( "${i/$substr}" = "$i" ) ]]; then
			CPATH=${CPATH/$i}; 
		fi;
		if [[ ! ( "${i/$replace}" = "$i" ) ]]; then
			CPATH=${CPATH/$i}; 
		fi;
	done;
	#done <<< "$CPATH";
	ADDR=""
	tmp=""
	IFS=':' read -ra ADDR <<< "$CPATH"
	#while IFS=':' read -ra ADDR; do
	for i in "${ADDR[@]}"; do
		if [[ ! ( "$i" = "" ) ]] ; then
			if [ "$tmp" = "" ] ; then
				tmp=$i
			else
				tmp=$tmp:$i
			fi;
		fi;
	done
	#done <<< "$CPATH";
	if [ "$tmp" = "" ] ; then
		CPATH=$OBJ_ROOT/include:$OBJ_ROOT/lib:$OBJ_ROOT/bin
#		CPATH=$OBJ_ROOT/include:$tmp
	else
		CPATH=$OBJ_ROOT/include:$OBJ_ROOT/lib:$OBJ_ROOT/bin:$tmp
#		CPATH=$OBJ_ROOT/include:$tmp
	fi;

	export CPATH

	# deal with PATH
	ADDR=""
	IFS=':' read -ra ADDR <<< "$PATH"
	for i in "${ADDR[@]}"; do
		if [[ ! ( "${i/$substr}" = "$i" ) ]]; then
			PATH=${PATH/$i}; 
		fi;
		if [[ ! ( "${i/$replace}" = "$i" ) ]]; then
			PATH=${PATH/$i}; 
		fi;
	done;
	ADDR=""
	tmp=""
	IFS=':' read -ra ADDR <<< "$PATH"
	for i in "${ADDR[@]}"; do
		if [[ ! ( "$i" = "" ) ]] ; then
			if [ "$tmp" = "" ] ; then
				tmp=$i
			else
				tmp=$tmp:$i
			fi;
		fi;
	done
	if [ "$tmp" = "" ] ; then
		PATH=$OBJ_ROOT/include:$OBJ_ROOT/lib:$OBJ_ROOT/bin
	else
		PATH=$OBJ_ROOT/include:$OBJ_ROOT/lib:$OBJ_ROOT/bin:$tmp
	fi;

	export PATH

	cuda_device="/usr/lib/nvidia-cuda-toolkit/libdevice" 

	# deal with LD_LIBRARY_PATH
	ADDR=""
	IFS=':' read -ra ADDR <<< "$LD_LIBRARY_PATH"
	for i in "${ADDR[@]}"; do
		if [[ ! ( "${i/$substr}" = "$i" ) ]]; then
			LD_LIBRARY_PATH=${LD_LIBRARY_PATH/$i}; 
		fi;
		if [[ ! ( "${i/$replace}" = "$i" ) ]]; then
			LD_LIBRARY_PATH=${LD_LIBRARY_PATH/$i}; 
		fi;
		if [[ ! ( "${i/$cuda_device}" = "$i" ) ]]; then
			LD_LIBRARY_PATH=${LD_LIBRARY_PATH/$i}; 
		fi;
	done;
	ADDR=""
	tmp=""
	IFS=':' read -ra ADDR <<< "$LD_LIBRARY_PATH"
	for i in "${ADDR[@]}"; do
		if [[ ! ( "$i" = "" ) ]] ; then
			if [ "$tmp" = "" ] ; then
				tmp=$i
			else
				tmp=$tmp:$i
			fi;
		fi;
	done
	if [ "$tmp" = "" ] ; then
		LD_LIBRARY_PATH=$OBJ_ROOT/lib:$cuda_device
	else
		LD_LIBRARY_PATH=$OBJ_ROOT/lib:$cuda_device:$tmp
	fi;
	
	export LD_LIBRARY_PATH

	# deal with LIBRARY_PATH
	ADDR=""
	IFS=':' read -ra ADDR <<< "$LIBRARY_PATH"
	for i in "${ADDR[@]}"; do
		if ! [ "${i/$substr}" = "$i" ]; then
			LIBRARY_PATH=${LIBRARY_PATH/$i}; 
		fi;
		if ! [ "${i/$replace}" = "$i" ]; then
			LIBRARY_PATH=${LIBRARY_PATH/$i}; 
		fi;
		if ! [ "${i##$cuda_device}" = "$i" ]; then
			LIBRARY_PATH=${LIBRARY_PATH/$i}; 
		fi;
	done;
	ADDR=""
	tmp=""
	IFS=':' read -ra ADDR <<< "$LIBRARY_PATH"
	for i in "${ADDR[@]}"; do
		if ! [ "$i" = "" ] ; then
			if [ "$tmp" = "" ] ; then
				tmp=$i
			else
				tmp=$tmp:$i
			fi;
		fi;
	done
	if [ "$tmp" = "" ] ; then
		LIBRARY_PATH=$OBJ_ROOT/lib:$cuda_device
	else
		LIBRARY_PATH=$OBJ_ROOT/lib:$cuda_device:$tmp
	fi;
	
	export LIBRARY_PATH

else
	echo "export WORKING_PATH first."
fi;
