#!/bin/bash
#

##############################################################################################

	today=20150201
	ndays=335
        nhrs=24
        dh=24
	nn=1

	ogcm='nemo'
        domain='bsa0.10'
        version='01a'

	echo
	echo " ### STARTING code to make clim file for roms ###"
	echo

        md=$today
        yr=${md:0:4}
        mm=${md:4:2}
        dd=${md:6:2}

        echo " ... start date is $yr/$mm/$dd"

#################### main configurations are here ############################################


	comp="${ndays}d_06h"

        nsig=30
        rotang="0."
        reftime='20000101'
        wesn_ogcm="-167. -117. 15. 47."

        ntimes=`echo $nhrs $dh | awk '{print $1/$2}'`

	echo
        echo " ... will run for $ndays days"
        echo " ... with ogcm data interval of $dh hours"
        echo " ... resulting in $ntimes times"
        echo

#################### choose the number of layers in OGCM data set ########################## 

	if [ $ogcm == "glby"  -o $ogcm == "glbv" ]; then
		ogcm_dt=6
		ndep=40
	elif [ $ogcm == "nemo" -o $ogcm == "glorys" ]; then
		ogcm_dt=24
		ndep=50
	else
		echo; echo ' ... dont know this ogcm name, exiting'
		echo; exit
	fi
	
	echo
	echo " ... will read $ndep layers in $ogcm file"
	echo

	dt=`echo $dh $ogcm_dt | awk '{printf "%d", $1/$2}'`
        nt=`echo  $nhrs  $dh  | awk '{printf "%d", $1/$2}'`

        echo " ... will extract the first $nt data from ogcm file"
	echo " ... with interval of $dt time steps" 
	echo

#################### sigma coordinate parameters #############################################

	spheri='1'
	vtrans='2'
	vstret='4'
	thetas='4.0'
	thetab='4.0'
	tcline='100'
	hc='100'

	sig_params="$spheri $vtrans $vstret $thetas $thetab $tcline $hc $nsig"

#################### file & dir names ########################################################

	ogcmdir="d-inputs/glbv_brz0.08_06h"
	ogcmdir="d-inputs/glorys_brz0.08_24h"
	tmpogcm="$ogcmdir/glorys_brz_YYYYMMDD.nc"

	interp4roms="$HOME/scripts/4roms"

	romsgrd="grid_${domain}_${version}.nc"
	tmpclm="roms_clm_YYYYMMDD.nc"
	tmpbry="roms_bry_YYYYMMDD.nc"

	cdo="$HOME/apps/cdo-2.0.0/bin/cdo -s --no_warnings"
	cdo="cdo -s --no_warnings"

################## here we start interpolating OGCM data #####################################

	#### the weights used in cdo remap command are done only once
	#### so, command 'genbil' stays out of the loop.


	ogcmfile=${tmpogcm/YYYYMMDD/$today}
	#ncks -d time,0,$nt,$dt ${ogcmfile} tmpfile.nc
	cp ${ogcmfile} tmpfile.nc

	rm -rf grid_r.nc weights_r.nc 
        cp d-interp/grid_r.nc grid_r.nc
	$cdo genbil,grid_r.nc tmpfile.nc weights_r.nc
	rm tmpfile.nc

	
	while [ $nn -le $ndays ] ; do


		ogcmfile=${tmpogcm/YYYYMMDD/$md}
		romsclm=${tmpclm/YYYYMMDD/$md}
		romsbry=${tmpbry/YYYYMMDD/$md}

		echo " ... working on file $ogcmfile"; echo

		### interpolate all ogcm vars to the resolution of grid_r.nc 
		###     (assuming all ogcm vars are in grid A locations)

		rm -rf clim_${ogcm}_${md}.nc clim_${ogcm}_${md}_nonans.nc
		rm -rf clim_${ogcm}_${md}_sig.nc ${ogcm}_${md}.nc

		#ncks -d time,0,$nt,$dt ${ogcmfile} tmpfile.nc; wait
		cp ${ogcmfile} tmpfile.nc; wait

                echo " ... CDO remap"; echo

		#$cdo genbil,grid_r.nc tmpfile.nc weights_r.nc
		$cdo remap,grid_r.nc,weights_r.nc tmpfile.nc clim_${ogcm}_${md}.nc
		rm tmpfile.nc

		echo " ... CDO intlevel"; echo

		#### interp to sigma levels
		depth_z="d-interp/depths_nemo.nc"
		depth_sig="d-interp/depths_sig.nc"
		$cdo intlevel3d,$depth_z clim_${ogcm}_${md}.nc $depth_sig clim_${ogcm}_${md}_sig.nc
		cp clim_${ogcm}_${md}_sig.nc clim_${ogcm}_${md}_nonans.nc

		#### inpaint nans on ogcm file
		#### will read clim_${ogcm}_$md_sig.nc and write clim_${ogcm}_${md}_nonans.nc
		#### will need a mask file

		tmpmsk="d-interp/roms_${domain}_${version}_tmpmsk.nc"

		python $interp4roms/make_clim_step01_inpaint_nans_on_remaped_ogcm.py $md $ogcm $ntimes $nsig $dh \
		       grid_${domain}_${version}.nc clim_${ogcm}_$md $tmpmsk

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
		python $interp4roms/make_clim_step02_write_clm_bry_files.py $ntimes $md $ogcm $rotang $sig_params \
			clim_${ogcm}_${md}_nonans.nc $romsgrd $romsclm $romsbry

		rm clim_${ogcm}_${md}*

		md=`find_tomorrow.sh $yr $mm $dd`
		yr=${md:0:4}
		mm=${md:4:2}
		dd=${md:6:2}

		let nn=$nn+1


	done

        echo
        echo " ### END of code ###"
        echo



#
#  the end
#
