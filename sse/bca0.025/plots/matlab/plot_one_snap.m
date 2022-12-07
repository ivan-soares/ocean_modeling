%%%%%%%%%%%%%%%%%%%  add netcdf paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    addpath ~/apps/mymatlab/ivans
    addpath ~/mystuff/toolbox_ivans
    addpath ~/roms/matlab/mexcdf/snctools
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/netcdf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %infile = '~/roms_results/sse/bsantos1.50/2012_02a/bsantos_his.nc';
    %infile = '/home/ivans/roms/cases/sse/bsa0.02/clim/matlab/clim_bsa0.02_02c_2012_glbu.nc'
    grfile = '/home/ivans/roms/cases/sse/bsa0.02/grid/grid_bsa0.02_02c.nc'
    
    
    lon = nc_varget(grfile,'lon_rho');
    lat = nc_varget(grfile,'lat_rho');
    msk = nc_varget(grfile,'mask_rho');
    prf = nc_varget(grfile,'h');
    
    
    close all
    pcolor(lon,lat,prf), shading interp, colorbar, hold on
    A = axis; plot_coast, axis(A), axis equal, axis(A)
    xlabel('Longitude'), ylabel('latitude')
    title('Bacia de Santos')
    
    
    
%     N = nc_getvarinfo(infile,'temp'); 
% 
%     nt = N.Size(1)
%     nk = N.Size(2)
%     nr = N.Size(3)
%     nc = N.Size(4)
%     
%     nn = 100;
% 
%     frame=sprintf('%3.3d',nn)
%     plot_snap_shot(infile,grfile,nn,19,'temp',2012)
%     drawnow, eval(['print -dtiff temp_' frame '.tif'])



    %!convert ...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
