

library(shiny)

shinyUI(fluidPage(
 
  # Application title
  titlePanel("Analysis of mtcars dataset"),
  
  sidebarLayout(
    sidebarPanel(
        conditionalPanel(condition = "input.tabset == 'Exploratory'",
                code("If you activate all chechboxes, you should need
                 to scroll too much. So activate some and diactivate others"),
                hr(),
                h4("Showing mtcars dataset:"),
                tags$ol("There are 3 widgets:",
                    tags$li("check to display the data"),
                    tags$li("select the number of row and"),
                    tags$li("select variables to display")),
                checkboxInput("dispD", "display data"),
                sliderInput("num", "number of row", 1, 32, 10, 1),
                selectInput("col", "variables to display", choices = 
                     names(mtcars), selected = "mpg", multiple = TRUE),
                hr(),
                h4("First summary"),
                helpText("check the result you want to see"),
                checkboxInput("str1", "structure"),
                checkboxInput("sm", "summary"),
                checkboxInput("unique", "number of uniques values"),
                 hr(),
                h4("Second summary:"),
                helpText("Variables with length of unique values less or equal
                         to 6 is transforme to factor variables"),
                helpText("check the result you want to see"),
                checkboxInput("strA", "structure"),
                checkboxInput("smA", "summary"),
                checkboxInput("corA", "correlation of continuous variables"),
                hr(),
                h4("Plotting section"),
                helpText("check to show the plot and then select all variable
                         you want to see"),
                code("Relationship between continuous and factor variable can be
                     shown by selecting only two variables and factor first. This 
                     shows boxplot"),
                checkboxInput("dgraph", "display plot"),
                selectInput("graph", "select variables", choices = names(mtcars),
                            selected = "mpg", multiple = TRUE)
             ),
        
        conditionalPanel(condition = "input.tabset == 'Regression'",
            code("You can specify any continuous variable as response and all 
                 others as predictor. The formula and the result are shown in
                 the main panel. Eg: mpg~am+wt+qsec. You can center the 
                 continuous variable"),
            hr(),
            helpText("In this tab there are 4 widgets to deal with regression :"),
            tags$ol(
            tags$li("select the variable of interest"),
            tags$li("select the predictors"),
            tags$li("you can center the continuous predictor. Checkbox appears
                    only if continuous variable is selected"),
            tags$li("display the diagnostic plots")),
            br(),
            selectInput("resp", "Response variable : ",
                    choices = names(mtcars)[c(1, 3:7)],
                    selected = "mpg"),
            selectInput("feat", "predictors variable : ",
                    choices = names(mtcars),
                    selected = "hp", multiple = TRUE),
        
            checkboxGroupInput("center", "center the predictor :",
                           choices = names(mtcars)[c(1, 3:7)]),
        
            radioButtons("display", "display regression diagnostic graphics:", 
                 choices = c("yes"="y", "no"="n"), selected = "n")
        
        )
    ),
    

    mainPanel(
        tabsetPanel(id = "tabset",
            tabPanel("Exploratory", #value = 1,
                 conditionalPanel(condition = "input.dispD ==true",    
                     tableOutput("data")),
                conditionalPanel(condition = "input.str1 ==true",
                    verbatimTextOutput("count")),
               
                conditionalPanel(condition = "input.sm == true",
                    verbatimTextOutput("smry")),
                conditionalPanel(condition = "input.unique ==true",
                    verbatimTextOutput("unique_value")),
                    br(), 
                conditionalPanel(condition = "input.strA ==true",
                    verbatimTextOutput("countA")),
                conditionalPanel(condition = "input.smA ==true",
                    verbatimTextOutput("smryA")),
                conditionalPanel(condition = "input.corA ==true",  
                    verbatimTextOutput("McorA")),
               conditionalPanel(condition = "input.dgraph ==true",
                    plotOutput("graph1", height = 600))
             
            ),
            
            tabPanel("Regression", #value = 2,
                h2("Result of the model"),
      
                verbatimTextOutput("form"),
      
                verbatimTextOutput("summary"),
                h3("Diagnostic"),
                conditionalPanel(condition = "input.display =='y'",
                    plotOutput("plot", height = 500) 
                )
            )
        )
    )  
   )
  )
)
