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

# Turn interactive plotting off
plt.ioff()

#import pylab as plt

from matplotlib.colors import BoundaryNorm
from matplotlib.ticker import MaxNLocator

import matplotlib.dates as mdates

#from mpl_toolkits.basemap import Basemap

###########################################################################################

print(' ')
print(' +++ Starting python program +++ ')
print(' ')

###########################################################################################

rmses = []
dates = []

f = open('rmse.dat','r')

while True:
      line = f.readline()
      if not line:
             break
      date = line.split(' ')[0]
      rmse = float(line.split(' ')[1])
      dates.append(date)
      rmses.append(rmse)

f.close()
x_values = [datetime.strptime(d,"%Y-%m-%d").date() for d in dates]
dtFmt = mdates.DateFormatter("%Y-%m-%d")

fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(x_values,rmses); ax.grid()
ax.set_title('RMSE'); ax.set_xlabel('days'); ax.set_ylabel('error')
ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m-%d'))
ax.xaxis_date(); ax.tick_params(axis='x', labelrotation=25)
plt.savefig('rmse.png',dpi=100)
plt.close()


#plt.figure()
#plt.plot(dates,rmses); #plt.grid()
#plt.title('RMSE'),plt.xlabel('days'),plt.ylabel('error')
#plt.gca().xaxis.set_major_formatter(dtFmt)
#plt.savefig('rmse.png',dpi=100)
#plt.close()






###########################################################################################

print(' ')
print(' +++ End of python program +++ ')
print(' ')

###########################################################################################


