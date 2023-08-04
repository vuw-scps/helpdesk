library(dplyr)
library(ggplot2)
library(tidyr)
library(R.matlab)
library(here)
setwd("~/Documents/github/presentations/2023_MESA/demo")

raw <- readMat('MESA.mat')
str(raw)
input <- attr(raw$input, "dimnames")[[1]]

wavelength <- as.vector(raw$input[which(input == "wavelength")][[1]])
params <- do.call(data.frame, lapply(raw$input[input != "wavelength"], as.vector))
names(params) <- input[input != "wavelength"]
params$satellite <- factor(params$satellite, labels=c("Ag","Pd"))
str(params)

N <- nrow(params)
Nl <- length(wavelength)
values <- data.frame(wavelength = rep(wavelength, N), 
                     id = rep(1:N, each=Nl),
                     total_absorption = c(raw$sigma.abs.tot),
                     sat_absorption = c(raw$sigma.abs.dip))

params$id <- 1:N
params

write.table(params %>% select(-c(epsCore:id)), file='params.dat', row.names = FALSE)


all <- left_join(params, values, by='id') %>% select(-c(epsCore:id))

write.table(all, file='results.dat', row.names = FALSE)

small <- all %>% filter(Rcore == 30, Rsat == 2.0)
write.table(small, file='results_small.dat', row.names = FALSE)

str(wavelength)
terms <- small %>% filter(wavelength %in% seq(350, 650, by=10), Nsat %in% c(1,50), gap==1)
write.table(terms, file='results_terms.dat', row.names = FALSE)

