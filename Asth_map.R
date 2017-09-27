# Load packages
library(shiny)
library(leaflet)
# Load data
pred <- readRDS("/home/ubuntu/AsthMap/pred.rds")
ca_preds <- readRDS("/home/ubuntu/AsthMap/ca_preds.rds")
popup <- paste0("Zip Code: ", ca_preds$zip, "<br>", 
        "Predicted rate of ashtma attacks (per 10,000) is ", 
        round(ca_preds$pred,1), ". This is ", 
        round(ca_preds$pred/mean(ca_preds$pred, na.rm=T)*100, 1),
        "% of the mean for CA")
pal <- colorNumeric(
  palette = "YlGnBu",
  domain = ca_preds$pred
)

map3 <-leaflet() %>%
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
 
)

server <- function(input, output) {
  
 zip.input <-  eventReactive(input$get_risk, {
    input$zip.text
    
  })
  

  
  output$zipcode <- renderText({ 
    paste("The predicted asthma attack rate per 10,000 at ", zip.input(), " is ", 
          round(pred$pred[pred$zip.text==zip.input()]), 
          ". This is ", round(pred$pred[pred$zip.text==zip.input()]
                              /mean(pred$pred)*100), "% of the mean rate of the state", sep="")
  })
  
  output$mymap <- renderLeaflet({
    map3 %>%
    setView(lng = as.numeric(ca_preds@data$INTPTLON10[ca_preds@data$GEOID10==zip.input()]),
            lat = as.numeric(ca_preds@data$INTPTLAT10[ca_preds@data$GEOID10==zip.input()]), 
            zoom = 8) %>%
    
    addMarkers(lng=as.numeric(ca_preds@data$INTPTLON10[ca_preds@data$GEOID10==zip.input()]), 
               lat=as.numeric(ca_preds@data$INTPTLAT10[ca_preds@data$GEOID10==zip.input()])
    )
    })
  
  
  output$distPlot <- renderPlot({
    
    x    <- pred$pred
    bins <- seq(floor(min(x)), ceiling(max(x)), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Rate per 10,000",
         main = paste("Distribution of asthma attacks rate in CA"))
    
  })
  
  
}

shinyApp(ui = ui, server = server)
