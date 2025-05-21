# --------------------------------------------------------
# Load Required Libraries
# --------------------------------------------------------
library(readxl)
library(caret)
library(rpart)
library(randomForest)
library(gbm)
library(e1071)
library(ggplot2)

# --------------------------------------------------------
# Load the Dataset
# --------------------------------------------------------
data <- read_excel("score result (2).xlsx")

# Convert the target variable to factor
data$Coded_score <- as.factor(data$Coded_score)

# --------------------------------------------------------
# Train-Test Split
# --------------------------------------------------------
set.seed(42)
split <- createDataPartition(data$Coded_score, p = 0.8, list = FALSE)
train_data <- data[split, ]
test_data  <- data[-split, ]

# Separate features and labels
X_train <- train_data[, !(names(train_data) %in% "Coded_score")]
y_train <- train_data$Coded_score

X_test <- test_data[, !(names(test_data) %in% "Coded_score")]
y_test <- test_data$Coded_score

# --------------------------------------------------------
# Impute Missing Values with Mean
# --------------------------------------------------------
preproc <- preProcess(X_train, method = "medianImpute")
X_train <- predict(preproc, X_train)
X_test <- predict(preproc, X_test)

# --------------------------------------------------------
# Model Training
# --------------------------------------------------------

# Decision Tree
dt_model <- rpart(Coded_score ~ ., data = train_data, method = "class")

# Random Forest
rf_model <- randomForest(Coded_score ~ ., data = train_data, importance = TRUE)

# Gradient Boosting
gb_model <- gbm(Coded_score ~ ., data = train_data, distribution = "multinomial", n.trees = 100, interaction.depth = 3, shrinkage = 0.1, cv.folds = 5, n.minobsinnode = 10, verbose = FALSE)

# --------------------------------------------------------
# Model Predictions
# --------------------------------------------------------

# Decision Tree
dt_pred <- predict(dt_model, newdata = X_test, type = "class")

# Random Forest
rf_pred <- predict(rf_model, newdata = X_test)

# Gradient Boosting
gb_pred_probs <- predict(gb_model, newdata = X_test, n.trees = gb_model$n.trees, type = "response")
gb_pred <- colnames(gb_pred_probs)[apply(gb_pred_probs, 1, which.max)]
gb_pred <- as.factor(gb_pred)

# --------------------------------------------------------
# Evaluation Metrics
# --------------------------------------------------------

evaluate_model <- function(true, pred) {
  cm <- confusionMatrix(pred, true)
  accuracy <- cm$overall["Accuracy"]
  sensitivity <- mean(cm$byClass[, "Sensitivity"], na.rm = TRUE)
  specificity <- mean(cm$byClass[, "Specificity"], na.rm = TRUE)
  f1 <- mean(cm$byClass[, "F1"], na.rm = TRUE)
  return(c(Accuracy = accuracy, Sensitivity = sensitivity, Specificity = specificity, F1_Score = f1))
}

results <- data.frame(
  t(evaluate_model(y_test, dt_pred)),
  t(evaluate_model(y_test, rf_pred)),
  t(evaluate_model(y_test, gb_pred))
)
colnames(results) <- c("Decision_Tree", "Random_Forest", "Gradient_Boosting")
results <- as.data.frame(t(results))
print("Model Evaluation Results:")
print(results)

# --------------------------------------------------------
# Confusion Matrices
# --------------------------------------------------------

cat("\nConfusion Matrix: Decision Tree\n")
print(confusionMatrix(dt_pred, y_test))

cat("\nConfusion Matrix: Random Forest\n")
print(confusionMatrix(rf_pred, y_test))

cat("\nConfusion Matrix: Gradient Boosting\n")
print(confusionMatrix(gb_pred, y_test))

# --------------------------------------------------------
# Feature Importances
# --------------------------------------------------------

# Decision Tree
dt_importance <- data.frame(Feature = names(dt_model$variable.importance), Importance = dt_model$variable.importance)
ggplot(dt_importance, aes(x = reorder(Feature, Importance), y = Importance)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  coord_flip() +
  ggtitle("Decision Tree Feature Importances") +
  xlab("Features") + ylab("Importance")

# Random Forest
rf_importance <- data.frame(Feature = rownames(rf_model$importance), Importance = rf_model$importance[, "MeanDecreaseGini"])
ggplot(rf_importance, aes(x = reorder(Feature, Importance), y = Importance)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  coord_flip() +
  ggtitle("Random Forest Feature Importances") +
  xlab("Features") + ylab("Importance")

# Gradient Boosting (Relative Influence)
gb_importance <- summary(gb_model, plotit = FALSE)
ggplot(gb_importance, aes(x = reorder(var, rel.inf), y = rel.inf)) +
  geom_bar(stat = "identity", fill = "salmon") +
  coord_flip() +
  ggtitle("Gradient Boosting Feature Importances") +
  xlab("Features") + ylab("Relative Influence")


