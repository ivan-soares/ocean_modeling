#!/bin/bash
#
	today=20200101
	ndays=367

	echo
	echo " +++ Starting script to merge GFS files +++"
	echo

	yr=${today:0:4}
	mm=${today:4:2}
	dd=${today:6:2}

	mdate=$today
	wesn_gfs="-50. -38. -30. -20."
	gfsfile="gfs_${today}_${ndays}d.nc"
	frcfile="force_gfs_bsa0.50_${today}_${ndays}d.nc"

	vars01='DLWRF_surface,DSWRF_surface,ULWRF_surface,USWRF_surface,PRATE_surface,PRMSL_meansealevel'
	vars02='RH_2maboveground,SPFH_2maboveground,TMP_2maboveground,TMP_surface,UGRD_10maboveground,VGRD_10maboveground'

	nn=1

	while [ $nn -le $ndays ]; do

		echo " ... reading file gfs_$mdate.nc"
		ncks -v $vars01,$vars02 -d time,0,7 d-inputs/gfsanl_glo0.50_2020_03h/gfs_$mdate.nc f_$mdate.nc

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

        fix_gfs_nomads4roms.sh $gfsfile $frcfile $today $wesn_gfs

        echo
        echo " +++ End of script +++"
        echo
	
#
#   the end
#

