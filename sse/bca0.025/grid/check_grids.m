
    addpath ~/roms/matlab/netcdf
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/mexcdf/snctools
    
    f1 = 'grid_bca0.025_01b.nc';
    f2 = 'grid_bca0.00833_01b.nc';
    
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
     
    %%% bounding box
   
    %%% Imin/Imax
    lon1 = min(min(g2.lon)); d1a = lon1+lon1/1000; d1b = lon1-lon1/1000;
    lon2 = max(max(g2.lon)); d2a = lon2+lon2/1000; d2b = lon2-lon2/1000;
   
    Imin = find(g1.lon(1,:) > d1a & g1.lon(1,:) < d1b); g1.lon(1,Imin)
    Imax = find(g1.lon(1,:) > d2a & g1.lon(1,:) < d2b); g1.lon(1,Imax)
    %clear lon1 lon2 d1a d1b d2a d2b
   
    %%% Jmin/Jmax
    lat1 = min(min(g2.lat)); d1a = lat1+lat1/10000; d1b = lat1-lat1/10000;
    lat2 = max(max(g2.lat)); d2a = lat2+lat2/10000; d2b = lat2-lat2/10000;
   
    Jmin = find(g1.lat(:,1) > d1a & g1.lat(:,1) < d1b); g1.lat(Jmin,1)
    Jmax = find(g1.lat(:,1) > d2a & g1.lat(:,1) < d2b); g1.lat(Jmax,1)
%     clear lat1 lat2 d1a d1b d2a d2b
    
    close all
    plot(g1.lon,g1.lat,'r'), hold on, plot(g1.lon',g1.lat','r')
    plot(g2.lon,g2.lat,'c'), hold on, plot(g2.lon',g2.lat','c')
    A = axis; axis equal, plot(lon,lat,'k'), axis(A)
    
    figure, pcolor(g1.lon, g1.lat, g1.prf./g1.msk); shading flat,  colorbar, axis equal
    hold on, pcolor(g2.lon, g2.lat, g2.prf./g2.msk); shading flat
    A = axis; axis equal, plot(lon,lat,'k'), axis(A)
    
    figure, pcolor(g2.lon, g2.lat, g2.msk); shading flat,  colorbar, axis equal, hold on
    plot(g1.lon,g1.lat,'r'), hold on, plot(g1.lon',g1.lat','r')
    plot(g2.lon,g2.lat,'c'), hold on, plot(g2.lon',g2.lat','c')
    A = axis; axis equal, plot(lon,lat,'m','linewidth',2), axis(A)