#!/bin/bash
#

     echo
     echo " *** STARTING bash script to create empty netcdf files depths_sig.nc & depths_z.nc ***"
     echo
     echo "         ...   NX = $nx"
     echo "         ...   NY = $ny"
     echo "         ...   ns = $nsig"
     echo "         ...   nz = $ndep"
     echo

     ### make file 'depths_sig.nc' with roms depths in sigma levels

     rm -rf depths_sig.nc

cat > depth.cdf << EOF
netcdf depth {
dimensions:
   lon = $nx ;
   lat = $ny ;
   layer = $nsig ;
variables:
   double lon(lon) ;
           lon:standard_name = "longitude" ;
           lon:long_name = "longitude" ;
           lon:units = "degrees_east" ;
           lon:axis = "X" ;
   double lat(lat) ;
           lat:standard_name = "latitude" ;
           lat:long_name = "latitude" ;
           lat:units = "degrees_north" ;
           lat:axis = "Y" ;
   double layer(layer) ;
           layer:standard_name = "layer" ;
           layer:long_name = "vertical layer" ;
           layer:units = "ordinal number" ;
           layer:axis = "Z" ;
   double depth(layer, lat, lon) ;
           depth:standard_name = "depth" ;
           depth:long_name = "distance below surface" ;
           depth:units = "meter" ;
// global attributes:
        :history = "ncgen -k4 *.cdf -o *.nc" ;
}
EOF

     echo
     echo " ... ncgen depths_sig.nc"
     echo

     ncgen -k4 depth.cdf -o depths_sig.nc
     rm depth.cdf

     ### make file 'depths_z.nc' with standard depths

     rm -rf depths_z.nc

cat > depth.cdf << EOF
netcdf depth {
dimensions:
   lon = $nx ;
   lat = $ny ;
   layer = $ndep ;
variables:
   double lon(lon) ;
           lon:standard_name = "longitude" ;
           lon:long_name = "longitude" ;
           lon:units = "degrees_east" ;
           lon:axis = "X" ;
   double lat(lat) ;
           lat:standard_name = "latitude" ;
           lat:long_name = "latitude" ;
           lat:units = "degrees_north" ;
           lat:axis = "Y" ;
   double prof(layer) ;
           prof:standard_name = "profundity" ;
           prof:long_name = "vertical distance from surface" ;
           prof:units = "meter" ;
           prof:axis = "Z" ;
   double depth(layer, lat, lon) ;
           depth:standard_name = "depth" ;
           depth:long_name = "distance below surface" ;
           depth:units = "meter" ;
// global attributes:
        :history = "ncgen -k4 *.cdf -o *.nc" ;
}
EOF

     echo
     echo " ... ncgen depths_z.nc"
     echo

     ncgen -k4 depth.cdf -o depths_z.nc
     rm depth.cdf

     echo
     echo " *** END bash script ***"
     echo


################################ end of script #####################################

