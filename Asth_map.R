# Load packages
library(shiny)
library(leaflet)
# Load data
#pred <- readRDS("/home/tyatabe/Onedrive/Dev folder/AsthMap/data/pred.rds")
#ca_preds <- readRDS("/home/tyatabe/Onedrive/Dev folder/AsthMap/data/ca_preds.rds")

# App of predicted rates asthma attack emergency dept visits  

ui <- fluidPage(
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
      textInput("zip.text", label = h3("Enter a zipcode"), value = "95616"),
      
      
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 5,
                  max = 100,
                  value = 50)
      
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output selected zipcode
      textOutput("zipcode"),
      # Tha map
      leafletOutput("mymap"),
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")
      
      
    )
  )
)

server <- function(input, output) {
  
  output$zipcode <- renderText({ 
    paste("The predicted asthma attack rate per 10,000 at ", input$zip.text, " is ", 
          round(pred$pred[pred$zip.text==input$zip.text]), 
          ". This is ", round(pred$pred[pred$zip.text==input$zip.text]
            /mean(pred$pred)*100), "% of the mean rate of the state", sep="")
  })
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      addPolygons(data = ca_preds, 
                  fillColor = ~pal(pred), 
                  color = "#b2aeae", # you need to use hex colors
                  fillOpacity = 0.7, 
                  weight = 1, 
                  smoothFactor = 0.2,
                  popup = popup) %>%
      addLegend(pal = pal, 
                values = ca_preds$pred, 
                position = "bottomright", 
                title = "Predicted asthma attack rates<br>per 10,000 people")
  })
  
  output$distPlot <- renderPlot({
    
    x    <- pred$pred
    bins <- seq(floor(min(x)), ceiling(max(x)), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Rate per 10,000",
         main = "Asthma attacks ED visits rate per 10,000 in CA")
    
  })
  
  
}

shinyApp(ui = ui, server = server)
