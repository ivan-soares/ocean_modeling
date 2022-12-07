
#!/bin/bash
#
	echo
	echo " +++ Starting script to create tmpmsk file +++"
	echo

        domain='bca0.025'
        version='01b'

	romsdir="$HOME/operational/roms/grids"
	grdfile="grid_${domain}_${version}.nc"

	vars1="lon_rho,lat_rho,lon_u,lat_u,lon_v,lat_v,lon_psi,lat_psi"
	vars2="mask_rho,mask_u,mask_v,mask_psi"
	vars3="spherical,h"

	ncks -v $vars1,$vars2,$vars3 $romsdir/$grdfile roms_${domain}_${version}_tmpmsk.nc
        #ncatted -O -a _coordinates,h,o,c,"lon lat" roms_${domain}_${version}_tmpmsk.nc

	echo
	echo " +++ End of script: +++"
	echo
