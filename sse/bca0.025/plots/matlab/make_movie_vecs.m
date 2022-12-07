%%%%%%%%%%%%%%%%%  add netcdf paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    addpath ~/Applications/ROMS/matlab/toolbox_ivans
    addpath ~/Applications/ROMS/matlab/mexcdf/snctools
    addpath ~/Applications/ROMS/matlab/mexcdf/mexnc
    addpath ~/Applications/ROMS/matlab/netcdf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   expt NPO1/125 year 2013
%        initial time is reffered to 01/01/2010: 31536000 secs
%        npo_his.nc: data storage interval = 6 hours
%        npo_avg.nc: data storage interval = 5 days
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    layer = 28;
    ivrsn = '';
    iyear = 2011;
    iexpt = 'NPO 1/12.5';
    ifile = ['~/TOC_STORAGE/ROMS_output/npo1.125_large/' num2str(iyear) ivrsn '/npo_avg.nc'];

    M=['movie_npo_'  num2str(iyear) '.avi']

    myvideo = VideoWriter(M);
    myvideo.FrameRate = 5;  %default 30
    myvideo.Quality = 100;  %default 75
    open(myvideo)

    n1 = 1;
    nn = 1;
    nt = length(nc_varget(ifile,'ocean_time'))

for tt=n1:nt-1
    %frame=sprintf('%3.3d',nn)
    plot_snap_shot_vecs(ifile,tt,layer,iexpt,iyear); 
    writeVideo(myvideo,getframe(gcf));
    nn = nn+1;
end
    close(myvideo)
%
% end of script
%

