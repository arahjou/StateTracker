library(shiny)
library(lubridate)
library(DT)

# Initialize the CSV file
output_file <- "time_series_state.csv"
if (!file.exists(output_file)) {
  write.csv(data.frame(DATE.TIME = character(), State = numeric()), output_file, row.names = FALSE)
}

ui <- fluidPage(
  titlePanel("StateTracker"),
  h4("Current DATE.TIME:"),
  textOutput("currentTime"),
  br(),
  fluidRow(
    column(6, actionButton("hereBtn", "Here!", class = "btn-success")),
    column(6, actionButton("leaveBtn", "Leave!", class = "btn-warning"))
  ),
  br(),
  fluidRow(
    column(6, actionButton("startBtn", "Start Recording", class = "btn-primary")),
    column(6, actionButton("stopBtn", "Stop Recording", class = "btn-danger"))
  ),
  br(),
  actionButton("resetBtn", "Reset Data", class = "btn-secondary"),
  br(), br(),
  h4("Recording Status:"),
  textOutput("recordingStatus"),
  br(),
  h4("Recorded Data:"),
  dataTableOutput("dataTable")
)

server <- function(input, output, session) {
  
  # Reactive values to store state
  values <- reactiveValues(
    state = 0,  # Default to "Leave"
    recording = FALSE,
    data = data.frame(DATE.TIME = character(), State = numeric(), stringsAsFactors = FALSE),
    last_record_time = NULL
  )
  
  # Update current time every second
  output$currentTime <- renderText({
    invalidateLater(1000, session)  # Update every second
    format(Sys.time(), "%Y-%m-%d %H:%M:%OS3")
  })
  
  # Handle "Here!" button
  observeEvent(input$hereBtn, {
    values$state <- 1
    showNotification("State set to 'Here!' (1)", type = "message")
  })
  
  # Handle "Leave!" button
  observeEvent(input$leaveBtn, {
    values$state <- 0
    showNotification("State set to 'Leave!' (0)", type = "warning")
  })
  
  # Handle "Start Recording" button
  observeEvent(input$startBtn, {
    if (!values$recording) {
      values$recording <- TRUE
      values$last_record_time <- NULL  # Reset the last record time
      showNotification("Recording started!", type = "message")
    }
  })
  
  # Handle "Stop Recording" button
  observeEvent(input$stopBtn, {
    if (values$recording) {
      values$recording <- FALSE
      showNotification("Recording stopped.", type = "warning")
    }
  })
  
  # Handle "Reset Data" button
  observeEvent(input$resetBtn, {
    values$data <- data.frame(DATE.TIME = character(), State = numeric(), stringsAsFactors = FALSE)
    if (file.exists(output_file)) {
      file.remove(output_file)
    }
    showNotification("Data reset successfully.", type = "message")
  })
  
  # Recording logic with updated interval
  observe({
    invalidateLater(500, session)  # Check every 0.5 seconds
    
    if (values$recording) {
      # Check if 0.5 seconds have passed since the last recording
      if (is.null(values$last_record_time) || difftime(Sys.time(), values$last_record_time, units = "secs") >= 0.5) {
        current_time <- Sys.time()
        new_entry <- data.frame(
          DATE.TIME = format(current_time, "%Y-%m-%d %H:%M:%OS3"),  # Include date and milliseconds
          State = values$state, 
          stringsAsFactors = FALSE
        )
        values$data <- rbind(values$data, new_entry)
        
        # Append new data to CSV
        if (!file.exists(output_file) || file.info(output_file)$size == 0) {
          write.csv(values$data, output_file, row.names = FALSE)
        } else {
          write.table(
            new_entry, 
            file = output_file, 
            append = TRUE, 
            sep = ",", 
            col.names = FALSE, 
            row.names = FALSE
          )
        }
        values$last_record_time <- Sys.time()
      }
    }
  })
  
  # Update recording status
  output$recordingStatus <- renderText({
    if (values$recording) {
      paste("Recording... State:", values$state)
    } else {
      "Not recording."
    }
  })
  
  # Display recorded data
  output$dataTable <- renderDataTable({
    if (file.exists(output_file) && file.info(output_file)$size > 0) {
      # Read the data and ensure DATE.TIME is properly formatted
      data <- read.csv(output_file, stringsAsFactors = FALSE)
      data$DATE.TIME <- as.POSIXct(data$DATE.TIME, format = "%Y-%m-%d %H:%M:%OS3")
      data
    } else {
      values$data
    }
  })
}

shinyApp(ui = ui, server = server)
