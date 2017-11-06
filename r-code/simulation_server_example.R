#library(devtools)

### Install R-package LandClimTools from file (see Ilias). Change the path to your folder structure! This line need to be executed only once.
install.packages(pkgs="/home/klara/CIR_2016/profound_simulations_server/LandClimTools.tar.gz", repos=NULL, type = "source")

### Load the library ###
library(LandClimTools)

### Set your working directory ####
setwd("/home/klara/CIR_2016/profound_simulations_server/")
proj_wd <- getwd()

### Create/find/check path to the executable ####
paste0(proj_wd, "/data/LandClim_trunk_2016")
list.files(paste0(proj_wd, "/data/"))  ### Should return > [1] "LandClim_trunk_2016"

set_landclim_path(paste0(proj_wd, "/data/LandClim_trunk_2016"))   ### only runs with Ubuntu!

### Your folder name
sites_sim <- "soro"   

### Simulation ####
setwd(paste(proj_wd, "/simulations/", tolower(sites_sim[1]), sep=""))
  
dir.create("Output")
file.remove(list.files("Output", full=TRUE))
simulate(paste(proj_wd, "/simulations/", tolower(sites_sim[1]), "/Input/control.xml", sep=""))
clean_output_ubuntu()

# setwd(proj_wd)


