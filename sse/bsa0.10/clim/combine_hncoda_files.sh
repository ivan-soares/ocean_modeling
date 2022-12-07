#!/bin/bash
#
	today=20151201
	ndays=32
        ogcm='glbv'
        nn=335

	echo
	echo " +++ Starting script to combine several hycom files in one +++ "
	echo


	mdate=$today
        let ndays=${ndays}+${nn}-1
	ddir="d-inputs/hycom/hncoda_${ogcm}_npo0.08_167W117W-15N47N_06h"
	outfile="${ogcm}_${today}_${ndays}d_06h.nc"
              
	yr=${mdate:0:4}
	mm=${mdate:4:2}
	dd=${mdate:6:2}


	while [ $nn -le $ndays ]; do

		infile="$ddir/${ogcm}_npo_${mdate}.nc"
		echo " ... reading file $infile"

		nnn=`echo $nn | awk '{printf "%3.3d", $1}'`

		#ncks -d time,0,7,2 $infile hycom_$nnn.nc
		ncks -d time,0,3 $infile hycom_$nnn.nc		

		mdate=`find_tomorrow.sh $yr $mm $dd`
		yr=${mdate:0:4}
		mm=${mdate:4:2}
		dd=${mdate:6:2}

		let nn=$nn+1

	done

	#cdo mergetime hycom_*.nc $outfile
	#rm hycom_*.nc

	echo
	echo " +++ End of Script +++ "
	echo

#
#   the end
#
