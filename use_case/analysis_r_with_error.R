
rm(list=ls())

library(dplyr)
library(caret)

## Reading

df <- read.csv("parisian_apartments.csv")


## Processing

# On retire les appartements etudiants    

df_clean <- rename(df,PRICE=PRICE_EURO,AREA=AREA_SQUARE_METER)

df_clean <- filter(df_clean, AREA >= 40)                                  

df_clean <- select(df_clean, AREA, PRICE, QUICKLY_SOLD)              

df_clean <- mutate(df_clean, MEAN_PRICE = scale(PRICE))


## Training

df_clean$QUICKLY_SOLD <- as.factor(df_clean$QUICKLY_SOLD)

df_clean$PRICE_Z <- df_clean$PRICE - df_clean$MEAN_PRIC

idx <- createDataPartition(df_clean$QUICKLY_SOLD, p = 0.8, list = FALSE)

train_data <- df_clean[idx, ]

test_data <- df_clean[-idx, ]

model <- train(QUICKLY_SOLD ~ ., data = train_data, method = "glm")


## Prediction

prediction <- predict(model,newdata=test_data)

print(model)

