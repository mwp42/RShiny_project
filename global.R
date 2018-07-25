#global.R
library(shiny)
library(dplyr)
library(ggplot2)
library(shinydashboard)
library(rworldmap)
library(googleVis)
library(DT)

commodity <- read.csv(file = "./commodity_trade_statistics_data.csv")


#Top_5 - USA, China, Canada, Mexico
commodity_T5 <- commodity %>%
  filter(., country_or_area == "USA" | country_or_area == "China, Hong Kong SAR" | country_or_area == "Canada" | country_or_area == "Mexico")

##sample your data
set.seed(0)
commodity_T5<-commodity_T5[sample(nrow(commodity_T5), 30000), ]


#tidy data
commodity_T5 <- rename(commodity_T5, country = `country_or_area`)
commodity_T5 <- rename(commodity_T5, comm.code = `comm_code`)
commodity_T5 <- rename(commodity_T5, quantity.name = `quantity_name`)
commodity_T5 <- rename(commodity_T5, weight.in.kg = `weight_kg`)
commodity_T5 <- rename(commodity_T5, trade.in.usd = `trade_usd`)
commodity_T5 <- rename(commodity_T5, year.trade = `year`)


class(commodity_T5$category)  ##factor
commodity_T5$category<-as.character(commodity_T5$category)

commodity_T5 <- mutate(commodity_T5, flow = gsub(pattern = "Re-Export", replacement = "Export", x = flow, ignore.case = F, fixed = T)) %>%
  mutate(flow = gsub(pattern = "Re-Import", replacement = "Import", x = flow, ignore.case = F))%>%
  mutate(country = gsub(pattern = "China, Hong Kong SAR", replacement = "China", x = country, ignore.case = F))

#remove outliers
keep <- !commodity_T5$trade.in.usd %in% boxplot.stats(commodity_T5$trade.in.usd)$out
commodity_T5<-commodity_T5[keep, ]



## Data Set for Map## 
commodity_T5_maps<-commodity_T5%>%
  filter(.,year.trade==2016)%>%
  mutate(.,flow_sign = ifelse(flow=="Import",-1,1))%>%
  mutate(.,trade.in.sign = trade.in.usd*flow_sign)%>%
  group_by(.,country)%>%
  summarize(., balance = sum(trade.in.sign), balance2 = mean(trade.in.sign))



