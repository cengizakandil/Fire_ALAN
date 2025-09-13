library(FSA)

dist_country <- read.csv("D:/Fire/data/200km/arctic_fire_distance_with_xy_countries.csv")

## get rid of greenland and norway
df_big <- dist_country %>%
  group_by(country) %>%
  filter(n() >= 20) %>%
  ungroup()

kruskal.test(distance ~ country, data = df_big)

# if significant, pairwise Dunn
dunnTest(distance ~ country, data = df_big, method = "bh")  # BH-adjusted p's
  

