library(GIFT)

shapes_data <- GIFT_shapes(
  entity_ID = NULL,
  api = "https://gift.uni-goettingen.de/api/extended/",
  GIFT_version = "latest"
)
str(shapes_data)

misc_env <- GIFT_env_meta_misc(
	api = "https://gift.uni-goettingen.de/api/extended/",
	GIFT_version = "latest"
)
View(misc_env)# list of environment variables

raster_env <- GIFT_env_meta_raster(
	api = "https://gift.uni-goettingen.de/api/extended/",
	GIFT_version = "latest"
)
View(raster_env)#list of climatic variables

env_data <- GIFT_env(
	entity_ID = NULL,
      miscellaneous = "biome",
      rasterlayer = c("wc2.0_bio_30s_12", "wc2.0_bio_30s_01"),#mostrar acumulada e não a maedia
	GIFT_version = "latest",
	api = "https://gift.uni-goettingen.de/api/extended/"
)
View(env_data)

biom <- merge(shapes_data, env_data[-c(2)], by = "entity_ID")
View(biom)#mean temperature, mean annual precipitation, geographic coordinates, biomes, botanical country and so on variables



GIFT_species_distribution()