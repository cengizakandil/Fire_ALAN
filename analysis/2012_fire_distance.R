library(terra)
library(tictoc)

# read the raster
mask = rast("D:/Fire/data/200km/Elena/Mask_NTL/ntl_mask_2012.tif")

# read vector file with fires
fires = vect("D:/Fire/data/esa_cci/cengiz_BA_CCI_polygons/BA_CCI_polygons_proximity_dissolved_66N-75N.shp")
fire_2012 <- fires %>% 
  dplyr::filter(year == 2012)

# set buffer size. If the distance is >BUFFER_SIZE it will be reported equal to BUFFER_SIZE.
# So all output values of 50 mean that the distance is 50 or more km
BUFFER_SIZE = 50 
BUFFER_SIZE_MAX = 500
STEP = 2

# calculate the distance from each fire
tic("Time for first 10 fires: ")
# calculate the distance from each point
  dists = sapply(1:length(fire_2012), function(i) {
    print(i)
    fire = fire_2012[i] # select one fire
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


toc()

dists
hist(dists, breaks = 30)
dists_fire = as.data.frame(dists)
dists_fire$ID = (1:nrow(dists_fire))
write.csv(dists_fire, "D:/Fire/data/200km/2012_fire_distance.csv")
