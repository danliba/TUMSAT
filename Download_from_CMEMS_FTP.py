# -*- coding: utf-8 -*-
"""
Created on Fri Jul  3 18:06:24 2020

@author: danli
"""


# -*- coding: utf-8 -*-
#'STRAtocaster_12', 'landrew'
#ftp://my.cmems-du.eu/Core/GLOBAL_REANALYSIS_PHY_001_030/global-reanalysis-phy-001-030-daily/1996/06/mercatorglorys12v1_gl12_mean_19960630_R19960703.nc
"""
Created on Fri Jul  3 15:11:58 2020

@author: danli
"""
import os
import ftplib

ftp = ftplib.FTP('my.cmems-du.eu')
ftp.login('landrew', 'STRAtocaster_12')

yrst=1996
yren=1996
most=6
moen=7

savedir = 'D:\descargas\CMEMS\ultimo_dia_del_mes'
os.chdir(savedir)

for iy in range (yrst, yren+1):
    for im in range(most, moen+1):
        ftp.cwd('/Core/GLOBAL_REANALYSIS_PHY_001_030/global-reanalysis-phy-001-030-daily/%d/%02d' % (iy,im))
        print(ftp.cwd)
        dir_list = []
        ftp.dir(dir_list.append)
        dir_list_end=dir_list [-1]
        fn=dir_list_end[58:]
        file = open(fn, 'wb')
        ftp.retrbinary('RETR ' + fn, file.write)
        file.close()
        print(fn)
