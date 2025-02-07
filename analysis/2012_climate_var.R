rm(list=ls())
library(terra)
library(dplyr)
library(tictoc)

##load the ntl and isolate as 1 and 0
ntl = rast("D:/Fire/data/ALAN/Cumulative/cum2012.tif")
mask <- ifel(ntl==0, NA, 1) # calculate a mask with 1 where there is some light
writeRaster(mask, "D:/Fire/data/200km/Elena/Mask_NTL/ntl_mask_2012.tif")
rm(ntl)

# set buffer size
BUFFER_SIZE = 50


##load 2012 data for ppt, vpd, lst
##lst
LST20_6 <- rast("D:/Fire/data/LST/LST_Monthly/Raw/MOD11C3.A2012153.061.2021222115722.hdf")
LST20_7 <- rast("D:/Fire/data/LST/LST_Monthly/Raw/MOD11C3.A2012183.061.2021226214145.hdf")
LST20_8 <- rast("D:/Fire/data/LST/LST_Monthly/Raw/MOD11C3.A2012214.061.2021231123740.hdf")
LST_avg <- (LST20_6$LST_Day_CMG + LST20_7$LST_Day_CMG + LST20_8$LST_Day_CMG + 
              LST20_6$LST_Night_CMG + LST20_7$LST_Night_CMG + LST20_8$LST_Night_CMG)/6

##ppt
ppt2020 <- rast("D:/Fire/data/Terra/TerraClimate_ppt_2012.nc")
ppt2020_summer <- (ppt2020$ppt_6 + ppt2020$ppt_7 + ppt2020$ppt_8)/3

##vpd
vpd2020 <- rast("D:/Fire/data/Terra/TerraClimate_vpd_2012.nc")
vpd2020_summer <- (vpd2020$vpd_6 + vpd2020$vpd_7 + vpd2020$vpd_8)/3

rm(LST20_6, LST20_7, LST20_8, ppt2020, vpd2020)

# load the tundra from CAVM in WGS84 format
e <- c(-180, 180, 66,75)
plot(e)

##somehow the coordinate system do not show true when I ask whether they are same or not
##so fix the coordinate system for al llayers to same
##crs(e) <- "EPSG:4326"
crs(vpd2020_summer) <- "EPSG:4326"
crs(ppt2020_summer) <- "EPSG:4326"
crs(LST_avg) <- "EPSG:4326"

##mask and crop the layers
LST_avg_1 <- crop(LST_avg, e)
ppt_avg_1 <- crop(ppt2020_summer , e)
vpd_avg_1 <- crop(vpd2020_summer , e)
plot(ppt_avg_1)


## as the resolution of lst is different than the rest, I need to resample that
LST_resample <- resample(LST_avg_1, ppt_avg_1, method="bilinear") ##is bilinear method ok?

## create the stack
com <- c(LST_resample, ppt_avg_1 , vpd_avg_1)
plot(com)

writeRaster(com, "D:/Fire/data/200km/Elena/Climate/stack_climate_vars_2012.tif", overwrite = TRUE)

##create data frame for the climate variables to use for choosing the sampling points
coordinates_df <- data.frame(xyFromCell(com, 1:ncell(com)))
values_df <- as.data.frame(values(com))
df <- cbind(coordinates_df, values_df)

## get rid of the NA values
df <- na.omit(df)
df$ID <- 1:nrow(df)
head(df)
# save climate values
write.csv(df, "D:/Fire/data/200km/Elena/df_climate/dataframe_climate_vars_2012.csv")

