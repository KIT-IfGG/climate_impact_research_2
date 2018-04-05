library(LandClimTools)
reload("/home/klara/R/x86_64-pc-linux-gnu-library/3.4/LandClimTools")
### Do not forget to create all input files!
### Execute (and later adjust) maps_exampe.R, species_example.R, climate_example.R 
### Copy also the control.xml etc. into the Input folder!
### In the following code the working directory will be changed (not good style, but necessary here);
### if there is a error message, check, if it is the because the wd changed! getwd()

getwd() ### ok?
proj_wd <- getwd()
#setwd(proj_wd)

### Set LandClim path: Full path!
set_landclim_path(paste(getwd(), "simulations/LandClim_trunk_2016", sep="/"))   ### only runs with Ubuntu!

### Folder name, simulation name. Could also be "bily_kriz_current_climate"
sites_sim <- "bily_kriz"

### Simulation ####
sim_folder <- paste("simulations/", tolower(sites_sim), sep="")
run_landclim(control_file="control.xml", input_folder=paste(sim_folder, "Input", sep="/"), output_folder=paste(sim_folder, "Output", sep="/"))
clean_output_ubuntu(sim_folder)

### If you prepared already two climate files as done in "climate_examle.R"
### you need to copy the one you want to use to file "climate.txt", corresponding
### file name in the control.xml. Same for species files.
file.copy("Input/climate_historical.txt", "Input/climate.txt", overwrite=TRUE)   ### Must return "TRUE"
file.copy("Input/species_actual.xml", "Input/species.xml", overwrite=TRUE)       ### Must return "TRUE"
#file.copy("Input/species_pnv.xml", "Input/species.xml", overwrite=TRUE)


### Plot succession ####
setwd(proj_wd)
dat <- read.table(paste("simulations/", tolower(sites_sim), "/Output/Output\\elevation_biomass_out.csv", sep=""), header=T, sep=",", dec=".")
plot_gradient(dat$decade, dat[,2:(ncol(dat)-2)], ylab="Biomass (t/ha)", xlab="Time (yrs)", main=sites_sim, ylim=c(0,500))
