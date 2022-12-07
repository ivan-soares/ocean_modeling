#!/bin/bash
#

	domain='bsa0.10'
	version='01a'
	grdfile="grid_${domain}_${version}.nc"

	echo
	echo " ... script to create file grid_r.nc from $grdfile"
	echo

	rm -rf grid_r.nc

	ncks -v h,mask_rho,lat_rho,lon_rho $grdfile grid_r.nc

	ncrename -h -O -d xi_rho,x    grid_r.nc
	ncrename -h -O -d eta_rho,y   grid_r.nc
	ncrename -h -O -v lat_rho,lat grid_r.nc
        ncrename -h -O -v lon_rho,lon grid_r.nc
        ncrename -h -O -v mask_rho,mask grid_r.nc

	ncatted -O -a coordinates,h,c,c,"lon lat"  grid_r.nc

	echo
	echo " ... the end !"
	echo

### the end



