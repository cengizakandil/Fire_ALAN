rm(list=ls())
library(terra)
library(dplyr)
library(tictoc)
library(DescTools)
library(proxy) 
library(tidyverse)
library(tidyterra)


# load values of climate stack
com = rast("D:/Fire/data/200km/Elena/Climate/stack_climate_vars_2012.tif")
coordinates_df <- data.frame(xyFromCell(com, 1:ncell(com)))
values_df <- as.data.frame(values(com))
df <- cbind(coordinates_df, values_df)
rm(coordinates_df, values_df)
plot(com)
## gecom## get rid of the NA values
df <- na.omit(df)

##load the ntl mask of 1 and 0
mask = rast("D:/Fire/data/200km/Elena/Mask_NTL/ntl_mask_2012.tif")

# read vector file with fires
fires = vect("D:/Fire/data/esa_cci/cengiz_BA_CCI_polygons/BA_CCI_polygons_proximity_dissolved_66N-75N.shp")
##tundra = vect("D:/Fire/data/cavm/bioclimate_dd/bioclimate_dd.shp")
##fires = makeValid(fires)
##tundra = makeValid(tundra)
##fires_t = crop(fires, tundra)
##fire_t = mask(fires, tundra)
##writeVector(fires_t, "D:/Fire/data/esa_cci/cengiz_BA_CCI_polygons/tundra_fires.shp", overwrite = TRUE)

fire_2012 <- fires %>% 
  dplyr::filter(year == 2012)

# So all output values of 50 mean that the distance is 50 or more km
BUFFER_SIZE = 50 
BUFFER_SIZE_MAX = 500
STEP = 2

N_CLOSEST_POINTS = 1000
SAMPLE_SIZE = 3


##fire_index = 1 # choose a fire
## here you can have a cycle of fires, here for the first 4:
tic("Time for 10 fires: ")

dists_per_fire = sapply(1:268, function(fire_index) {
  print(paste("fire index", fire_index))
  
  ## find the exact climate values of the fire_index fire scar 
  #fire_clim = df_20[fire_index,c(3,5,4)]
  fire_clim = colMeans(terra::extract(com, fire_2012[fire_index])[,2:4])
  print(fire_clim)
  dfex = df[, 3:5]
  mean_vals = colMeans(dfex)
  sd_vals = apply(dfex, 2, sd)
  # scale the climate values so that distance in climate space works
  dfex_scaled = as.data.frame(scale(dfex))
  #scale the initial cliamte of the fire the same way
  fire_clim_scaled = (fire_clim - mean_vals)/sd_vals
  
  # for each climate find a "distance" to target climate of the fire in climate space
  df$dist_to_fire = dist(as.data.frame(t(fire_clim_scaled)), dfex_scaled)[1,]
  
  # choose 10 closest points - this can be adjusted as necessary
  closest_points = df %>%
    arrange(dist_to_fire) %>%
    slice_head(n = N_CLOSEST_POINTS)
  
  inside_fires = terra::extract(fire_2012, closest_points[c("x", "y")])
  inside_fires_inds = inside_fires[!is.na(inside_fires[,2]),1]
  if (length(inside_fires_inds) > 0) {
    closest_points = closest_points[-inside_fires_inds,]
  }
  # if all rows are excluded
  if (nrow(closest_points) < SAMPLE_SIZE) return(c(fire_index, c(1:SAMPLE_SIZE)*NA))
  
  
  # sample N of them - this also can be adjusted as necessary
  sample_N <- closest_points %>% sample_n(SAMPLE_SIZE)
  spat_vec <- vect(sample_N, geom=c("x", "y")) 
  crs(spat_vec) <- "EPSG:4326"
  
  
  # calculate the distance from each point
  dists = sapply(1:length(spat_vec), function(i) {
    print(i)
    fire = spat_vec[i] # select one fire
    buff = buffer(fire, BUFFER_SIZE*1000) # create a buffer of BUFFER_SIZE in km around it
    
    # Checking if the extents of the fire and NTL overlap. If not, return NA
    if (is.null(intersect(ext(mask), ext(fire)))) return(NA) else
      # cropping ntl with the fire buffer
      res_try = tryCatch( {cr_mask = crop(mask, buff, mask = T)}, error = function(e) {return(NULL)}) 
    if (is.null(res_try)) return(NA)
    
    # In case the buffer goes beyond 180 lon we separate the buffer into 2 parts
    if (xmax(cr_mask) - xmin(cr_mask) == 360) {
      
      # part 1
      cr_mask1 = crop(cr_mask, ext(xmin(cr_mask), -176, ymin(cr_mask), ymax(cr_mask)))
      if (all(is.na(minmax(cr_mask1)))) dvals1 = BUFFER_SIZE else { # if overlap if empty, return max distance
        dist_layer1 <- distance(cr_mask1, unit="km") # create distance map from NTL
        dvals1 = terra::extract(dist_layer1, fire)$layer # extract values intersecting with the fire
      }
      
      # part 2
      cr_mask2 = crop(cr_mask, ext(176, xmax(cr_mask), ymin(cr_mask), ymax(cr_mask)))
      if (all(is.na(minmax(cr_mask2)))) dvals2 = BUFFER_SIZE else { # if overlap if empty, return max distance
        dist_layer2 <- distance(cr_mask2, unit="km") # create distance map from NTL
        dvals2 = terra::extract(dist_layer2, fire)$layer # extract values intersecting with the fire
      }
      return(min(dvals1, dvals2)) # we take the minimum distance
    }
    
    # In case all is OK
    if (all(is.na(minmax(cr_mask)))) {
      bs = BUFFER_SIZE
      while (bs < BUFFER_SIZE_MAX) {
        bs = bs + STEP
        buff_bs = buffer(fire, bs*1000) 
        cr_mask_bs = crop(mask, buff_bs, mask = T) 
        if (!all(is.na(minmax(cr_mask_bs)))) return(bs)
      }
      return(BUFFER_SIZE_MAX) 
    } else {
      dist_layer <- distance(cr_mask, unit="km") # create distance map from NTL
      dvals = terra::extract(dist_layer, fire)[,2] # extract values intersecting with the fire
      return(min(dvals)) # we take the minimum distance
    }
  }) 
  
  return(c(fire_index, dists))
})

toc()

dat_dists_per_fire = as.data.frame(t(dists_per_fire))
colnames(dat_dists_per_fire) = c("fire_index", paste0("dist", 1:SAMPLE_SIZE))
dat_dists_per_fire
head(dat_dists_per_fire)
write.csv(dat_dists_per_fire, "D:/Fire/data/200km/2012_tundra_sample_distance.csv")

combined_df <- dat_dists_per_fire %>%
  pivot_longer(cols = c(dist1, dist2, dist3), names_to = "column", values_to = "combined")
hist(combined_df$combined, breaks= 30)

na_count_column1 <- sum(is.na(combined_df$combined))

# Create a new dataframe with the combined column
new_df <- data.frame(combined_column = combined_df$combined)
