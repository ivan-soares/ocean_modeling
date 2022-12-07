#!/bin/bash
#

	today=$1
	ndays=$2
	ogcm=$3

	echo
	echo " ### Starting script to interp ROMS output to z levels ### "
	echo

################## *** interp outputs from sigma to z levels *** #############################################

        #### fix ndays in step00
        sed -i "/ndays=/ c\        ndays=$ndays "  expt_setup.sh

	source expt_setup.sh

	here=`pwd`
	cd $tmpdir

	echo " ... Here I am @ $tmpdir to do what I was told to do"
	echo 

	domainname="${domain_roms}_${version}"
	inpfile="$stodir/$today/roms_his_${domainname}_${today}_${ogcm}.nc"
	outfile="$stodir/$today/roms_zlevs_${domainname}_${today}_${ogcm}.nc"

	depth_sig="$here/d-interp/depths_sig.nc"
	depth_z="$here/d-interp/depths_glby.nc"

	vars="zeta,u_eastward,v_northward,temp,salt"

	n1=0
	n2=$nhrs_roms

	nx=`ncdump -h $depth_z | grep "lon ="   | awk '{print $3}'`
	ny=`ncdump -h $depth_z | grep "lat ="   | awk '{print $3}'`
	nz=`ncdump -h $depth_z | grep "level =" | awk '{print $3}'`

	echo " ... doing file $outfile"
	echo " ... will interp $nhrs_roms hrs"
	echo " ... sourcing roms cdf file, nx, ny, nz are: $nx, $ny, $nz"
	echo

	sed -e "s/YYYY-MM-DD/${yr}-${mm}-${dd}/g"\
	-e "s/NLON/$nx/g" -e "s/NLAT/$ny/g" -e "s/NDEP/$nz/g" \
	$here/d-interp/roms_YYYY-MM-DD_hrs.cdf >& cdf.cdf


	ncgen -k4 cdf.cdf -o $outfile
	rm cdf.cdf

	echo " ... extract time steps $n1 to $n2 from $inpfile"

	tmpfile="roms_${dd}.nc"
	ncks -d ocean_time,$n1,$n2 $inpfile $tmpfile

	echo " ... start interpolation now !!!!"

	cdo="$HOME/apps/cdo-1.9.7/bin/cdo -s --no_warnings"
	$cdo select,name=$vars $tmpfile tmp1.nc
	$cdo  intlevel3d,$depth_sig     tmp1.nc   $depth_z  tmp2.nc
	#$cdo  intlevelx3d,$depth_sig     tmp1.nc   $depth_z  tmp2.nc
	ncrename -v u_eastward,u -v v_northward,v tmp2.nc

	python $here/d-interp/write_roms_file.py tmp2.nc $outfile

	rm tmp* $tmpfile

	mv $outfile $stodir/$today/.

	#done

	echo 
	echo " ### End of vertical interp from sigma to z coord ### "
	echo

##################################  *** the end *** ############################################################
#
