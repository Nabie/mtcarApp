
#    http://shiny.rstudio.com/
#

library(shiny)
library(datasets)
#This function acte as paste but here it paste the element of a list or vector
paste1 <- function(pred){
    l <- length(pred)
    if(l==0){ 
        p <- character(0)
        }else if(l==1){
            p <- pred
        } else{
            p <- pred[1]
            for(i in 2:l){
            p <- paste(p, pred[i], sep = "+") 
            }
            p   
                
    }
    
}


mt <- mtcars
# server function

shinyServer(function(input, output, session) {
   
    ##.........tabpane exploratory...................
    # displaying the dataset mtcars
    showP <- reactive({
        req(input$col)
        mt[1:input$num, input$col]
    })
    
    output$data <- renderTable(showP())
    
    # creating factor variable
    
     
    for(i in 1:11){
        if(length(unique(mtcars[, i]))<=6){
            mtcars[i] <- as.factor(mtcars[, i])
        }
    }

    # First structure and summary
    str2 <- reactive({
        if(input$str1){
            str(mt)
        }
    })
    
    summ <- reactive({
        if(input$sm){
            summary(mt)
        }
    })
    
    output$count <- renderPrint(str2())  
    output$smry <- renderPrint(summ())
    
    uniq <- reactive({
        if(input$unique){
            sapply(mt, function(x) length(unique(x)))
        }
    })
    output$unique_value <- renderPrint(uniq())
    
    # computation
    str3 <- reactive({
        if(input$strA){
            str(mtcars)
        }
    })
    
    summA <- reactive({
        if(input$smA){
            summary(mtcars)
        }
    })
    
    output$countA <- renderPrint(str3())  
    output$smryA <- renderPrint(summA())
    
    cr <- reactive(cor(mtcars[c(1, 3:7)]))
    output$McorA <- renderPrint(cr())
    
    # Graphic section
    gr <- reactive({
        req(input$graph)
        plot( mtcars[, input$graph])
         
        })
    
    output$graph1 <- renderPlot(gr())
    
    # ..................tabpanel Regression........................
    observe({
        updateSelectInput(session, "feat",
                          choices = setdiff(names(mtcars), input$resp),
                          selected = "am"
        )
        })
        
    observe({
        updateCheckboxGroupInput(session, "center",
                choices = setdiff(input$feat, names(mtcars)[c(2, 8:11)]),
                 selected = "am"
        )
    })
    
    #Model construction
        
    model <- reactive({
       
        req(input$feat)
            a <-  match(input$center, input$feat)
            y <- input$feat
            for(i in a){
                y[i] <- paste0("I(",input$feat[i],"-","mean(",input$feat[i],"))")
            } 
          frml <- as.formula(paste(input$resp, "~", paste1(y), sep = ""))
       lm( frml, data = mtcars)  

     })
    
   output$form <- renderPrint({
       a <-  match(input$center, input$feat)
       y <- input$feat
       for(i in a){
           y[i] <- paste0("I(",input$feat[i],"-","mean(",input$feat[i],"))")
       }
        frml <- paste(input$resp, "~", paste1(y), sep = "")
        return(paste0("frml = ", frml))
        
    })
    
   
    output$summary <- renderPrint(summary(model()))
    
    plot1 <- reactive({
        #layout(matrix(1:4, 2,2)) 
        par(mfrow = c(2,2))
        plot(model())})
    
    
       output$plot <- renderPlot(
        plot1())
    
      
  })
  
