#!/bin/bash
#

	### domain & version

	domain='bca0.025'	 
	version='01b'

	### nudge type: either 'exp' for enponentail or 'lin' for linear decay

	#itype='exp'; ispec='weak'; nl=100
	#itype='exp'; ispec='medium'; nl=100
	itype='exp'; ispec='strong'; nl=100
	#itype='lin'; ispec='10lines'; nl=10

	nudge="${itype}_${ispec}"

	### get nlon & nlat from grid file

	grid="grid_${domain}_${version}.nc"
	nlon=`cdo -s --no_warnings griddes $grid  | grep xsize | head -1 | awk '{print $3}'`
	nlat=`cdo -s --no_warnings griddes $grid  | grep ysize | head -1 | awk '{print $3}'`
	nsig=30

	### create empty netcdf file
	### will make a file named nudge.nc
	create_ncfile_nudge.sh $nlon $nlat $nsig
	mv nudge.nc nudge_${domain}_${version}_${nudge}.nc

	### run python code to create nudge values and write in netcdf file
	python make_nudge_file.py $domain $version $itype $ispec $nl

####    the end

	 
