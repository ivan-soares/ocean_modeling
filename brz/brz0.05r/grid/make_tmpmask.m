        addpath ~/roms/matlab/netcdf
        addpath ~/roms/matlab/mexcdf/mexnc
        addpath ~/roms/matlab/mexcdf/snctools

        addpath ~/roms/matlab/grid
        addpath ~/roms/matlab/landmask
        addpath ~/roms/matlab/utility

        addpath ~/roms/matlab/seagrid
        addpath ~/roms/matlab/seagrid/presto

        romsmasks = 'grid_brz0.05r_01a_tmpmsk.nc';
        coastfile = 'costa_leste.mat';
    

        %   editmask(romsmasks,coastfile)