#!/bin/bash
#

	today=20140101
	ndays=1
	nhrs=18
	dh=6

        domain='brz0.05r'
        version='01a'
        ogcm='glbv'

	echo
	echo " ### STARTING code to make clim file for roms ###"
	echo

        md=$today
        yr=${today:0:4}
        mm=${today:4:2}
        dd=${today:6:2}

	echo " ... start date is $yr/$mm/$dd"

	ntimes=`echo $ndays $nhrs $dh | awk '{print $1*($2/$3 + 1) +1}'`
	ndep=40
	nsig=30

	echo " ... will run for $ndays days"
	echo " ... with ogcm data interval of $dh hours"
	echo " ... resulting in $ntimes times"
	echo

	rotang="37."
        reftime='20000101'
        wesn_ogcm="-56. -25. -42. 0."

        #### sigma coordinate params:

        spheri='1'
        vtrans='2'
        vstret='4'
        thetas='4.0'
        thetab='4.0'
        tcline='100'
        hc='100'

	sig_params="$spheri $vtrans $vstret $thetas $thetab $tcline $hc $nsig"

	### file names

	ogcmfile="storage/hncoda_${today}.nc"
	romsclm="roms_clm_$today.nc"
	romsbry="roms_bry_$today.nc"
	grdfile="grid_${domain}_${version}.nc"

	cdo="$HOME/apps/cdo-1.9.7/bin/cdo -s --no_warnings"
	cdo="cdo -s --no_warnings"

	### interpolate all ogcm vars to grid_r.nc 
	### (assuming all ogcm vars are in grid A locations)

	rm -rf rotated_${ogcm}_$today.nc
	rm -rf grid_r.nc weights_r.nc
	cp trunk/grid_r_brz0.05r_01a.nc     grid_r.nc
        #cp trunk/weights_r_brz0.05r_01a.nc  weights_r.nc

	echo " ... cdo genbil & remap: 2D interps"

        $cdo genbil,grid_r.nc $ogcmfile weights_r.nc
	$cdo remap,grid_r.nc,weights_r.nc $ogcmfile rotated_${ogcm}_$today.nc
	cp rotated_${ogcm}_$today.nc rotated_${ogcm}_${today}_nonans.nc


        #### inpaint nans on ogcm file
	#### will read rotated_${ogcm}_$today.nc and write rotated_${ogcm}_${today}_nonans.nc

	python make_rotated_clim_step01_inpaint_nans_on_ogcm.py $today $ogcm $rotang $ntimes $ndep $dh \
	       grid_${domain}_${version}.nc rotated_${ogcm}_$today

	echo " ... cdo intlevel3D: vertical interp"

	#### interp to sigma levels
	depth_z=glby2sig/depths_z.nc
	depth_sig=glby2sig/depths_sig.nc
        $cdo intlevel3d,$depth_z rotated_${ogcm}_${today}_nonans.nc $depth_sig rotated_${ogcm}_${today}_sig.nc

        #### ncgen: create empty clim and bdry files
	nlon=`ncdump -h grid_r.nc | grep 'nx = ' | awk '{print $3}'`
        nlat=`ncdump -h grid_r.nc | grep 'ny = ' | awk '{print $3}'`

	echo
	echo " ... writing clm & bry files, nlon/nlat = $nlon/$nlat"
	echo

        create_ncfiles_clm+bry.sh $reftime $nlon $nlat $nsig
        mv clm.nc $romsclm
        mv bry.nc $romsbry

	#### read ogcm and write roms clm & bry files
        python make_rotated_clim_step02_write_clm_bry_files.py $ntimes $today $ogcm $sig_params \
		rotated_${ogcm}_${today}_sig.nc $grdfile $romsclm $romsbry


        echo
        echo " ### END of code ###"
        echo



#
#  the end
#
