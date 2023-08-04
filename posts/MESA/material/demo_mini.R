library(dplyr)
library(ggplot2)
library(tidyr)
library(egg)
# library(here)
# setwd(here("2023_MESA","demo"))
setwd("~/Documents/github/presentations/2023_MESA/demo")

map <- aes
plot <- ggplot
layer_line <- geom_line
layer_point <- geom_point
save_plot <- ggsave

d <- read.table("results.dat", header = TRUE)
head(d)
glimpse(d)

dsmall <- read.table("results_small.dat", header = TRUE)
head(dsmall)
glimpse(dsmall)

d3 <- read.table("results_terms.dat", header = TRUE) 


plot(data = dsmall, mapping = map(x = wavelength, y = sat_absorption, 
                                  group = interaction(Rsat,Rcore,gap,satellite,Nsat))) +
  layer_line()



plot(data = d |> filter(satellite == "Ag"), 
     mapping = map(
       x = wavelength, y = sat_absorption / Nsat,
       linetype = factor(gap), colour = factor(Nsat)
     )) +
  layer_line() +
  layer_point(data = d3 |> filter(satellite == "Ag"), aes(shape = "Reference")) +
  facet_grid(Rsat ~ Rcore,
             scales = "free",
             labeller = label_bquote(rows = R[sat] == .(Rsat) * nm, cols = R[core] == .(Rcore) * nm)
  ) +
  scale_x_continuous(lim = c(350, 460), expand = c(0, 0)) +
  theme_presentation(base_size = 14, base_family = "Gill Sans Nova") +
  labs(
    x = "wavelength /nm", y = expression(sigma[abs] / nm^2),
    linetype = "gap /nm", colour = expression(N[sat]), shape = ""
  )
