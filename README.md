# Sixty-seconds Summary

Create Big Files (~9gb) From R
=====

Run time: 90 minutes

```r
    nc <- 1e3 # one thousand
    nr <- 5e6 # five million
    header <- paste(c('"id"', sprintf('"x%s"', seq(nc))),
                    collapse=",")
    for(fid in c('A','B','C')) {
        fh <- file(sprintf("bigfile%s.csv", fid), "w")
        writeLines(header, fh)
        ids <- sample(nr)
        for(id in ids) {
            line <- paste(c(sprintf('"%s%s"', id, fid), 
                            sample(0:1, nc, replace=TRUE)),
                        collapse=",")
            writeLines(line, fh)
        }
        close(fh)
    }
```

Load Data into SQLite
=====

My database name is `mydata.db`

Run time: 1 hour

```sqlite
    .mode csv
    .import bigfileA.csv mytbl
    .import bigfileB.csv mytbl
    .import bigfileC.csv mytbl
    CREATE INDEX ixid ON mytbl (id);
    DELETE FROM mytbl WHERE id='id';
```

Query Data From R
=====

Run time: < 1 second

```r
    library(RSQLite)
    con <- dbConnect(RSQLite::SQLite(), "mydata.db")
    a <- dbGetQuery(con, "SELECT id, x1, x2, x1000 FROM mytbl
        WHERE id IN ('1234B','4321A','3388C')")
    dbDisconnect(con)
```

Try a Shiny Example
=====

```r
    library(shiny)
    shiny::runApp()
```
