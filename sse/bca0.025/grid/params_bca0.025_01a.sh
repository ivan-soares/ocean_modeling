#!/bin/bash

	### gridsize, first and last lon/lat
	### and grid resolution

	nx=517
	ny=237

	x1=-48.40
	x2=-35.50

	y1=-25.4
	y2=-19.5

	incr=0.025

	#### bbox to extract a cut of etopo file

	lon1=-49.0
	lon2=-35.0
	lat1=-26.0
	lat2=-19.0

        #### shapiro topo filter params

        npass=4
        order=2
        scheme=2

        shapiro_params="$npass $order $scheme"

        #### minimum and maximum grid depths

        mindep=6.01
        maxdep=5800.01	

### the end
