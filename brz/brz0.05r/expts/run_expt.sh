#!/bin/bash
#

#    script to run the model ROMS

#

        set -o errexit    # will exit in case of fail
        set -o pipefail   # if one command ini the pipe fails the entire pipeline will fail
        set -o nounset    # when it encounters a variable that does not exist, it will report an error and stop executing. 
	#set -o xtrace    # output the executed command line before its execution result.

##############################   help text   #######################################################

	if [ "$1" == "-h" ]; then
		echo " "
		echo " Function run_expt.sh takes 4 arguments: "
		echo "                                                   "
		echo "    (1) start date (yyyymmdd)                      "
		echo "    (2) # of days in the forecast range            "
		echo "    (3) ogcm (glby/glbv/nemo)                      "
		echo "    (4) wind (gfs/cfsr)                            "
		echo "                                                   "
		echo " "
		exit 0
	fi

####################################################################################################

	#sleep 2s

	today=$1
	ndays=$2
	ogcm=$3
	wind=$4

	nsecs=120   # 120

        #### fix ndays & nsecs in step00

	sed -i "/ndays=/ c\        ndays=$ndays "  expt_setup.sh
	sed -i "/nsecs=/ c\        nsecs=$nsecs "  expt_setup.sh

	#### start logfile

	here=`pwd`
	log="$here/timelog_${ogcm}.$today"

	now=$(date "+%Y/%m/%d %T")

	echo  >& $log
	echo " ########## NEW LONGTERM OPERATIONAL HINDCAST @ $now ##########" >> $log
	echo  >> $log

	echo
	echo " ==> STARTING ROMS EXPT @ $now <== "
	echo

	args="$today $ogcm $wind $here $log"

##################################  DO IT  !!!  ####################################################


	./step05_run_roms.sh  $args ; wait 


################################# FINISH  ##########################################################

	now=$(date "+%Y/%m/%d %T")

	echo
	echo " ==> FINISHED ROMS EXPT @ $now <== "
	echo

	echo  >> $log
	echo "########## END OF LONG-TERM HINDCAST @ $now ##########" >> $log
	echo >> $log

	mv $log $here/d-logfiles/.

####################################################################################################

#                                  THE END

####################################################################################################

