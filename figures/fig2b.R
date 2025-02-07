library(MASS)  # For fitdistr
library(ggplot2)  # For visualization
##install.packages("metR")  # Install the package if not already installed
library(metR)       

dat <- read.csv("D:/Fire/data/200km/final_table_with_rounded_values.csv")

dfire0 <- dat$Distance[dat$fire_occurence==1]
dcont0 <- dat$Distance[dat$fire_occurence!=1]

dfire <- dfire0[dfire0>0]
dcont <- dcont0[dcont0>0]
# Fit distributions
a <- fitdistr(dfire, densfun = "gamma", lower = c(0.01, 0.001))
b <- fitdistr(dcont, densfun = "gamma", lower = c(0.01, 0.001))

# Log-likelihood function
loglik <- function(theta, x) {
  sum(dgamma(x, shape = theta[1], rate = theta[2], log = TRUE))
}

# Define parameter ranges
shape <- seq(0.8, 1.08, length.out = 30)
rate <- seq(0.015, 0.022, length.out = 41)

# Create a grid of parameter values
grid <- expand.grid(shape = shape, rate = rate)

# Compute log-likelihood for dfire
grid$loglik_fire <- apply(grid, 1, function(theta) loglik(as.numeric(theta), x = dfire))
grid$loglik_fire <- grid$loglik_fire - max(grid$loglik_fire)

# Compute log-likelihood for dcont
grid$loglik_cont <- apply(grid, 1, function(theta) loglik(as.numeric(theta), x = dcont))
grid$loglik_cont <- grid$loglik_cont - max(grid$loglik_cont)

# Create data frames for estimated points
df_a <- data.frame(shape = a$estimate[1], rate = a$estimate[2], label = "dfire")
df_b <- data.frame(shape = b$estimate[1], rate = b$estimate[2], label = "dcont")

# Create the ggplot
ggplot(grid, aes(x = shape, y = rate)) +
  # Contour for dfire with labels
  geom_contour(aes(z = loglik_fire), color = "#8B635C", breaks = c(0, -1, -2, -3, -4, -5)) +
  geom_text_contour(aes(z = loglik_fire), breaks = c(0, -1, -3, -5), 
                    color = "#8B635C", size = 4, vjust = 0.5, hjust = 0.5) +
  
  # Contour for dcont with labels
  geom_contour(aes(z = loglik_cont), color = "cornflowerblue", breaks = c(0, -1, -2, -3, -4, -5)) +
  geom_text_contour(aes(z = loglik_cont), breaks = c(0, -1, -3, -5), 
                    color = "cornflowerblue", size = 4, vjust = 0.5, hjust = 0.5) +
  
  # Add points for estimated parameters using the created data frames
  geom_point(data = df_a, aes(x = shape, y = rate), color = "#8B635C", size = 3) +
  geom_point(data = df_b, aes(x = shape, y = rate), color = "cornflowerblue", size = 3) +
  
  # Add labels for estimated points
  geom_text(data = df_a, aes(x = shape, y = rate, label = "fire"), color = "#8B635C", vjust = -1, size = 4) +
  geom_text(data = df_b, aes(x = shape, y = rate, label = "control"), color = "cornflowerblue", vjust = -1, size = 4) +
  
  labs(
    title = " ",
    x = "Shape Parameter (α)",
    y = "Rate Parameter (β)"
  ) +
  theme_minimal()+
  theme(
    text = element_text(family = "Times New Roman"),
    legend.title = element_blank(),
    plot.title = element_text(size = 14, face = "bold"),
    axis.title = element_text(size = 10),
    axis.text = element_text(size = 10),
    legend.text = element_text(size = 10),
    axis.title.y = element_text(margin = margin(r = 10)),  # 30 seems right margin to y-axis title
    plot.margin = margin(t = 20, r = 20, b = 20, l = 20, unit = "pt")  # Increase overall plot margins
  )
