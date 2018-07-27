#ui.R

sidebar <- dashboardSidebar(
  width = 250,
  sidebarUserPanel("Michael Tarino"),
  sidebarMenu(
    menuItem("Maps", tabName = "maps", icon = icon("fire")),
    menuItem("Graphs", tabName = "graphs", icon = icon("list-alt"),
             menuItem("Bar Graph: Trade", tabName = "bargraph", icon=icon('bar-chart-o')),
              menuItem("Histogram: Trade", tabName = "histogram", icon=icon('bar-chart-o'))
    ),
    menuItem("Statistics", tabName = "statistics", icon = icon("gear")),
    menuItem("Table", tabName = "table", icon = icon("table"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "maps",
            h2("Global Commodity Trade Balances for 2016"),
            fluidPage(htmlOutput("map"))
    ),
    
    tabItem(tabName = "bargraph",
            h2("Global Commodity Trade Data"),
            fluidPage(
              titlePanel("Bar Graph: Trade by Country and Flow"),
              sidebarLayout(
                sidebarPanel(
                  selectizeInput(inputId = "year.trade",
                                 label = "Year",
                                 choices = unique(commodity_T5[, 'year.trade'])),
                  selectizeInput(inputId = "category",
                                 label = "Category",
                                 choices = unique(commodity_T5[, 'category']))
                ),
                mainPanel(
                  fluidRow(
                    column(6, plotOutput("bar_graph", width = "200%"))
                  )
                )
              )
            )
            
    ),
    
    tabItem(tabName = "histogram",
            h2("Global Commodity Trade Data"),
            fluidPage(titlePanel("Histogram: Sum of Commodity transaction grouped by Year")),
            fluidRow(column(6, plotOutput("histogram_graph", width = "200%")))
    ),
    
    tabItem(tabName = "statistics",
            h2("Statistics: Linear Model and LOESS Regression"),
            fluidRow(column(3, selectizeInput('country', 
                                              label='Country:', 
                                              choices= unique(commodity_T5[, 'country'])))),
            fluidRow(column(5, plotOutput('statistics', width = "250%")))
            
    ),
    
    tabItem(tabName = "table",
            h2("Table from Commodity Database"),
            fluidRow(column(3, selectizeInput('country1', label='Country:', choices= unique(commodity_T5[, 'country']))),
                     column(3, selectizeInput('year.trade1', label='Year:', choices= unique(commodity_T5[, 'year.trade']))),
                     dataTableOutput('table'))
            
    )
    
  )
)


dashboardPage(skin='red',
  dashboardHeader(title = "Commodity Data"),
  sidebar,
  body
)



