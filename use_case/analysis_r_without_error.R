

## Gestion de l'aléatoire pour createDataPartition()
## Vérification de l'existence du fichier
## Ajout de pipes
## Correction du nom de la colonne
## Précision du paquet en amont de la méthode


rm(list=ls())

set.seed(35)

library(dplyr)
library(caret)
# library(readr)

## Reading

path_parisian_apartment <- file.path("/home","nb","Documents","rstudio_stuffs","parisian_apartments.csv")    
if(file.exists(path_parisian_apartment))
  df <- read.csv(path_parisian_apartment)

# df <- readr::read_csv(path_parisian_apartment,col_select="AREA_SQUARE_METER")


## Processing
                                 
est_appartement_etudiant <- df$AREA<40
df_clean <- rename(df,PRICE=PRICE_EURO,AREA=AREA_SQUARE_METER) |> 
    filter(!est_appartement_etudiant) |>
    select(AREA, PRICE, QUICKLY_SOLD) |>
    mutate(MEAN_PRICE = scale(PRICE))                


## Training

df_clean$QUICKLY_SOLD <- as.factor(df_clean$QUICKLY_SOLD)

df_clean$PRICE_Z <- df_clean$PRICE - df_clean["MEAN_PRICE"]

idx <- caret::createDataPartition(df_clean$QUICKLY_SOLD, p = 0.8, list = FALSE)

train_data <- df_clean[idx, ]

test_data <- df_clean[-idx, ]

model <- caret::train(QUICKLY_SOLD ~ ., data = train_data, method = "glm")


## Prediction

prediction <- stats::predict(model,newdata=test_data)

print(model)
