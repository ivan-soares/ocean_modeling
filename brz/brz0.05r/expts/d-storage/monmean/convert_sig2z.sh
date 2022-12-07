#!/bin/bash
#

	today=$1
	ogcm='bc_transp'

	echo
	echo " ### Starting script to interp ROMS output to z levels ### "
	echo

################## *** interp outputs from sigma to z levels *** #############################################


	here=`pwd`

	domain="brz0.05r_01d"
	inpfile="roms_monmean_${domain}_${today}.nc"
	outfile1="roms_monmean_${domain}_${today}_regridded_sigma.nc"
	outfile2="roms_monmean_${domain}_${today}_regridded_zlevs.nc"

	depth_s="$here/d-interp/depths_sig_${domain}.nc"
	depth_z="$here/d-interp/depths_${ogcm}_${domain}.nc"


	nx=`ncdump -h $depth_z | grep "lon ="   | awk '{print $3}'`
	ny=`ncdump -h $depth_z | grep "lat ="   | awk '{print $3}'`
	nz=`ncdump -h $inpfile | grep "s_rho =" | awk '{print $3}'`

	echo
	echo " ... starting horizontal rotation now !!!"
	echo " ... rotated values will be written on file $outfile1"
	echo " ... and are sized $nx x $ny x $nz"
	echo

	if [ -e $outfile1 ]; then rm $outfile1; fi
	if [ -e $outfile2 ]; then rm $outfile2; fi


	sed -e "s/YYYY-MM-DD/2000-01-01/g" \
	-e "s/NLON/$nx/g" -e "s/NLAT/$ny/g" -e "s/NDEP/$nz/g" \
	$here/d-interp/roms_YYYY-MM-DD_hrs_regridded_sigma.cdf >& cdf.cdf


	ncgen -k4 cdf.cdf -o $outfile1
	rm cdf.cdf

	python $here/d-interp/write_roms_file_regridded_sigma.py $inpfile $outfile1


	echo
	echo " ... starting vertical interpolation now !!!!"
	echo " ... will write zlevel values on file $outfile1"
	echo 

	cdo="$HOME/apps/cdo-1.9.7.1/bin/cdo -s --no_warnings"
	cdo="cdo -s --no_warnings"
	
	$cdo  intlevel3d,$depth_s      $outfile1   $depth_z  tmp1.nc
	#$cdo  intlevelx3d,$depth_s    $outfile1   $depth_z  tmp1.nc

	echo
	echo " ... rewrite recently interpolated file with new missval"
	echo

	cdo -setmissval,NaN tmp1.nc tmp2.nc
	cdo -setmissval,-9999. tmp2.nc tmp3.nc

	nz=`ncdump -h $depth_z | grep "level =" | awk '{print $3}'`

	sed -e "s/YYYY-MM-DD/2000-01-01/g" \
        -e "s/NLON/$nx/g" -e "s/NLAT/$ny/g" -e "s/NDEP/$nz/g" \
        $here/d-interp/roms_YYYY-MM-DD_hrs_regridded_zlevs.cdf >& cdf.cdf

	ncgen -k4 cdf.cdf -o $outfile2
        rm cdf.cdf

	python $here/d-interp/write_roms_file_zlevs.py tmp3.nc $outfile2
	rm tmp*

	echo 
	echo " ### End of vertical interp from sigma to z coord ### "
	echo

##################################  *** the end *** ############################################################
#
