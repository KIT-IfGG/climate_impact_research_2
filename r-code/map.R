library(ProfoundData)
library(raster)
library(ggmap)
library(mapproj)


setDB("../data/ProfoundData.sqlite")

overview <- browseData()
site_infos <- ProfoundData::getData(dataset =  "SITES")
site_infos <- site_infos[overview$TREE == 1,]
site_infos <- site_infos[site_infos$site != "global",]

map <- get_map(location = 'Europe', zoom = 4,  maptype = c("watercolor"), source = "stamen")
ggm <- ggmap(map,  extent = "normal") + theme_bw()  + geom_point(data=site_infos, colour="blue", cex=2, aes(lon, lat))  + geom_label(data=site_infos, size=5, hjust = 0, nudge_x = 0.5, aes(lon, lat, label=site_infos$site))
ggm

ggsave(paste("figures/", "europe_map.pdf", sep=""), ggmap(map,  extent = "normal") + theme_bw(),  width=10, height=10)
ggsave(paste("figures/", "site_map.pdf", sep=""), ggm,  width=10, height=10) 

