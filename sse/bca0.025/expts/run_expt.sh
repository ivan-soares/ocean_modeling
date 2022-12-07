#!/bin/bash
#

#    script to run 7-day forecast

#    will download GFS and HNCODA and create files:
#
#         gfs_bsa0.02_today.nc
#         gfs_atl1.00_today.nc
#
#    will run ROMS and WW3 and create the files:
#
#         roms_domain_version_today_ogcm_his.nc
#         roms_domain_version_today_ogcm_rst.nc
#         ww3_domain_version_today.nc
#         restart_xxxx
#

	set -o nounset
	set -o errexit
	set -o pipefail

##############################   help text   #######################################################

	if [ "$1" == "-h" ]; then
		echo " "
		echo " Function run_expt.sh takes 4 arguments:           "
		echo "                                                   "
		echo "    (1) start date (yyyymmdd)                      "
		echo "    (2) n. of days to run (ndays)                  "
		echo "    (3) ogcm (glby/glbv/nemo)                      "
		echo "                                                   "
		echo "    (4) step:                                      "
		echo "                                                   "
		echo "        1 start new expt                           "
		echo "        2 download gfs data                        "
		echo "        3 download ogcm data                       "
		echo "        4 make clim files for ROMS                 "
		echo "        5 run the model ROMS                       "
		echo "                                                   "
		echo "       99 do it all                                "
		echo "                                                   "
		echo "    Example:  20190801 7 nemo 99                   "
		echo " "
		exit 0
	fi

####################################################################################################

	sleep 2s

	today=$1
	ndays=$2

	ogcm='glorys'
	N=5

	#### fix ndays in step00

	sed -i "/ndays=/ c\        ndays=$ndays "  expt_setup.sh

	#### start logfile

	here=`pwd`
	log="$here/timelog_${ogcm}.$today"
	echo  >& $log

	#### get today's date	

	now=`date`

	echo
	echo " ==> STARTING ROMS/WW3 7-DAY FORECAST @ $now <== "
	echo

	args="$today $ogcm $here $log"

##################################  DO IT ALL !!!  #################################################

	if  [ $N ==  1 -o $N == 99 ]; then ./step01_startup.sh          $args ; wait ; fi

	if  [ $N ==  2 -o $N == 99 ]; then ./step02_download_force.sh   $args ; wait ; fi

	if  [ $N ==  3 -o $N == 99 ]; then ./step03_download_ogcm.sh    $args ; wait ; fi

	if  [ $N ==  4 -o $N == 99 ]; then ./step04_make_clim4roms.sh   $args ; wait ; fi

	if  [ $N ==  5 -o $N == 99 ]; then ./step05_run_roms.sh         $args ; wait ; fi


################################# FINISH  ##########################################################

	now=`date`

	echo
	echo " ==> FINISHED ROMS/WW3 7-DAY FORECAST @ $now <== "
	echo

	echo  >> $log
	now=$(date "+%Y/%m/%d %T"); echo " ==> finished forecast cycle at $now" >> $log
	echo >> $log

	mv $log $here/d-logfiles/$today/.

####################################################################################################

#                                  THE END

####################################################################################################

