#!/bin/bash

	### gridsize, first and last lon/lat
	### and grid resolution

	nx=66
	ny=71

	x1=-48.8
	x2=-47.5

	y1=-26.2
	y2=-24.8

	incr=0.02

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

	lon1=-49.
	lon2=-47.
	lat1=-27.
	lat2=-24.

        #### shapiro topo filter params

        npass=4
        order=2
        scheme=2

        shapiro_params="$npass $order $scheme"

        #### minimum and maximum grid depths

        mindep=2.01
        maxdep=5800.01	

### the end
