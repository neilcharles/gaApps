library(bs4Dash)
library(shiny)
library(googleAuthR)

options(googleAuthR.webapp.client_id = "544952614531-cp3154luqkgfde6po9opl5k60hl16r5o.apps.googleusercontent.com")
options(shiny.port = 4093)


ui <- list(
  shiny::HTML(
    "<script src=\"https://apis.google.com/js/platform.js?onload=init\"></script>"
  ),
  uiOutput('app')
)

server <- function(input, output, session) {
  sign_ins <- callModule(googleSignIn, "signin")
  
  g_name <- reactive(sign_ins()$name)
  g_email = reactive(sign_ins()$email)
  g_image = reactive(sign_ins()$image)
  
  user_is_logged_in <- reactive({
    !class(try(g_name(), silent = TRUE)
    ) == "try-error"
  })
  
  output$app <- renderUI({
    if (user_is_logged_in()) {
      bs4DashPage(
        dark = NULL,
        header = bs4DashNavbar(title = "Login Skeleton",
                               rightUi = userOutput('login_rightui')),
        sidebar = bs4DashSidebar(),
        # controlbar = bs4DashControlbar(disable = TRUE),
        body = bs4DashBody(
          shiny::HTML(
            "<script src=\"https://apis.google.com/js/platform.js?onload=init\"></script>"
          )
        )
      )
    } else {
      bs4DashPage(
        header = bs4DashNavbar(disable = TRUE),
        sidebar = bs4DashSidebar(disable = TRUE),
        bs4DashBody(
          tags$style(HTML(
            'body:not(.sidebar-mini-md) .content-wrapper, body:not(.sidebar-mini-md) .main-footer, body:not(.sidebar-mini-md) .main-header {
               margin-left: 0;
            }
            #controlbar-toggle, .fa-bars{
              visibility: hidden;
            }')),
          bs4Card(
            closable = FALSE,
            collapsible = FALSE,
            tags$h2("Login Skeleton", class = "text-left", style = "padding-top: 0;color:#333; font-weight:600;"),
            hr(),
            googleSignInUI("signin")
          )
        )
      )
    }
  })
  
  output$login_rightui <-
    renderUser({
      dashboardUser(
        name = g_name(),
        image = g_image(),
        title = "Neil's Plans",
        subtitle = "Admin",
        footer = googleSignInUI("signin")
      )
    })
}

shinyApp(ui = ui, server = server)
