## The new dataset extends from 66 latitude to 75 latitude and we first need to find the 
## center points of the fire data points and turn it into a daatframe so that we can use in the 
## future analysis

## 4-April-2024
rm(list=ls())
##load libraries

library(terra)
library(raster)
##load fire scars polygons
fire <- vect("D:/Fire/data/esa_cci/cengiz_BA_CCI_polygons/BA_CCI_polygons_proximity_dissolved_66N-75N.shp")
plot(fire)

## find the centroids of the fire scars, although the fire scars accouring exactly on the 
##66th parallel will be problematic
point <- centroids(fire)
plot(point)
point_crd_2020 <- crds(centroids(fire))
plot(point_crd_2020, xlim=c(-180,180), ylim=c(50,76), pch=20, cex=2, col='red', xlab='X', ylab='Y', las=1)

point_df_2020 <- as.data.frame(point)
points <- cbind(point_df_2020, point_crd_2020)

write.csv(points, "D:/Fire/data/final/all_fires.csv")
