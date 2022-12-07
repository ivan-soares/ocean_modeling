#!/bin/bash
#
#################################################################################
#
#      Script to make inputs files for make_clim_XXXn.nn
#
#      make_clim_params: file names, dir names, grid size, n. of layers, 
#                        sigma params, etc
#
#      sub01: generates gridfiles
#
#      sub02: generates depth files
#
#             subsub02a: creates empty files: depth_z.nc & depth_sig.nc
#             subsub02b: write depth values in files depth_z.nc & depth_sig.nc
#
#      sub03: generates a mask for hncoda
#
#################################################################################

	echo
	echo " ==> STARTING script to create input files for make_clim.sh <=="
	echo

	today=$1
	ndays=$2

	#### set grid dimension, sigma params and file names
	source params.txt
	echo $ogcm_depths | sed -e 's/,//g' >& ogcm_depths	

	operdir=`pwd`

	#### create new files  !!!!!
	#### will need sigma params to compute sigma levels
	#### and NX,NY,ndep,nsig

	

	# create depth files for rho points
	# will use scripts subsub02a & subsub02b
	source $operdir/create_depth_files_sub01_write_empty_files.sh

	# write values on newly created files
	python $operdir/create_depth_files_sub02_fillin_files.py $sig_params $grdfile depths_sig.nc depths_z.nc 
	rm ogcm_depths

	echo
	echo " ==> END of script to create input files <=="
	echo

#
######  the end
#
