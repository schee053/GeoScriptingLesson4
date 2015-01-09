# Names: Daniel Scheerooren & Jorn Dallinga
# Teamname: DD
# Date: 8-1-2015

# loading library
library(raster)
# source of the functions
source('R/Function.R')

# Downloading data
# NA

# Open the data files from /data folder
Landsat8_list <- list.files('data/LC81970242014109-SC20141230042441', pattern = glob2rx('*.tif'), full.names = TRUE)
Landsat5_list <- list.files('data/LT51980241990098-SC20150107121947', pattern = glob2rx('*.tif'), full.names = TRUE)

# Stack and Brick the Landsat images for landsat 8
Landsat8_stack <- stack(Landsat8_list)
writeRaster(Landsat8_stack, 'output/Landsat8.tif', overwrite = TRUE)
Landsat8_Brick <- brick('output/Landsat8.tif')

# Stack and Brick the landsat images for landsat 5
Landsat5_stack <- stack(Landsat5_list)
writeRaster(Landsat5_stack, 'output/Landsat5.tif', overwrite = TRUE)
Landsat5_Brick <- brick('output/Landsat5.tif')

# Remove clouds from landsat 8
cloud8 <- Landsat8_Brick[[1]]
CloudLandsat8 <- dropLayer(Landsat8_Brick, 1)
CloudLandsat8 [cloud8 != 0] <- NA

cloud8_2 <- dropLayer(Landsat8_Brick, 1)
Landsat8CloudFree <- overlay (x=cloud8_2, y = cloud8, fun = cloud8NA)

# Remove clouds from landsat 5
cloud5 <- Landsat5_Brick[[1]]
CloudLandsat5 <- dropLayer(Landsat5_Brick, 1)
CloudLandsat5 [cloud5 != 0] <- NA

cloud5_2 <- dropLayer(Landsat5_Brick, 1)
Landsat5CloudFree <- overlay (x=cloud5_2, y = cloud5, fun = cloud5NA)


# Calculate the NDVI for both Landsat images
ndvi_landsat8 <- (Landsat8CloudFree[[4]] - Landsat8CloudFree[[3]]) / (Landsat8CloudFree[[4]] + Landsat8CloudFree[[3]])
#plot(ndvi_landsat8)

ndvi_landsat5 <- (Landsat5CloudFree[[6]] - Landsat5CloudFree[[5]]) / (Landsat5CloudFree[[6]] + Landsat5CloudFree[[5]])
#plot(ndvi_landsat5)

# Cropping the images
Landsat1990_5 <- crop(ndvi_landsat5, ndvi_landsat8)
Landsat2014_8 <- crop(ndvi_landsat8, ndvi_landsat5)

# final calculation for NDVI difference
# The output map shows the difference in NDVI between 1990 and 2014
Diff <- Landsat2014_8 - Landsat1990_5
plot(Diff, zlim = c(-2, 1))

# Write Final Raster to a file
writeRaster(Diff, 'output/NDVI_Difference', overwrite = TRUE)

