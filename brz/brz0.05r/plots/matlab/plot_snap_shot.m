
function [lon,lat,t,msk] = plot_snap_shot(file,tt,nlayer,ivar,year)

        lon=nc_varget(file,'lon_rho');
        lat=nc_varget(file,'lat_rho');
        %prf=nc_varget(file,'h');
        %csr=nc_varget(file,'Cs_r');

        nsig=1;
        [nlat,nlon]=size(lon);
        
        eta = squeeze(nc_varget(file,'zeta',[0 0 0],[1 nlat nlon]));
        
        msk = ones(size(eta));
        msk(find(eta == 0)) = 0;

        t1=nc_varget(file,'ocean_time',0,1);
        t2=nc_varget(file,'ocean_time',tt-1,1);

        iday=(t2-t1)/3600/24
        tit = [ 'layer ' num2str(nsig-nlayer+1) ', year ' year ', day ' num2str(iday) ];

switch ivar
    case 'temp_sur'
        t = squeeze(nc_varget(file,'temp_sur',[tt-1 0 0],[1 nlat nlon]));
        hold off, pcolor(lon,lat,t./msk), shading interp, caxis([14 27]), colorbar
        title([ 'Temperature, ' tit]), colormap(flipud(mypal3(1.00)));
    case 'temp'
        t = squeeze(nc_varget(file,'temp',[tt-1 nlayer-1 0 0],[1 1 nlat nlon]));
        hold off, pcolor(lon,lat,t./msk), shading interp, caxis([14 28.5]), colorbar
        title([ 'Temperature, ' tit]), colormap(flipud(mypal3(1.00)));
    case 'salt'
        t = squeeze(nc_varget(file,'salt',[tt-1 nlayer-1 0 0],[1 1 nlat nlon]));
        hold off, pcolor(lon,lat,t./msk), shading flat, caxis([32.5 37.5]), colorbar
        title([ 'Salinity, ' tit]), colormap(mypal_ssec);
        
     case 'velo_sur'
        u = squeeze(nc_varget(file,'u_sur_eastward', [tt-1 0 0],[1 nlat nlon]));
        v = squeeze(nc_varget(file,'v_sur_northward',[tt-1 0 0],[1 nlat nlon]));
        t = sqrt(u.^2 + v.^2);
        
        pcolor(lon,lat,t./msk), shading flat, caxis([0 1]), colorbar
        %plot_uv3(lon,lat,u,v,msk,rate,col,ang,scl,vmin,stretch,xi,yi)
        hold on, plot_uv3(lon,lat,u,v,msk,5,'k',0.,3,.1,3,.05,.5)
        title(['Velocity Magnitude, ' tit]), colormap(mypal_redblue(80));
        
    case 'velo'
        u = squeeze(nc_varget(file,'u_eastward', [tt-1 nlayer-1 0 0],[1 1 nlat nlon]));
        v = squeeze(nc_varget(file,'v_northward',[tt-1 nlayer-1 0 0],[1 1 nlat nlon]));
        t = sqrt(u.^2 + v.^2);
        
        pcolor(lon,lat,t./msk), shading flat, caxis([0 1.5]), colorbar
        %plot_uv3(lon,lat,u,v,msk,rate,col,ang,scl,vmin,stretch,xi,yi)
        hold on, plot_uv3(lon,lat,u,v,msk,10,'k',0.,3.,.5,3,.05,.5)
        title(['Velocity Magnitude, ' tit]), colormap(mypal_redblue(100));

    case 'vort'
        u = squeeze(nc_varget(file,'u_eastward', [tt-1 nlayer-1 0 0],[1 1 nlat nlon]));
        v = squeeze(nc_varget(file,'v_northward',[tt-1 nlayer-1 0 0],[1 1 nlat nlon]));
        [dvdx,tmp] = gradient(u);
        [tmp,dudy] = gradient(v); 
        t = dvdx-dudy;
        hold off, pcolor(lon,lat,t./msk), shading flat, caxis([0 1]), colorbar
        title(['Velocity Magnitude, ' tit]), colormap(flipud(mypal3(1.00)));
end

%         hold on,  plot_coast
        ylabel('Latitude'), xlabel('Longitude')
        A=axis; axis equal, axis(A)

    
