#!/bin/bash
#


	#### Script to make a regular grid, i.e., a grid having constant lat/lon increment
	

	echo; echo " ==> STARTING script to make ROMS grid file <=="; echo

	### file names

	domain=$1
	version=$2

	ddir="$HOME/scripts/4roms"
	grdfile="grid_${domain}_${version}.nc"
	etopofile="$HOME/data/etopo/etopo_global_remo_br.nc"

	#### load grid size, grid resolution, etopo cut
	#### and shapiro filter params
	source params_${domain}_${version}.sh 

	#### create an empty netcdf ROMS gridfile from grid.cdf
	if [ -e $grdfile ]; then rm $grdfile; fi
	create_ncfile_grid.sh $nx $ny
	mv grid.nc $grdfile

	#### make ETOPO cut
	#### in case of not modifying etopo file, just do: 
	#### cp etopo_cut.nc etopo_cut_fixed.nc
        ncks -d lon,$lon1,$lon2 -d lat,$lat1,$lat2 $etopofile etopo_cut.nc
        #ncap2 -s 'z(177:269,588:690)=-4000' etopo_cut.nc etopo_cut_fixed.nc
	cp etopo_cut.nc etopo_cut_fixed.nc

	#### step 01:
	#### will extract a cut of etopo file
	#### and create topo and mask files for rho, u, v and psi
	source $ddir/make_grid_step01_create_topo+masks.sh

	#### step 02:
	#### write depths and masks in the empty grid file created above.
	#### apply shapiro filter on topography, apply masks to topography and 
        #### apply the minimum & maximum depths
	python $ddir/make_grid_step02_write_grid_topo+masks.py $grdfile $shapiro_params $mindep $maxdep
	#rm topo_*.nc mask_*.nc

	#### steps 03 & 04
	#### write grid metric factors (pn,pm) & diff, visc, coriolis
	#### will create grid masks, apply masks to topography and 
	#### apply the minimum depth 'mindep' 
	python $ddir/make_grid_step03_write_grid_metrics.py $grdfile $incr
	python $ddir/make_grid_step04_write_diff+visc+coriolis.py $grdfile

	#### if necessary, fix grid masks, masking out water points which
	#### are completely surrounded by land. if necessary do it twice or more.

	newgrid01="${grdfile}1"
	newgrid02="${grdfile}2"
	cp $grdfile $newgrid01
	cp $grdfile $newgrid02

	python $ddir/fix_grid_mask.py $grdfile   $newgrid01
	python $ddir/fix_grid_mask.py $newgrid01 $newgrid02

        echo; echo " ==> END of script to make ROMS grid file <=="; echo	

#### the end

