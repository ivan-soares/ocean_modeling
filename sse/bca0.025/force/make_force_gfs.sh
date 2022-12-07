#!/bin/bash
#
	today=20210101
	ndays=366

	echo
	echo " +++ Starting script to merge GFS files +++"
	echo

	yr=${today:0:4}
	mm=${today:4:2}
	dd=${today:6:2}

	mdate=$today
	wesn_gfs="-167. -117. 15. 47."
	gfsfile="gfs_${today}_${ndays}d.nc"
	frcfile="force_npo0.50_${yr}_gfs_new.nc"

	ddir="d-inputs/gfsanl_glo0.50_${yr}_03h"
	v01="TMP_surface,TMP_2maboveground,SPFH_2maboveground,RH_2maboveground"
	v02="UGRD_10maboveground,VGRD_10maboveground,PRATE_surface,PRMSL_meansealevel"
	v03="DSWRF_surface,DLWRF_surface,USWRF_surface,ULWRF_surface"

	nn=1

	while [ $nn -le $ndays ]; do

		echo " ... reading file gfs_$mdate.nc"
		ncks -d time,0,7 -v $v01,$v02,$v03 $ddir/gfs_$mdate.nc f_$mdate.nc

		mdate=`find_tomorrow.sh $yr $mm $dd`
		yr=${mdate:0:4}
		mm=${mdate:4:2}
		dd=${mdate:6:2}

		let nn=$nn+1
	done


	rm -rf $gfsfile
	cdo mergetime f_*.nc $gfsfile
	rm f_*.nc

        echo 
	echo " ... create a force file for ROMS"
	echo

        fix_gfs_nomads4roms_new.sh $gfsfile $frcfile $today $wesn_gfs

        echo
        echo " +++ End of script +++"
        echo
	
#
#   the end
#

