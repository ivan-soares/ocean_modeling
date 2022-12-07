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

	yesterday='20131201'
	tomorrow='20140110'
	#yesterday=`find_yesterday.sh $yr $mm $dd`
	#tomorrow=`find_tomorrow.sh $yr $mm $dd`

	########################################################################
	#                                                                      #
	#                      GENERIC INFO                                    #
	#                                                                      #
	########################################################################

        ndays=10 
        nsecs=45 
	nfast=30            ### ext mode steps
	his_dh=6            ### roms output interval in hrs

	nsig=30
	incr='0.025'

	### DOMAIN NAME & GEOGRAPHICAL LIMITS

	appflag="BCA"
	mytitle="Campos Basin ${yr}, 1/40 deg, 45.15W-35.15W - 26.50S-19.25S (401x291x30)"
	varinfo="$HOME/roms/trunk/ROMS/External/varinfo.dat"

	region='sse'
	domain='bca0.025'
	domain_roms='bca0.025'
	version='01b'

	wesn_roms="-45.15 -35.15 -26.50 -19.25"

	### EXPT NAME
	expt="${domain_roms}_${version}_${today}"

	### WIND: used to compose force file name
	domain_wind='bca0.25'  
	wind='cfsr'

	### OGCM used in OBCs: this comes in as argument
	#ogcm='nemo'	

	### OUTPUT INTERVAL

	roms_his_dh=$his_dh
	nhrs_roms=`echo $ndays 24 $roms_his_dh | awk '{print $1*$2/$3 + 1}'`
	nsteps=`echo $ndays $nsecs | awk '{print int($1*24*3600/$2)}'`
	dt="${nsecs}.0d0"

	### NUDGING

	nudge_scl='exp_medium'

	floats='no'
	stations='no'

	# nrrec
	#  0 starts a new run
	# -1 restarts from last data in previous
	#  1 restarts from first data in previous
	nrrec=-1

        # Logical switch (T/F) used to recycle time records in restart file.  
        # If TRUE, only the latest two re-start time records are maintained.  
        # If FALSE, all re-start fields are saved every NRST timesteps.

        lcycle_rst='T'

	### FLAGS USED TO COMPOSE ROMS EXEC FILE NAME
	### WHEN USING TIDES, KEEP FLAG AS 'tide_with_ramp'
	### IF NO RESTART FILE IS FOUND, THE FLAG WILL CHANGE TO 'tide_no_ramp'

	ramp_flag='no_tide'         # either tide_with_ramp or tide_no_ramp or no_tide
	nudge_flag='nudge_by_user'  # either nudge_by_user  or ananudge
	avg_flag='avg_no_dqdsst'    # either avg or no_avg  or avg_no_dqdsst

	# MPI TILES
	ntile_i=8
	ntile_j=5
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

	exptdir=`pwd`
	stodir="$exptdir/d-storage"
	logdir="$exptdir/d-logfiles"
	tmpdir="$exptdir/d-temporary"
	trunk="$exptdir/d-trunk"


	if [ ! -e $logdir ]; then mkdir -p $logdir;fi
	if [ ! -e $stodir ]; then mkdir -p $stodir;fi
	if [ ! -e $tmpdir ]; then mkdir -p $tmpdir;fi
	if [ ! -e $trunk ];  then mkdir -p $trunk;fi

	### roms dirs:

	roms_codedir="$HOME/operational/roms/code"

	casedir="$HOME/roms/cases/$region/$domain"
	romsgrd="$casedir/grid/grid_${domain_roms}_${version}.nc"
	romstid="$casedir/tide/tide_${domain_roms}_${version}_${yr}_ref2000.nc"
	romsnud="$casedir/nudge/nudge_${domain_roms}_${version}_${nudge_scl}.nc"
	romsriv="$casedir/river/river_${domain_roms}_${version}_${yr}0101_ref2000.nc"

	romsfrc="$casedir/force/d-storage/force_${domain_wind}_${yr}_${wind}_03h.nc" # force file for roms

	romsclm="$casedir/clim/d-storage/input_clm_${domain_roms}_${version}_${yr}0101_${ogcm}_365d.nc" # clim file for roms
	romsbry="$casedir/clim/d-storage/input_bry_${domain_roms}_${version}_${yr}0101_${ogcm}_365d.nc" # bdry file for roms
	
	romsini="$casedir/expts/d-storage/${yesterday}/roms_rst_${domain_roms}_${version}_${today}.nc " # roms rst file

        #romsclm="$casedir/clim/d-storage/input_clm_${today}.nc"
	#romsbry="$casedir/clim/d-storage/input_bry_${today}.nc"

	#romsclm="$HOME/storage_at02/roms_clim/toc/npo0.08/hncoda/input_clm_npo0.08_07e_${today}_${ogcm}_365d_06h.nc"
	#romsbry="$HOME/storage_at02/roms_clim/toc/npo0.08/hncoda/input_bry_npo0.08_07e_${today}_${ogcm}_365d_06h.nc"
	#romsini="$HOME/storage_at02/roms_outputs/toc/npo0.08/roms+cfsr03h+hncoda06h/${yesterday}/roms_rst_npo0.08_07e_${today}.nc"

	romsstn="$casedir/grid/roms_stations_${domain_roms}_${version}.in"
	romsflt="$casedir/grid/roms_floats_${domain_roms}_${version}.in"

	echo " ... roms grid file is $romsgrd"

        if [ -e  lonlat1.nc ]; then rm  lonlat1.nc; fi
        if [ -e  lonlat2.nc ]; then rm  lonlat2.nc; fi
        ncks -v lon_rho,lat_rho -d eta_rho,0 -d xi_rho,0   $romsgrd lonlat1.nc
        ncks -v lon_rho,lat_rho -d eta_rho,-1 -d xi_rho,-1 $romsgrd lonlat2.nc

        nx=`ncdump -h $romsgrd | grep "xi_rho = " | awk '{print $3}'`
        ny=`ncdump -h $romsgrd | grep "eta_rho = " | awk '{print $3}'`
        x1=`ncdump lonlat1.nc | grep -A1 "lon_rho =" | column | awk '{print $3}'`
        y1=`ncdump lonlat1.nc | grep -A1 "lat_rho =" | column | awk '{print $3}'`
        x2=`ncdump lonlat2.nc | grep -A1 "lon_rho =" | column | awk '{print $3}'`
        y2=`ncdump lonlat2.nc | grep -A1 "lat_rho =" | column | awk '{print $3}'`

        #nx=`cdo -s --no_warnings -griddes $romsgrd | grep xsize  | grep -m1 "" | awk '{print $3}'`
        #ny=`cdo -s --no_warnings -griddes $romsgrd | grep ysize  | grep -m1 "" | awk '{print $3}'`
        #x1=`cdo -s --no_warnings  info    $romsgrd | grep " 23 : " | awk '{printf "%.2f",  $9}'`
        #x2=`cdo -s --no_warnings  info    $romsgrd | grep " 23 : " | awk '{printf "%.2f", $11}'`
        #y1=`cdo -s --no_warnings  info    $romsgrd | grep " 24 : " | awk '{printf "%.2f",  $9}'`
        #y2=`cdo -s --no_warnings  info    $romsgrd | grep " 24 : " | awk '{printf "%.2f", $11}'`

	lonlatbox="$x1 $x2 $y1 $y2"

	echo " ... grid box is $lonlatbox"

	nlon=$nx
	nlat=$ny
	lon1=$x1
	lon2=$x2
	lat1=$y1
	lat2=$y2

	nz=$nsig

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


