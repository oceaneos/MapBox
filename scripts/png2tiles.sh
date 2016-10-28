

gdal_translate MY1DMM_CHLORA_2002-08.png -a_ullr -180 90 180 -90 -a_srs EPSG:4326 out.tif
# Upper Left  (-180.0000000,  90.0000000) (180d 0' 0.00"W, 90d 0' 0.00"N)
# Lower Left  (-180.0000000, -90.0000000) (180d 0' 0.00"W, 90d 0' 0.00"S)
# Upper Right ( 180.0000000,  90.0000000) (180d 0' 0.00"E, 90d 0' 0.00"N)
# Lower Right ( 180.0000000, -90.0000000) (180d 0' 0.00"E, 90d 0' 0.00"S)
# Center      (   0.0000000,   0.0000000) (  0d 0' 0.01"E,  0d 0' 0.01"N)

rm -rf out
gdal2tilesp.py -z 0-5 -w all out.tif out
gdal2tilesp.py -z 4   -w all -e out.tif out
gdal2tilesp.py -z 3   -w all -e out.tif out
gdal2tilesp.py -z 2   -w all -e out.tif out
gdal2tilesp.py -z 1   -w all -e out.tif out
gdal2tilesp.py -z 0   -w all -e out.tif out

# mbtiles
rm out.mbtiles
mb-util --image_format=png out out.mbtiles

# upload

# test upload
http://a.tiles.mapbox.com/v4/mriedijk.MY1DMM_CHLORA_2002-08/page.html?access_token=pk.eyJ1IjoibXJpZWRpamsiLCJhIjoiY2lzNzM1eWV6MDJkajJ0cG4xdjZzdTg4cCJ9.7OZRVApNk9iTjneT5Kx4Aw#2/24.4/-118.7





# gdal_translate MY1DMM_CHLORA_2002-08.png -a_ullr -180 -90 180 90 -a_srs EPSG:4326 out.tif
dalinfo out.tif
Driver: GTiff/GeoTIFF
Files: out.tif
Size is 3600, 1800
Coordinate System is:
GEOGCS["WGS 84",
    DATUM["WGS_1984",
        SPHEROID["WGS 84",6378137,298.257223563,
            AUTHORITY["EPSG","7030"]],
        AUTHORITY["EPSG","6326"]],
    PRIMEM["Greenwich",0],
    UNIT["degree",0.0174532925199433],
    AUTHORITY["EPSG","4326"]]
Origin = (-180.000000000000000,-90.000000000000000)
Corner Coordinates:
Upper Left  (-180.0000000, -90.0000000) (180d 0' 0.00"W, 90d 0' 0.00"S)
Lower Left  (-180.0000000,  90.0000000) (180d 0' 0.00"W, 90d 0' 0.00"N)
Upper Right ( 180.0000000, -90.0000000) (180d 0' 0.00"E, 90d 0' 0.00"S)
Lower Right ( 180.0000000,  90.0000000) (180d 0' 0.00"E, 90d 0' 0.00"N)
Center      (   0.0000000,   0.0000000) (  0d 0' 0.01"E,  0d 0' 0.01"N)




gdalinfo ../../1-month/MY1DMM_CHLORA_2002-08.TIFF

Size is 3600, 1800
Coordinate System is:
GEOGCS["WGS 84",
    DATUM["WGS_1984",
        SPHEROID["WGS 84",6378137,298.257223563,
            AUTHORITY["EPSG","7030"]],
        AUTHORITY["EPSG","6326"]],
    PRIMEM["Greenwich",0],
    UNIT["degree",0.0174532925199433],
    AUTHORITY["EPSG","4326"]]
Origin = (-180.000000000000000,90.000000000000000)

Upper Left  (-180.0000000,  90.0000000) (180d 0' 0.00"W, 90d 0' 0.00"N)
Lower Left  (-180.0000000, -90.0000000) (180d 0' 0.00"W, 90d 0' 0.00"S)
Upper Right ( 180.0000000,  90.0000000) (180d 0' 0.00"E, 90d 0' 0.00"N)
Lower Right ( 180.0000000, -90.0000000) (180d 0' 0.00"E, 90d 0' 0.00"S)
Center      (   0.0000000,   0.0000000) (  0d 0' 0.01"E,  0d 0' 0.01"N)
