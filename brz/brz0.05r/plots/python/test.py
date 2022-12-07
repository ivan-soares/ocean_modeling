
import os, gc, sys
sys.path.append('/home/ivans/scripts/python/')

import numpy as np
import time as tempo
#import netCDF4 as nc
#import subprocess as sp

from my_tools import *
from io_tools_v0 import *

from netCDF4 import Dataset
from romstools import scoord
#from interp_data_v0 import get_ogcm, get_roms_grid_vars, ogcm2roms_delaunay_2d as ogcm2roms


############################ *** introdu *** ######################################################

print(' ')
print(' ===> STARTING PYTHON PROGRAM Make_clm+bry+sst_files.py <=== ')
print(' ')

class data:
      def __init__(self):
          pass

PARAM = data   # ROMS grid params

today   = str(sys.argv[1])
domain  = str(sys.argv[2])
version = str(sys.argv[3])

print (' ... today is ' + today)
print (' ... domain is ' + domain)
print (' ... version is ' + version)
print(' ')
