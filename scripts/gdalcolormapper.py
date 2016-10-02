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

parser = argparse.ArgumentParser(description='Apply a color map to a GDAL VRT', epilog="gdalcolormapper.py -i clut.vrt -o out.vrt -csv black-body-table-byte-0256.csv")
parser.add_argument('-i', '--input', help='input VRT file', required=True)
parser.add_argument('-o', '--output', help='output VRT file', required=True)
group = parser.add_mutually_exclusive_group(required=True)
group.add_argument('-csv', '--csv-color-map', help='apply the csv color map to the input VRT', required=False)
group.add_argument('-noG', '--no-green-color-map', action='store_true', help='Generates the no green color map to the input VRT', required=False)
parser.add_argument('-invert', '--inverted-color-map', action='store_true', help='Invert the color map by reordering (255..0)', required=False)
args = parser.parse_args()

# This Python script takes a Color Table from a VRT file
# and sets the Green Channel to zero, and then writes out a seperate VRT file

# Documentaton on the GDAL bindings for Python
# http://gdal.org/python/
# Example Python code for various Python commands for GDAL
# https://pcjericks.github.io/py-gdalogr-cookbook/raster_layers.html

if( __debug__):
  countToPrint = 10  # Print out only the first 10 elements

if (args.no_green_color_map):
    print "--no-green was passed in"

if (args.inverted_color_map):
    print "--inverted-color-map was passed in"

csvData = []
if (args.csv_color_map):
    print "--csv-color-map was passed in " + args.csv_color_map

    import csv
    with open(args.csv_color_map, 'rb') as csvfile:
      reader = csv.reader(csvfile, delimiter=',', quotechar='|')
      rowNumber = 0
      print "-----"
      print "input csv"
      for row in reader:
        csvData.append(row)
        rowNumber += 1
        if (rowNumber < countToPrint):
          print row

      #  after the for loop, skip the first row as it is the header
      csvData.pop(0)


# Python Constants
RED_VALUE_RGBA = 0
GREEN_VALUE_RGBA = 1
BLUE_VALUE_RGBA = 2
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


# Print out the first several entries of the original
print "-----"
print "input color entries for", args.input
for i in range( 0, countToPrint):
  index = i
  if (args.inverted_color_map):
    skipHeaderRow = 1
    skipTransparencyRow = 1
    invertedIndex = count - i - skipHeaderRow - skipTransparencyRow
    index = invertedIndex

  entry = inputColorTable.GetColorEntry( index)
  print "RGBA = ", inputColorTable.GetColorEntry( index)

if (args.no_green_color_map):
  print "-----"
  print "c2 entry is green and values should be zero"

print "-----"
print "Output Color map for", args.output

for i in range( 0, count):
  # Get the ith color table entry
  entry = inputColorTable.GetColorEntry( i )     #  inputColorTable.GetColorEntry(0) = (8, 0, 88, 255)
  entryAsList = list(entry)                     #  Make a copy of the entry, as a Python list

  if (args.csv_color_map):
    # color map data looks like ['0.0', '0', '0', '0'], which is Scaler, R, G, B
    SCALAR_RGB_RED = 1
    SCALAR_RGB_GREEN = 2
    SCALAR_RGB_BLUE = 3

    index = i
    if (args.inverted_color_map):
      skipHeaderRow = 1
      skipTransparencyRow = 1
      invertedIndex = count - i - skipHeaderRow - skipTransparencyRow
      index = invertedIndex

    entryAsList[RED_VALUE_RGBA] = int(csvData[index][SCALAR_RGB_RED])
    entryAsList[GREEN_VALUE_RGBA] = int(csvData[index][SCALAR_RGB_GREEN])
    entryAsList[BLUE_VALUE_RGBA] = int(csvData[index][SCALAR_RGB_BLUE])

    outputColorTable.SetColorEntry( i, tuple(entryAsList))  #  Convert back to a Python tuple, and set the new color Entry
    if (i < countToPrint):
      print "CSV RGBA = ", outputColorTable.GetColorEntry( i)
    continue

  if (args.no_green_color_map):
    entryAsList[GREEN_VALUE_RGBA] = ZERO        #  Set the Green channel to ZERO
    outputColorTable.SetColorEntry( i, tuple(entryAsList))  #  Convert back to a Python tuple, and set the new color Entry
    if (i < countToPrint):
      print "noG RGBA = ", outputColorTable.GetColorEntry( i)
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
