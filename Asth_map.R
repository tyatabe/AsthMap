library(shiny)

# App of predicted rates asthma attack emergency dept visits  

ui <- fluidPage(
  
  # App title ----
  titlePanel("Asthma"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Help text indicating asthma is important because such and such
      helpText("25,000,000 people live with Asthma in the US, half of which will experience
               an asthma attack on any given year (CDC)"),
      
      # Zip code
      textInput("zipcode", label = h3("Enter a zipcode"), value = "95616"),
      
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
      textOutput(label = "selected_var"),
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")
      
      
    )
  )
)

server <- function(input, output) {
  
  output$selected_var <- renderText({ 
    paste("The predicted asthma attack rate at", input$zipcode, "is...")
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
