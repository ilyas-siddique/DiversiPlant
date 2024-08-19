biomes_data <- GIFT_shapes()
View(biomes_data)

misc_env <- GIFT_env_meta_misc(
	api = "https://gift.uni-goettingen.de/api/extended/",
	GIFT_version = "latest")
View(misc_env) # list of environment variables

raster_env <- GIFT_env_meta_raster()
View(raster_env) #list of climatic variables

env_data <- GIFT_env(
	entity_ID = NULL,
	miscellaneous = "biome",
	rasterlayer = NULL,
	GIFT_version = "latest",
	api = "https://gift.uni-goettingen.de/api/extended/")


clim_data <- GIFT_env(entity_ID = NULL,
                    miscellaneous = "biome",
                    rasterlayer = c("wc2.0_bio_30s_12", "wc2.0_bio_30s_01")) 
	#need add overlap and entity_type selection command, and check if this is the mean or accumulated data


clim_biom <- merge(biomes_data, clim_data[-c(2)], by = "entity_ID") #mean temperature, mean annual precipitation, geographic coordinates, biomes, botanical country and so on variables



