    addpath ~/roms/matlab/netcdf
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/mexcdf/snctools

    addpath ~/roms/matlab/grid
    addpath ~/roms/matlab/landmask
    addpath ~/roms/matlab/utility
    
   f1 = 'grid_bca0.025_01b.nc';
   f2 = 'grid_bca0.00833_01a.nc';
   f3 = 'grid_acu0.00833_01a.nc';
   
   r1.lon = nc_varget(f1,'lon_rho');
   r1.lat = nc_varget(f1,'lat_rho');
   
   r2.lon = nc_varget(f2,'lon_rho');
   r2.lat = nc_varget(f2,'lat_rho'); 
   
   plot(r1.lon, r1.lat, 'k'), hold on
   plot(r2.lon, r2.lat, 'm')
   
   %%% bounding box
   
   %%% Imin/Imax
   lon1 = min(min(r2.lon)); d1a = lon1+lon1/10000; d1b = lon1-lon1/10000;
   lon2 = max(max(r2.lon)); d2a = lon2+lon2/10000; d2b = lon2-lon2/10000;
   
   Imin = find(r1.lon(1,:) > d1a & r1.lon(1,:) < d1b); r1.lon(1,Imin)
   Imax = find(r1.lon(1,:) > d2a & r1.lon(1,:) < d2b); r1.lon(1,Imax)
   clear lon1 lon2 d1a d1b d2a d2b
   
   %%% Jmin/Jmax
   lat1 = min(min(r2.lat)); d1a = lat1+lat1/10000; d1b = lat1-lat1/10000;
   lat2 = max(max(r2.lat)); d2a = lat2+lat2/10000; d2b = lat2-lat2/10000;
   
   Jmin = find(r1.lat(:,1) > d1a & r1.lat(:,1) < d1b); r1.lat(Jmin,1)
   Jmax = find(r1.lat(:,1) > d2a & r1.lat(:,1) < d2b); r1.lat(Jmax,1)
   clear lat1 lat2 d1a d1b d2a d2b
   
   F = coarse2fine(f1,f3,3,Imin,Imax,Jmin,Jmax);
   
   
   
    
