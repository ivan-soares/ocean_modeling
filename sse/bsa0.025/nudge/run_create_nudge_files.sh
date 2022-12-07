#!/bin/bash

#  directory with bash scripts

	echo
	echo " ... BASH script to create nudge files ..."
	echo

	domain=$1
	version=$2

	grid="grid_${domain}_${version}.nc"

	type1='exp_medium'
	type2='lin_1d1yr'

	f1="nudge_${domain}_${version}_${type1}.nc"
	f2="nudge_${domain}_${version}_${type2}.nc"

	echo " ... will create file:"
	echo
	echo " ... ... $f1"
	echo " ... ... $f2"
	echo

	nlon=`cdo -s --no_warnings griddes $grid  | grep xsize | head -1 | awk '{print $3}'`
	nlat=`cdo -s --no_warnings griddes $grid  | grep ysize | head -1 | awk '{print $3}'`
	nsig=30

	#  create file   
	create_ncfile_nudge.sh $nlon $nlat $nsig
	mv nudge.nc $f1

	#  again for the other type
	create_ncfile_nudge.sh $nlon $nlat $nsig
	mv nudge.nc $f2

	echo
	echo " ... run program make_nudge_file for type $type1"
	echo

	python make_nudge_file.py $domain $version exp medium 100

	echo
        echo " ... run program make_nudge_file for type $type2"
        echo

	python make_nudge_file.py $domain $version lin 1d1yr  100

	echo
	echo " ... END of script"
	echo

