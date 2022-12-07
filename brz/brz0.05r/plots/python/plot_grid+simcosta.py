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

# Turn interactive plotting off
plt.ioff()

#import pylab as plt

from matplotlib.colors import BoundaryNorm
from matplotlib.ticker import MaxNLocator

#from mpl_toolkits.basemap import Basemap

###########################################################################################

print(' ')
print(' +++ Starting python program +++ ')
print(' ')

###########################################################################################


#grid1 = Dataset(str(sys.argv[1]),'r')
#grid2 = Dataset(str(sys.argv[2]),'r')

grid = Dataset('grid_brz0.05r_01d.nc','r')

fvars = grid.variables
fdims = grid['h'].shape

print(' ')
print(' ... dimensions of vars in grid file are ' + str(fdims))
print(' ')

lon = grid.variables['lon_rho'][:]
lat = grid.variables['lat_rho'][:]
msk = grid.variables['mask_rho'][:]
prf = grid.variables['h'][:]

lon_rg = float('{:.4f}'.format(-52. - ( 1. + 30./60.)/60.))
lat_rg = float('{:.4f}'.format(-32. - (17. + 03./60.)/60.))

lon_rj = float('{:.4f}'.format(-43. - ( 9. + 01./60.)/60.))
lat_rj = float('{:.4f}'.format(-22. - (58. + 18./60.)/60.))

lon_ba1 = float('{:.4f}'.format(-38. - (32. + 30./60.)/60.))
lat_ba1 = float('{:.4f}'.format(-12. - (59. + 22./60.)/60.))

lon_ba2 = float('{:.4f}'.format(-37. - (58. + 30./60.)/60.))
lat_ba2 = float('{:.4f}'.format(-12. - (36. + 12./60.)/60.))

lon_tra = float('{:.4f}'.format(-50. - (02. + 44./60.)/60.))
lat_tra = float('{:.4f}'.format(-30. - (00. + 18./60.)/60.))

lon_ilh = float('{:.4f}'.format(-45. - (21. + 17./60.)/60.))
lat_ilh = float('{:.4f}'.format(-23. - (46. + 25./60.)/60.))

lon_fun = float('{:.4f}'.format(-44.9262))
lat_fun = float('{:.4f}'.format(-25.28028))

print(' ')
print(' RG  ' + str(lon_rg) + ' / ' + str(lat_rg))
print(' RJ  ' + str(lon_rj) + ' / ' + str(lat_rj))
print(' BA1 ' + str(lon_ba1) + ' / ' + str(lat_ba1))
print(' BA1 ' + str(lon_ba2) + ' / ' + str(lat_ba2))
print(' TRA ' + str(lon_tra) + ' / ' + str(lat_tra))
print(' ILH ' + str(lon_ilh) + ' / ' + str(lat_ilh))
print(' FUN ' + str(lon_fun) + ' / ' + str(lat_fun))
print(' ')

######################### plot fig

origin = 'lower'
colormap = 'nipy_spectral'
colormap = 'jet'

fig_name = 'brz0.05r_grid+simcosta.png'

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
CS = ax2.contourf(lon, lat, prf, 100, cmap=colormap, origin=origin)

ax2.set_title('ROMS grid brz0.05r + boias Simcosta + fundeio BR')
ax2.set_xlabel('Longitude')
ax2.set_ylabel('Latitude')

# Make a colorbar for the ContourSet returned by the contourf call.
cbar = fig1.colorbar(CS)
cbar.ax.set_ylabel('m')

# plot coastline
A = ax2.axis(); print(A)
ax2.fill(clon,clat,'g')

# plot buoys
ax2.plot(lon_rg,lat_rg,'*m')
ax2.plot(lon_rj,lat_rj,'*m')
ax2.plot(lon_ba1,lat_ba1,'*m')
ax2.plot(lon_ba2,lat_ba2,'*m')
ax2.plot(lon_tra,lat_tra,'*m')
ax2.plot(lon_ilh,lat_ilh,'*m')
ax2.plot(lon_fun,lat_fun,'*c')

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


