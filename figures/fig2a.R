##figure 1a for fire paper
rm(list=ls())
library(ggplot2)
library(extrafont) ## for times new roman
loadfonts(device = "win")
library(dplyr)

##load data
dat <- read.csv("D:/Fire/data/200km/final_table_with_rounded_values.csv")
fire <- dat[dat$fire_occurence == 1 ,]
control <- dat[dat$fire_occurence == 0 ,]
fire_zero <- fire[fire$Distance == 0 , ]
control_zero <- control[control$Distance == 0 , ]

##simple zero ratio 
ratio_fire <- nrow(fire_zero)/nrow(fire)
ratio_control <- nrow(control_zero)/nrow(control)
##create simple dataframe
data <- data.frame(
  Category = c( "fire" , "control"),
  Value = c(ratio_fire , ratio_control))
data$Category <- factor(data$Category, levels = c("fire", "control"))

plot1 <- ggplot(data, aes(x = Category, y = Value, fill = Category, color = Category)) +
  geom_col(width = 0.5) +
  geom_text(aes(label = scales::percent(Value, accuracy = 0.01)), 
            vjust = -0.5, size = 5) +
  scale_y_continuous(
    limits = c(0, 0.15),
    labels = scales::percent_format(accuracy = 1),
    breaks = seq(0, 0.15, by = 0.05)
  ) + 
  labs(x = " ",
       y = "Percentage") +
  theme_minimal() +
  theme(legend.position = "none")

fig2a <- plot1 + scale_color_manual(values=c("#8B635C", "cornflowerblue")) +
  scale_fill_manual(values=c("#8B635C", "cornflowerblue"))+
  theme(
    text = element_text(family = "Times New Roman"),
    legend.title = element_blank(),
    plot.title = element_text(size = 14, face = "bold"),
    axis.title = element_text(size = 10),
    axis.text = element_text(size = 10),
    legend.text = element_text(size = 12),
    axis.title.y = element_text(margin = margin(r = 20)),  
    plot.margin = margin(t = 20, r = 20, b = 20, l = 20, unit = "pt")  
  )

plot(fig2a)
# this comment


