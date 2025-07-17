# R/visualize.R

# Load required libraries
library(ggplot2)
library(pROC)
library(caret)
library(readr)

# 1. Load the trained model and feature data
model    <- readRDS("data/logistic_model.rds")
features <- read_csv("data/features.csv")

# Recode numeric label into a two‐level factor for classification
features$label <- factor(
  features$label,
  levels = c(0, 1),
  labels = c("ham", "spam")
)

# 2. Recreate the train/test split to isolate the test set
set.seed(123)
test_idx <- createDataPartition(features$label, p = 0.8, list = FALSE)
test_df  <- features[-test_idx, ]

# 3. Predict class probabilities for the test set
probs <- predict(model, test_df, type = "prob")[, "spam"]
preds <- ifelse(probs > 0.5, "spam", "ham")

# 4. Build ROC curve data
roc_obj <- roc(
  response  = test_df$label,
  predictor = probs,
  levels    = c("ham", "spam")
)
roc_df <- data.frame(
  FPR = 1 - roc_obj$specificities,
  TPR = roc_obj$sensitivities
)

# 5. Plot the ROC curve
roc_plot <- ggplot(roc_df, aes(x = FPR, y = TPR)) +
  geom_line(size = 1) +
  geom_abline(linetype = "dashed") +
  labs(
    title = "ROC Curve for Phishing Email Classifier",
    x     = "False Positive Rate",
    y     = "True Positive Rate"
  )

# 6. Compute confusion matrix data frame
conf_mat <- confusionMatrix(
  factor(preds, levels = c("ham", "spam")),
  test_df$label,
  positive = "spam"
)
cm_df <- as.data.frame(conf_mat$table)

# 7. Plot the confusion matrix as a heatmap
cm_plot <- ggplot(cm_df, aes(x = Reference, y = Prediction, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), color = "white", size = 6) +
  labs(
    title = "Confusion Matrix",
    x     = "Actual Label",
    y     = "Predicted Label"
  ) +
  scale_fill_continuous()

# 8. Display and save the plots
print(roc_plot)
print(cm_plot)

ggsave("roc_curve.png",        plot = roc_plot, width = 6, height = 5)
ggsave("confusion_matrix.png", plot = cm_plot,  width = 5, height = 5)
