###########################################################################################

#       Python program by IDS @ TOC, Florianopolis, Brazil
#                                                                       2021-02-01

###########################################################################################

import os.path, gc, sys
home = os.path.expanduser('~')
sys.path.append(home + '/scripts/python/')

import math
import numpy as np
import scipy.io as sio

from netCDF4 import Dataset
from datetime import datetime, timedelta

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

from matplotlib.colors import BoundaryNorm
from matplotlib.ticker import MaxNLocator

from romstools import get_roms_date, scoord, get_sigma_level_depths
from plot_ogcm import plot_contour_and_vectors

###########################################################################################

'''------------------------------ begin aux_function -----------------------------------'''

def transp(romsfile, PARAM, lat0, lon1, lon2, nt):

    roms = Dataset(romsfile,'r')

    vel = roms.variables['v'][nt,:,lat0,lon1:lon2+1]
    lon = roms.variables['lon_rho'][lat0,lon1:lon2+1]
    lat = roms.variables['lat_rho'][lat0,lon1:lon2+1]
    prf = roms.variables['h'][lat0,lon1:lon2]

    #nlon = lon.shape[0]

    print(' ... nlon is ' + str(nlon))

    sig = get_sigma_level_depths(prf, PARAM)
    prf = -sig.z_w[:]

    ns = PARAM.ns
    alon = np.zeros((vel.shape))

    for n in range(ns):
        alon[n,:] = lon[:]
    
    dlon = np.diff(alon, axis = 1)
    dprf = np.diff(prf, axis = 0)

    print(' ... dlon  ' + str(dlon))
    print(' ... dprf  ' + str(dprf))
    #print(' ... vel is shaped ' + str(vel.shape))

    v  = 0.5 * (vel[:,0:nlon-1] + vel[:,1:nlon])

    #dlon = np.hstack((dlon,dlon[:,-1]))
    #dprf = np.vstack((dprf,dprf[-1,:]))

    twopir = 2.0 * np.pi * 6.371e+06
    dx = dlon * twopir * np.cos(lat0 * np.pi / 180.) / 360.
    dz = dprf
    V = -v * dx * dz

    print(' ... TRANSP is shape ' + str(V.shape))

    if lat[0] > -13.:
       T = sum(V[np.where(V > 0.)]) * 1.e-06
    else:
       T = sum(V[np.where(V < 0.)]) * 1.e-06

    return V,T


'''-------------------------------- end aux_function -----------------------------------'''

###########################################################################################

print(' ')
print(' +++ Starting python program +++ ')
print(' ')


################### *** read input files *** ##############################################

romsfile = str(sys.argv[1])
gridfile = str(sys.argv[2])

roms = Dataset(romsfile,'r')
grid = Dataset(gridfile,'r')

mon = int(sys.argv[3])
year = int(sys.argv[4])

lat0 = int(sys.argv[5])
lon1 = int(sys.argv[6])
lon2 = int(sys.argv[7])

transect_name = str(sys.argv[8])

print(' ')
print(' ... will read roms file ' + romsfile )
print(' ... will read grid file ' + gridfile )
print(' ')

MON = '{:02d}'.format(mon)
ntime = mon -1

########### *** read grid vars *** #######################################################

lon = roms.variables['lon_rho'][lat0,lon1:lon2]; nlon = len(lon)
lat = roms.variables['lat_rho'][lat0,lon1:lon2]; nlat = len(lat)
prf = roms.variables['h'][lat0,lon1:lon2]

print(' ')
print(' ... will compute BC transport @ lat ' + str(lat[0]))
print(' ')

################## *** get depths at rho points *** ######################################

class data:
      def __init__(self):
          pass
PARAM = data   # ROMS grid params

PARAM.spheri = 1
PARAM.vtrans = 2 
PARAM.vstret = 4
PARAM.thetas = 4.
PARAM.thetab = 4.
PARAM.tcline = 100
PARAM.hc     = 100
PARAM.ns     = 30

sig = get_sigma_level_depths(prf, PARAM)
prf = sig.z_r[:]

################## *** read roms file *** ################################################

time = get_roms_date(romsfile,ntime)

print(' ')
print(' ... date ' + str(time))
print(' ')

zeta = roms.variables['zeta'] [ntime,lat0,lon1:lon2]
temp = roms.variables['temp'] [ntime,:,lat0,lon1:lon2]
velo = roms.variables['v'][ntime,:,lat0,lon1:lon2]

ns = PARAM.ns
alon = np.zeros((ns,nlon))

for n in range(ns):
    alon[n,:] = lon[:]

