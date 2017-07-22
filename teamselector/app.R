# Shiny app for generating the teams to review and be revewed by in the Geoscripting course.
# Licensed under CC0: https://creativecommons.org/publicdomain/zero/1.0/

library(shiny)

## UPDATE THE TEAM NAMES TO REAL ONES!
TeamNames = c("Adolph", "Bob", "Christie", "Doug", "Elayne", "Fritz", "Gunther", "Heinrich", "Indre", "Joachim",
"Konrad", "Leonardo", "Maria", "Nigel", "Okuda", "Peter", "Quinn", "Raul", "Steve", "Tricia", "Ursula",
"Victoria", "Winston", "Xiaomi", "Yorrick", "Zoe")
## UPDATE THE YEAR!
Year = 2018
Seed = 0xfedbeef

names(TeamNames) = TeamNames
OldNames = TeamNames
i = length(TeamNames)
if (i %% 2 != 0)
    stop("Number of teams must be even! Add pseudo-team 'Staff' to fix.")

server = function(input, output)
{
  output$YourTeam = renderText({
    if (input$Assignment == 10)
        "This assignment is on DataCamp, which does the reviewing for you, so you don't have to review anyone!"
    else
    {
        set.seed(input$Assignment+Year+Seed)
        # Sattolo's algorithm
        while (i > 1)
        {
            j = as.integer(runif(1, 1, i)) # as.integer is equivalent to floor
            formeri = TeamNames[i]
            TeamNames[i] = TeamNames[j]
            TeamNames[j] = formeri
            i = i-1
        }
        if (any(TeamNames == OldNames))
            stop("A team has been assigned to review itself!")
    
        paste0("For assignment ", input$Assignment, ", your team (", input$MyTeam, ") should review ", TeamNames[[input$MyTeam]],
            " and you will be reviewed by ", names(TeamNames)[TeamNames==input$MyTeam], ".")
    }
  })
}

ui = fluidPage(
  titlePanel("Geoscripting review team generator"),

  sidebarLayout(
    sidebarPanel(
      helpText("This Shiny app tells you which team's code you should review for each assignment. The project is considered to be the final assignment on the list."),
      sliderInput("Assignment",
        "Assignment number:",
        min = 3,
        max = 15,
        value = 3),
      selectInput("MyTeam", 
        label = "Your team name",
        choices = TeamNames)
    ),

    mainPanel(
      textOutput("YourTeam")
    )
  )
)

shinyApp(ui = ui, server = server)
