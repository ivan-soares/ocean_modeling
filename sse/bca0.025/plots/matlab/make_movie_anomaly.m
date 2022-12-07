%%%%%%%%%%%%%%%%%  add netcdf paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    addpath ~/Applications/ROMS/matlab/toolbox_ivans
    addpath ~/Applications/ROMS/matlab/mexcdf/snctools
    addpath ~/Applications/ROMS/matlab/mexcdf/mexnc
    addpath ~/Applications/ROMS/matlab/netcdf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   expt NPO1/125 year 2011
%        initial time is reffered to 01/01/2010: 31536000 secs
%        npo_his.nc: data storage interval = 6 hours
%        npo_avg.nc: data storage interval = 48 hours
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    iyear = 2012;
    infile= ['~/TOC_STORAGE/ROMS_output/npo1.125_large/' num2str(iyear) '/npo_avg.nc']
    nlayer = 28;
    expt = 'NPO1/125';

    M1=['movie_roms_temp_'  num2str(iyear) '.avi']
    M2=['movie_roms_velo_'  num2str(iyear) '.avi']

    myvideo1 = VideoWriter(M1)
    myvideo1.FrameRate = 5; %default 30
    myvideo1.Quality = 100;  %default 75
    open(myvideo1)

    myvideo2 = VideoWriter(M2)
    myvideo2.FrameRate = 5; %default 30
    myvideo2.Quality = 100;  %default 75
    open(myvideo2)

    nn = 1;

    nt=length(nc_varget(infile,'ocean_time'))
    nlat=size(nc_varget(infile,'mask_rho'),1)
    nlon=size(nc_varget(infile,'mask_rho'),2)

    tbar = zeros(nlat,nlon);
    ubar = zeros(nlat,nlon);
    vbar = zeros(nlat,nlon);

for tt=1:nt-1
    tbar = tbar + squeeze(nc_varget(infile,'temp',       [tt nlayer-1 0 0],[1 1 nlat nlon]))/(nt-1);
    ubar = ubar + squeeze(nc_varget(infile,'u_eastward', [tt nlayer-1 0 0],[1 1 nlat nlon]))/(nt-1);
    vbar = vbar + squeeze(nc_varget(infile,'v_northward',[tt nlayer-1 0 0],[1 1 nlat nlon]))/(nt-1);
end

    avg(1,:,:) = tbar;
    avg(2,:,:) = ubar;
    avg(3,:,:) = vbar;
  
for tt=1:nt-1
    frame=sprintf('%3.3d',nn)
    plot_snap_shot_anomaly(infile,tt,nlayer,expt,iyear,avg)
    figure(1), drawnow, writeVideo(myvideo1,getframe(gcf));
    eval(['print -dtiff temp_' frame '.tif'])
    figure(2), drawnow, writeVideo(myvideo2,getframe(gcf));
    eval(['print -dtiff velo_' frame '.tif'])
    nn = nn+1;
end
    close(myvideo1)
    close(myvideo2)
    eval(['!convert -delay 30 temp_*.tif movie_roms_tprime_' num2str(iyear) '.gif'])
    eval(['!convert -delay 30 velo_*.tif movie_roms_vprime_' num2str(iyear) '.gif'])
    !rm temp_*.tif
    !rm velo_*.tif
%
% end of script
%

