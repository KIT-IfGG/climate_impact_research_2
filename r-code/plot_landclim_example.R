library(LandClimTools)

?plot_gradient

### Read example data provided in the package
dat <- read.table(system.file("elevation_biomass_out.csv", package = "LandClimTools"), sep=",", dec=".", header=TRUE)

species <- c("abiealba" , "piceabie", "fagusilv", "pinusilv", "querpetr")

x11()
plot_gradient(dat$decade[dat$elevation==823], dat[dat$elevation==823, c(species)])


