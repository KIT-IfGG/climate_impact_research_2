library(LandClimTools)

### Read in LandClim species parameter file with all available species
species <- read_species_xml("../data/landclim_files/species_full_med.xml")   ### LandClim species parameters
species$name <- as.character(species$name)

site_species <- read.csv("../data/landclim_site_infos/site_species_actual.csv", stringsAsFactors=F, skip=1)  ### Species present at each profound site
site_species_pnv <- read.csv("../data/landclim_site_infos/site_species_pnv.csv", stringsAsFactors=F, skip=1) ### Alternative species list for each profound site; create your own in odt-file and export as csv)
species_codes <- read.csv("../data/landclim_site_infos/species_codes.csv", stringsAsFactors=F)  ### Translation for LandClim species names in species_full_med.xml and profound species names.

species_selection_profound <- as.character(site_species[site_species$BilyKriz==1,"X"])

m <- match(species_selection_profound, species_codes$name_profound)
species_codes[m,"name_landclim"]

species_selection <- species[species$name %in% species_codes$name_landclim[match(species_selection_profound, species_codes$name_profound)],]

write_species_xml(species_selection, paste0("simulations/bily_kriz/Input/species_actual.xml"))



