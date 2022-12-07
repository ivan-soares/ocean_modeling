#!/bin/bash
#

####    Script to download GFS

	today=20200501
	ndays=31
	here=`pwd`
	log='logfile.log'

	mdate=$today
	wesn_gfs='-167. -117. 15. 47.'

	yr=${today:0:4}
	mm=${today:4:2}
	dd=${today:6:2}

        #source $here/hindcast_setup.sh # will load dir names and other info

	#====================================================================================
	#echo >> $log ; cd $tmpdir; dr=`pwd`
	echo ; echo " ==> HERE I am @ $dr for step 02: download GFS data <=="; echo
	now=$(date "+%Y/%m/%d %T"); echo " ... starting download of GFS at $now" >> $log
	#====================================================================================

	echo
	echo " ... today is ${yr}-${mm}-${dd}"
	echo " ... will download $ndays days"
	echo " ... will store downloaded files in folder $stodir"
	echo

	nn=1
	while [ $nn -le $ndays ]; do 

          # will download a file named gfs_$today.nc
	  get_gfsanl4_historical_one_day.sh $today 
	  #get_gfs_g4files_hindcast_shortTerm_oneday.sh $today
	  #mv gfs_$today.nc trunk/.
	
	  today=`find_tomorrow.sh $yr $mm $dd`
          yr=${today:0:4}
          mm=${today:4:2}
          dd=${today:6:2} 

	  let nn=$nn+1

	done

	#cdo mergetime trunk/gfs_20*.nc wind_$mdate.nc

	# create a force file for WW3
	#fix_gfs_nomads4ww3.sh wind_$today.nc gfs_glo0.50_$today.nc $today

	# create a force file for ROMS
	#fix_gfs_nomads4roms.sh wind_$today.nc gfs_npo0.50_$today.nc $today $wesn_gfs


	#====================================================================================
	echo ; echo " ==> FINISHED downloading GFS <=="; echo
	now=$(date "+%Y/%m/%d %T"); echo " ... finished download at $now" >> $log
	#====================================================================================

	#cd $here

################################## *** the end *** ##############################################

