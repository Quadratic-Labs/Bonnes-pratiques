

## Gestion de l'aléatoire pour createDataPartition()
## Vérification de l'existence du fichier
## Ajout de pipes
## Correction du nom de la colonne
## Précision du paquet en amont de la méthode


rm(list=ls())

source("generate_csv_tables.R")

set.seed(35)

library(caret)
library(dplyr)

generate_table_with_many_lines()


## Reading

path_parisian_apartment <- file.path("data","LOT_OF_parisian_apartments.csv")
if(file.exists(path_parisian_apartment))
  df_full <- read.csv(path_parisian_apartment)

df_extract <- df_full |> slice(1:1000)


## Processing
                                 
est_appartement_etudiant <- df_extract$AREA<40

df_extract_clean <- df_extract |> 
    rename(PRICE=PRICE_EURO,AREA=AREA_SQUARE_METER) |> 
    filter(!est_appartement_etudiant) |>
    select(AREA, PRICE, QUICKLY_SOLD) |>
    mutate(MEAN_PRICE = scale(PRICE))                


## Training

df_extract_clean$QUICKLY_SOLD <- as.factor(df_extract_clean$QUICKLY_SOLD)

df_extract_clean$PRICE_Z <- df_extract_clean$PRICE - df_extract_clean[["MEAN_PRICE"]]

idx <- caret::createDataPartition(df_extract_clean$QUICKLY_SOLD, p = 0.8, list = FALSE)

train_data <- df_extract_clean[idx, ]

test_data <- df_extract_clean[-idx, ]

model <- caret::train(QUICKLY_SOLD ~ ., data = train_data, method = "glm")


## Prediction

prediction <- stats::predict(model,newdata=test_data)

print(model)
