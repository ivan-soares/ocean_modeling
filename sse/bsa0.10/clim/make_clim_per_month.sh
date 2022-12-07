#!/bin/bash
#

##############################################################################################

	today=20150101
	ndays=366
        nhrs=18
        dh=06

	echo
	echo " ### STARTING code to make clim file for roms ###"
	echo

        md=$today
        yr=${today:0:4}
        mm=${today:4:2}
        dd=${today:6:2}

        echo " ... start date is $yr/$mm/$dd"

#################### main configurations are here ############################################

        domain='npo0.08n'
        version='07f'
        ogcm='glbv'

	comp="${ndays}d_06h"

        nsig=30
        rotang="0."
        reftime='20000101'
        wesn_ogcm="-167. -117. 15. 47."

        ntimes=`echo $ndays $nhrs $dh | awk '{print $1*($2/$3 + 1) +1}'`

	echo
        echo " ... will run for $ndays days"
        echo " ... with ogcm data interval of $dh hours"
        echo " ... resulting in $ntimes times"
        echo

#################### choose the number of layers in OGCM data set ########################## 

	if [ $ogcm == 'glby' ]; then
		ogcm_dt=3
		ndep=40
	elif [ $ogcm == 'glbv' ]; then
                ogcm_dt=6
                ndep=40
	elif [ $ogcm == 'nemo' ]; then
		ogcm_dt=24
		ndep=50
	else
		echo; echo ' ... dont know this ogcm name, exiting'
		echo; exit
	fi
	
	echo
	echo " ... will read $ndep layers in $ogcm file $ogcmfile"
	echo

#################### sigma coordinate parameters #############################################

	spheri='1'
	vtrans='2'
	vstret='4'
	thetas='10.0'
	thetab='4.0'
	tcline='150'
	hc='150'

	sig_params="$spheri $vtrans $vstret $thetas $thetab $tcline $hc $nsig"

#################### file & dir names ########################################################


	ogcmdir="d-inputs/hycom"
	ogcmfile="$ogcmdir/${ogcm}_${today}_${comp}.nc"

	interp4roms="$HOME/oper/scripts/4roms"

	romsgrd="grid_${domain}_${version}.nc"
	romsclm="roms_clm_$today.nc"
	romsbry="roms_bry_$today.nc"

	cdo="$HOME/apps/cdo-1.9.7/bin/cdo -s --no_warnings"
	cdo="cdo -s --no_warnings"

################## here we start interpolating OGCM data #####################################


	### interpolate all ogcm vars to the resolution of grid_r.nc 
	###     (assuming all ogcm vars are in grid A locations)

	rm -rf clim_${ogcm}_$today.nc clim_${ogcm}_${today}_nonans.nc
	rm -rf clim_${ogcm}_${today}_sig.nc ${ogcm}_${today}.nc
	rm -rf grid_r.nc weights_r.nc tmp* 
	cp d-interp/grid_r.nc .

	#dt=`echo $dh $ogcm_dt | awk '{printf "%d", $1/$2}'` 
	#ncks -d time,0,7,$dt ${ogcmdir}/${ogcm}_${today}.nc ${ogcm}_${today}.nc
	#ncks -d time,0 ${ogcmdir}/${ogcm}_${today}.nc ${ogcm}_${today}.nc
        #wait

        $cdo genbil,grid_r.nc ${ogcmfile} weights_r.nc
	$cdo remap,grid_r.nc,weights_r.nc ${ogcmfile} clim_${ogcm}_$today.nc

	#### interp to sigma levels
	depth_z="d-interp/${ogcm}2sig/depths_z.nc"
	depth_sig="d-interp/${ogcm}2sig/depths_sig.nc"
        $cdo intlevelx3d,$depth_z clim_${ogcm}_${today}.nc $depth_sig clim_${ogcm}_${today}_sig.nc
        cp clim_${ogcm}_${today}_sig.nc clim_${ogcm}_${today}_nonans.nc

        #### inpaint nans on ogcm file
	#### will read clim_${ogcm}_$today_sig.nc and write clim_${ogcm}_${today}_nonans.nc
	#### will need a mask file

	tmpmsk="$HOME/oper/pacific_npo/forecast/d-interp/glby2sig/roms_npo0.08_07e_tmpmsk.nc"

	python $interp4roms/make_clim_step01_inpaint_nans_on_remaped_ogcm.py $today $ogcm $ntimes $nsig $dh \
	       grid_${domain}_${version}.nc clim_${ogcm}_$today $tmpmsk

	wait

        #### ncgen: create empty clim and bdry files
	nlon=`ncdump -h $romsgrd | grep 'xi_rho = ' | awk '{print $3}'`
        nlat=`ncdump -h $romsgrd | grep 'eta_rho = ' | awk '{print $3}'`

	echo
	echo " ... writing clm & bry files, nlon/nlat/nsig = $nlon/$nlat/$nsig"
	echo " ... reftime is $reftime"
	echo 

        create_ncfiles_clm+bry.sh $reftime $nlon $nlat 30
        mv clm.nc $romsclm
        mv bry.nc $romsbry

	#### read ogcm and write roms clm & bry files
        python $interp4roms/make_clim_step02_write_clm_bry_files.py $ntimes $today $ogcm $rotang $sig_params \
		clim_${ogcm}_${today}_nonans.nc $romsgrd $romsclm $romsbry


        echo
        echo " ### END of code ###"
        echo



#
#  the end
#
