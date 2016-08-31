# failed
# http://gis.stackexchange.com/questions/130199/changing-color-of-raster-images-based-on-their-data-values-gdal
gdaldem color-relief -alpha MY1DMM_CHLORA_2016-07-01_rgb_3600x1800.TIFF col.txt out.tif
gdal2tilesp.py out.tif
