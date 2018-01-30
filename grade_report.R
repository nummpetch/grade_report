library(sqldf)
library(DBI)
read_file <- function(name_file){
  rawdata <- read.csv(file=name_file,header = TRUE) 
  return (list(term=rawdata[,1],name=rawdata[,2],credit=rawdata[,3],grade=rawdata[,4],point=rawdata[,5]))
}

create_db <- function (){
  dbSendQuery(conn = db,
              'CREATE TABLE grade
              (term INTEGER,
              name TEXT,
              credit INTEGER,
              grade FLOAT,
              point FLOAT)')
}


insert_data <- function (term,name,credit,grade,point){
  tmp<-sprintf("INSERT INTO grade VALUES ( %d , '%s ', %d , %.2f ,%.2f )",term,name,credit,grade,point)
  print(tmp)
  dbSendQuery(conn = db,tmp)
}

show_all_table<-function(){
  dbListTables(db) 
}
show_head_table<-function(table){
  dbListFields(db, table)
}
cal_grade_term<-function(name,term){
  tmp<-sprintf("SELECT sum(credit),sum(point) FROM %s WHERE term == %d",name,term)
  data<-dbGetQuery( db,tmp )
  gpa<-data[,2]/data[,1]

  return(gpa)
  
}
cal_gpa<-function(name){
  tmp<-sprintf("SELECT sum(credit),sum(point) FROM %s",name)
  data<-dbGetQuery( db,tmp )
  gpa<-data[,2]/data[,1]
  return(gpa)
  
}
delete_data_table <-function(name){
  tmp<-sprintf("DELETE FROM %s",name)
  print(tmp)
  dbSendQuery(db = db,tmp)
}
show_data <-function(name){
  tmp<-sprintf("SELECT * FROM %s",name)
  dbGetQuery( db,tmp )
}
number_of_term <-function(name){
  tmp<-sprintf("SELECT MAX(term) FROM %s",name)
  n<-dbGetQuery( db,tmp )
  print(n[,1])
  return(n[,1])
}



table_name <-"grade"
db <- dbConnect(SQLite(), dbname='my_database.db')
dbRemoveTable(con =db, "grade")

create_table()
newdata <-read_file("C:\\Users\\NUMMPETCH\\Desktop\\4term2\\database\\grade_report.csv")
#delete_data_table(table_name)
for (i in 1:length(newdata$term)){
  print(newdata$name[i])
  insert_data(newdata$term[i],newdata$name[i],newdata$credit[i],newdata$grade[i],newdata$point[i])
}
#show_table()
#delete_data_table(table_name)
show_data(table_name)

n_term<-number_of_term(table_name)
for (g in 1:n_term){
  grade_term<-cal_grade_term(table_name,g)
  text_tmp<-sprintf("grade term %d = %.3f",g,grade_term)
  print(text_tmp)
}
gpa<-cal_gpa(table_name)
text_gpa<-sprintf("GPA = %.3f",gpa)
print(text_gpa)
dbDisconnect(con=db)
