
    function plot_snap_shot_anomaly(infile,tt,nlayer,expt,iyr,avg)

    lon=nc_varget(infile,'lon_rho');
    lat=nc_varget(infile,'lat_rho');
    msk=nc_varget(infile,'mask_rho');
    csr=nc_varget(infile,'Cs_r');

    nsig=length(csr);
   [nlat,nlon]=size(msk);

    t1=nc_varget(infile,'ocean_time',0,1);
    t2=nc_varget(infile,'ocean_time',tt,1);

    iday=(t2-t1)/3600/24;

    t = squeeze(nc_varget(infile,'temp',       [tt nlayer-1 0 0],[1 1 nlat nlon]))-squeeze(avg(1,:,:));
    u = squeeze(nc_varget(infile,'u_eastward', [tt nlayer-1 0 0],[1 1 nlat nlon]))-squeeze(avg(2,:,:));
    v = squeeze(nc_varget(infile,'v_northward',[tt nlayer-1 0 0],[1 1 nlat nlon]))-squeeze(avg(3,:,:));

    V = sqrt(u.^2 + v.^2);

    close all
    pcolor(lon,lat,t./msk), shading flat, caxis([-3 3]), colorbar
    A=axis; axis equal, axis(A), colormap(mypal3(0.75));
    title([expt ', Temperature Anomaly, layer ' num2str(30-nlayer) ', year ', num2str(iyr) ', day ' num2str(iday)])
    ylabel('Latitude'), xlabel('Longitude')
    figure
    pcolor(lon,lat,u./msk), shading flat, caxis([-.2 .2]), colorbar
    A=axis; axis equal, axis(A), colormap(mypal3(0.75));
    title([expt ', U velocity component Anomaly, layer ' num2str(30-nlayer) ', year ', num2str(iyr) ', day ' num2str(iday)])
    ylabel('Latitude'), xlabel('Longitude')

    
