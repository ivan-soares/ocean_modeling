netcdf glby_brz0.08_20200721 {
dimensions:
	time = UNLIMITED ; // (5 currently)
	xcoord = NLON ;
	ycoord = NLAT ;
	depth = NDEP ;
variables:
	double time(time) ;
		time:standard_name = "time" ;
		time:long_name = "time since initialization" ;
		time:units = "seconds since YYYY-MM-DD 00:00:00.000 UTC" ;
		time:calendar = "proleptic_gregorian" ;
		time:axis = "T" ;
	double lon(ycoord, xcoord) ;
		lon:standard_name = "longitude" ;
		lon:long_name = "Longitude" ;
		lon:units = "degrees_east" ;
		lon:axis = "X" ;
	double lat(ycoord, xcoord) ;
		lat:standard_name = "latitude" ;
		lat:long_name = "Latitude" ;
		lat:units = "degrees_north" ;
		lat:axis = "Y" ;
	double angle(ycoord, xcoord) ;
		angle:long_name = "angle between XI-axis and EAST" ;
		angle:units = "radians" ;
		angle:coordinates = "lat lon" ;
		angle:field = "angle, scalar" ;
	double h(ycoord, xcoord) ;
		h:long_name = "bathymetry at central points" ;
		h:units = "meter" ;
		h:coordinates = "lat lon" ;
	double mask(ycoord, xcoord) ;
		mask:long_name = "mask on central points" ;
		mask:coordinates = "lat lon" ;
		mask:flag_values = 0., 1. ;
		mask:flag_meanings = "land water" ;
	double depth(depth) ;
		depth:standard_name = "depth" ;
		depth:long_name = "Depth" ;
		depth:units = "m" ;
		depth:positive = "down" ;
		depth:axis = "Z" ;
		depth:_CoordinateAxisType = "Height" ;
		depth:_CoordinateZisPositive = "down" ;
	float zeta(time, ycoord, xcoord) ;
		zeta:standard_name = "sea_surface_elevation" ;
		zeta:long_name = "Water Surface Elevation" ;
		zeta:units = "m" ;
		zeta:_FillValue = -9999.f ;
		zeta:missing_value = -9999.f ;
		zeta:_CoordinateAxes = "time lat lon" ;
	float salt(time, depth, ycoord, xcoord) ;
		salt:standard_name = "sea_water_salt" ;
		salt:long_name = "Salinity" ;
		salt:units = "psu" ;
		salt:_FillValue = -9999.f ;
		salt:missing_value = -9999.f ;
		salt:_CoordinateAxes = "time depth lat lon" ;
	float temp(time, depth, ycoord, xcoord) ;
		temp:standard_name = "sea_temperature" ;
		temp:long_name = "Water Temperature" ;
		temp:units = "degC" ;
		temp:_FillValue = -9999.f ;
		temp:missing_value = -9999.f ;
		temp:_CoordinateAxes = "time depth lat lon" ;
	float u(time, depth, ycoord, xcoord) ;
		u:standard_name = "eastward_sea_velocity" ;
		u:long_name = "Eastward Water Velocity" ;
		u:units = "m/s" ;
		u:_FillValue = -9999.f ;
		u:missing_value = -9999.f ;
		u:_CoordinateAxes = "time depth lat lon" ;
	float v(time, depth, ycoord, xcoord) ;
		v:standard_name = "northward_sea_velocity" ;
		v:long_name = "Northward Water Velocity" ;
		v:units = "m/s" ;
		v:_FillValue = -9999.f ;
		v:missing_value = -9999.f ;
		v:_CoordinateAxes = "time depth lat lon" ;

// global attributes:
		:CDI = "Climate Data Interface version 1.9.9rc2 (https://mpimet.mpg.de/cdi)" ;
		:NCO = "netCDF Operators version 4.7.5 (Homepage = http://nco.sf.net, Code = http://github.com/nco/nco)" ;
		:nco_openmp_thread_number = 1 ;
		:CDO = "Climate Data Operators version 1.9.9rc2 (https://mpimet.mpg.de/cdo)" ;
}
