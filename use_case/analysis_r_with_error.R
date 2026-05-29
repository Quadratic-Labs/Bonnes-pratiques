
rm(list=ls())

source("generate_csv_tables.R")

library(dplyr)
library(caret)

generate_table_with_many_lines()


## Reading

df_full <- read.csv("data/LOT_OF_parisian_apartments.csv")
df_extract <- slice(df_full,1:1000)

## Processing



df_extract_clean <- rename(df_extract,PRICE=PRICE_EURO,AREA=AREA_SQUARE_METER)

# On retire les appartements etudiants   
df_extract_clean <- filter(df_extract_clean, AREA >= 40)                                  

df_extract_clean <- select(df_extract_clean, AREA, PRICE, QUICKLY_SOLD)              

df_extract_clean <- mutate(df_extract_clean, MEAN_PRICE = scale(PRICE))


## Training

df_extract_clean$QUICKLY_SOLD <- as.factor(df_extract_clean$QUICKLY_SOLD)

df_extract_clean$PRICE_Z <- df_extract_clean$PRICE - df_extract_clean$MEAN_PRIC

idx <- createDataPartition(df_extract_clean$QUICKLY_SOLD, p = 0.8, list = FALSE)

train_data <- df_extract_clean[idx, ]

test_data <- df_extract_clean[-idx, ]

model <- train(QUICKLY_SOLD ~ ., data = train_data, method = "glm")


## Prediction

prediction <- predict(model,newdata=test_data)

print(model)

