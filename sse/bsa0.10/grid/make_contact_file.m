    addpath ~/roms/matlab/netcdf
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/mexcdf/snctools

    addpath ~/roms/matlab/grid
    addpath ~/roms/matlab/landmask
    addpath ~/roms/matlab/utility
    
   
    gnames = {'grid_bsa0.10_01a.nc', 'grid_pgua0.02_01a.nc'};
    cname = 'ngc_bsa0.10_pgua0.02.nc';
    
    [S,G] = contact(gnames, cname)