#!/bin/bash
#
	echo
	echo " +++ Starting script to make a mean eta file for Santos Bay +++"
	echo

	grdfile="$HOME/roms/cases/sse/bsa0.10/grid/grid_bsa0.10_01a.nc"
	wesn_name="50W38W-30S21S" 
        today=20210801

	wesn='-50.0 -38.0 -30.0 -21.0'

	product=46

        yr=${today:0:4}
        mm=${today:4:2}
        dd=${today:6:2}

	########### download SLA from CMEMS

	outfile="sla_allsat_${wesn_name}_${yr}-${mm}-${dd}.nc"

	echo ; echo " ... downloading file $outfile "; echo

	get_cmems_sla.sh $today $wesn $product

	########## interp SLA to the resolution of ROMS grid

	cdo="cdo -s --no_warnings "

	rm -rf grid_r.nc weights_r.nc
        ncks -v lon_rho,lat_rho $grdfile grid_r.nc
        ncrename -h -O -v lon_rho,lon -v lat_rho,lat grid_r.nc
        $cdo genbil,grid_r.nc $outfile weights_r.nc
        $cdo remap,grid_r.nc,weights_r.nc $outfile sat_mean_eta.nc


	echo
	echo " +++ End of scxript +++"
	echo

#
#   the end
#
