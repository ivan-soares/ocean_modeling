#!/bin/bash
#


	#### Script to make a regular grid, i.e., a grid having constant lat/lon increment
	

	echo; echo " ==> STARTING script to make ROMS grid file <=="; echo

	### file names

	domain=$1
	version=$2

	grdfile="grid_${domain}_${version}.nc"
	mskfile="grid_${domain}_${version}.mask"
	echo $grdfile > grdfile
	echo $mskfile > mskfile

	ddir="$HOME/scripts/4roms"

	#### load grid size, grid resolution, etopo cut
	#### and shapiro filter params
	source params_${domain}_${version}.sh 

	#### step 00:
	#### make gridfile for rho, u, v & psi
        #### will create files: gridfile_r.txt, gridfile_u.txt, gridfile_v.txt & gridfile_p.txt
	source $ddir/make_grid_step00_create_gridfiles.sh

	#### step 01:
	#### extract a cut of etopo file
	#### will create a file named etopo_cut.nc
	make_grid_step01_extract_etopo_cut.sh $lon1 $lon2 $lat1 $lat2

	#### interpolates etopo to the resolution of newly created grid files
	#### cdo got  problem with HDF5 used in etopo file
	#### so, for this task, I am using new cdo version 1.9.7

	newcdo="$HOME/apps/cdo-1.9.7/bin/cdo"

	$newcdo remapbil,gridfile_rho.txt    etopo_cut.nc   tmp1
	$newcdo remapbil,gridfile_u.txt      etopo_cut.nc   tmp2
	$newcdo remapbil,gridfile_v.txt      etopo_cut.nc   tmp3
	$newcdo remapbil,gridfile_psi.txt    etopo_cut.nc   tmp4

	#### rename depth var 'z' inherited from etopo

	$newcdo chname,z,h_rho  tmp1   gridfile_rho.nc
	$newcdo chname,z,h_u    tmp2   gridfile_u.nc
	$newcdo chname,z,h_v    tmp3   gridfile_v.nc
	$newcdo chname,z,h_psi  tmp4   gridfile_psi.nc

	rm tmp* gridfile_*.txt

	#### create a netcdf ROMS gridfile from grid.cdf

	rm -rf $grdfile
	create_ncfile_grid.sh $nx $ny
	mv grid.nc $grdfile

	#### step 02:
	#### write depths in newly created ROMS gridfile

	#python $ddir/make_grid_step02_interp_grid_depths.py
	python $ddir/make_grid_step02_write_grid_depths.py $grdfile $mindep $maxdep
	#rm gridfile_*.nc etopo_*.nc

	#### step 03, 04 & 05
	#### write grid masks, grid metric factors (pn,pm) & diff, visc, coriolis
	#### will create grid masks, apply masks to topography and 
	#### apply the minimum depth 'mindep' 

	python $ddir/make_grid_step03_write_grid_masks_and_filter.py $grdfile $mskfile $shapiro_params $mindep $maxdep
	python $ddir/make_grid_step04_write_grid_metrics.py $grdfile $incr
	python $ddir/make_grid_step05_write_diff+visc+coriolis.py $grdfile

        rm grdfile mskfile
	rm etopo* gridfile_*.nc

#### the end

