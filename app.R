# Load packages ----------------------------------------------------------------
library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(DT)

# Load data --------------------------------------------------------------------
load("movies.RData")
# Calculate total number of movies in dataset
n_total = nrow(movies)
# Calculate min and max dates
min_date = min(movies$thtr_rel_date)
max_date = max(movies$thtr_rel_date)

# Define UI --------------------------------------------------------------------
ui = page_sidebar(
  title = 'IMDB Movies',
  sidebar = sidebar(
    HTML(paste0('The dataset has ', nrow(movies), ' observations.')),
    HTML(paste0('Movies released since the following date will be plotted.
                 Pick a date between ', min_date, ' and ', max_date, '.')),
    br(), br(),
    dateInput(inputId = 'date',
              label = 'Select date:',
              value = '2013-09-16',
              min = min_date, max = max_date),
    # Select variable for y-axis
    selectInput(
      inputId = "y",
      label = "Y-axis:",
      choices = c(
        "IMDB rating" = "imdb_rating",
        "IMDB number of votes" = "imdb_num_votes",
        "Critics score" = "critics_score",
        "Audience score" = "audience_score",
        "Runtime" = "runtime"),
      selected = "audience_score"),
    # Select variable for x-axis
    selectInput(
      inputId = "x",
      label = "X-axis:",
      choices = c(
        "IMDB rating" = "imdb_rating",
        "IMDB number of votes" = "imdb_num_votes",
        "Critics score" = "critics_score",
        "Audience score" = "audience_score",
        "Runtime" = "runtime"),
      selected = "critics_score"),
    # Select variable for color
    selectInput(
      inputId = "z",
      label = "Color by:",
      choices = c(
        "Title type" = "title_type",
        "Genre" = "genre",
        "MPAA rating" = "mpaa_rating",
        "Critics rating" = "critics_rating",
        "Audience rating" = "audience_rating"),
      selected = "mpaa_rating"),
    # Add filter for film studio
    selectInput(
      inputId = 'movie_studio',
      label = 'Movie Studio',
      choices = sort(movies$studio),
      multiple = TRUE,
      selectize = TRUE
    ),
    # Set alpha value
    sliderInput(inputId = 'slider',
                label = 'Alpha:',
                min = 0.0, max = 1.0,
                value = 0.5),
    # Show data table
    checkboxInput(inputId = 'show_data',
                  label = 'Show data table',
                  value = TRUE),
    numericInput(inputId = 'n',
                 label = 'Select number of movies',
                 min = 1, max = n_total,
                 value = 30)
  ),
  
  # Output: Show scatterplot
  card(
    # Show scatterplot
    plotOutput(outputId = 'scatterplot'),
    # Show density plot
    # plotOutput(outputId = 'densityplot')
    dataTableOutput(outputId = 'movies_table')
  )
)

# Define server ----------------------------------------------------------------
server = function(input, output, session) {
  output$scatterplot = renderPlot({ # scatterPlot instead of scatterplot
    movies_selected_date = movies %>%
      filter(thtr_rel_date >= as.POSIXct(input$date))
    ggplot(data = movies, aes_string(x = input$x, y = input$y, color = input$z)) + # NEED TO PREFIX x, y, and z WITH 'input$'
      geom_point(alpha = input$slider)
  })
  
  #output$densityplot = renderPlot({
  #  ggplot(data = movies, aes_string(x = input$x)) + 
  #    geom_density()
  #})
  
  output$movies_table = renderDataTable({
    if(input$show_data) {
      req(input$n)
      req(input$movie_studio)
      movies_sample = movies %>%
        # filter(studio == input$movie_studio) %>%
        sample_n(input$n) %>%
        select(title:studio)
      DT::datatable(data = movies_sample,
                    options = list(pageLength = 10),
                    rownames = FALSE)
      #DT::datatable(data = movies %>% select(1:7),
      #              options = list(pageLength = 10),
      #              rownames = FALSE)
    }
  })
  
  #output$movies_table = renderDataTable({
  #  movies_sample = movies %>%
  #    sample_n(input$n) %>%
  #    select(title:studio)
  #  DT::datatable(data = movies_sample,
  #                options = list(pageLength = 10),
  #                rownames = FALSE)
  #})
}

# Create a Shiny app object ----------------------------------------------------
shinyApp(ui = ui, server = server)