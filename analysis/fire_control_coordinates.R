rm(list=ls())
library(terra)
library(dplyr)
library(tictoc)
library(DescTools)
library(proxy) 
library(tidyverse)
library(tidyterra)
library(sf)
library(dplyr)


# load values of climate stack
com = rast("D:/Fire/data/200km/Elena/Climate/stack_climate_vars_2003.tif")
coordinates_df <- data.frame(xyFromCell(com, 1:ncell(com)))
values_df <- as.data.frame(values(com))
df <- cbind(coordinates_df, values_df)
rm(coordinates_df, values_df)
plot(com)
## gecom## get rid of the NA values
df <- na.omit(df)

##load the ntl mask of 1 and 0
mask = rast("D:/Fire/data/200km/Elena/Mask_NTL/ntl_mask_2003.tif")

# read vector file with fires
fires = vect("D:/Fire/data/esa_cci/cengiz_BA_CCI_polygons/BA_CCI_polygons_proximity_dissolved_66N-75N.shp")
##tundra = vect("D:/Fire/data/cavm/bioclimate_dd/bioclimate_dd.shp")
##fires = makeValid(fires)
##tundra = makeValid(tundra)
##fires_t = crop(fires, tundra)
##fire_t = mask(fires, tundra)
##writeVector(fires_t, "D:/Fire/data/esa_cci/cengiz_BA_CCI_polygons/tundra_fires.shp", overwrite = TRUE)

fire_2003 <- fires %>% 
  dplyr::filter(year == 2003)

# So all output values of 50 mean that the distance is 50 or more km
BUFFER_SIZE = 50 
BUFFER_SIZE_MAX = 500
STEP = 2

N_CLOSEST_POINTS = 1000
SAMPLE_SIZE = 3


# assume fire_2003, df, N_CLOSEST_POINTS, SAMPLE_SIZE are already defined

dists_per_fire <- lapply(1:233, function(fire_index) {
  print(paste("fire index", fire_index))
  
  fire_clim = colMeans(terra::extract(com, fire_2003[fire_index])[,2:4])
  print(fire_clim)
  dfex = df[, 3:5]
  mean_vals = colMeans(dfex)
  sd_vals = apply(dfex, 2, sd)
  dfex_scaled = as.data.frame(scale(dfex))
  fire_clim_scaled = (fire_clim - mean_vals)/sd_vals
  
  df$dist_to_fire = dist(as.data.frame(t(fire_clim_scaled)), dfex_scaled)[1,]
  
  closest_points = df %>%
    arrange(dist_to_fire) %>%
    slice_head(n = N_CLOSEST_POINTS)
  
  inside_fires = terra::extract(fire_2003, closest_points[c("x", "y")])
  inside_fires_inds = inside_fires[!is.na(inside_fires[,2]),1]
  if (length(inside_fires_inds) > 0) {
    closest_points = closest_points[-inside_fires_inds,]
  }
  
  # ** too few? return a DATA.FRAME of NAs **
  if (nrow(closest_points) < SAMPLE_SIZE) {
    return(data.frame(
      fire_index = fire_index,
      x          = rep(NA_real_, SAMPLE_SIZE),
      y          = rep(NA_real_, SAMPLE_SIZE)
    ))
  }
  
  # pad/trim to exactly N_CLOSEST_POINTS
  if (nrow(closest_points) < N_CLOSEST_POINTS) {
    pad_n  <- N_CLOSEST_POINTS - nrow(closest_points)
    pad_df <- data.frame(x = rep(NA_real_, pad_n),
                         y = rep(NA_real_, pad_n))
    closest_points <- bind_rows(closest_points, pad_df)
  } else if (nrow(closest_points) > N_CLOSEST_POINTS) {
    closest_points <- closest_points %>% slice_head(n = N_CLOSEST_POINTS)
  }
  
  # return as a data.frame
  closest_points %>%
    transmute(
      fire_index = fire_index,
      x,
      y
    )
})

# stack them all into one data.frame
closest_df <- bind_rows(dists_per_fire)
rownames(closest_df) <- NULL
write.csv(closest_df, "C:/Users/cengiz/Desktop/Fire/r_folder/2013_control_xy.csv")


# 2003 fires + centroids
fire_2003     <- fires %>% filter(year == 2003)
centroids2003 <- terra::centroids(fire_2003)
coords2003    <- terra::crds(centroids2003)  # matrix [n_fires × 2]


