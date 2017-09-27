# Load packages
library(shiny)
library(leaflet)
# Load data
load('app_data.RData')
# App of predicted rates asthma attack emergency dept visits  



shinyServer (function(input, output) {
  
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
  
  
})

shinyApp(ui = ui, server = server)
