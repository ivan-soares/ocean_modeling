#!/bin/bash
#
	romsfile="roms_bsa0.10_20210101.nc"


	### make roms_20210101_u.nc, roms_20210101_v.nc, roms_20210101_tsz.nc

	ncks -v u,ubar $romsfile roms_20210101_u.nc
	ncks -v v,vbar $romsfile roms_20210101_v.nc
        ncks -v zeta,temp,salt $romsfile roms_20210101_tsz.nc

	cdo sub roms_20210101_u.nc roms_avg_2020_u.nc roms_20210101_u_anom.nc; wait
	cdo sub roms_20210101_v.nc roms_avg_2020_v.nc roms_20210101_v_anom.nc; wait
	cdo sub roms_20210101_tsz.nc roms_avg_2020_tsz.nc roms_20210101_tsz_anom.nc; wait





#
#   the end
#
