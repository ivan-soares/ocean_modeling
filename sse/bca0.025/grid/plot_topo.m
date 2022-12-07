    addpath ~/roms/matlab/netcdf
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/mexcdf/snctools
    
    file = 'grid_bca0.025_01c.nc';
    
    lon = nc_varget(file,'lon_rho');
    lat = nc_varget(file,'lat_rho');
    msk = nc_varget(file,'mask_rho');
    prf = nc_varget(file,'h');
    
    close all
    pcolor(lon,lat,prf./msk), shading flat, axis equal, colorbar
    title('Grade CRONOS 1/40')
    xlabel('Longitude')
    ylabel('Latitude')
    axis tight
    
    print -dpng grid_cronos_01c.png
    