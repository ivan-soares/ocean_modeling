#!/bin/bash
#

	#### S02

	today=$1
	ogcm=$2
	wind=$3
	here=$4
	log=$5

	source $here/expt_setup.sh # will load dir names and other info

	ntry=3
	nbytes='112298488'
	gfsfile="gfs_$today.nc"

	#====================================================================================
	echo ; cd $tmpdir; dr=`pwd`; now=$(date "+%Y/%m/%d %T"); echo >> $log
	echo " ... starting download of forcing $wind at $now" >> $log; echo >> $log
	echo " ==> $now HERE I am @ $dr for step 02: download forcing $wind data <=="; echo
	#====================================================================================

	echo
	echo " ... today is ${yr}-${mm}-${dd}"
	echo " ... will download $nhrs hours"
	echo " ... will store downloaded files in folder $stodir"
	echo

	# will download a file named gfs_$today.nc

	n=1

	while [ $n -le $ntry ]; do
	      get_gfs_nomads_oneday+forecast.sh $today $nhrs
	      ## script check_gfs.sh will create a file named check_status
	      check_gfs.sh $gfsfile $nbytes $log
	      check=`cat check_status`
	      rm check_status

	      if [ $check == 0 ]; then
		 echo " ... %%%%%% Downloaded file is OK !! %%%%%%"
		 break
	      fi

	      let n=$n+1
	done

	# create a force file for WW3
	fix_gfs_nomads4ww3.sh gfs_$today.nc gfs_${domain_wind}_$today.nc $today

	# create a force file for ROMS
	fix_gfs_nomads4roms.sh gfs_$today.nc gfs_${domain_wind2}_$today.nc $today $wesn_gfs

	mv gfs_${today}.nc                 ${stodir}/${today}/
	mv gfs_${domain_wind}_${today}.nc   ${stodir}/${today}/
	mv gfs_${domain_wind2}_${today}.nc   ${stodir}/${today}/

	#====================================================================================
	echo ; now=$(date "+%Y/%m/%d %T"); echo >> $log
	echo " ... finished download of forcing at $now" >> $log; echo >> $log
	echo " ==> $now FINISHED downloading of forcing <=="; echo
	#====================================================================================

	cd $here

################################## *** the end *** ##############################################
