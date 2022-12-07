#!/bin/bash
#
	########### caompute avg of year 2020

	roms_avg_file="$HOME/roms/cases/sse/bsa0.10/expts/bsa0.10_01a_gfs+glby_20200101_366d_rad/d-storage/20200101/roms_avg_bsa0.10_01a_20200101_glby.nc"
        roms_his_file="$HOME/roms/cases/sse/bsa0.10/expts/bsa0.10_01a_gfs+glby_20200101_366d_rad/d-storage/20200101/roms_his_bsa0.10_01a_20200101_glby.nc"


	ncks -v temp  $roms_avg_file tmp.nc; wait
	ncwa -O -a ocean_time tmp.nc t.nc; wait
	ncdump -h t.nc >& t.cdf
	rm tmp.nc t.nc

        ncks -v salt  $roms_avg_file tmp.nc; wait
        ncwa -O -a ocean_time tmp.nc s.nc; wait
	ncdump -h s.nc >& s.cdf
        rm tmp.nc s.nc

        ncks -v zeta  $roms_avg_file tmp.nc; wait
        ncwa -O -a ocean_time tmp.nc z.nc; wait
        ncdump -h z.nc >& z.cdf
        rm tmp.nc z.nc

        ncks -v u_eastward  $roms_avg_file tmp.nc; wait
        ncwa -O -a ocean_time tmp.nc u.nc; wait
        ncdump -h u.nc >& u.cdf
        rm tmp.nc u.nc

        ncks -v v_northward  $roms_avg_file tmp.nc; wait
        ncwa -O -a ocean_time tmp.nc v.nc; wait
        ncdump -h v.nc >& v.cdf
        rm tmp.nc v.nc






#
#   the end
#
