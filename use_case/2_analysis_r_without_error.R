

######################### DO NOT MODIFY ########################################
################################################################################

rm(list=ls())

source("tools/function_generate_table_with_many_lines.R")

library(caret)
library(dplyr)

table_to_analysis <- "LOT_OF_parisian_apartments.csv"

generate_table_with_many_lines(
  number_lines=5000000,
  name_writed_file=table_to_analysis
)

################################################################################
################################################################################

set.seed(35)

## Reading

path_parisian_apartment <- file.path("data",table_to_analysis)
if(file.exists(path_parisian_apartment))
  df_full <- read.csv(path_parisian_apartment)

df_extract <- df_full |> slice(1:1000)


## Processing
                                 
est_appartement_etudiant <- df_extract$AREA<40

df_extract_clean <- df_extract |> 
  rename(PRICE=PRICE_EURO,AREA=AREA_SQUARE_METER) |> 
  filter(!est_appartement_etudiant) |>
  select(AREA, PRICE, QUICKLY_SOLD) |>
  mutate(MEAN_PRICE = scale(PRICE)) |>
  mutate(QUICKLY_SOLD = as.factor(QUICKLY_SOLD)) |>
  mutate(PRICE_Z = PRICE - MEAN_PRICE)


## Training

idx <- caret::createDataPartition(df_extract_clean$QUICKLY_SOLD, p = 0.8, list = FALSE)

train_data <- df_extract_clean[idx, ]

test_data <- df_extract_clean[-idx, ]

model <- caret::train(QUICKLY_SOLD ~ ., data = train_data, method = "glm")


## Prediction

prediction <- stats::predict(model,newdata=test_data)

print(model)

