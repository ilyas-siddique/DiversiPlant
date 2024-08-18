# 

# extend timeout to load large datasets:
options(timeout = max(1000, getOption("timeout"))) 

#install.packages("GIFT")
#install.packages("rWCVP")
library(GIFT)
library(rWCVP)
library(tidyverse)
library(data.table)

# Save names & IDs of "Botanical Countries"
## (only ~300 main botanical regions out of >4000 overlapping, mostly tiny regions): 
GIFT.reg <- GIFT_regions() 
Bot.country <- GIFT.reg %>% 
  filter(entity_type == "Botanical Country") 
write.table(Bot.country, sep="\t", file="Bot.country.txt")

# Retrieve GIFT species checklists

## Lon,Lat point coordinate of UFSC Experimental Farm 
## (located in Botanical Country "Santa Catarina Province"):
coord <- cbind(-48.5412,-27.6853) 

## Retrieve list of all native vascular plant species for point coordinate:
natvasc <- GIFT_checklists(taxon_name="Tracheophyta", # or lower taxon. level: Angiospermae, Fabaceae, etc
                           complete_taxon=F, # checklists don't need to completely cover taxon of interest
                           floristic_group="native",# FROM DASHBOARD USER INPUT: all,native,endemic or naturalized
                           complete_floristic=F, # even if incomplete list for chosen floristic_group 
                           coordinates = coord, # Lon,Lat point coordinate in 2 columns
                           overlap="extent_intersect", # if point location/small polygon 
                           # (maybe set "extent_intersect" if country/region)
                           list_set_only=F, # don't restrict metadata of checklists matching criteria $lists
                           remove_overlap=T, #retrieve only single geogr polygon? F=retrieve checklists of overlapping taxon.levels?
                           # F=retrieve checklists of taxon? or geogr? levels that overlap
                           area_threshold_mainland=100) # select only polygons >100km² among overlapping polygons
natvasc[["lists"]] # check metadata
natvascp <- natvasc[["checklists"]]
natvascp[] <- lapply(natvascp, factor) # converts chr into factos, but "[]" keeps dataframe structure
summary(natvascp)
write.table(natvascp[["checklists"]], file="SCnatvasc_checklist.csv") 

## Download raw checklists by ID (e.g. Brazilian federal state): 
listID_BA <- GIFT_checklists_raw(list_ID=c(10939), namesmatched=T) # 10939 Bahia 
listID_SC <- GIFT_checklists_raw(list_ID=c(10132), namesmatched=T) # 10132 SC 

# Retrieve GIFT trait data

## download trait names, codes & nº of species covered
trait_meta <- GIFT_traits_meta() 
trait_meta[which(trait_meta$Trait2 == "Plant_height_max"), ] # display metadata of trait of interest
height <- GIFT_traits(trait_IDs = c("1.6.2"), agreement = 0.66, # download aggregate value for 1 trait of all spp 
                      bias_ref = FALSE, bias_deriv = FALSE)
height_raw <- GIFT_traits_raw(trait_IDs = c("1.6.2")) # download all raw values for 1 trait of all spp

## retrieve alternative more crude traits for species for which ideal (more differentiated) traits NA
trait_meta[which(trait_meta$Trait2 == "Growth_form_1"), ] # display metadata of trait of interest

### Combine traits into single:
# Growth_form_2  Climber_2

### Order of preference of traits
# Growth_form_1 > Woodiness_1 > Climber_1 > Shoot_orientation 

# Shoot_length_min (cm prostrate and erect)

# Lifespan_1 Lifecycle_1 

# Life_form_2 Life_form_1 

## Traits to filter species from output: 
# Seed_mass_mean Nitrogen_fix_1 Fruit_length_max Deciduousness_1 SLA_mean SSD_mean
# Dispersal_syndrome_2 > Dispersal_syndrome_1 
# Pollination_syndrome_3 > Pollination_syndrome_2 

# Aggregate trait values at genus level for species with trait NA: 
trait_tax <- GIFT_traits_tax(trait_IDs = c("1.1.1", "1.2.1", "1.4.1", "1.6.2"),
                             bias_ref=F, bias_deriv=F)
trait_tax[1:4, ]