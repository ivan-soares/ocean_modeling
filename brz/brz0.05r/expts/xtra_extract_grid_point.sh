#!/bin/bash
#

	f1="d-temporary/roms_in/roms_clm.nc"
	f2="d-temporary/roms_out/roms_his.nc"

	out1="hycom.nc"
	out2="roms.nc"

	lo=300
	la=180
	
	troms=1200
	thycom=300

	if [ -e roms.nc ]; then rm roms.nc; fi
	if [ -e hycom.nc ]; then rm hycom.nc ; fi

	ncks -v temp -d ocean_time,$thycom -d s_rho,29 -d eta_rho,$la -d xi_rho,$lo $f1 $out1
	ncks -v temp -d ocean_time,$troms  -d s_rho,29 -d eta_rho,$la -d xi_rho,$lo $f2 $out2

	#  the end
