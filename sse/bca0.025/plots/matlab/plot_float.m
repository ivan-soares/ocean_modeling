

function plot_float(infile,nfloat,nday)  

    flon = nc_varget(infile,'lon');
    flat = nc_varget(infile,'lat');

    time = nc_varget(infile,'ocean_time');
    time = time - time(1);
    time = time/24/3600;
    
    t1=nday-1;
    t2=nday-1+0.9;
    
    x = find(time>=t1 & time<=t2);
    
  for k = 1:length(x)
      color = 1-(time(x(k)) - fix(time(x(k))));
      plot(flon(x(k),nfloat),flat(x(k),nfloat),'o','color',[color color color])
  end

%
% end of script
%


