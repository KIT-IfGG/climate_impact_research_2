library(ProfoundData)
library(LandClimTools)

proj_wd <- getwd()

setDB(paste(getwd(), "/data/ProfoundData.sqlite", sep=""))
set_landclim_path("/home/klara/profound_simulations/data/LandClim_trunk_2016")   ### only runs with Ubuntu!

overview <- browseData()

### Select sites with data suitable for LandClim simulations
sites <- overview[overview$CLIMATE==1,]
sites <- overview[overview$TREE==1 | overview$STAND==1,]

site_infos <- ProfoundData::getData(dataset = "SITES")


sites_sim <- sites$name1[1]
### Simulations ####
setwd(paste(proj_wd, "/simulations/", tolower(sites_sim[1]), sep=""))
  
file.copy("Input/climate_historical.txt", "Input/climate.txt", overwrite=TRUE)
file.copy("Input/species_actual.xml", "Input/species.xml", overwrite=TRUE)
#file.copy("Input/species_pnv.xml", "Input/species.xml", overwrite=TRUE)
  
dir.create("Output")
file.remove(list.files("Output", full=TRUE))
simulate(paste(proj_wd, "/simulations/", tolower(sites_sim[i]), "/Input/control.xml", sep=""))
clean_output_ubuntu()

setwd(proj_wd)


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
