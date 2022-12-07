#!/bin/bash

        ################ select lon/lat grid box for a regular non-rotated grid
        ################ pick the angle to create the rotated grid 

        nlon=221
        nlat=651
        lat0=-34.25
        lon0=-55.25
        lat2=-1.75
        lon2=-44.25 #-43.75
        dlon=0.049999
        dlat=0.049999
	incr=0.05
        ang=37.

        args="$lon0 $lon2 $lat0 $lat2 $dlon $dlat $ang"

	#### etopo cut

	elon1=-56.
	elon2=-26.
	elat1=-45.
	elat2=-5.

        #### shapiro topo filter params

        npass=4
        order=5
        scheme=2

        shapiro_params="$order $scheme $npass"

        #### minimum and maximum grid depths

        mindep=10.01
        maxdep=7000.01

#### the end

