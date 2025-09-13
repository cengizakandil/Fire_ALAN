rm(list=ls())
library(terra)
library(tictoc)
library(sf)
library(dplyr)
library(rnaturalearth)

## load the data with x, y and distance coordinates for each year
##2001

dists_fire_2001 <- read.csv("D:/Fire/data/200km/2001_fire_distance_with_xy.csv")
#Convert to sf points
dists_sf <- st_as_sf(dists_fire_2001,
                     coords = c("x", "y"),
                     crs    = 4326)

# Load world
world_sf <- ne_countries(scale = "medium",
                         returnclass = "sf") %>%
  select(country = admin, iso3 = iso_a3)

#Reprojec
world_sf <- st_transform(world_sf, st_crs(dists_sf))

# Join
joined <- st_join(dists_sf, world_sf, join = st_intersects)

# Drop geometry
dists_2001 <- joined %>%
  st_drop_geometry()

##2002


dists_fire_2002 <- read.csv("D:/Fire/data/200km/2002_fire_distance_with_xy.csv")
#Convert to sf points
dists_sf <- st_as_sf(dists_fire_2002,
                     coords = c("x", "y"),
                     crs    = 4326)

# Load world
world_sf <- ne_countries(scale = "medium",
                         returnclass = "sf") %>%
  select(country = admin, iso3 = iso_a3)

#Reprojec
world_sf <- st_transform(world_sf, st_crs(dists_sf))

# Join
joined <- st_join(dists_sf, world_sf, join = st_intersects)

# Drop geometry
dists_2002 <- joined %>%
  st_drop_geometry()


##2003

dists_fire_2003 <- read.csv("D:/Fire/data/200km/2003_fire_distance_with_xy.csv")
#Convert to sf points
dists_sf <- st_as_sf(dists_fire_2003,
                     coords = c("x", "y"),
                     crs    = 4326)

# Load world
world_sf <- ne_countries(scale = "medium",
                         returnclass = "sf") %>%
  select(country = admin, iso3 = iso_a3)

#Reprojec
world_sf <- st_transform(world_sf, st_crs(dists_sf))

# Join
joined <- st_join(dists_sf, world_sf, join = st_intersects)

# Drop geometry
dists_2003 <- joined %>%
  st_drop_geometry()


##2004

dists_fire_2004 <- read.csv("D:/Fire/data/200km/2004_fire_distance_with_xy.csv")
#Convert to sf points
dists_sf <- st_as_sf(dists_fire_2004,
                     coords = c("x", "y"),
                     crs    = 4326)

# Load world
world_sf <- ne_countries(scale = "medium",
                         returnclass = "sf") %>%
  select(country = admin, iso3 = iso_a3)

#Reprojec
world_sf <- st_transform(world_sf, st_crs(dists_sf))

# Join
joined <- st_join(dists_sf, world_sf, join = st_intersects)

# Drop geometry
dists_2004 <- joined %>%
  st_drop_geometry()


##2005

dists_fire_2005 <- read.csv("D:/Fire/data/200km/2005_fire_distance_with_xy.csv")
#Convert to sf points
dists_sf <- st_as_sf(dists_fire_2005,
                     coords = c("x", "y"),
                     crs    = 4326)

# Load world
world_sf <- ne_countries(scale = "medium",
                         returnclass = "sf") %>%
  select(country = admin, iso3 = iso_a3)

#Reprojec
world_sf <- st_transform(world_sf, st_crs(dists_sf))

# Join
joined <- st_join(dists_sf, world_sf, join = st_intersects)

# Drop geometry
dists_2005 <- joined %>%
  st_drop_geometry()


##2006

dists_fire_2006 <- read.csv("D:/Fire/data/200km/2006_fire_distance_with_xy.csv")
#Convert to sf points
dists_sf <- st_as_sf(dists_fire_2006,
                     coords = c("x", "y"),
                     crs    = 4326)

# Load world
world_sf <- ne_countries(scale = "medium",
                         returnclass = "sf") %>%
  select(country = admin, iso3 = iso_a3)

#Reprojec
world_sf <- st_transform(world_sf, st_crs(dists_sf))

# Join
joined <- st_join(dists_sf, world_sf, join = st_intersects)

# Drop geometry
dists_2006 <- joined %>%
  st_drop_geometry()


##2007

dists_fire_2007 <- read.csv("D:/Fire/data/200km/2007_fire_distance_with_xy.csv")
#Convert to sf points
dists_sf <- st_as_sf(dists_fire_2007,
                     coords = c("x", "y"),
                     crs    = 4326)

# Load world
world_sf <- ne_countries(scale = "medium",
                         returnclass = "sf") %>%
  select(country = admin, iso3 = iso_a3)

#Reprojec
world_sf <- st_transform(world_sf, st_crs(dists_sf))

# Join
joined <- st_join(dists_sf, world_sf, join = st_intersects)

# Drop geometry
dists_2007 <- joined %>%
  st_drop_geometry()

##2008

dists_fire_2008 <- read.csv("D:/Fire/data/200km/2008_fire_distance_with_xy.csv")
#Convert to sf points
dists_sf <- st_as_sf(dists_fire_2008,
                     coords = c("x", "y"),
                     crs    = 4326)

