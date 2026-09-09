# Load packages
library(shiny)
library(bslib)
library(ggplot2)

# # Get data
# file = 'https://github.com/rstudio-education/shiny-course/raw/main/movies.RData'
# destfile = 'movies.RData'
# download.file(file, destfile)
# 
# # Load data
# load('movies.RData')
# 
# # Define UI
# ui = page_sidebar(
#   sidebar = sidebar(
#     # Select a variable for x-axis
#     selectInput(inputId = 'x',
#                 label = 'X-axis:',
#                 choices = c(
#                   'IMDB Rating' = 'imdb_rating', 
#                   'IMDB Number of Votes' = 'imdb_num_votes', 
#                   'Critics Score' = 'critics_score', 
#                   'Audience Score' = 'audience_score', 
#                   'Runtime' = 'runtime'),
#                 selected = 'critics_score'
#     ),
#     # Select a variable for y-axis
#     selectInput(inputId = 'y',
#                 label = 'Y-axis:',
#                 choices = c(
#                   'IMDB Rating' = 'imdb_rating', 
#                   'IMDB Number of Votes' = 'imdb_num_votes', 
#                   'Critics Score' = 'critics_score', 
#                   'Audience Score' = 'audience_score', 
#                   'Runtime' = 'runtime'),
#                 selected = 'audience_score'
#     ),
#     # Select a variable to color points
#     selectInput(inputId = 'z',
#                 label = 'Color',
#                 choices = c(
#                   'Title Type' = 'title_type', 
#                   'Genre' = 'genre', 
#                   'MPAA Rating' = 'mpaa_rating', 
#                   'Critics Rating' = 'critics_rating', 
#                   'Audience Rating' = 'audience_rating'),
#                 selected = 'mpaa_rating'
#     )
#   ),
#   # Output: Show scatterplot
#   card(plotOutput(outputId = 'scatterplot'))
# )
# 
# # Define server
# server = function(input, output, session) {
#   output$scatterplot = renderPlot({
#     ggplot(data = movies, aes_string(x = input$x, y = input$y, color = input$z)) +
#       geom_point()
#   })
# }
# 
# # Run app
# shinyApp(ui, server)


# ui = page_fluid(
#   textInput(
#     inputId = 'custom_text',
#     label = 'Input some text here:'
#   ),
#   strong('Text is shown below:'),
#   textOutput(outputId = 'user_text')
# )
# 
# server = function(input, output, session) {
#   output$user_text = renderText({ input$custom_text })
# }
# 
# shinyApp(ui, server)

# FIXING THE APP - https://shiny.posit.co/r/getstarted/build-an-app/hello-shiny/server-function.html
# Load packages ----------------------------------------------------------------

library(shiny)
library(bslib)
library(ggplot2)

# Load data --------------------------------------------------------------------

load("movies.RData")

# Define UI --------------------------------------------------------------------

ui <- page_sidebar(
  sidebar = sidebar(
    # Select variable for y-axis
    selectInput(
      inputId = "y",
      label = "Y-axis:",
      choices = c(
        "IMDB rating" = "imdb_rating",
        "IMDB number of votes" = "imdb_num_votes",
        "Critics score" = "critics_score",
        "Audience score" = "audience_score",
        "Runtime" = "runtime"
      ),
      selected = "audience_score"
    ),
    
    # Select variable for x-axis
    selectInput(
      inputId = "x",
      label = "X-axis:",
      choices = c(
        "IMDB rating" = "imdb_rating",
        "IMDB number of votes" = "imdb_num_votes",
        "Critics score" = "critics_score",
        "Audience score" = "audience_score",
        "Runtime" = "runtime"
      ),
      selected = "critics_score"
    ),
    
    # Select variable for color
    selectInput(
      inputId = "z",
      label = "Color by:",
      choices = c(
        "Title type" = "title_type",
        "Genre" = "genre",
        "MPAA rating" = "mpaa_rating",
        "Critics rating" = "critics_rating",
        "Audience rating" = "audience_rating"
      ),
      selected = "mpaa_rating"
    )
  ),
  
  # Output: Show scatterplot
  card(plotOutput(outputId = "scatterPlot"))
)

# Define server ----------------------------------------------------------------

server <- function(input, output, session) {
  output$scatterPlot <- renderPlot({ # scatterPlot instead of scatterplot
    
    ggplot(data = movies, aes_string(x = input$x, y = input$y, color = input$z)) + # NEED TO PREFIX x, y, and z WITH 'input$'
      geom_point()
    
  })
  
}

# Create a Shiny app object ----------------------------------------------------

shinyApp(ui = ui, server = server)