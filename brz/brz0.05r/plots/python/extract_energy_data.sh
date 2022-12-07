#!/bin/bash
#

	today=$1

	year=${today:0:4}
	infile="logfile_brz0.05r_01d_${today}.log"



	cat ../../expts/d-storage/${infile} | grep "${year}-" | \
		grep -Ev 'GET_STATE|GET_2DFLD|GET_3DFLD|GET_NGFLD' | \
		sed -e 's/E/e/g' -e 's/-/ /g' -e 's/:/ /g' | \
		awk '{print $2,$3,$4,$5,$6,$7,$8 "-" $9,$10,$11,$12}' > energy_${year}.log
