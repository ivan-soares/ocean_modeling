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

###########################################################################################

inpfile = str(sys.argv[1])
dat = Dataset(inpfile,'r')

lat = dat.variables['latitude'] [:]
lon = dat.variables['longitude'] [:]

coastfile = '/home/ivans/data/costas/costa_mundo.mat'
coast = sio.loadmat(coastfile)

fig_name = 'jason-3_track_2021-01-01.png'

fig = plt.figure()
ax = fig.add_subplot(111)
ax.set(title = 'Satellite tracks', ylabel = 'Latitude', xlabel = 'Longitude')
ax.set(xlim = [-180., + 180.], ylim = [-90., +90.])
plt.plot(lon, lat, 'ko')
plt.plot(coast['lon'],coast['lat'],'g.')
plt.savefig(fig_name,dpi=100)
plt.close()


###########################################################################################

print(' ')
print(' +++ End of python program +++ ')
print(' ')

###########################################################################################


