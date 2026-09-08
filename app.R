# Load packages
library(shiny)
library(bslib)
library(ggplot2)

# Get data
file = 'https://github.com/rstudio-education/shiny-course/raw/main/movies.RData'
destfile = 'movies.RData'
download.file(file, destfile)

# Load data
load('movies.RData')

# Define UI
ui = page_sidebar(
  sidebar = sidebar(
    # Select a variable for y-axis
    selectInput(
      inputId = 'x',
      label = 'X-axis:',
      choices = c('imdb_rating', 'imdb_num_votes', 'critics_score', 
                  'audience_score', 'runtime'),
      selected = 'critics_score'
    ),
    # Select a variable for x-axis
    selectInput(
      inputId = 'y',
      label = 'Y-axis:',
      choices = c('imdb_rating', 'imdb_num_votes', 'critics_score', 
                  'audience_score', 'runtime'),
      selected = 'imdb_rating'
    )
  ),
  # Output: Show scatterplot
  card(plotOutput(outputId = 'scatterplot'))
)

# Define server
server = function(input, output, session) {
  output$scatterplot = renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
      geom_point()
  })
}

# Run app
shinyApp(ui, server)