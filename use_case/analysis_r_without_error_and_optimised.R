

## Utilisation de data.table


rm(list=ls())

source("generate_csv_tables.R")

set.seed(35)

library(caret)
library(data.table)

generate_table_with_many_lines()


## Reading

path_parisian_apartment <- file.path("data","LOT_OF_parisian_apartments.csv")    
if(file.exists(path_parisian_apartment))
  df_extract <- data.table::fread(
    path_parisian_apartment,
    select=c("QUICKLY_SOLD","AREA_SQUARE_METER","PRICE_EURO"),
    nrow=1000
  )



## Processing

df_extract_clean <- copy(df_extract)
     
setnames(df_extract_clean, c("AREA_SQUARE_METER", "PRICE_EURO"), c("AREA","PRICE"))                     

est_appartement_etudiant <- df_extract_clean$AREA>=40
  
df_extract_clean <- df_extract_clean[
  est_appartement_etudiant == TRUE
][
  ,MEAN_PRICE := scale(PRICE)
]
               


## Training

### ...
