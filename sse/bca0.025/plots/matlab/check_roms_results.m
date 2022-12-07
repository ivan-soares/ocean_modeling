%%%%%%%%%%%%%%%%%%%  add netcdf paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    addpath ~/apps/mymatlab/ivans
    addpath ~/mystuff/toolbox_ivans
    addpath ~/roms/matlab/mexcdf/snctools
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/netcdf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    f1 = '~/roms_results/sse/bsantos1.50/2012_02a/bsantos_his.nc';
    f2 = '~/roms_results/sse/bsantos1.50/2012_02c/bsantos_his.nc';

    nt = nc_getvarinfo(f2,'ocean_time');
    nt = nt.Size

    time = nc_varget(f2,'ocean_time');
    time = (time-time(1))/24/3600;

    i = 027;
    j = 162;
    k = 20;

    var1 = 'v_northward';
    var2 = 'v';

    v1 = nc_varget(f1,var1,[0 k-1 j i],[nt 1 1 1]);
    v2 = nc_varget(f2,var2,[0 k-1 j i],[nt 1 1 1]);

    plot(time,v1,'k',time,v2,'r'), legend('02a','02c')
    title(['BSANTOS 1/50 2012 - ' upper(var2)])
    xlabel('days')    
    
    addpath '/home/ivans/mystuff/toolbox_ivans'
    
    N=nc_getvarinfo(f2,'temp');
    
    nt=N.Size(1)/2;
    nk=N.Size(2);
    nr=N.Size(3);
    nc=N.Size(4);
    
    lon = nc_varget(f1,'lon_rho');
    lat = nc_varget(f1,'lat_rho');
    
    v1 = nc_varget(f1,'temp',[nt-1 nk-1 0 0],[1 1 nr nc]);
    v2 = nc_varget(f2,'temp',[nt-1 nk-1 0 0],[1 1 nr nc]);
    
    figure, pcolor(lon,lat,v1),shading flat, colormap(flipud(mypal3(1))), colorbar, axis equal, title('02a')
    figure, pcolor(lon,lat,v2),shading flat, colormap(flipud(mypal3(1))), colorbar, axis equal, title('02c')
    figure, pcolor(lon,lat,v1-v2),shading flat, colormap(flipud(mypal3(1))), colorbar, axis equal, title('02a-02c')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


