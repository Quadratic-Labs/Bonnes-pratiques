
rm(list=ls())

generate_table_with_many_lines <- function(){
  if(file.exists(file.path("data","LOT_OF_parisian_apartments.csv")))
    return(NULL)
    
  df <- read.csv(file.path("data","parisian_apartments.csv"))
  df_final <- read.csv(file.path("data","parisian_apartments.csv"))
  while(nrow(df_final)<5000000){
    df_final <- rbind(df_final,df)
  }
  write.csv(df_final,file.path("data","LOT_OF_parisian_apartments.csv"))
  
  return(NULL)
}

