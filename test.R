library(sqldf)
  tmp <- read.table( grade_report.csv)
  sqldf("INSERT INTO mytable SELECT * FROM tmp;", dbname = "mydb.sqlite", drv = "SQLite")
