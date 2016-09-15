import gdal
import sys
import os.path
#
# if len(sys.argv) < 2:
#      print "Usage: gdalNoGreen.py input output"
#      sys.exit(1)
#
# input = sys.argv[1]

# output = sys.argv[2]

input = "clut.vrt"

GREEN_VALUE_RGBA = 1
ZERO = 0

dataset = gdal.Open( input, gdal.GA_Update )
# if dataset is None:
#     print 'Unable to open', input, 'for writing'
#     sys.exit(1)

b1 = dataset.GetRasterBand(1)
ctable = b1.GetColorTable()
nogColorTable = ctable
count = ctable.GetCount()
print "[ COLOR TABLE COUNT ] = ", count

for i in range( 0, 10):
  entry = ctable.GetColorEntry( i )
  print "[ COLOR ENTRY RGB ] = ", ctable.GetColorEntry( i)
print "-----"

for i in range( 0, count):
  entry = ctable.GetColorEntry( i )
  entryNoGreen = list(entry)                     #  Make a copy of the entry, as a Python list
  entryNoGreen[GREEN_VALUE_RGBA] = ZERO          #  Set the Green channel to ZERO
  ctable.SetColorEntry( i, tuple(entryNoGreen))  #  Convert back to a Python tuple, and set the new color Entry
  if not entry:
    continue
  print "[ COLOR ENTRY RGB ] = ", ctable.GetColorEntry( i)

# datasetNoGreen = dataset
# datasetNoGreen.SetColorTable(nogColorTable)
# nogColorTable = b1.GetColorTable()
# count = nogColorTable.GetCount()
# for i in range( 0, 10):
#   entry = ctable2.GetColorEntry( i )