# Load world
world_sf <- ne_countries(scale = "medium",
                         returnclass = "sf") %>%
  select(country = admin, iso3 = iso_a3)

#Reprojec
world_sf <- st_transform(world_sf, st_crs(dists_sf))

# Join
joined <- st_join(dists_sf, world_sf, join = st_intersects)

# Drop geometry
dists_2008 <- joined %>%
  st_drop_geometry()

##2009

dists_fire_2009 <- read.csv("D:/Fire/data/200km/2009_fire_distance_with_xy.csv")
#Convert to sf points
dists_sf <- st_as_sf(dists_fire_2009,
                     coords = c("x", "y"),
                     crs    = 4326)

# Load world
world_sf <- ne_countries(scale = "medium",
                         returnclass = "sf") %>%
  select(country = admin, iso3 = iso_a3)

#Reprojec
world_sf <- st_transform(world_sf, st_crs(dists_sf))

# Join
joined <- st_join(dists_sf, world_sf, join = st_intersects)

# Drop geometry
dists_2009 <- joined %>%
  st_drop_geometry()


##2010

dists_fire_2010 <- read.csv("D:/Fire/data/200km/2010_fire_distance_with_xy.csv")
#Convert to sf points
dists_sf <- st_as_sf(dists_fire_2010,
                     coords = c("x", "y"),
                     crs    = 4326)

# Load world
world_sf <- ne_countries(scale = "medium",
                         returnclass = "sf") %>%
  select(country = admin, iso3 = iso_a3)

#Reprojec
world_sf <- st_transform(world_sf, st_crs(dists_sf))

# Join
joined <- st_join(dists_sf, world_sf, join = st_intersects)

# Drop geometry
dists_2010 <- joined %>%
  st_drop_geometry()


##2011

dists_fire_2011 <- read.csv("D:/Fire/data/200km/2011_fire_distance_with_xy.csv")
#Convert to sf points
dists_sf <- st_as_sf(dists_fire_2011,
                     coords = c("x", "y"),
                     crs    = 4326)

# Load world
world_sf <- ne_countries(scale = "medium",
                         returnclass = "sf") %>%
  select(country = admin, iso3 = iso_a3)

#Reprojec
world_sf <- st_transform(world_sf, st_crs(dists_sf))

# Join
joined <- st_join(dists_sf, world_sf, join = st_intersects)

# Drop geometry
dists_2011 <- joined %>%
  st_drop_geometry()

##2012

dists_fire_2012 <- read.csv("D:/Fire/data/200km/2012_fire_distance_with_xy.csv")
#Convert to sf points
dists_sf <- st_as_sf(dists_fire_2012,
                     coords = c("x", "y"),
                     crs    = 4326)

# Load world
world_sf <- ne_countries(scale = "medium",
                         returnclass = "sf") %>%
  select(country = admin, iso3 = iso_a3)

#Reprojec
world_sf <- st_transform(world_sf, st_crs(dists_sf))

# Join
joined <- st_join(dists_sf, world_sf, join = st_intersects)

# Drop geometry
dists_2012 <- joined %>%
  st_drop_geometry()


##2013

dists_fire_2013 <- read.csv("D:/Fire/data/200km/2013_fire_distance_with_xy.csv")
#Convert to sf points
dists_sf <- st_as_sf(dists_fire_2013,
                     coords = c("x", "y"),
                     crs    = 4326)

# Load world
world_sf <- ne_countries(scale = "medium",
                         returnclass = "sf") %>%
  select(country = admin, iso3 = iso_a3)

#Reprojec
world_sf <- st_transform(world_sf, st_crs(dists_sf))

# Join
joined <- st_join(dists_sf, world_sf, join = st_intersects)

# Drop geometry
dists_2013 <- joined %>%
  st_drop_geometry()

dist_country <- rbind(dists_2001, dists_2002, dists_2003, dists_2004, dists_2005,
                      dists_2006, dists_2007, dists_2008, dists_2009, dists_2010,
                      dists_2011, dists_2012, dists_2013)

write.csv(dist_country , "D:/Fire/data/200km/arctic_fire_distance_with_xy_countries.csv")
##histogram

#Russia
russia_df <- subset(dist_country, country == "Russia")
max(russia_df$distance)
#Plot
ggplot(russia_df, aes(x = distance)) +
  geom_histogram(
    breaks = seq(0, 260, by = 2),
    color  = "black",
    fill   = "steelblue"
  ) +
  scale_x_continuous(
    limits = c(0, 260),
    breaks = seq(0, 260, by = 20)    # tick marks every 20 km
  ) +
  labs(
    title = "Russia",
    x     = "Distance to Nearest NTL (km)",
    y     = "Number of Fires (total = 2359)"
  ) +
  theme_minimal()

#greenland
greenland_df <- subset(dist_country, country == "Greenland")
max(greenland_df$distance)
#Plot
ggplot(greenland_df, aes(x = distance)) +
  geom_histogram(
    breaks = seq(0, 180, by = 2),
    color  = "black",
    fill   = "steelblue"
  ) +
  scale_x_continuous(
    limits = c(0, 260),
    breaks = seq(0, 260, by = 20)    # tick marks every 20 km
  ) +
  labs(
    title = "Russia",
    x     = "Distance to Nearest NTL (km)",
    y     = "Number of Fires (total = 2359)"
  ) +
  theme_minimal()
