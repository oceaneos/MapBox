#!/usr/bin/env python2.7
###############################################################################
#
# Python example of gdal_translate
#
###############################################################################

# MIT License
#
# Copyright (c) 2016 ePi Rational, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


from osgeo import gdal
import numpy as numpy
import argparse

usage = '''
This is a Python wrapper of some of the options for http://www.gdal.org/gdal_translate.html
This is not intended to replace gdal_translate

Example,
gdal_translate -of VRT input.tif output.vrt
gdal_translate -of PNG input.tif output.png

'''
#
# parser = argparse.ArgumentParser(description='converts raster data between different formats', epilog = usage, formatter_class=argparse.RawTextHelpFormatter)
# parser.add_argument('src_dataset')
# parser.add_argument('dst_dataset')
# parser.add_argument('-of', '--format', help='Select the output format. The default is GeoTIFF (GTiff). Use the short format name.', required=False)
# args = parser.parse_args()


if __name__ == '__main__':


  print "FS TOPO"
  fs = gdal.Open('363011815_Mount_Whitney_FSTopo.tif')



  src = gdal.Open('MY1DMM_CHLORA_2002-07.TIFF')
  band = src.GetRasterBand(1)
  data = numpy.array(src.GetRasterBand(1).ReadAsArray())

  ## manipulate color map with gdalcolormapper.py

  # gdal_translate $new_color_table $new_tiff
  srcVrt = gdal.Open('kindlmann.vrt')
  format = "GTiff"
  driver = gdal.GetDriverByName( format )
  dst_ds_tif = driver.CreateCopy( "kindlmann.tif", srcVrt, 0 )
  # dst_ds = driver.Create(  "kindlmann.tif", 3600, 1800, 1, gdal.GDT_Byte )
  dst_ds_tif = None

  float = gdal.Open('../../input/float/MY1DMM_CHLORA_2002-07.FLOAT.TIFF')
  f = numpy.array(float.GetRasterBand(1).ReadAsArray())
  grid = numpy.meshgrid(f)
  t = numpy.less (grid , 1.0)
  choice = numpy.logical_and(t , grid)
  lowPlank = numpy.extract(choice, grid)
  print numpy.sum(lowPlank)
