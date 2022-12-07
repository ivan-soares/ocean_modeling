#!/bin/bash
#
	echo
	echo " +++ Starting script to create files depths_sig.nc & depths_lev.nc for ROMS +++"
	echo

	domain=$1
	version=$2
	ogcm=$3

	ddir="$HOME/scripts/4roms"

	################# load grid params and files names

	source params_${domain}_${version}.txt

	################# create empty netcdf files: depths_sig.nc & depths_z.nc

	source $ddir/create_depth_files_sub01_ncgen_empty_files.sh
	mv depths_z.nc depths_${ogcm}_${domain}.nc
	mv depths_sig.nc depths_sig_${domain}.nc

	################# fill in values in files: depths_sig.nc & depths_ogcm.nc

	echo $ogcm_depths | sed 's/,/ /g' >& ogcm_depths
	infiles="$grdfile depths_sig_${domain}.nc depths_${ogcm}_${domain}.nc"
	python $ddir/create_depth_files_sub02_fillin_files.py $sig_params $infiles                    
	rm ogcm_depths

	#################  the end

	echo
	echo " +++ End of script +++"
	echo


########################################################################################################


