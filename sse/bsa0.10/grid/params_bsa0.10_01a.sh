#!/bin/bash

	### gridsize, first and last lon/lat
	### and grid resolution

	nx=101
	ny=76

	x1=-49.0
	x2=-39.0

	y1=-29.5
	y2=-22.0

	incr=0.1

	#### will need NX,NY,NX1,NY1 to create netcdf files

        NY=$ny
        NX=$nx
        let NY1=${NY}-1
        let NX1=${NX}-1

        echo " ... nx is $nx"
        echo " ... ny is $by"
        echo "... NX - 1 is $NX1"
        echo "... NY - 1 is $NY1"

	#### bbox to extract a cut of etopo file

	lon1=-50.
	lon2=-38.
	lat1=-30.
	lat2=-21.

        #### shapiro topo filter params

        npass=4
        order=2
        scheme=2

        shapiro_params="$npass $order $scheme"

        #### minimum and maximum grid depths

        mindep=5.01
        maxdep=5800.01	

### the end
