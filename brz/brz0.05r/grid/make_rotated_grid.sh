#!/bin/bash
#

	set -o errexit    # will exit in case of fail
	set -o pipefail   # if one command ini the pipe fails the entire pipeline will fail
	set -o nounset    # when it encounters a variable that does not exist, it will report an error and stop executing. 
	#set -o xtrace    # output the executed command line before its execution result.

##############################################################################################

	domain="brz0.05r"
	version="01f"

	source params_${domain}_${version}.sh
	grdfile="grid_${domain}_${version}.nc"

	ddir="$HOME/scripts/4roms"
	cdo="$HOME/apps/cdo-1.9.7/bin/cdo -s --no_warnings"
	cdo="cdo -s --no_warnings"

	echo
	echo " ### STARTING bash code to create ROMS grid ###"
	echo 

	### remove old stuff
	rm -rf *.cdf tmp* etopo_cut.nc

	echo
	echo " ... get etopo cut"
	echo

	etopo="$HOME/data/etopo/etopo_global_remo_br.nc"
	ncks -d lat,$elat1,$elat2 -d lon,$elon1,$elon2 $etopo etopo_cut.nc

	echo
	echo " ... create empty roms file"
	echo

	NNX=$nlon
	NNY=$nlat
	let NX1=${NNX}-1
	let NY1=${NNY}-1

	sed -e "s/NXR/$NNX/g" -e "s/NYR/$NNY/g" \
	    -e "s/NXU/$NX1/g" -e "s/NYU/$NNY/g" \
	    -e "s/NXV/$NNX/g" -e "s/NYV/$NY1/g" \
	    -e "s/NXP/$NX1/g" -e "s/NYP/$NY1/g" \
	     d-interp/roms.cdf >& cdf.cdf

	ncgen -k4 cdf.cdf -o $grdfile
	rm cdf.cdf

	echo
	echo " ... run python code to interp topo and write in newly created roms file"
	echo

	python make_rotated_grid_step01_interp_topo.py $grdfile etopo_cut.nc $args
	rm etopo_cut.nc

	echo
	echo " ... run python code to filter ROMS grid topography"
	echo

	python make_rotated_grid_step02_filter_topo.py $grdfile $shapiro_params $mindep $maxdep

	echo
	echo " ... run python code to write grid metric"
	echo

	python make_rotated_grid_step03_write_metrics.py $grdfile $incr $ang

	echo
	echo " ... run python code to write diff/visc/coriolis"
	echo

	python make_rotated_grid_step04_write_diff+visc+coriolis.py $grdfile

	echo
	echo " ### END of bash code to create ROMS grid ###"
	echo

#
#  the end
#
