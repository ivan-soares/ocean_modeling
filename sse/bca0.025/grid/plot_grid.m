
    addpath ~/roms/matlab/netcdf
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/mexcdf/snctools
    
    f1 = 'grid_bca0.025_01b.nc';
    f2 = 'grid_bca0.00833_01c.nc';
    
    g1.lon = nc_varget(f1,'lon_rho');
    g1.lat = nc_varget(f1,'lat_rho');
    g1.msk = nc_varget(f1,'mask_rho');
    g1.prf = nc_varget(f1,'h');
    
    g2.lon = nc_varget(f2,'lon_rho');
    g2.lat = nc_varget(f2,'lat_rho');
    g2.msk = nc_varget(f2,'mask_rho');
    g2.prf = nc_varget(f2,'h');

    load costa_leste_com_ilhas
    
    lo1 = min(min(g2.lon)); lo2 = max(max(g2.lon));
    la1 = min(min(g2.lat)); la2 = max(max(g2.lat));
    box = [lo1 la1; lo2 la1; lo2 la2; lo1 la2; lo1 la1];
    
    
    close all
    plot(g1.lon,g1.lat,'r'), hold on, plot(g1.lon',g1.lat','r')
    plot(g2.lon,g2.lat,'c'), hold on, plot(g2.lon',g2.lat','c')
    A = axis; axis equal, plot(lon,lat,'k'), axis(A)
    
    figure, pcolor(g1.lon, g1.lat, g1.prf./g1.msk); shading flat,  colorbar, axis equal
    hold on, pcolor(g2.lon, g2.lat, g2.prf./g2.msk); shading flat
    A = axis; axis equal, plot(lon,lat,'k'), axis(A)
    
    figure, pcolor(g2.lon, g2.lat, g2.prf./g2.msk); shading flat,  colorbar, hold on
    A = axis; axis equal, plot(lon,lat,'k'), axis(A)
    
    figure, pcolor(g2.lon, g2.lat, g2.msk); shading flat,  colorbar, axis equal, hold on
    plot(g1.lon,g1.lat,'r'), hold on, plot(g1.lon',g1.lat','r')
    plot(g2.lon,g2.lat,'c'), hold on, plot(g2.lon',g2.lat','c')
    A = axis; axis equal, plot(lon,lat,'m','linewidth',2), axis(A)