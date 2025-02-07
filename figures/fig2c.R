##plot fig 2c
rm(list=ls())
library(ggplot2)
library(extrafont) ## for times new roman
loadfonts(device = "win")
library(dplyr)
library(MASS)
library(tidyr)
##install.packages("purrr")
library(purrr)

dat <- read.csv("D:/Fire/data/200km/final_table_with_rounded_values.csv")
dfire0 <- dat$Distance[dat$fire_occurence==1]
dcont0 <- dat$Distance[dat$fire_occurence!=1]
dfire <- dfire0[dfire0>0]
dcont <- dcont0[dcont0>0]
##combine the data
combined_data <- data.frame(
  value = c(dfire, dcont),
  group = factor(c(rep("Fire", length(dfire)), 
                   rep("Control", length(dcont))))
)

# Fit the gamma for fire
fire_data <- combined_data$value[combined_data$group == "Fire"]
fire_fit <- fitdistr(fire_data, "gamma")
shape_fire <- fire_fit$estimate["shape"]
rate_fire <- fire_fit$estimate["rate"]

# Fit the gamma for control
control_data <- combined_data$value[combined_data$group == "Control"]
control_fit <- fitdistr(control_data, "gamma")
shape_control <- control_fit$estimate["shape"]
rate_control <- control_fit$estimate["rate"]

#this is the last one I used in the manuscript at the moment
fig2c <- ggplot(combined_data, aes(x = value, fill = group)) +
  # Use geom_bar with fixed binwidth of 2 km
  geom_bar(aes(y = ..density..), stat = "bin", position = position_dodge(width = 0.9), 
           binwidth = 3, alpha = 0.5, boundary = 0) +
  scale_fill_manual(values = c("Fire" = "#8B635C", "Control" = "blue")) +
  labs(title = " ",
       x = "Distance (km)", y = "Density") +
  # Add the fit lines
  stat_function(fun = dgamma, args = list(shape = shape_fire, rate = rate_fire), 
                color = "#8B635C", size = 1) +
  stat_function(fun = dgamma, args = list(shape = shape_control, rate = rate_control), 
                color = "cornflowerblue", size = 1) +
  theme_minimal() +
  theme(
    text = element_text(family = "Times New Roman"),
    legend.title = element_blank(),
    plot.title = element_text(size = 14, face = "bold"),
    axis.title = element_text(size = 8),
    axis.text = element_text(size = 8),
    legend.text = element_text(size = 8),
    axis.title.y = element_text(margin = margin(r = 20)),
    plot.margin = margin(t = 20, r = 20, b = 20, l = 20, unit = "pt")
  )
plot(fig2c)
