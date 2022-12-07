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

    %romsmasks = 'grid_pgua0.02_01a.mask';
    %romsmasks = 'grid_bsa0.10_01a.mask'
    romsmasks = 'roms_bsa0.10_01a.tmpmsk'
    coastfile = 'costa_leste_com_ilhas.mat';
    bathyfile =  'etopo.nc';
    
%   editmask(romsmasks,coastfile)
        

%
% end of script
%    
