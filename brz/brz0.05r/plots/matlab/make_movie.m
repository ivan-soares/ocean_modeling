%%%%%%%%%%%%%%%%%%%  add netcdf paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    addpath ~/apps/mymatlab/ivans
    addpath ~/mystuff/toolbox_ivans
    addpath ~/roms/matlab/mexcdf/snctools
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/netcdf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    infile = '../roms_qck_20201201_nemo.nc';
    figname = 'velo_20201201'
    nvar = 'velo_sur'
    
    coast_file = '~/data/costas/costa_leste.mat'
    load(coast_file)
    
    N = nc_getvarinfo(infile,'temp_sur'); 

    nt = N.Size(1)
    nr = N.Size(2)
    nc = N.Size(3)
    
    dt = 12;
    
    time = nc_varget(infile,'ocean_time');
    time = time - time(1);
    time = time/24/3600;
    
    nn = 1;
    
for n=0:dt:nt
    close all
    frame=sprintf('%3.3d',nn)
    plot_snap_shot(infile,n+1,nk,nvar,'2020');
    A=axis; hold on, fill(lon,lat,[.3 .7 .2]), axis([A])
    drawnow, eval(['print -dtiff ' figname '_' frame '.tif'])
    nn = nn+1;
end


    %!convert ...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
