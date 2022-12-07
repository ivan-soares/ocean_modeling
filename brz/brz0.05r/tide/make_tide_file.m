%
% Escolha o ano para correção de fase. Em experimentos de varios anos, o
% ideal é que se faça cada ano separadamente, cada qual com um arquivo de
% maré diferente, assim como os arquivos das outras forçantes !!
%
% Observe a mensagem lançada durante a execução ...
% Now go to /home/ivan/etc ... and run extract_HC for otps_input_z,otps_input_u,otps_input_v and press enter afterwards
%
% na shell mencionada faça : 
% for i in {u,v,z}; do ./extract_HC < otps_input_${i} ; done
% 

%

year = 2019;
refy = 2000;

vrsn = '01d';
region = 'brz';
grddomain = 'brz0.05r';
domain = 'brz0.05r';

dir = ['/home/ivans/roms/cases/' region '/' grddomain];
gridfile = [ dir '/grid/grid_' domain '_' vrsn '.nc'];
tidefile = [ dir '/tide/tide_' domain '_' vrsn '_' num2str(year)  '_ref' num2str(refy)  '.nc'];

title = ['BRZ 1/20 rotated ' num2str(year)] 

addpath /home/ivans/roms/matlab/netcdf
addpath /home/ivans/roms/matlab/mexcdf/mexnc
addpath /home/ivans/roms/matlab/mexcdf/snctools
addpath /home/ivans/roms/matlab/roms_otps

addpath /home/ivans/roms/matlab/tidal_ellipse
addpath /home/ivans/roms/matlab/t_tide

otpsfile = '/home/ivans/apps/OTPS/DATA/Model_AO';

tref  = datenum(refy,1,1);
tpred = datenum(year,1,1);

otps2frc_v4(gridfile,tref,tpred,tidefile,otpsfile);


