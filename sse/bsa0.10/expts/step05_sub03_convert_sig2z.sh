#!/bin/bash
#

	domainname="${domain_roms}_${version}"

################## *** convert outputs from sigma to z levels *** #############################################

	echo " ... interp ROMS output from sigma to z coord "

	inpfile="$stodir/$today/roms_his_${domainname}_${today}_${ogcm}.nc"
	#outfile="$stodir/$today/roms_zlevs_${domainname}_${today}_${ogcm}.nc"

	depth_sig="$here/d-interp/depths_sig.nc"
	depth_z="$here/d-interp/depths_glby.nc"

	vars="zeta,u_eastward,v_northward,temp,salt"

	n1=0
	#n2=23
	n2=$nrhs_roms

        nx=`ncdump -h $depth_z | grep "lon ="   | awk '{print $3}'`
        ny=`ncdump -h $depth_z | grep "lat ="   | awk '{print $3}'`
        nz=`ncdump -h $depth_z | grep "level =" | awk '{print $3}'`

	mdate=$today

	#for d in $(seq 1 $ndays); do

	    #outfile="$stodir/$today/roms_zlevs_${domainname}_${mdate}_${ogcm}.nc"
	    outfile="roms_zlevs_${domainname}_${mdate}_${ogcm}.nc"
	    echo " ... doing file $outfile"
	    echo " ... sourcing roms cdf file, nx, ny, nz are: $nx, $ny, $nz"

	    sed -e "s/YYYY-MM-DD/${yr}-${mm}-${dd}/g"\
                -e "s/NLON/$nx/g" -e "s/NLAT/$ny/g" -e "s/NDEP/$nz/g" \
                $here/d-interp/roms_YYYY-MM-DD_hrs.cdf >& cdf.cdf


            ncgen -k4 cdf.cdf -o $outfile
	    rm cdf.cdf

	    tmpfile="roms_${dd}.nc"
	    ncks -d ocean_time,$n1,$n2 $inpfile $tmpfile

	    cdo="$HOME/apps/cdo-1.9.7/bin/cdo -s --no_warnings"
	    $cdo select,name=$vars $tmpfile tmp1.nc
	    $cdo  intlevelx3d,$depth_sig     tmp1.nc   $depth_z  tmp2.nc
	    ncrename -v u_eastward,u -v v_northward,v tmp2.nc

	    python $here/d-interp/write_roms_file.py tmp2.nc $outfile

	    mdate=`find_tomorrow.sh $yr $mm $dd`
	    yr=${mdate:0:4}
	    mm=${mdate:4:2}
	    dd=${mdate:6:2}

	    let n1=$n1+24
	    let n2=$n2+24

	    rm tmp* $tmpfile

	    mv $outfile $stodir/$today/.

        #done

	echo " ... end of vertical interp from sigma to z coord "

##################################  *** the end *** ############################################################
#
