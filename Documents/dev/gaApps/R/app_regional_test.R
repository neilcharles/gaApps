library(shiny)
library(googleAuthR)
library(googleAnalyticsR)

options(shiny.port = 1221)

gar_set_client(
  scopes = c("https://www.googleapis.com/auth/analytics",
             "https://www.googleapis.com/auth/analytics.edit"),
  activate = "web")

## ui --------------------------------------------------------------------------
ui <- fluidPage(title = "googleAuthR Shiny Demo",
                selectInput("test", "Test", c("1","2")),
                authDropdownUI("auth_menu")
)

## server ----------------------------------------------------------------------
server <- function(input, output, session){

  gar_shiny_auth(session) #googleAuthR

  ga_accounts <- reactive({
    req(input$test)
    ga_account_list()
  })

  selected_id <- callModule(module = authDropdown, id = "auth_menu", ga.table = ga_accounts)

}

shinyApp(gar_shiny_ui(ui, login_ui = gar_shiny_login_ui), server)
