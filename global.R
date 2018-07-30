#global.R

library(shiny)
library(dplyr)
library(ggplot2)
library(shinydashboard)
library(rworldmap)
library(googleVis)
library(DT)

commodity <- read.csv(file = "./commodity_trade_statistics_data.csv")

#Top_4 - USA, China, Canada, Mexico
commodity_T4 <- commodity %>%
  filter(., country_or_area == "USA" | country_or_area == "China, Hong Kong SAR" | country_or_area == "Canada" | country_or_area == "Mexico")

#tidy data
commodity_T4[,'comm_code']<-NULL
commodity_T4[,'weight_kg']<-NULL
commodity_T4[,'quantity_name']<-NULL
commodity_T4[,'quantity']<-NULL


commodity_T4 <- rename(commodity_T4, country = `country_or_area`)
commodity_T4 <- rename(commodity_T4, trade.in.usd = `trade_usd`)
commodity_T4 <- rename(commodity_T4, year.trade = `year`)


class(commodity_T4$category)  ##factor
commodity_T4$category<-as.character(commodity_T4$category)

commodity_T4 <- mutate(commodity_T4, flow = gsub(pattern = "Re-Export", replacement = "Export", x = flow, ignore.case = F, fixed = T)) %>%
  mutate(flow = gsub(pattern = "Re-Import", replacement = "Import", x = flow, ignore.case = F))%>%
  mutate(country = gsub(pattern = "China, Hong Kong SAR", replacement = "China", x = country, ignore.case = F))


## Data Set for Map## 
commodity_T4_maps<-commodity_T4%>%
  filter(.,year.trade==2016)%>%
  mutate(.,flow_sign = ifelse(flow=="Import",-1,1))%>%
  mutate(.,trade.in.sign = trade.in.usd*flow_sign)%>%
  group_by(.,country)%>%
  summarize(., balance = sum(trade.in.sign), balance2 = mean(trade.in.sign))



