%%%%%%%%%%%%%%%%%  add netcdf paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    addpath ~/apps/mymatlab/ivans
    addpath ~/mystuff/toolbox_ivans
    addpath ~/roms/matlab/mexcdf/snctools
    addpath ~/roms/matlab/mexcdf/mexnc
    addpath ~/roms/matlab/netcdf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    nvar = 'salt';
    year = '2012';
    name = ['movie_' nvar '_' year '_1.avi']
    
    file1 = '~/roms_results/sse/bsantos1.50/2012_02a/bsantos_avg.nc';
    file2 = '~/roms_results/sse/bsantos1.50/2012_02a/bsantos_flt.nc';
    
    myvideo = VideoWriter(name,'Uncompressed AVI');
    myvideo.FrameRate = 5;   %default 30
    %myvideo.Quality = 100;  %default 75
    open(myvideo)

    nt = nc_getvarinfo(file1,'ocean_time'); nt=nt.Size(1);

for n=1:nt
    hold off, plot_snap_shot(file1,file2,n,20,nvar,year);
    writeVideo(myvideo,getframe(gcf))
end
    close(myvideo)
%
% end of script
%

