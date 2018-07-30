#server.R

function(input, output, session) {
  
  ########  MAP ########
  output$map <- renderGvis({
    map<-gvisGeoChart(commodity_T4_maps, locationvar='country', colorvar='balance',
                      options=list(title='Trade Balance by Country', width='100%', projection="kavrayskiy-vii", colorAxis="{colors:['#0000ff', '#FF0000']}"))
    return(map)
  })
  
  
  ########  BAR GRAPH 1 ########
  observe(
    print(paste("year.trade:", input$year.trade, "category:", input$category))
  )
  
  observe({
    category <- unique(commodity_T4 %>%
                     filter(commodity_T4$year.trade == input$year.trade) %>%
                     .$category)
    updateSelectizeInput(
      session, "category",
      choices = category,
      selected = category[1])
  })
  
  output$bar_graph <- renderPlot({
    commodity_T4 %>%
      filter(.,commodity_T4$year.trade == input$year.trade & commodity_T4$category == input$category)%>%
      group_by(.,country, flow)%>% 
      summarize(., sum_trade_yr = sum(trade.in.usd, na.rm=TRUE)) %>%
      ggplot(., aes(x=flow, y=sum_trade_yr)) +
      geom_bar(aes(x=country,fill=flow), stat="identity", position='dodge') +
      labs(title='Trade by country and flow', x='Country', y='Sum Trade in USD') + 
      theme_bw()
  })
  
  ########  HISTOGRAM 1 ########
  output$histogram_graph <- renderPlot({
    commodity_T4%>%
      group_by(country, year.trade)%>%
      summarize(sum.trade=sum(trade.in.usd))%>%
      ggplot(aes(x=sum.trade)) + geom_histogram(aes(fill=country), color="black", bins = 40, position = position_stack(reverse=TRUE)) + coord_cartesian(xlim=c(66000000000,5e+12),ylim=c(0,15)) + ##from 5000000, 4500000000
      xlab("Sum of Commodity transactions in USD grouped by Year") + ylab("Count")
  })
  
  ########  STATISTICS ########
  observe(
    print(paste("country:", input$country))
  )
  
  output$statistics <- renderPlot({
    commodity_T4 %>%
      filter(.,commodity_T4$country == input$country, year.trade==1996|year.trade==1998|year.trade==2000|year.trade==2002|year.trade==2004|year.trade==2006|year.trade==2008|year.trade==2010|year.trade==2012|year.trade==2014|year.trade==2016)%>%
      group_by(., year.trade)%>%
      summarize(., balance = sum(trade.in.usd), balance2 = mean(trade.in.usd))%>%
      ggplot(., aes(x=year.trade, y=balance)) + geom_point(color='red1', shape=2 , size=4) + geom_smooth(se=FALSE, col = "green") + stat_smooth(method = "lm", col = "blue", se=FALSE) +
      labs(title='Trade Volume in USD', x='Year', y='Trade in USD') + 
      theme(legend.key=element_blank(), legend.position="bottom") +
      theme_bw()
  })
  
  
  ########  FILTERING TABLE ########
  observe(
    print(paste("year.trade:", input$year.trade1, "country:", input$country1))
  )
  
  observe({
    country <- unique(commodity_T4 %>%
                         filter(commodity_T4$year.trade == input$year.trade1) %>%
                         .$country1)
    updateSelectizeInput(
      session, "country",
      choices = country,
      selected = country[1])
  })
  
  trade_filter<-reactive({
    commodity_T4%>%
      filter(., year.trade == input$year.trade1)%>%
      filter(., country == input$country1)
  })
  
  output$table <- renderDataTable({
    datatable(trade_filter(), rownames=TRUE) %>%
      formatStyle(input$selected, background="red", fontWeight='bold')
  })
}