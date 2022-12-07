    addpath ~/roms/matlab/netcdf
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/mexcdf/snctools
    
    addpath ~/apps/mymatlab/ivans
    
    ddir = '~/roms/cases/brz'
    
    g1 = [ ddir '/brz_rotated/clim/rotated_glby_20201001_sig.nc' ];
    g2 = [ ddir '/brz_rotated/clim/glby_20201001.nc' ];
    
    lon1= nc_varget(g1, 'lon');
    lat1= nc_varget(g1, 'lat');
    tpt1= nc_varget(g1, 'water_temp');
    u3d1= nc_varget(g1, 'water_u');
    v3d1= nc_varget(g1, 'water_v');
    
    t1 = squeeze(tpt1(1,30,:,:));
    u1 = squeeze(u3d1(1,30,:,:));
    v1 = squeeze(v3d1(1,30,:,:));
    
    vzao1 = sqrt(u1.^2 + v1.^2);
    vzao1(isnan(vzao1))=0;
    vzao1(isnan(t1))=nan;
    
    lon2= nc_varget(g2, 'lon');
    lat2= nc_varget(g2, 'lat');
    tpt2= nc_varget(g2, 'water_temp');
    u3d2= nc_varget(g2, 'water_u');
    v3d2= nc_varget(g2, 'water_v');
    
    t2 = squeeze(tpt2(1,1,:,:));
    u2 = squeeze(u3d2(1,1,:,:));
    v2 = squeeze(v3d2(1,1,:,:));
    
    vzao2 = sqrt(u2.^2 + v2.^2);
    vzao2(isnan(vzao2))=0;
    vzao2(isnan(t2))=nan;  
    
    [lon2, lat2] = meshgrid(lon2,lat2);
    
    close all
    pcolor(lon1,lat1,t1), shading flat, colorbar, axis equal, colormap(mypal_redblue(100)), caxis([7 29])
    hold on, plot_uv3(lon1,lat1,u1,v1,u1,3,'k',-37,1.,0.1,3,.50,.50)
    title('Surface ROMS Temp Grid BRZ 0.05r 01a'), xlabel('Longitude'), ylabel('Latitude')
    A = axis;
    print -dpng roms_brz0.05r_temp.png
    
    figure
    pcolor(lon2,lat2,t2), shading flat, colorbar, axis equal, colormap(mypal_redblue(100)), caxis([7 29])
    hold on, plot_uv3(lon2,lat2,u2,v2,u2,5,'k',0,1.,0.1,3,.50,.50)
    title('Surface HYCOM Temp'), xlabel('Longitude'), ylabel('Latitude')
    axis(A)
    print -dpng hycom_temp.png
    
%     figure
%     pcolor(lon1,lat1,u1), shading flat, colorbar, axis equal
%     title('Surface U comp Grid BRZ 0.05r 01a')
%     xlabel('Longitude'), ylabel('Latitude')
%     print -dpng brz0.05r_u.png
%     
%     figure
%     pcolor(lon1,lat1,v1), shading flat, colorbar, axis equal
%     title('Surface V comp Grid BRZ 0.05r 01a')
%     xlabel('Longitude'), ylabel('Latitude')
%     print -dpng brz0.05r_v.png
    
    %print -dpng  
         
%     close all
%     pcolor(lon2,lat2,(prf1-prf2)./msk1), shading flat, colorbar, axis equal
%     title('Diff Topography Grid NAO 0.04 01a - NAO 0.04 01b')
%     xlabel('Longitude'), ylabel('Latitude')
%     print -dpng diff_topo_grid_nao0.04.png 