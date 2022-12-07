
    addpath ~/roms/matlab/netcdf
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/mexcdf/snctools

    addpath ~/roms/matlab/grid
    addpath ~/roms/matlab/landmask
    addpath ~/roms/matlab/utility

    addpath ~/roms/matlab/seagrid
    addpath ~/roms/matlab/seagrid/presto


    gridfile = 'grid_bsa0.10_01a.nc';

    rlon = nc_varget(gridfile,'lon_rho');
    rlat = nc_varget(gridfile,'lat_rho');
    mask = nc_varget(gridfile,'mask_rho');
    masku = nc_varget(gridfile,'mask_u');
    maskv = nc_varget(gridfile,'mask_v');
    h = nc_varget(gridfile,'h');

    [nrow,ncol]=size(mask);

    dx = 1./nc_varget(gridfile,'pm');
    dy = 1./nc_varget(gridfile,'pn');

    gh = sqrt(9.806*h).*mask;
    
    cfl = 1./sqrt( (gh./dx).^2 + (gh./dy).^2 ).*mask;

