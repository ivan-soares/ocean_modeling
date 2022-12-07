

function plot_float(infile,nday)  

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
      plot(flon(x(k),1),flat(x(k),1),'+','color',[color color color])
      plot(flon(x(k),2),flat(x(k),2),'+','color',[color color color])
      plot(flon(x(k),3),flat(x(k),3),'+','color',[color color color])
      
      plot(flon(x(k),4),flat(x(k),4),'+','color',[color color color])
      plot(flon(x(k),5),flat(x(k),5),'+','color',[color color color])
      plot(flon(x(k),6),flat(x(k),6),'+','color',[color color color])
      
      plot(flon(x(k),7),flat(x(k),5),'+','color',[color color color])
      plot(flon(x(k),8),flat(x(k),8),'+','color',[color color color])
      plot(flon(x(k),9),flat(x(k),9),'+','color',[color color color])
      
  end

%
% end of script
%


