#!/usr/bin/env python
#
# python make an animation of snap shots
#
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

from plot_ogcm import *

import plotly.figure_factory as ff
import plotly.graph_objects as go

####################################################

print(' ')
print(' +++ STARTING python program to plots ROMS +++')
print(' ')

inp = str(sys.argv[1])
inpfile=Dataset(inp,'r')

today = str(sys.argv[2])
nhour = int(sys.argv[3])
dtime = int(sys.argv[4])
vint = int(sys.argv[5])

today = today + '_' + str(nhour).zfill(3)

############## reads in lon, lat, ssh & temp

lat = inpfile.variables['lat_rho'] [:]
lon = inpfile.variables['lon_rho'] [:]

prf = inpfile.variables['h'][:]
#msk = inpfile.variables['mask_rho'][:]

ssh = inpfile.variables['zeta'] [dtime,:,:]
nlat, nlon = ssh.shape
ndims = str(nlat) + ' x ' + str(nlon) 
print(' ... zeta is shaped ' + ndims)

temp = inpfile.variables['temp'] [dtime, 29, :,:]
nlat, nlon = temp.shape
ndims = str(nlat) + ' x ' + str(nlon)
print(' ... temp is shaped ' + ndims)

############# reads in and reshape U and V

u2d = inpfile.variables['u'][dtime,29,:,:]
v2d = inpfile.variables['v'][dtime,29,:,:]

ssh[np.where(prf < 1.)] = np.nan
temp[np.where(prf < 1.)] = np.nan
prf[np.where(prf < 1.)] = np.nan


############ append 1 column to U and 1 line to V
############ A = numpy.hstack([A, newline])
############ A = numpy.vstack([A, newrow])

#v2d = np.hstack([v2d, v2d[nlat-2,:]])
#u2d = np.vstack([u2d, u2d[:,nlon-2]])

u2d = np.insert(u2d, nlon-2, values=u2d[:,nlon-2], axis=1)
v2d = np.insert(v2d, nlat-2, values=v2d[nlat-2,:], axis=0)

nlat, nlon = u2d.shape
ndims = str(nlat) + ' x ' + str(nlon)
print(' ... U is shaped ' + ndims)

nlat, nlon = v2d.shape
ndims = str(nlat) + ' x ' + str(nlon)
print(' ... V is shaped ' + ndims)


vel = np.sqrt(u2d**2 + v2d**2)


coastfile = "costa_leste_brasil.mat"
coast = sio.loadmat(coastfile)

############## plot SSH

tit = 'ROMS SLA  on ' + today
fig = 'roms_sla_' + today + '.png'
units = 'm'

contour_ogcm_new(lon,lat,ssh,tit,fig,coastfile,units,-.5,.5,'jet')


############### plot SST

tit = 'ROMS SST  on ' + today
fig = 'roms_sst_' + today + '.png'
units = 'deg C'

contour_ogcm_new(lon,lat,temp,tit,fig,coastfile,units,20.,30.,'jet')

############### plot topo


tit = 'ROMS toppography'
fig = 'roms_topo.png'
nits = 'm'

contour_ogcm_new(lon,lat,prf,tit,fig,coastfile,units,0.,5000.,'jet')


print(' ')
print(' +++ END of python program to plots ROMS +++')
print(' ')

