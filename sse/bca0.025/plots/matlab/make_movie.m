%%%%%%%%%%%%%%%%%%%  add netcdf paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    addpath ~/apps/mymatlab/ivans
    addpath ~/mystuff/toolbox_ivans
    addpath ~/roms/matlab/mexcdf/snctools
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/netcdf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    infile = '~/roms_results/sse/bsantos1.50/2012_02a/bsantos_his.nc';

    N = nc_getvarinfo(infile,'temp'); 

    nt = N.Size(1)
    nk = N.Size(2)
    nr = N.Size(3)
    nc = N.Size(4)
    
    dt = 1;
    
    time = nc_varget(infile,'ocean_time');
    time = time - time(1);
    time = time/24/3600;
    
    nvar = 'temp';
    
    nn = 1;
    
for n=1:dt:nt
    frame=sprintf('%3.3d',nn)
    plot_snap_shot(infile,n,nk,nvar,2012)
    drawnow, eval(['print -dtiff ' nvar '_' frame '.tif'])
    nn = nn+1;
end


    %!convert ...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
