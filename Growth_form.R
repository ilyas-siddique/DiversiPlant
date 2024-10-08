#install packages#
install.packages("GFIT")

#call packages#
library("GIFT")
library("dplyr")

#Increasing the timeout to complete larger downloads#
options(timeout = max(1000, getOption("timeout")))

#Loading GIFT traits dataset#
trait <- GIFT_traits_meta()
View(trait)

growthf<- GIFT_traits(trait_IDs = "1.2.2", agreement = 0.66, bias_ref = FALSE, bias_deriv = FALSE) #growth_form_2
growthf$trait_value_1.2.2<-as.factor(growthf$trait_value_1.2.2)
summary(growthf$trait_value_1.2.2)

climb<- GIFT_traits(trait_IDs = "1.4.2", agreement = 0.66, bias_ref = FALSE, bias_deriv = FALSE) #climber_2
climb$trait_value_1.4.2<-as.factor(climb$trait_value_1.4.2)
summary(climb$trait_value_1.4.2)


#Creating a dataframe with traits climber_2 e growth_form_2 by species#
combined_data <- merge(climb, growthf, by = "work_species", all = TRUE)
View(combined_data)
spp_cl_gw = combined_data[,c(1, 4, 10)] #selecting only the columns with species and traits
str(spp_cl_gw)


#Creating new data frame with trait value1.4.2 or trait value1.2.2 priority by specie#
func_group <- spp_cl_gw %>%
  mutate(
    prioritized_trait = case_when(
      trait_value_1.4.2 == "liana" & trait_value_1.2.2 == "shrub" ~ "liana",
      trait_value_1.4.2 == "liana" & trait_value_1.2.2 == "herb" ~ "liana",
      trait_value_1.4.2 == "liana" & is.na(trait_value_1.2.2) ~ "liana",
	trait_value_1.4.2 == "liana" & trait_value_1.2.2 == "other" ~ "liana",
      trait_value_1.4.2 == "liana" & trait_value_1.2.2 == "tree" ~ "liana",
      trait_value_1.4.2 == "liana" & trait_value_1.2.2 == "forb" ~ "liana",
	trait_value_1.4.2 == "liana" & trait_value_1.2.2 == "subshrub" ~ "liana",
      trait_value_1.4.2 == "liana" & trait_value_1.2.2 == "palm" ~ "liana",
      trait_value_1.4.2 == "self-supporting" & is.na(trait_value_1.2.2) ~ "other",
	trait_value_1.4.2 == "self-supporting" & trait_value_1.2.2 == "forb" ~ "forb",
	trait_value_1.4.2 == "self-supporting" & trait_value_1.2.2 == "graminoid" ~ "graminoid",
	trait_value_1.4.2 == "self-supporting" & trait_value_1.2.2 == "herb" ~ "forb",
	trait_value_1.4.2 == "self-supporting" & trait_value_1.2.2 == "other" ~ "other",
	trait_value_1.4.2 == "self-supporting" & trait_value_1.2.2 == "palm" ~ "palm",
	trait_value_1.4.2 == "self-supporting" & trait_value_1.2.2 == "shrub" ~ "shrub",
	trait_value_1.4.2 == "self-supporting" & trait_value_1.2.2 == "subshrub" ~ "subshrub",
	trait_value_1.4.2 == "self-supporting" & trait_value_1.2.2 == "tree" ~ "tree",
	trait_value_1.4.2 == "vine" & trait_value_1.2.2 == "shrub" ~ "vine",
      trait_value_1.4.2 == "vine" & trait_value_1.2.2 == "herb" ~ "vine",
      trait_value_1.4.2 == "vine" & is.na(trait_value_1.2.2) ~ "vine",
	trait_value_1.4.2 == "vine" & trait_value_1.2.2 == "other" ~ "vine",
      trait_value_1.4.2 == "vine" & trait_value_1.2.2 == "tree" ~ "vine",
      trait_value_1.4.2 == "vine" & trait_value_1.2.2 == "forb" ~ "vine",
	trait_value_1.4.2 == "vine" & trait_value_1.2.2 == "subshrub" ~ "vine",
      trait_value_1.4.2 == "vine" & trait_value_1.2.2 == "graminoid" ~ "vine",
	is.na(trait_value_1.4.2) & trait_value_1.2.2 == "forb" ~ "forb",
	is.na(trait_value_1.4.2) & trait_value_1.2.2 == "graminoid" ~ "graminoid",
	is.na(trait_value_1.4.2) & trait_value_1.2.2 == "herb" ~ "forb",
	is.na(trait_value_1.4.2) & trait_value_1.2.2 == "other" ~ "other",
	is.na(trait_value_1.4.2) & trait_value_1.2.2 == "palm" ~ "palm",
	is.na(trait_value_1.4.2) & trait_value_1.2.2 == "shrub" ~ "shrub",
	is.na(trait_value_1.4.2) & trait_value_1.2.2 == "subshrub" ~ "subshrub",
	is.na(trait_value_1.4.2) & trait_value_1.2.2 == "tree" ~ "tree",
      # Adicione outras regras conforme necessário
      TRUE ~ trait_value_1.4.2 # Se nenhuma condição for atendida, manter 'trait_value_1.4.2'
    )
  )
str(func_group)

func_group$trait_value_1.4.2<-as.factor(func_group$trait_value_1.4.2)
func_group$trait_value_1.2.2<-as.factor(func_group$trait_value_1.2.2)
func_group$prioritized_trait<-as.factor(func_group$prioritized_trait)

func_group$growth_form<-(func_group$prioritized_trait)
Growth_form<-func_group[,-c(2,3,4)]
str(Growth_form)
summary(Growth_form$growth_form)
