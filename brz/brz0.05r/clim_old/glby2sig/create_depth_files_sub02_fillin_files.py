#!/usr/bin/env python

########################################################################################

#    compute 3D depths Prf = H*Zeta
#
#                                                          by IDS @ TOC, Ctba 2018

############################ *** importing libraries *** ###############################
import os.path, gc, sys
home = os.path.expanduser('~')
sys.path.append(home + '/scripts/python/')

import numpy as np
import time as tempo

from romstools import get_sigma_level_depths
from netCDF4 import Dataset

########################################################################################

print(' ')
print(' *** STARTING Python program to write depth 3D values ***')
print(' ')

##################### *** check arguments *** ##########################################

error = ' ... ERROR, Wrong # of arguments, exiting !!!'

nargs = len(sys.argv)
print(' ... # of args is : ' + str(nargs))
print(' ... input arguments are : ' + str(sys.argv[1:nargs]))

if nargs != 12:
   sys.exit(error)

#################### *** get file names *** ############################################

romsgrid = str(sys.argv[9])   # roms grid file
outfile1 = str(sys.argv[10])  # file containing depths at sigma levels
outfile2 = str(sys.argv[11])  # file containing depths at hncoda levels

print(' ... file having depths at sigma levels is  ' + outfile1)
print(' ... file having depths at hycom levels is  ' + outfile2)
print(' ')

##################### *** get sigma params *** #########################################

class data:
      def __init__(self):
          pass

params = data

params.spheri = int(sys.argv[1])
params.vtrans = int(sys.argv[2])
params.vstret = int(sys.argv[3])
params.thetas = float(sys.argv[4])
params.thetab = float(sys.argv[5])
params.tcline = int(sys.argv[6])
params.hc = int(sys.argv[7])
params.ns = int(sys.argv[8])

nsig = params.ns

############ *** read h,lon,lat from ROMS gridfile & check nlon/nlat *** ###############

grdfile = Dataset(romsgrid,'r')

prf = grdfile.variables['h'][:]
lon = grdfile.variables['lon_rho'][0, :]
lat = grdfile.variables['lat_rho'][:, 0]

nlat, nlon = prf.shape
nla2 = int(nlat/2)
nlo2 = int(nlon/2)


########### *** compute depths at sigma levels & read ogcm levels *** #################


# this will return parameters sig.zr and sig.zw
# which are the depths at rho and w levels
sig = get_sigma_level_depths(prf, params)
zr = -sig.z_r[:]
zw = -sig.z_w[:]
cr = sig.Cs_r[:]
cw = sig.Cs_w[:]

with open('ogcm_depths') as f:
     zz = f.readlines()

depth = zz[0].split( ); nz = len(depth)
prof = np.zeros([nz, nlat, nlon])

for k in range(nz):
    prof[k, :, :] = float(depth[k])

s_layer = np.arange(1,nsig+1)
z_layer = np.arange(1,nz+1)

print(' ... nlon = ' + str(nlon))
print(' ... nlat = ' + str(nlat))
print(' ... nsig = ' + str(nsig))
print(' ... nz   = ' + str(nz))

print(' ')
print(' ... prf in the middle of domain = ' + str(prf[nla2,nlo2]))
print(' ...  zr in the middle of domain = ' + str(zr[:,nla2,nlo2]))
print(' ')

####################### *** output values *** ###########################################

print(' ')
print(' ... write out values in output files')
print(' ')

out1 = Dataset(outfile1, 'r+')
out2 = Dataset(outfile2, 'r+')

out1.variables['lon'] [:] = lon
out1.variables['lat'] [:] = lat
out1.variables['layer'] [:] = s_layer
out1.variables['depth'] [:] = zr

out2.variables['lon'] [:] = lon
out2.variables['lat'] [:] = lat
out2.variables['prof'] [:] = depth
out2.variables['depth'] [:] = prof

out1.close()
out2.close()

print(' ')
print(' *** END of python program ***')
print(' ')



##################################### THE END ##########################################
