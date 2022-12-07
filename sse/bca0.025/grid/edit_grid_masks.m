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

%     romsmasks = 'grid_bca0.005_01b.mask';
    romsmasks = 'grid_bca0.00833_01c.mask';
    coastfile = 'costa_leste_com_ilhas.mat';
    bathyfile =  'etopo.nc';
    
%   editmask(romsmasks,coastfile)
        

%
% end of script
%    
