
function plot_snap_shot_floats(file1,file2,tt,nlayer,iopt,year)

        lon=nc_varget(file1,'lon_rho');
        lat=nc_varget(file1,'lat_rho');
        msk=nc_varget(file1,'mask_rho');
        csr=nc_varget(file1,'Cs_r');

        nsig=length(csr);
        [nlat,nlon]=size(msk);

        t1=nc_varget(file1,'ocean_time',0,1);
        t2=nc_varget(file1,'ocean_time',tt-1,1);

        iday=(t2-t1)/3600/24

        tit = [ 'layer ' num2str(nsig-nlayer+1) ', year ' year ', day ' num2str(iday) ];

switch iopt
    case 'temp'
        t = squeeze(nc_varget(file1,'temp',[tt-1 nlayer-1 0 0],[1 1 nlat nlon]));
        hold off, pcolor(lon,lat,t./msk), shading interp, caxis([12 27.5]), colorbar
        title([ 'Temperature, ' tit]), colormap(flipud(mypal3(1.00)));

    case 'salt'
        s = squeeze(nc_varget(file1,'salt',[tt-1 nlayer-1 0 0],[1 1 nlat nlon]));
        hold off, pcolor(lon,lat,s./msk), shading flat, caxis([32.5 37.5]), colorbar
        title([ 'Salinity, ' tit]), colormap(mypal_ssec);
        
    case 'velo'
        u = squeeze(nc_varget(file1,'u_eastward', [tt-1 nlayer-1 0 0],[1 1 nlat nlon]));
        v = squeeze(nc_varget(file1,'v_northward',[tt-1 nlayer-1 0 0],[1 1 nlat nlon]));
        V = sqrt(u.^2 + v.^2);
        
        hold off, pcolor(lon,lat,V./msk), shading flat, caxis([0 1]), colorbar
        title(['Velocity Magnitude, ' tit]), colormap(flipud(mypal3(1.00)));
end

        hold on,  plot_floats(file2,tt),  plot_coast
        ylabel('Latitude'), xlabel('Longitude')
        A=axis; axis equal, axis(A)

    
