#!/bin/bash

	### gridsize, first and last lon/lat
	### and grid resolution

	echo
	echo " ... reading file params !!!!"
	echo

	nx=489
	ny=388

	x1=-45.00
	x2=-32.80

	y1=-28.00
	y2=-18.30

	incr=0.025

	####### NX & NY for RHO U V and PSI

	nx_rho=$( bc <<< "$nx + 0" )
	ny_rho=$( bc <<< "$ny + 0" )
	nx_psi=$( bc <<< "$nx - 1" )
	ny_psi=$( bc <<< "$ny - 1" )

	nx_u=$( bc <<< "$nx - 1" )
	ny_u=$( bc <<< "$ny + 0" )
	nx_v=$( bc <<< "$nx + 0" )
	ny_v=$( bc <<< "$ny - 1" )

	###### X1 & Y1 for RHO U V and PSI

	x1_rho=$( bc <<< "$x1 + 00000" )
	y1_rho=$( bc <<< "$y1 + 00000" )
	x1_psi=$( bc <<< "$x1 + $incr" )
	y1_psi=$( bc <<< "$y1 + $incr" )

	x1_u=$( bc <<< "$x1 + $incr" )
	y1_u=$( bc <<< "$y1 + 00000" )
	x1_v=$( bc <<< "$x1 + 00000" )
	y1_v=$( bc <<< "$y1 + $incr" )

	#### bbox to extract a cut of etopo file

	lon1=-45.5
	lon2=-32.0
	lat1=-28.5
	lat2=-18.0

	#### shapiro topo filter params

	npass=4
	order=2
	scheme=2

	shapiro_params="$npass $order $scheme"

	#### minimum and maximum grid depths

	mindep=5.01
	maxdep=5800.01	

	echo
	echo " ... grid $domain is dimensioned $nx_rho x $ny_rho"
	echo " ... the first grid point is $x1_rho , $y1_rho"
	echo

### the end
