#!/bin/bash
#

	###### issues to solve:

	###### Nothing for now !!!

	### export PATHs is necessary for the crontab
	### which will not source .bashrc because it doesnt run in a terminal

	scriptsdir=${HOME}/scripts/bash

	export PATH=${PATH}:${scriptsdir}
	export PATH=${PATH}:${scriptsdir}/find_fncts
	export PATH=${PATH}:${scriptsdir}/wget
	export PATH=${PATH}:${scriptsdir}/check

	echo
	echo " ==> Sourcing expt_setup.sh for general forecast settings <=="
	echo

	########################################################################
	#                                                                      #
	#                          DATE                                        #
	#                                                                      #
	########################################################################

	yr=${today:0:4}
	mm=${today:4:2}
	dd=${today:6:2}

	yesterday=`find_yesterday.sh $yr $mm $dd`
	tomorrow=`find_tomorrow.sh $yr $mm $dd`

	########################################################################
	#                                                                      #
	#                      GENERIC INFO                                    #
	#                                                                      #
	########################################################################

        ndays=30 
	nsecs=120           ### delta-t
	nfast=30            ### ext mode steps
	his_dh=3            ### roms output interval in hrs

	nsig=30
	incr='0.10'

	### DOMAIN NAME & GEOGRAPHICAL LIMITS

	appflag="BSA"
	mytitle="Bacia de Santos 1/10 degreee 49W-39W - 29.5N-22N (101x76x30)"
	varinfo="$HOME/roms/trunk/ROMS/External/varinfo.dat"

	region='sse'
	domain='bsantos'
	domain_roms='bsa0.10'
	version='01a'

	wesn_roms="-49.0 -39.0 -29.5 -22.0"

	### EXPT NAME
	expt="${domain_roms}_${version}_${today}"

	### WIND: used to compose force file name
	domain_wind='bsa0.50'  
	wind='gfs'

	### OGCM used in OBCs
	ogcm='glby'	

	### OUTPUT INTERVAL

	roms_his_dh=$his_dh
	nhrs_roms=`echo $ndays 24 $roms_his_dh | awk '{print $1*$2/$3 + 1}'`
	nsteps=`echo $ndays $nsecs | awk '{print int($1*24*3600/$2)}'`
	dt="${nsecs}.0d0"

	### NUDGING

	nudge_scl='exp_medium'

	floats='yes'
	stations='yes'

	# nrrec
	#  0 starts a new run
	# -1 restarts from last data in previous
	#  1 restarts from first data in previous
	nrrec=1          


	### FLAGS USED TO COMPOSE ROMS EXEC FILE NAME
	### WHEN USING TIDES, KEEP FLAG AS 'tide_with_ramp'
	### IF NO RESTART FILE IS FOUND, THE FLAG WILL CHANGE TO 'tide_no_ramp'

	ramp_flag='no_tide'         # either tide_with_ramp or tide_no_ramp or no_tide
	nudge_flag='nudge_by_user'  # either nudge_by_user  or ananudge
	avg_flag='avg_no_dqdsst'    # either avg or no_avg  or avg_no_dqdsst

	# MPI TILES
	ntile_i=2
	ntile_j=22
	let ntiles=${ntile_i}*${ntile_j}



	########################################################################
	#                                                                      #
	#                   SPECIFIC INFO FOR ROMS                             #
	#                                                                      #
	########################################################################

	# ref day
	refday=20000101
	reftime=$refday

	# nudging
	tnudg=360.0       #0.3333
	znudg=360.0       #0.0833
	obcfac=360.0      #120.0

	# sigma coord params
	spheri='1'
	vtrans='2'
	vstret='4'
	thetas='4.0'
	thetab='4.0'
	tcline='100'
	hc='100'

	sig_params="$spheri $vtrans $vstret $thetas $thetab $tcline $hc $nsig"

	########################################################################
	#                                                                      #
	#                     INFO FOR SIG2Z                                   #
	#                                                                      #
	########################################################################


	depths_hncoda="0, 2, 4, 6, 8, 10, 12, 15, 20, 25, 30, 35, 40, 45, 50,  \
	60, 70, 80, 90, 100, 125, 150, 200, 250, 300, 350, 400, 500, 600, 700, \
	800, 900, 1000, 1250, 1500, 2000, 2500, 3000, 4000, 7000"

	depths_nemo="0., 1.541375, 2.645669, 3.819495, 5.078224, 6.440614,    \
	7.92956, 9.572997, 11.405, 13.46714, 15.81007, 18.49556, 21.59882,    \
	25.21141, 29.44473, 34.43415, 40.34405, 47.37369, 55.76429, 65.80727, \
	77.85385, 92.32607, 109.7293, 130.666, 155.8507, 186.1256, 222.4752,  \
	266.0403, 318.1274, 380.213, 453.9377, 541.0889, 643.5668, 763.3331,  \
	902.3393, 1062.44, 1245.291, 1452.251, 1684.284, 1941.893, 2225.078,  \
	2533.336, 2865.703, 3220.82, 3597.032, 3992.484, 4405.224, 4833.291,  \
	5274.784, 7000.000"

	########################################################################
	#                                                                      #
	#                      FILE & DIR NAMES                                #
	#                                                                      #
	########################################################################

	interp4roms="$HOME/scripts/4roms"
	pythdir="$HOME/scripts/python"

	operdir=`pwd`
	stodir="$operdir/d-storage"
	report="$operdir/d-bulletin"
	logdir="$operdir/d-logfiles"
	tmpdir="$operdir/d-temporary"
	trunk="$operdir/d-trunk"

	#stodir="$HOME/mdata/${domain_roms}/outputs/"

	if [ ! -e $logdir ]; then mkdir -p $logdir;fi
	if [ ! -e $stodir ]; then mkdir -p $stodir;fi
	if [ ! -e $tmpdir ]; then mkdir -p $tmpdir;fi
	if [ ! -e $trunk ];  then mkdir -p $trunk;fi

	### roms dirs:

	roms_codedir="$HOME/operational/roms/code"

	casedir="$HOME/roms/cases/$region/$domain_roms"
	romsgrd="$casedir/grid/grid_${domain_roms}_${version}.nc"
	romstid="$casedir/tide/tide_${domain_roms}_${version}_${yr}_ref2000.nc"
	romsnud="$casedir/nudge/nudge_${domain_roms}_${version}_${nudge_scl}.nc"
	romsriv="$casedir/river/river_${domain_roms}_${version}_${yr}0101_ref2000.nc"

	romsfrc="$casedir/force/d-storage/force_${wind}_${domain_wind}_${today}_366d_no_dqdsst.nc" # force file for roms
	romsclm="$casedir/clim/d-storage/glby_bsa0.10/input_clm_${domain_roms}_${version}_${today}_366d_${ogcm}.nc" # clim file for roms
	romsbry="$casedir/clim/d-storage/glby_bsa0.10/input_bry_${domain_roms}_${version}_${today}_366d_${ogcm}.nc" # bdry file for roms
	romssst="$casedir/clim/d-storage/glby_bsa0.10/input_clm_${domain_roms}_${version}_${today}_366d_${ogcm}.nc" # surf file for roms

	romsini="$casedir/d-storage/yesterday/roms_rst_${domain_roms}_${version}_${today}_${ogcm}.nc"
	ogcmfile="$casedir/clim/d-inputs/hncoda_bsa0.08_06h/glby_20210101.nc" # ogcm file for roms

	romsstn="$casedir/grid/roms_stations_${domain_roms}_${version}.in"
	romsflt="$casedir/grid/roms_floats_${domain_roms}_${version}.in"

	echo " ... roms grid file is $romsgrd"


	nx=`cdo -s --no_warnings -griddes $romsgrd | grep xsize  | grep -m1 "" | awk '{print $3}'`
	ny=`cdo -s --no_warnings -griddes $romsgrd | grep ysize  | grep -m1 "" | awk '{print $3}'`
	x1=`cdo -s --no_warnings  info    $romsgrd | grep " 23 : " | awk '{printf "%.2f",  $9}'`
	x2=`cdo -s --no_warnings  info    $romsgrd | grep " 23 : " | awk '{printf "%.2f", $11}'`
	y1=`cdo -s --no_warnings  info    $romsgrd | grep " 24 : " | awk '{printf "%.2f",  $9}'`
	y2=`cdo -s --no_warnings  info    $romsgrd | grep " 24 : " | awk '{printf "%.2f", $11}'`

	lonlatbox="$x1 $x2 $y1 $y2"

	echo " ... grid box is $lonlatbox"

	nlon=$nx
	nlat=$ny
	lon1=$x1
	lon2=$x2
	lat1=$y1
	lat2=$y2

	nz=$ndep

	dlon=$incr
	dlat=$incr

	echo 
	echo " ... grid size is $nlon lons,  $nlat lats, $nz layers"
	echo

	###############################################################################################
	#                                                                                             #
	#                                     THE END                                                 #
	#                                                                                             #
	###############################################################################################

:1EP EXPT *
