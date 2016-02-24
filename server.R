library(shiny)
library(RSQLite)

shinyServer(function(input, output) {
  idl <- reactive({
    fh <- input$fids[1,]
    if(is.null(fh)) {
      return('')
    }
    dat <- scan(fh$datapath, '', sep="\n")
    sprintf("'%s'", paste(dat, collapse="','"))
  })
  dat <- reactive({
    vars <- input$vars
    nr <- length(vars)
    if(nr == 0) {
      x <- NULL
      return(NULL)
    }
    input$fids
    idlist <- idl()
    if(nchar(idlist) == 0) {
      where <- 'LIMIT 5'
    } else {
      where <- sprintf('WHERE id IN (%s)', idlist)
    }
    qry <- sprintf("SELECT id, %s FROM mytbl %s", paste(vars, collapse=","), where)
    con <- dbConnect(RSQLite::SQLite(), "mydata.db")
    x <- dbGetQuery(con, qry)
    dbDisconnect(con)
    x
  })
  output$filename <- renderText({
    input$fids[1,'name']
  })
  output$distPlot <- renderTable({
    x <- dat()
    if(is.null(x)) return(NULL)
    as.data.frame(x)
  })
  output$cnt <- renderTable({
    x <- dat()
    if(is.null(x)) return(NULL)
    t(sapply(x[,-1,drop=FALSE], function(i) table(factor(i, levels=0:1))))
  })

})
