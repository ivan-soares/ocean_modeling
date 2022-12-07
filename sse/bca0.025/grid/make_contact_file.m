    addpath ~/roms/matlab/netcdf
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/mexcdf/snctools

    addpath ~/roms/matlab/grid
    addpath ~/roms/matlab/landmask
    addpath ~/roms/matlab/utility
    
   
    gnames = {'grid_bca0.025_01b.nc', 'grid_bca0.00833_01b.nc'};
    cname = 'ngc_bca0.05_bca0.00833.nc';
    
    [S,G] = contact(gnames, cname)