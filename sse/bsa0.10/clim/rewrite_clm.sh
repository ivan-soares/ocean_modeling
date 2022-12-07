#!/bin/bash
#

	rm -rf list
	ls -1 d-storage/roms_npo0.08n_07f_2019*_clm_*d.nc >& list

        vlist01='spherical,Vtransform,Vstretching,theta_s,theta_b,Tcline,hc'
        vlist02='s_rho,s_w,Cs_r,Cs_w,h,lon_rho,lat_rho,lon_u,lat_u,lon_v,lat_v'
        vlist03='ocean_time,zeta,ubar,vbar,u,v,temp,salt'

	while read line; do	
	      outfile=`echo $line | sed -e 's/d-storage\///g'`
	      echo " ... doing file $outfile"
	      ncks -v $vlist01,$vlist02,$vlist03 $line $outfile
	done < list

#   the end
