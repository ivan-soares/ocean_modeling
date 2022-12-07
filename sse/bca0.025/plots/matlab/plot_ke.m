%%%%%%%%%%%%%%%%%  add netcdf paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    addpath ~/roms/matlab/toolbox_ivans
    addpath ~/roms/matlab/toolbox_ivans/seawater
    addpath ~/roms/matlab/mexcdf/snctools
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/netcdf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   expt NPO1/125 years 2010, 2011, 2012, ...
%        initial time is reffered to 01/01/2010: 31536000 secs
%        npo_his.nc: data storage interval = 6 hours
%        npo_avg.nc: data storage interval = 48 hours
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    iyear = 2012;
    iopt = 'compute_one' % 'compute_one' 'plot_one' 'plot_several'

switch lower(iopt)

  case 'compute_one'

    infile= ['~/TOC_STORAGE/ROMS_output/npo1.125_large/' num2str(iyear) '/npo_his.nc']

    roms.time=nc_varget(infile,'ocean_time');
    roms.lat=nc_varget(infile,'lat_rho');
    roms.lon=nc_varget(infile,'lon_rho');
    roms.sig=nc_varget(infile,'Cs_r');
    roms.h=nc_varget(infile,'h');

    roms.nt=length(roms.time);
    roms.nsig=length(roms.sig);
    roms.nlat=size(roms.lat,1);
    roms.nlon=size(roms.lat,2)

    for l=1:roms.nsig
        d(l,:,:)=-roms.h(:,:)*roms.sig(l);
    end

    for row=1:roms.nlat
    for col=1:roms.nlon
        p(:,row,col)=sw_pres(squeeze(d(:,row,col)),30);
    end
    end

    for n = 1:roms.nt,
        u = nc_varget(infile,'u_eastward',[n-1 0 0 0],[1 roms.nsig roms.nlat roms.nlon]);
        v = nc_varget(infile,'v_northward',[n-1 0 0 0],[1 roms.nsig roms.nlat roms.nlon]);
        t = nc_varget(infile,'temp',[n-1 0 0 0],[1 roms.nsig roms.nlat roms.nlon]);
        s = nc_varget(infile,'salt',[n-1 0 0 0],[1 roms.nsig roms.nlat roms.nlon]);
        r = sw_dens(s,t,p);
        k = r.*(u.^2 + v.^2)/2;
        roms.K(n) = nanmean(nanmean(nanmean(k)));
    end
    eval(['save ke_' num2str(iyear) ' roms'])

  case 'plot_one'

    eval(['load kinetic_' num2str(iyear)])
    plot(K),title(['NPO 1/12.5 - Mean Kinetic Energy - ' num2str(iyear)])
    ylabel('Joule/m2'), xlabel('days')
    eval(['print -dtiff k_' num2str(iyear) '.tif'])
    
  case 'plot_several'

    load kinetic_2011; 
    k2011 = K;
    t2011 = time; 
    clear K 

    load kinetic_2012; 
    k2012 = K; 
    t2012 = time;
    
    clear K u v t s r k p n d row col 

    k = [k2011(:); k2012(:)];
    time = [t2011; t2012]; time=time/3600/24;

    plot(time,k),title(['NPO 1/12.5 - Mean Kinetic Energy - 2011-2012'])
    ylabel('Joule/m2'), xlabel('days')

  otherwise

    disp('wrong option')

end    
%
% end of script
%

