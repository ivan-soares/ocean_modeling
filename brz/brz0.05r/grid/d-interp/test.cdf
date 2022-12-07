netcdf test {
dimensions:
	nx = NNX ;
	ny = NNY ;
variables:
	float lon(ny, nx) ;
		lon:standard_name = "longitude" ;
		lon:long_name = "longitude (centre of grid cell)" ;
		lon:units = "degrees_eastward" ;
		lon:axis = "X" ;
	float lat(ny, nx) ;
		lat:standard_name = "latitude" ;
		lat:long_name = "latitude (centre of grid cell)" ;
		lat:units = "degrees_northward" ;
		lat:axis = "Y" ;
	float temp(ny, nx) ;
		temp:standard_name = "temperature" ;
		temp:coordinates = "lon lat" ;
		temp:_FillValue = -9999.9f ;
		temp:missing_value = -9999.9f ;
}
