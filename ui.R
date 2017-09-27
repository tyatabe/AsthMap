# Load packages
library(shiny)
library(leaflet)
# Load data
# App of predicted rates asthma attack emergency dept visits  

shinyUI  (fluidPage(
  # Leaflet output
  
  # App title ----
  titlePanel(h2("RiskMap")),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Help text indicating asthma is important because such and such
      helpText("25,000,000 people live with Asthma in the US, half of which will experience
               an asthma attack on any given year (CDC)"),
      
      # Zip code
      textInput("zip.text", label= h3("Enter a zipcode"), value = "95616"),
      actionButton("get_risk", "Get Risk"),
      
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 5,
                  max = 100,
                  value = 50),
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")
      
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output selected zipcode
      textOutput("zipcode"),
      # Tha map
      leafletOutput("mymap")  
      
      
      
    )
  )
 
))
