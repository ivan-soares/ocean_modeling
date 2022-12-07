% Script to interpolate topo to Roms GRID
%
%     caminhos

    addpath ~/roms/matlab/netcdf
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/mexcdf/snctools

    addpath ~/roms/matlab/grid
    addpath ~/roms/matlab/landmask
    addpath ~/roms/matlab/utility

    addpath ~/roms/matlab/seagrid
    addpath ~/roms/matlab/seagrid/presto



%   input files

    roms='mask_r.nc'
    %roms = 'rotated_grid.nc';
    %roms = 'grid_brz0.05r_01a.nc'
    coast = 'costa_leste_com_ilhas.mat';
    
    bathyfile =  'etopo.nc';
    
%   editmask(roms,coast)
        

%
% end of script
%    
