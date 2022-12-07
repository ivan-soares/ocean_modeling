
    function plot_snap_shot_vecs(infile,tt,nlayer,expt,iyr)

    lon=nc_varget(infile,'lon_rho');
    lat=nc_varget(infile,'lat_rho');
    msk=nc_varget(infile,'mask_rho');
    csr=nc_varget(infile,'Cs_r');

    nsig=length(csr);
    [nlat,nlon]=size(msk);

    t1=nc_varget(infile,'ocean_time',0,1);
    t2=nc_varget(infile,'ocean_time',tt,1);

    iday=(t2-t1)/3600/24;

    t = squeeze(nc_varget(infile,'temp',       [tt nlayer-1 0 0],[1 1 nlat nlon]));
    u = squeeze(nc_varget(infile,'u_eastward', [tt nlayer-1 0 0],[1 1 nlat nlon]));
    v = squeeze(nc_varget(infile,'v_northward',[tt nlayer-1 0 0],[1 1 nlat nlon]));

    V = sqrt(u.^2 + v.^2);

    close all
    pcolor(lon,lat,t./msk), shading flat, caxis([6 27]), colorbar
    hold on, plot_uv3(lon,lat,u,v,msk,5,'k',0,1.,.01,2,.9,.85);
    A=axis; axis equal; axis(A); colormap(mypal3(0.5));
    title([expt ', year ', num2str(iyr) ', day ' num2str(iday)])
    ylabel('Latitude'), xlabel('Longitude')

