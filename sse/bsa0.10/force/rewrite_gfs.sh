#!/bin/bash
#
	today=$1
	ndays=$2
 
        nn=1

	echo
	echo " +++ Starting bash sript to do what I say +++ "
	echo


	mdate=$today
              
	yr=${mdate:0:4}
	mm=${mdate:4:2}
	dd=${mdate:6:2}

	domain="bsa0.10"
	inpdir="$HOME/roms/cases/sse/$domain/force/d-inputs/gfsanl_glo0.50_03h"

	wesn="-50. -38. -30. -21."

	while [ $nn -le $ndays ]; do


		inpfile="$inpdir/gfs_${mdate}.nc"
		outfile="gfs_bsa0.50_${mdate}.nc"

		echo " ... make file $outfile"

		# create a force file for ROMS
        	fix_gfs_nomads4roms.sh $inpfile $outfile $mdate $wesn

		mdate=`find_tomorrow.sh $yr $mm $dd`
		yr=${mdate:0:4}
		mm=${mdate:4:2}
		dd=${mdate:6:2}

		let nn=$nn+1

	done


	echo
	echo " +++ End of Script +++ "
	echo

#
#   the end
#