print(' ... Lon is shaped ' + str(alon.shape))
print(' ... Prf is shaped ' + str(prf.shape))
print(' ... Vel is shaped ' + str(velo.shape))


############# *** compute transport *** ##################################################

BC_Vzao, BC_transp = transp(romsfile, PARAM, lat[0], lon1, lon2, ntime)
BC = '{:.2f}'.format(BC_transp)

print(' ')
print(' ... BC transport on date ' + str(time) + ' is ' + str(BC_transp))
print(' ')

############ *** plot a map showing across shelf *** #####################################

coastfile = "costa_leste.mat"
coast = sio.loadmat(coastfile)

lo1 = roms.variables['lon_rho'][:]
la1 = roms.variables['lat_rho'][:]
dep = roms.variables['h'][:] 
LAT = str(round(-lat[0],2))

plt.figure()
plt.contourf(lo1,la1,dep,cmap='jet')
plt.plot(lon,lat,'.r')
plt.plot(coast['lon'],coast['lat'],'g')
plt.axis((-60,-25,-45,-5))
plt.savefig('across_lat_' + LAT + '.png')
plt.close()


################## *** plot data *** ######################################################

levels = MaxNLocator(nbins=100).tick_values(10., 30.)
cmap = plt.get_cmap('jet')

print(' ... lon1 ' + str(lon[0]))
print(' ... lon2 ' + str(lon[-1]))

label_xpos = lon[0] + (lon[-1] - lon[0] )/10.
label_ypos = np.min(prf) - np.min(prf)/10
label_ypos2 = np.min(prf) - np.min(prf)/25

print(' ... label xpos ' + str(label_xpos))
print(' ... label ypos ' + str(label_ypos))
print(' ... label ypos2 ' + str(label_ypos2))

############## temp

units = 'deg C'
vartit = 'Acros shelf Temp @ lat ' + LAT 
varprn = 'temp_across_lat_' + LAT + '_' + MON + '_' + str(year)

levels = np.arange(0,30,0.25)

tit = vartit + ' ' + time
fig = varprn + '.png'

plt.figure()
cf = plt.contourf(alon, prf, temp, levels , cmap=cmap, alpha = 0.75)
cbar = plt.colorbar(cf); cbar.ax.set_ylabel(units)
plt.title(tit); plt.xlabel('Longitude'); plt.ylabel('Depth')
plt.savefig(fig,dpi=100)
plt.close()


############ v

units = 'm/s'
vartit = 'Across shelf V @ lat ' + LAT
varprn = 'v_across_lat_' + LAT + '_' + MON + '_' + str(year)

levels = np.arange(-1.,1.,0.05)

tit = vartit + ' ' + time
fig = varprn + '.png'

plt.figure()
cf = plt.contourf(alon, prf, velo, cmap=cmap, alpha = 0.95)
cbar = plt.colorbar(cf); cbar.ax.set_ylabel(units)
plt.title(tit); plt.xlabel('Longitude'); plt.ylabel('Depth')

if lat[0] < -13.:
    plt.text(label_xpos, label_ypos,  transect_name, color = 'k')
    plt.text(label_xpos, label_ypos2, 'CB transp ' + str(BC) + ' Sv', color = 'k')
else:
    plt.text(label_xpos, label_ypos,  transect_name, color = 'k')
    plt.text(label_xpos, label_ypos2, 'CNB transp ' + str(BC) + ' Sv', color = 'k')

#plt.tight_layout()


plt.savefig(fig,dpi=100)
plt.close()

############ vzao

units = 'm³/s'
vartit = 'Across shelf Vzao @ lat ' + LAT
varprn = 'vzao_across_lat_' + LAT + '_' + MON + '_' + str(year)

levels = np.arange(-1.,1.,0.05)

tit = vartit + ' ' + time
fig = varprn + '.png'

plt.figure()
cf = plt.contourf(alon, prf, BC_Vzao, cmap=cmap, alpha = 0.95)
cbar = plt.colorbar(cf); cbar.ax.set_ylabel(units)
plt.title(tit); plt.xlabel('Longitude'); plt.ylabel('Depth')

if lat0 < -13.:
    plt.text(label_xpos, label_ypos,  transect_name, color = 'k')
    plt.text(label_xpos, label_ypos2, 'CB transp ' + str(BC) + ' Sv', color = 'k')
else:
    plt.text(label_xpos, label_ypos,  transect_name, color = 'k')
    plt.text(label_xpos, label_ypos2, 'CNB transp ' + str(BC) + ' Sv', color = 'k')

#plt.tight_layout()


plt.savefig(fig,dpi=100)
plt.close()


###########################################################################################

print(' ')
print(' +++ End of python program +++ ')
print(' ')

###########################################################################################


