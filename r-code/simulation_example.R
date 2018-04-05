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
clean_output_ubuntu()

### If you prepared already two climate files as done in "climate_examle.R"
### you need to copy the one you want to use to file "climate.txt", corresponding
### file name in the control.xml. Same for species files.
file.copy("Input/climate_historical.txt", "Input/climate.txt", overwrite=TRUE)   ### Must return "TRUE"
file.copy("Input/species_actual.xml", "Input/species.xml", overwrite=TRUE)       ### Must return "TRUE"
#file.copy("Input/species_pnv.xml", "Input/species.xml", overwrite=TRUE)


### Plot succession ####
setwd(proj_wd)

species_codes <- read.csv("data/landclim_site_infos/species_codes.csv", stringsAsFactors=F)
species_codes$colors <- rainbow(nrow(species_codes))
species_codes$colors <- colors()[(1:nrow(species_codes))*2]

sim_species <- unique(as.character(unlist(lapply(sites_sim, function(x) read_species_xml(paste("simulations/", tolower(x), "/Input/species.xml", sep=""))$name))))
sim_species <- data.frame(name=sim_species, colors=landclim_colors(length(sim_species)), stringsAsFactors=F)

pie(rep(1, nrow(sim_species)), col=sim_species$colors)


pdf("figures/succession_plots.pdf", width=7, height=4)
for(i in 1:NROW(sites_sim)){
  dat <- read.table(paste("simulations/", tolower(sites_sim[i]), "/Output/Output\\elevation_biomass_out.csv", sep=""), header=T, sep=",", dec=".")
  mycols <- sim_species$colors[match(names(dat)[2:(ncol(dat)-2)], sim_species$name)]
  plot_gradient(dat$decade, dat[,2:(ncol(dat)-2)], ylab="Biomass (t/ha)", xlab="Time (yrs)", main=sites_sim[i], ylim=c(0,500), col=mycols)
  legend("bottomright", legend=names(dat)[2:(ncol(dat)-2)], col=mycols, pch=15, title="Species", bg="white")
  
}
dev.off()
