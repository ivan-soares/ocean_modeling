%%%%%%%%%%%%%%%%%%%  add netcdf paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    addpath ~/apps/mymatlab/ivans
    addpath ~/mystuff/toolbox_ivans
    addpath ~/roms/matlab/mexcdf/snctools
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/netcdf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    date = '20201119'

    nvar = 'velo';
    figname = [ nvar '_' date ];

    f1 = [ '~/oper/bcampos/forecast/d-storage/' date '/roms_his_bca0.025_01b_' date '_glby.nc' ];
    f2 = [ '~/oper/bcampos/forecast/d-storage/' date '/roms_his_bca0.00833_01c_' date '_glby.nc' ];

    g1 = '~/roms/cases/sse/bca0.025/grid/grid_bca0.025_01b.nc';
    g2 = '~/roms/cases/sse/bca0.025/grid/grid_bca0.00833_01c.nc';
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    N1 = nc_getvarinfo(f1,'temp'); 

    nt1 = N1.Size(1)
    nk1 = N1.Size(2)
    nr1 = N1.Size(3)
    nc1 = N1.Size(4)
    
    N2 = nc_getvarinfo(f2,'temp'); 

    nt2 = N2.Size(1)
    nk2 = N2.Size(2)
    nr2 = N2.Size(3)
    nc2 = N2.Size(4) 
    
    
    time = nc_varget(f1,'ocean_time');
    time = time - time(1);
    time = time/24/3600;
    
    for n=0:6:168
    
    close all
    [lon1, lat1, t1, msk1, bb1] = plot_snap_shot(f1,g1,n+1,30,nvar,date); hold on
    [lon2, lat2, t2, msk2, bb2] = plot_snap_shot(f2,g2,n+1,30,nvar,date);
    plot(bb2(:,1), bb2(:,2))
    nn = sprintf('%3.3d',n)
    drawnow, eval(['print -dtiff ' figname '_' nn '_.tif'])

    end
    %!convert ...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
