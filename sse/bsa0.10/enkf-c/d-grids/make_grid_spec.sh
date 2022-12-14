#!/bin/bash
#
	echo
	echo " +++ Starting script to make grid spec for ENKF +++"
	echo

	romsgrid='grid_bsa0.10_01a.nc'
	romsclim='input_clm_bsa0.10_01a_20210101_31d_glby.nc'
	gridspec='grid_spec_bsa0.10.nc'

cat > grid.cdf << EOF
netcdf grid {
dimensions:
        eta_rho = 76 ;
	eta_u = 76 ;
	eta_v = 75 ;
        xi_rho = 101 ;
	xi_u = 100 ;
	xi_v = 101 ;
        s_rho = 30 ;
        s_w = 31 ;
variables:
        int spherical ;
                spherical:long_name = "grid type logical switch" ;
                spherical:flag_values = 0, 1 ;
                spherical:flag_meanings = "Cartesian spherical" ;
        int Vtransform ;
                Vtransform:long_name = "vertical terrain-following transformation equation" ;
        int Vstretching ;
                Vstretching:long_name = "vertical terrain-following stretching function" ;
        double theta_s ;
                theta_s:long_name = "S-coordinate surface control parameter" ;
        double theta_b ;
                theta_b:long_name = "S-coordinate bottom control parameter" ;
        double Tcline ;
                Tcline:long_name = "S-coordinate surface/bottom layer width" ;
                Tcline:units = "meter" ;
        double hc ;
                hc:long_name = "S-coordinate parameter, critical depth" ;
                hc:units = "meter" ;
        double s_rho(s_rho) ;
                s_rho:long_name = "S-coordinate at RHO-points" ;
                s_rho:valid_min = -1. ;
                s_rho:valid_max = 0. ;
                s_rho:positive = "up" ;
                s_rho:standard_name = "ocean_s_coordinate_g2" ;
                s_rho:formula_terms = "s: s_rho C: Cs_r eta: zeta depth: h depth_c: hc" ;
        double s_w(s_w) ;
                s_w:long_name = "S-coordinate at W-points" ;
                s_w:valid_min = -1. ;
                s_w:valid_max = 0. ;
                s_w:positive = "up" ;
                s_w:standard_name = "ocean_s_coordinate_g2" ;
                s_w:formula_terms = "s: s_w C: Cs_w eta: zeta depth: h depth_c: hc" ;
        double Cs_r(s_rho) ;
                Cs_r:long_name = "S-coordinate stretching function at RHO-points" ;
                Cs_r:valid_min = -1. ;
                Cs_r:valid_max = 0. ;
        double Cs_w(s_w) ;
                Cs_w:long_name = "S-coordinate stretching function at W-points" ;
                Cs_w:valid_min = -1. ;
                Cs_w:valid_max = 0. ;
        double h(eta_rho, xi_rho) ;
                h:long_name = "model bathymetry at RHO-points" ;
                h:units = "meter" ;
                h:_FillValue = -32768. ;
                h:missing_value = -32768s ;
        double lat_rho(eta_rho, xi_rho) ;
                lat_rho:long_name = "latitute of RHO-points" ;
                lat_rho:units = "degree_north" ;
                lat_rho:standard_name = "latitude" ;
        double lon_rho(eta_rho, xi_rho) ;
                lon_rho:long_name = "longitude of RHO-points" ;
                lon_rho:units = "degree_east" ;
                lon_rho:standard_name = "longitude" ;
	double lon_u(eta_u, xi_u) ;
		lon_u:long_name = "longitude of U-points" ;
		lon_u:units = "degree_east" ;
		lon_u:standard_name = "longitude" ;
	double lat_u(eta_u, xi_u) ;
		lat_u:long_name = "latitute of U-points" ;
		lat_u:units = "degree_north" ;
		lat_u:standard_name = "latitude" ;
	double lon_v(eta_v, xi_v) ;
		lon_v:long_name = "longitude of V-points" ;
		lon_v:units = "degree_east" ;
		lon_v:standard_name = "longitude" ;
	double lat_v(eta_v, xi_v) ;
		lat_v:long_name = "latitute of V-points" ;
		lat_v:units = "degree_north" ;
		lat_v:standard_name = "latitude" ;
	double mask_rho(eta_rho, xi_rho) ;
                mask_rho:long_name = "mask on RHO-points" ;
                mask_rho:flag_values = 0., 1. ;
                mask_rho:flag_meanings = "land water" ;
	double mask_u(eta_u, xi_u) ;
		mask_u:long_name = "mask on U-points" ;
		mask_u:flag_values = 0., 1. ;
		mask_u:flag_meanings = "land water" ;
	double mask_v(eta_v, xi_v) ;
		mask_v:long_name = "mask on V-points" ;
		mask_v:flag_values = 0., 1. ;
		mask_v:flag_meanings = "land water" ;
        int num_levels(eta_rho, xi_rho) ;
                num_levels:long_name = "number of vertical T-cells" ;
                num_levels:units = "none" ; 

// global attributes:
                :type = "GRID file" ;
}
EOF
	ncgen -k4 grid.cdf -o $gridspec
	rm grid.cdf

	python3 write_grid_spec_vars.py $romsgrid $romsclim $gridspec

	echo
        echo " +++ END of  script to make grid spec for ENKF +++"
        echo
