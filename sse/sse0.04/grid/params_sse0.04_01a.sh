#!/bin/bash

        ################ select lon/lat grid box for a regular non-rotated grid
        ################ pick the angle to create the rotated grid 

        nlon=418
        nlat=318

	lon1=-49.5
	lon2=-32.8

	lat1=-31.0
	lat2=-18.3

	incr=0.04
        dlon=$incr
        dlat=$incr

        ang=0.

        args="$lon1 $lon2 $lat1 $lat2 $dlon $dlat $ang"

	#### etopo cut

	elon1=-50.0
	elon2=-32.0
	elat1=-31.5
	elat2=-18.0

        #### shapiro topo filter params

        npass=4
        order=2
        scheme=2

        shapiro_params="$order $scheme $npass"

        #### minimum and maximum grid depths

        mindep=10.01
        maxdep=7000.01

#### the end

