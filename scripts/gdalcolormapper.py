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
import argparse

parser = argparse.ArgumentParser(description='Apply a color map to a GDAL VRT', epilog="This is the Oceaneos Color Mapper")
parser.add_argument('-i', '--input', help='input VRT file', required=True)
parser.add_argument('-o', '--output', help='output VRT file', required=True)
group = parser.add_mutually_exclusive_group(required=True)
group.add_argument('-csv', '--csv-color-map', help='apply the csv color map to the input VRT', required=False)
group.add_argument('-noG', '--no-green-color-map', action='store_true', help='Generates the no green color map to the input VRT', required=False)
args = parser.parse_args()

# This Python script takes a Color Table from a VRT file
# and sets the Green Channel to zero, and then writes out a seperate VRT file

# Documentaton on the GDAL bindings for Python
# http://gdal.org/python/
# Example Python code for various Python commands for GDAL
# https://pcjericks.github.io/py-gdalogr-cookbook/raster_layers.html


if (args.no_green_color_map):
    print "--no-green was passed in"

if (args.csv_color_map):
    print "--csv-color-map was passed in " + args.csv_color_map

# Python Constants
GREEN_VALUE_RGBA = 1
ZERO = 0

dataset = gdal.Open( args.input, gdal.GA_Update )
if dataset is None:
  print 'Unable to open', args.input, 'for writing'
  sys.exit(1)

# Assume that the VRT has a single band with the following set in the XML of the VRT file
#   <ColorInterp>Palette</ColorInterp>
#  * Get the Raster band (should be one) and the Color table (should be 256 entries for RGBA)
b1 = dataset.GetRasterBand(1)
inputColorTable = b1.GetColorTable()
outputColorTable = inputColorTable
count = inputColorTable.GetCount()


if( __debug__):
  countToPrint = 10  # Print out only the first 10 elements

# Print out the first several entries of the original
print "-----"
print "input color entries"
for i in range( 0, countToPrint):
  entry = inputColorTable.GetColorEntry( i )
  print "RGBA = ", inputColorTable.GetColorEntry( i)

if (args.no_green_color_map):
  print "-----"
  print "c2 entry is green and values should be zero"

for i in range( 0, count):
  # Get the ith color table entry
  entry = inputColorTable.GetColorEntry( i )     #  inputColorTable.GetColorEntry(0) = (8, 0, 88, 255)
  entryAsList = list(entry)                     #  Make a copy of the entry, as a Python list

  if (args.no_green_color_map):
    entryAsList[GREEN_VALUE_RGBA] = ZERO        #  Set the Green channel to ZERO
    outputColorTable.SetColorEntry( i, tuple(entryAsList))  #  Convert back to a Python tuple, and set the new color Entry
    if (i < countToPrint):
      print "RGBA = ", outputColorTable.GetColorEntry( i)
    continue

  if not entry:
    continue

datasetNoGreen = dataset
noGb1 = datasetNoGreen.GetRasterBand(1)
ct = noGb1.GetColorTable()
ct.GetCount()
ct.GetColorEntry(0)

# Write out the output
print "writing file ", args.output
driver = gdal.GetDriverByName('VRT')
driver.CreateCopy( args.output, datasetNoGreen)
