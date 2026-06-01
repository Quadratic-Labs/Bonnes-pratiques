
generate_table_with_many_lines <- function(number_lines,name_writed_file){
  if(file.exists(file.path("data",name_writed_file))){
    warning(paste("Table",name_writed_file,"already exists.",sep=" "))
    return(NULL)
  }
    
    
  df <- read.csv(file.path("data","parisian_apartments.csv"))
  df_final <- read.csv(file.path("data","parisian_apartments.csv"))
  while(nrow(df_final)<number_lines){
    df_final <- rbind(df_final,df)
  }
  write.csv(df_final,file.path("data",name_writed_file))
  
  return(NULL)
}

