netcdf grid {
dimensions:
	y = NNY ;
	x = NNX ;
variables:
	double h(y, x) ;
		h:long_name = "model bathymetry at RHO-points" ;
		h:units = "meter" ;
		h:_FillValue = NaNf ;
		h:missing_value = NaNf ;
		h:coordinates = "lon lat" ;
	double lat(y, x) ;
		lat:long_name = "latitute of RHO-points" ;
		lat:units = "degrees_north" ;
		lat:standard_name = "latitude" ;
	double lon(y, x) ;
		lon:long_name = "longitude of RHO-points" ;
		lon:units = "degrees_east" ;
		lon:standard_name = "longitude" ;

// global attributes:
		:type = "GRID file" ;
		:history = "GRID file made with cdo genbil & remap, 26-Oct-2020" ;
}
