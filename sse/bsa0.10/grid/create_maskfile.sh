#!/bin/bash
#

	####  script to create the file 'grid_bsa0.02_reg.masks'
	####  which is used when making grid file 'grid_bsa0.02_reg.nc'

	echo
	echo " +++ Starting script to make a maskfile to new grid +++"
	echo


	todays_date=`date`
	domain=$1
	version=$2

	mskfile="grid_${domain}_${version}.mask"

	source params_${domain}_${version}.sh

	operdir="$HOME/scripts/4roms"

	## the next will create a file named mask.nc
	## will need NX, NY, NX-1, NY-1, specified in file params
	source $operdir/create_grid_maskfile_sub01.sh

	#### fill in mask.nc with lon_rho, lat_rho & mask_rho values
	#### will need lon1, lon2, lat1, lat2 & incr

	python $operdir/create_grid_maskfile_sub02.py $x1 $x2 $y1 $y2 $incr

	mv mask.nc $mskfile

	echo
	echo " +++ End of script +++"
	echo

#### the end

#   the old way:
    
#   ncks -v spherical,lon_rho,lat_rho,lon_u,lat_u,lon_v,lat_v,lon_psi,lat_psi,mask_rho,mask_u,mask_v,mask_psi \
#         grid_${domain}_${version}.nc grid_${domain}_${version}.masks
