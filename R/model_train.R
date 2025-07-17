
# 1. Load packages
library(caret)
library(pROC)
library(readr)

# 2. Read features and convert label to factor for classification
features <- read_csv("data/features.csv")
features$label <- factor(features$label,
                         levels = c(0, 1),
                         labels = c("ham", "spam"))

# 3. Split into training (80%) and test (20%)
set.seed(123)
train_idx <- createDataPartition(features$label, p = 0.8, list = FALSE)
train_df  <- features[train_idx, ]
test_df   <- features[-train_idx, ]

# 4. Set up trainControl to compute class probabilities
ctrl <- trainControl(method = "none",
                     classProbs = TRUE)

# 5. Train a logistic regression model
#    Use all feature columns except 'id' and 'label'
model <- train(
  label ~ . - id,
  data    = train_df,
  method  = "glm",
  family  = binomial(),
  trControl = ctrl
)

# 6. Print model summary
print(model)

# 7. Predict probabilities on the test set
probs <- predict(model, test_df, type = "prob")[, "spam"]
preds <- ifelse(probs > 0.5, "spam", "ham")

# 8. Evaluate performance with a confusion matrix
conf_matrix <- confusionMatrix(
  factor(preds, levels = c("ham", "spam")),
  test_df$label,
  positive = "spam"
)
print(conf_matrix)

# 9. Compute ROC curve and AUC
roc_obj  <- roc(response = test_df$label, predictor = probs,
                levels = c("ham", "spam"))
auc_val  <- auc(roc_obj)
cat("Test ROC AUC:", round(auc_val, 3), "\n")

# 10. Save the trained model
saveRDS(model, file = "data/logistic_model.rds")
