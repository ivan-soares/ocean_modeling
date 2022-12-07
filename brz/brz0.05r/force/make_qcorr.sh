#!/bin/bash
#
	echo
	echo " +++ Stareting script to make Q CORR file +++ "
	echo

	year=2014
	domain='brz0.25'
	wind='cfsr'

	domain_roms="brz0.05r"
	version="01a"
	mindepth=11

	outfile="qcorr_${domain}_${year}_03h.nc"
	frcfile="d-storage/force_${domain_roms}_${version}_${year}_cfsr_03h.nc"
	grdfile="../grid/grid_${domain_roms}_${version}.nc"

	echo
	echo " ... will read force file $frcfile"
	echo " ... will write qcorr file $outfile"
	echo

	#ncks -v Tair d-storage/force_${domain}_${year}_${wind}_03h.nc tmp.nc
	#ncdump -h tmp.nc > qcorr.cdf

	#### fix qcorr.cdf and then create empty nectdf file from cdf

	ncgen -k4 qcorr.cdf -o $outfile

cat > write_qcorr.py << EOF
############################################
import os.path, gc, sys
home = os.path.expanduser('~')
sys.path.append(home + '/scripts/python/')
import numpy as np
from netCDF4 import Dataset
############################################

grdfile = Dataset('$grdfile','r')
frcfile = Dataset('$frcfile','r')
outfile = Dataset('$outfile','r+')


lon = grdfile.variables



EOF




	echo
	echo " +++ End of Script +++ "
	echo


#
#    the end
#
