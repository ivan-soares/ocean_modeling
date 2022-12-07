%
% Escolha o ano para correção de fase. Em experimentos de varios anos, o
% ideal é que se faça cada ano separadamente, cada qual com um arquivo de
% maré diferente, assim como os arquivos das outras forçantes !!
%
% Observe a mensagem lançada durante a execução ...
% Now go to /home/ivan/etc ... and run extract_HC for otps_input_z,otps_input_u,otps_input_v and press enter afterwards
%
% na shell mencionada faça : 
% 
% for i in {u,v,z}; do ./extract_HC < otps_input_${i} ; done
%

year = 2019;
refy = 2000;

vrsn = '01a';
region = 'sse';
domain = 'bsa0.025';

dir = ['/home/ivans/roms/cases/' region '/' domain];
gridfile = [ dir '/grid/grid_' domain '_' vrsn '.nc'];
tidefile = [ dir '/tide/tide_' domain '_' vrsn '_' num2str(year)  '_ref2000.nc'];

title = 'BSA 1/40  49.0W-39.0W 29.5S-22.0S  2019' 

addpath /home/ivans/roms/matlab/netcdf
addpath /home/ivans/roms/matlab/mexcdf/mexnc
addpath /home/ivans/roms/matlab/mexcdf/snctools
addpath /home/ivans/roms/matlab/roms_otps

addpath /home/ivans/roms/matlab/tidal_ellipse
addpath /home/ivans/roms/matlab/t_tide

otpsfile = '/home/ivans/apps/OTPS/DATA/Model_AO_atlas';

tpred = datenum(year,1,1)
trefy = datenum(refy,1,1)

otps2frc_v4(gridfile,trefy,tpred,tidefile,otpsfile); 


