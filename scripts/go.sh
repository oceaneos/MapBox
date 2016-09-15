
#  This makes a file called clut.vrt that has the look up table
#    with no modification it is a Blue to Yellow color ramp.
gdal_translate -of VRT MY1DMM_CHLORA_2016-07-01_rgb_3600x1800.TIFF clut.vrt

#  In order to make a Blue to Red color ramp, remove the green channel
gdalNoGreen.py clut.vrt clut.blue2red.vrt

# Apply the blue to red color look up table
gdal_translate clut.blue2red.vrt MY1DMM_CHLORA_2016-07-01_rgb_3600x1800.clut.blue2red.TIFF

# Alternatively, check the red2blue color table actually took by inspecting a VRT
gdal_translate -of VRT MY1DMM_CHLORA_2016-07-01_rgb_3600x1800.clut.blue2red.TIFF clut.blue2red.check.vrt

# Expand the data to four bands, rgba, and assign NODATA for transparency over land masses
gdal_translate -of vrt -expand rgba -a_nodata 0 MY1DMM_CHLORA_2016-07-01_rgb_3600x1800.clut.blue2red.TIFF temp.vrt

# Prepare temp.vrt for "slippy" map tiles, one step closer to Mapbox
#  Zoom level 0 (whole earth) to a reasonalbe zoom level of 6.
gdal2tilesp.py -z 0-6 temp.vrt
mb-util temp MY1DMM_CHLORA_2016-07-01_rgb_3600x1800.mbtiles
