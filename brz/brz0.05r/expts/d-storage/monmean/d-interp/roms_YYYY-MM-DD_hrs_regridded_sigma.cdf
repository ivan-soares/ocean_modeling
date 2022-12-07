netcdf roms_sigma_coord_rotated {
dimensions:
	s_rho = NDEP ;
	eta_rho = NLAT ;
	xi_rho = NLON ;
	ocean_time = UNLIMITED ; // (0 currently)
variables:
	double ocean_time(ocean_time) ;
		ocean_time:standard_name = "time" ;
		ocean_time:long_name = "time since initialization" ;
		ocean_time:units = "seconds since YYYY-MM-DD 00:00:00.000 UTC" ;
		ocean_time:calendar = "proleptic_gregorian" ;
		ocean_time:axis = "T" ;
	double s_rho(s_rho) ;
		s_rho:standard_name = "ocean_s_coordinate_g2" ;
		s_rho:long_name = "S-coordinate at RHO-points" ;
		s_rho:positive = "up" ;
		s_rho:axis = "Z" ;
		s_rho:field = "s_rho, scalar" ;
	double angle(eta_rho, xi_rho) ;
		angle:long_name = "angle between XI-axis and EAST" ;
		angle:units = "radians" ;
		angle:coordinates = "lat_rho lon_rho" ;
		angle:cell_methods = "ocean_time: mean" ;
		angle:field = "angle, scalar" ;
	double h(eta_rho, xi_rho) ;
		h:long_name = "bathymetry at RHO-points" ;
		h:units = "meter" ;
		h:coordinates = "lat_rho lon_rho" ;
		h:cell_methods = "ocean_time: mean" ;
	double lat_rho(eta_rho, xi_rho) ;
		lat_rho:standard_name = "latitude" ;
		lat_rho:long_name = "latitude of RHO-points" ;
		lat_rho:units = "degree_north" ;
		lat_rho:_CoordinateAxisType = "Lat" ;
	double lon_rho(eta_rho, xi_rho) ;
		lon_rho:standard_name = "longitude" ;
		lon_rho:long_name = "longitude of RHO-points" ;
		lon_rho:units = "degree_east" ;
		lon_rho:_CoordinateAxisType = "Lon" ;
	double mask_rho(eta_rho, xi_rho) ;
		mask_rho:long_name = "mask on RHO-points" ;
		mask_rho:coordinates = "lat_rho lon_rho" ;
		mask_rho:cell_methods = "ocean_time: mean" ;
		mask_rho:flag_values = 0., 1. ;
		mask_rho:flag_meanings = "land water" ;
	float salt(ocean_time, s_rho, eta_rho, xi_rho) ;
		salt:long_name = "salinity" ;
		salt:coordinates = "lat_rho lon_rho" ;
		salt:_FillValue = 1.e+37f ;
		salt:missing_value = 1.e+37f ;
		salt:cell_methods = "ocean_time: mean" ;
		salt:time = "ocean_time" ;
		salt:field = "salinity, scalar, series" ;
	float temp(ocean_time, s_rho, eta_rho, xi_rho) ;
		temp:long_name = "potential temperature" ;
		temp:units = "Celsius" ;
		temp:coordinates = "lat_rho lon_rho" ;
		temp:_FillValue = 1.e+37f ;
		temp:missing_value = 1.e+37f ;
		temp:cell_methods = "ocean_time: mean" ;
		temp:time = "ocean_time" ;
		temp:field = "temperature, scalar, series" ;
	float u(ocean_time, s_rho, eta_rho, xi_rho) ;
		u:long_name = "u-momentum component" ;
		u:units = "meter second-1" ;
		u:coordinates = "lat_rho lon_rho" ;
		u:_FillValue = 1.e+37f ;
		u:missing_value = 1.e+37f ;
		u:cell_methods = "ocean_time: mean" ;
		u:time = "ocean_time" ;
		u:field = "u-velocity, scalar, series" ;
	float v(ocean_time, s_rho, eta_rho, xi_rho) ;
		v:long_name = "v-momentum component" ;
		v:units = "meter second-1" ;
		v:coordinates = "lat_rho lon_rho" ;
		v:_FillValue = 1.e+37f ;
		v:missing_value = 1.e+37f ;
		v:cell_methods = "ocean_time: mean" ;
		v:time = "ocean_time" ;
		v:field = "v-velocity, scalar, series" ;
	float zeta(ocean_time, eta_rho, xi_rho) ;
		zeta:long_name = "free-surface" ;
		zeta:units = "meter" ;
		zeta:coordinates = "lat_rho lon_rho" ;
		zeta:_FillValue = 1.e+37f ;
		zeta:missing_value = 1.e+37f ;
		zeta:cell_methods = "ocean_time: mean" ;
		zeta:time = "ocean_time" ;
		zeta:field = "free-surface, scalar, series" ;

// global attributes:
		:CDI = "Climate Data Interface version 2.0.4 (https://mpimet.mpg.de/cdi)" ;
		:Conventions = "CF-1.4, SGRID-0.3" ;
		:CDO = "Climate Data Operators version 2.0.4 (https://mpimet.mpg.de/cdo)" ;
		:NCO = "netCDF Operators version 4.9.1 (Homepage = http://nco.sf.net, Code = http://github.com/nco/nco)" ;
}