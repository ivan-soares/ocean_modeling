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

#from mpl_toolkits.basemap import Basemap

###########################################################################################

print(' ')
print(' +++ Starting python program +++ ')
print(' ')

################### *** read input files *** ##############################################

romsfile = str(sys.argv[1])
roms = Dataset(romsfile,'r')

lon = roms.variables['lon_rho'][:]
lat = roms.variables['lat_rho'][:]

nt, nlat, nlon = roms.variables['temp_sur'].shape

print(' ... ntimes = ' + str(nt))
print(' ... nlats = ' + str(nlat))
print(' ... nlons = ' + str(nlon))

temp = np.squeeze(roms.variables['temp_sur'] [100,:,:])

################## *** plot data *** ######################################################

origin = 'lower'
colormap = 'nipy_spectral'
colormap = 'jet'

fig_name = 'roms_brz0.05r.png'

coastfile = 'costa_leste.mat'
coast = sio.loadmat(coastfile)
clon = coast['lon']
clat = coast['lat']

#np.where(clon < -180, clon + 360 , clon)
#clon = clon +360.
clon[clon == -9999] = np.nan
clat[clat == -9999] = np.nan

# We are using automatic selection of contour levels;
# this is usually not such a good idea, because they don't
# occur on nice boundaries, but we do it here for purposes
# of illustration.

fig1, ax2 = plt.subplots(constrained_layout=True)
CS = ax2.contourf(lon, lat, temp, 100, cmap=colormap, origin=origin)

# Note that in the following, we explicitly pass in a subset of
# the contour levels used for the filled contours.  Alternatively,
# We could pass in additional levels to provide extra resolution,
# or leave out the levels kwarg to use all of the original levels.

#CS2 = ax2.contour(CS, levels=CS.levels[::2], colors='r', origin=origin)

ax2.set_title('ROMS brz0.05r')
ax2.set_xlabel('Longitude')
ax2.set_ylabel('Latitude')

# Make a colorbar for the ContourSet returned by the contourf call.
cbar = fig1.colorbar(CS)
cbar.ax.set_ylabel('degrees C')

# plot coastline
A = ax2.axis(); print(A)
ax2.fill(clon,clat,'g')

# tight and equal axis
ax2.axis('tight')
ax2.axis('equal')
ax2.axis(A)

# save it
plt.savefig(fig_name,dpi=100)
plt.close()


###########################################################################################

print(' ')
print(' +++ End of python program +++ ')
print(' ')

###########################################################################################


