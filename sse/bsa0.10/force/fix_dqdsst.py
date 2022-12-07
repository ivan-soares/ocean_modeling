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
matplotlib.use('tkagg')
import matplotlib.pyplot as plt

from matplotlib.colors import BoundaryNorm
from matplotlib.ticker import MaxNLocator

#from mpl_toolkits.basemap import Basemap

###########################################################################################

print(' ' )
print(' +++ Starting python program +++ ')
print(' ' )

###########################################################################################

frcfile = Dataset(str(sys.argv[1]),'r+')

nt, nlat, nlon = frcfile.variables['Tair'].shape

print (' ... nt is ' + str(nt))
print (' ... ny is ' + str(nlat))
print (' ... nx is ' + str(nlon))

dq = -300.0 * np.ones([nt, nlat, nlon])

frcfile.variables['dQdSST'] [:] = dq
frcfile.close()


###########################################################################################

print(' ' )
print(' +++ End of python program +++ ')
print(' ' )

###########################################################################################