# loop
dists_per_fire <- lapply(seq_along(fire_2003), function(fire_index) {
  message("fire index ", fire_index)
  
  # th existing climate‐scaling stuff 
  fire_clim        <- colMeans(terra::extract(com, fire_2003[fire_index])[,2:4])
  dfex             <- df[, 3:5]
  mean_vals        <- colMeans(dfex)
  sd_vals          <- apply(dfex, 2, sd)
  dfex_scaled      <- as.data.frame(scale(dfex, mean_vals, sd_vals))
  fire_clim_scaled <- (fire_clim - mean_vals) / sd_vals
  
  df$dist_to_fire <- dist(
    as.data.frame(t(fire_clim_scaled)),
    dfex_scaled
  )[1, ]
  
  # pick the raw N_CLOSEST_POINTS closest 
  closest_points <- df %>%
    arrange(dist_to_fire) %>%
    slice_head(n = N_CLOSEST_POINTS)
  
  # extract polygo i, and wrap points in vect() 
  pts_vect    <- vect(closest_points[c("x", "y")], geom = c("x","y"),
                      crs = crs(fire_2003))
  inside_fires <- terra::extract(fire_2003[fire_index], pts_vect)
  inside_inds  <- inside_fires[!is.na(inside_fires[,2]), 1]
  if (length(inside_inds) > 0) {
    closest_points <- closest_points[-inside_inds, ]
  }
  
  # trim to exactly N_CLOSEST_POINTS
  if (nrow(closest_points) < N_CLOSEST_POINTS) {
    pad_n  <- N_CLOSEST_POINTS - nrow(closest_points)
    pad_df <- data.frame(x = rep(NA_real_, pad_n),
                         y = rep(NA_real_, pad_n))
    closest_points <- bind_rows(closest_points, pad_df)
  } else {
    closest_points <- slice_head(closest_points, n = N_CLOSEST_POINTS)
  }
  
  # rename, add original xy
  closest_points %>%
    transmute(
      index      = fire_index,
      control_x  = x,
      control_y  = y,
      original_x = coords2003[fire_index, 1],
      original_y = coords2003[fire_index, 2]
    )
})

# add it alle
closest_df <- bind_rows(dists_per_fire)
rownames(closest_df) <- NULL
write.csv(closest_df, "C:/Users/cengiz/Desktop/Fire/r_folder/2013_control_and_fire_xy.csv")


## points inside the tundra

#load tundra
tundra_sf <- st_read("D:/Fire/data/cavm/bioclimate_dd/bioclimate_dd.shp")

# Disable S2
sf::sf_use_s2(FALSE)

# Check the invalid polygons
tundra_sf <- st_make_valid(tundra_sf)

ctrl_sf <- closest_df %>% 
  filter(!is.na(control_x)&!is.na(control_y)) %>% 
  st_as_sf(coords = c("control_x","control_y"),
           crs    = st_crs(tundra_sf))

fire_pts <- closest_df %>% 
  select(index, original_x, original_y) %>% 
  distinct() %>% 
  st_as_sf(coords = c("original_x","original_y"),
           crs    = st_crs(tundra_sf))

#  intersections
ctrl_hits <- lengths(st_intersects(ctrl_sf,  tundra_sf)) > 0
fire_hits <- lengths(st_intersects(fire_pts, tundra_sf)) > 0

# put it back
closest_df <- closest_df %>%
  mutate(
    is_control_in_tundra = ctrl_hits[row_number()[!is.na(control_x)]],
    is_fire_in_tundra    = fire_hits[index]
  ) %>%
  mutate(
    match_tundra = as.integer(is_control_in_tundra == is_fire_in_tundra)
  )


tundra_sf <- st_read("D:/Fire/data/cavm/bioclimate_dd/bioclimate_dd.shp")
sf_use_s2(FALSE)
tundra_sf <- st_make_valid(tundra_sf)

raw_crs <- 4326

ctrl_sf <- closest_df %>%
  filter(!is.na(control_x) & !is.na(control_y)) %>%
  st_as_sf(coords = c("control_x","control_y"), crs = raw_crs) %>%
  st_transform(st_crs(tundra_sf))

fire_pts <- closest_df %>%
  distinct(index, original_x, original_y) %>%
  st_as_sf(coords = c("original_x","original_y"), crs = raw_crs) %>%
  st_transform(st_crs(tundra_sf))

ctrl_hits <- lengths(st_within(ctrl_sf,  tundra_sf)) > 0
fire_hits <- lengths(st_within(fire_pts, tundra_sf)) > 0

is_control_in_tundra <- rep(NA, nrow(closest_df))
valid_idx           <- which(!is.na(closest_df$control_x))
is_control_in_tundra[valid_idx] <- ctrl_hits

is_fire_in_tundra <- fire_hits[ closest_df$index ]

closest_df <- closest_df %>%
  mutate(
    is_control_in_tundra = is_control_in_tundra,
    is_fire_in_tundra    = is_fire_in_tundra,
    match_tundra         = as.integer(is_control_in_tundra == is_fire_in_tundra)
  )
