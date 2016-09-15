#!/usr/bin/env python
# Copyright 2016 ePi Rational, Inc.
# Copyright 2016 Oceaneos Environmental Solutions, Inc

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


import gdal
import sys
import os.path

# This Python script takes a Color Table from a VRT file
# and sets the Green Channel to zero, and then writes out a seperate VRT file

# Documentaton on the GDAL bindings for Python
# http://gdal.org/python/
# Example Python code for various Python commands for GDAL
# https://pcjericks.github.io/py-gdalogr-cookbook/raster_layers.html

if (len(sys.argv) < 2):
  print "Usage: gdalNoGreen.py input output"
  print ""
  print "Example"
  print "   gdalNoGreen.py clut.vrt out.vrt"
  sys.exit(1)

input = sys.argv[1]
output = sys.argv[2]

# Python Constants
GREEN_VALUE_RGBA = 1
ZERO = 0

dataset = gdal.Open( input, gdal.GA_Update )
if dataset is None:
  print 'Unable to open', input, 'for writing'
  sys.exit(1)

# Assume that the VRT has a single band with the following set in the XML of the VRT file
#   <ColorInterp>Palette</ColorInterp>
#  * Get the Raster band (should be one) and the Color table (should be 256 entries for RGBA)
b1 = dataset.GetRasterBand(1)
ctable = b1.GetColorTable()
noGColorTable = ctable
count = ctable.GetCount()


if( __debug__):
  countToPrint = 10  # Print out only the first 10 elements

# Print out the first several entries of the original
print "-----"
print "input color entries"
for i in range( 0, countToPrint):
  entry = ctable.GetColorEntry( i )
  print "RGBA = ", ctable.GetColorEntry( i)

print "-----"
print "c2 entry is green and values should be zero"

for i in range( 0, count):
  entry = ctable.GetColorEntry( i )
  entryNoGreen = list(entry)                     #  Make a copy of the entry, as a Python list
  entryNoGreen[GREEN_VALUE_RGBA] = ZERO          #  Set the Green channel to ZERO
  noGColorTable.SetColorEntry( i, tuple(entryNoGreen))  #  Convert back to a Python tuple, and set the new color Entry
  if not entry:
    continue
  if (i < countToPrint):
    print "RGBA = ", ctable.GetColorEntry( i)

count = noGColorTable.GetCount()
datasetNoGreen = dataset
noGb1 = datasetNoGreen.GetRasterBand(1)
ct = noGb1.GetColorTable()
ct.GetCount()
ct.GetColorEntry(0)

# Write out the output
print "writing file ", output
driver = gdal.GetDriverByName('VRT')
driver.CreateCopy( output, datasetNoGreen)
