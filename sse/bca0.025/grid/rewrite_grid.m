    addpath ~/roms/matlab/netcdf
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/mexcdf/snctools

    addpath ~/roms/matlab/grid
    addpath ~/roms/matlab/landmask
    addpath ~/roms/matlab/utility
    
   
    f1 = 'grid_bca0.00833_01b.nc';
    f2 = 'grid_bca0.00833_01c.nc';
   
    vars = {'lon_rho';'lon_psi';'lon_u';'lon_v'; ...
            'lat_rho';'lat_psi';'lat_u';'lat_v'};
    
    N = length(vars);
    
    for n = 1:N
        disp([' ... rewrite var ' vars{n}])
        nc_varput(f2,vars{n},nc_varget(f1,vars{n}))
        %nc_varput(f2,vars{n},round(nc_varget(f1,vars{n})*1000)/1000);
    end 
    
   