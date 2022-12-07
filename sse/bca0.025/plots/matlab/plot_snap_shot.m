
function [lon,lat,t,msk,bb] = plot_snap_shot(file,grdfile,tt,nlayer,ivar,date)

        lon=nc_varget(grdfile,'lon_rho');
        lat=nc_varget(grdfile,'lat_rho');
        msk=nc_varget(grdfile,'mask_rho');
        csr=nc_varget(file,'Cs_r');

        nsig=length(csr);
        [nlat,nlon]=size(msk);

        t1=nc_varget(file,'ocean_time',0,1)
        t2=nc_varget(file,'ocean_time',tt-1,1)

        h=(t2-t1)/3600/24

        tit = [ 'layer ' num2str(nsig-nlayer+1) ', ' date ', hour ' num2str(h) ];

switch ivar
    case 'temp'
        t = squeeze(nc_varget(file,'temp',[tt-1 nlayer-1 0 0],[1 1 nlat nlon]));
        pcolor(lon,lat,t./msk), shading interp, caxis([20 27.5]), colorbar
        title([ 'Temperature, ' tit]), colormap(flipud(mypal3(1.00)));

    case 'salt'
        t = squeeze(nc_varget(file,'salt',[tt-1 nlayer-1 0 0],[1 1 nlat nlon]));
        pcolor(lon,lat,t./msk), shading flat, caxis([32.5 37.5]), colorbar
        title([ 'Salinity, ' tit]), colormap(mypal_ssec);
        
    case 'velo'
        u = squeeze(nc_varget(file,'u_eastward', [tt-1 nlayer-1 0 0],[1 1 nlat nlon]));
        v = squeeze(nc_varget(file,'v_northward',[tt-1 nlayer-1 0 0],[1 1 nlat nlon]));
        t = sqrt(u.^2 + v.^2);
        
        pcolor(lon,lat,t./msk), shading flat, caxis([0 1.]), colorbar
        %plot_uv3(lon,lat,u,v,msk,rate,col,ang,scl,vmin,stretch,xi,yi)
        hold on, plot_uv3(lon,lat,u,v,msk,5,'k',0.,1.,.1,3,.05,.95)
        title(['Velocity Magnitude, ' tit]), colormap(mypal_redblue(100));
end

        hold on %,  plot_coast
        ylabel('Latitude'), xlabel('Longitude')
        A=axis; axis equal, axis(A)
       
        lon1 = min(min(lon)); lon2 = max(max(lon));
        lat1 = min(min(lat)); lat2 = max(max(lat));
        
        bb = [lon1 lat2; lon1 lat1; lon2 lat1; lon2 lat2; lon1 lat2]; 
    
