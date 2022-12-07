#!/bin/bash
#

	year=$1


	v01="s_rho,s_w,Cs_r,Cs_w,h,angle"
	v02="lon_rho,lat_rho,lon_u,lat_u,lon_v,lat_v"
	v03="zeta,temp,salt,u,v"
	v04="mask_rho,mask_u,mask_v"



	inpfile="roms_his_brz0.05r_01d_${year}0101_monmean.nc"
	outfile="roms_monmean_brz0.05r_01d_${year}0101.nc"


	ncks -v ${v01},${v02},${v03},${v04}  $inpfile $outfile

# the end


