#!/bin/bash
#
	grdfile=$1
	mskfile=$2


	ncks -v mask_rho,lon_rho,lat_rho $grdfile $mskfile

	python make_tmpmsk.py $mskfile	
