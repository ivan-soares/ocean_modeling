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

#import matplotlib
#matplotlib.use('Agg')
import matplotlib.pyplot as plt

from matplotlib.colors import BoundaryNorm
from matplotlib.ticker import MaxNLocator
from scipy.interpolate import interp1d, interp2d, griddata
from romstools import get_roms_date2, scoord, get_sigma_level_depths
from plot_ogcm import plot_contour_and_vectors



###########################################################################################

'''------------------------------ begin aux_function -----------------------------------'''

def transp(vel,lon,prf,lat0):
    dlon = np.diff(lon, axis = 1)
    dprf = np.diff(prf, axis = 0)
    print(dlon)
    print(dprf)
    twopir = 2.0 * np.pi * 6.371e+06
    dx = dlon * twopir * np.cos(lat0 * np.pi / 180.) / 360.
    dz = dprf
    V = vel * dx * dz
    if lat0 == -11.:
       V = sum(V[np.where(V > 0.)]) * 1.e-06
    else:
       V = sum(V[np.where(V < 0.)]) * 1.e-06
    return V


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

lat0 = float(sys.argv[5])
lon1 = float(sys.argv[6])
lon2 = float(sys.argv[7])

maxlon = float(sys.argv[8])
maxprf = float(sys.argv[9])

xlabel = float(sys.argv[10])
ylabel = float(sys.argv[11])

print(' ')
print(' ... will read roms file ' + romsfile )
print(' ... will read grid file ' + gridfile )
print(' ')


ogcm = 'glorys+era5'
MON = '{:02d}'.format(mon)
ntime = mon -1

################## *** read roms velocity *** ################################################

lon = roms.variables['lon'][:]
lat = roms.variables['lat'][:]

time = get_roms_date2(romsfile,ntime)

roms_prf = roms.variables['depth'][:]
roms_vel = roms.variables['v'][ntime,:,:,:]
roms_nan = roms.variables['v'].__getattribute__('missing_value')

nz, nlat, nlon = roms_vel.shape

print(' ')
print(' ... roms NaN ' + str(roms_nan) )
print('                               ')
print(' ...      n. lats ' + str(nlat) )
print(' ...      n. lons ' + str(nlon) )
print(' ')

roms_vel[np.where(roms_vel <= -9000 )] = np.nan


############ append 1 column to U and 1 line to V
############ A = numpy.hstack([A, newline])
############ A = numpy.vstack([A, newrow])

#vvel = np.hstack([vvel, vvel[nlat-2,:]])
#uvel = np.vstack([uvel, uvel[:,nlon-2]])

#uvel = np.insert(uvel, nlon-2, values=uvel[:,nlon-2], axis=1)
#vvel = np.insert(vvel, nlat-2, values=vvel[nlat-2,:], axis=0)
#

across_lon = np.arange(lon1,lon2,0.05); nlon_across = len(across_lon)

print(' ')
print(' ... cross shelf transect lat ' + str(lat0))
print('                                          ')
print(' ... cross shelf transect lon ' + str(across_lon[np.where(across_lon <= maxlon)]))
print(' ')
print(' ... roms depths ' + str(roms_prf[np.where(roms_prf <= maxprf)]))
print(' ')
print(' ')

roms_across_lon = np.zeros((nz, nlon_across))
roms_across_prf = np.zeros((nz, nlon_across))
roms_across_vel = np.zeros((nz, nlon_across))


for i in range(nlon_across):
    roms_across_prf[:,i] = roms_prf[:]

for n in range(nz):
    roms_across_lon[n,:] = across_lon[:]


for n in range(nz):
    roms_across_vel[n, :] = griddata(np.column_stack((lon.ravel(), lat.ravel())),
                            roms_vel[n, :, :].ravel(),(across_lon.ravel(), lat0))    

I = across_lon[np.where(across_lon <= maxlon)]
J = roms_prf[np.where(roms_prf <= maxprf)]

NI = len(I) - 1
NJ = len(J) - 1

bc_vel = roms_across_vel[0:NJ, 0:NI]
bc_lon = roms_across_lon[0:NJ, 0:NI+1]
bc_prf = roms_across_prf[0:NJ+1, 0:NI]

BC_transp = transp(bc_vel, bc_lon, bc_prf, lat0)
BC = '{:.2f}'.format(BC_transp)

print(' ')
print(' ... BC transport on date ' + str(time) + ' is ' + str(BC_transp))
print(' ')

################## *** plot data *** ######################################################

cmap = plt.get_cmap('jet')


############ v northward

units = 'm/s'
vartit = 'Across shelf V NORTHWARD @ lat ' + str(lat0) 
varprn = 'v-northward_across_lat_' + str(-lat0) + '_' + MON + '_' + str(year)

levels = np.arange(-.7,.7,0.05)

tit_name = vartit + ' ' + time
fig_name = varprn + '.png'

fig, (ax1, ax2) = plt.subplots(2)
fig.tight_layout()
fig.suptitle(tit_name)

ax1.contourf(roms_across_lon, -roms_across_prf, roms_across_vel, cmap=cmap)
ax1.axis((lon1 - 0.5, lon2 + 0.5, -500., 0.))
ax1.set_ylabel('Depth (m)')
ax1.set_xticklabels([])
ax1.grid()

ax2.contourf(roms_across_lon, -roms_across_prf, roms_across_vel, cmap=cmap)
ax2.axis((lon1 - 0.5, lon2 + 0.5, -4000., -500.))
ax2.set_xlabel('Longitude')
ax2.grid()

if lat0 == -11.:
    ax2.text(xlabel, ylabel, 'CNB transp ' + str(BC) + ' Sv', color = 'k')
else:
    ax2.text(xlabel, ylabel, 'CB transp ' + str(BC) + ' Sv', color = 'k')

fig.tight_layout()

#cf = plt.contourf(roms_across_lon, -roms_across_prf, roms_across_vel, levels = levels, cmap=cmap)
#cbar = plt.colorbar(cf); cbar.ax.set_ylabel(units)

#plt.title(tit); plt.xlabel('Longitude'); plt.ylabel('Depth')
#plt.axis((lon1 - 0.5, lon2 + 0.5, -4000., 0.))
fig.savefig(fig_name,dpi=100)
#fig.close()


###########################################################################################

print(' ')
print(' +++ End of python program +++ ')
print(' ')

###########################################################################################


