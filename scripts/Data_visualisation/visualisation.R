##R data visualisation
#R script used for generating Data visualisations and analysis for MAGGImpute workflow
library(dplyr)
library(ggplot2)
library(reshape2)
library(gridExtra)
library(readr)

##Path to Run1:
matrix_imputed_1 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/before_imputation/Final_updated_node_matrice.csv")
matrix_imputed_2 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/CF_SVD_1.csv")
matrix_imputed_3 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/BR_mags.csv")
matrix_imputed_4 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/DTR_mags.csv")
matrix_imputed_5 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/ETR_mags.csv")
matrix_imputed_6 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/KNR_mags.csv")
matrix_imputed_7 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/SI_mags.csv")
matrix_imputed_8 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation//KNN_mags.csv")
 
matrix_ref <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/ground_truth/Final_updated_node_matrice.csv")

 
calculate_metrics <- function(matrix_ref, matrix_imputed) {
  TP <- sum(matrix_ref == 1 & matrix_imputed == 1)
  TN <- sum(matrix_ref == 0 & matrix_imputed == 0)
  FP <- sum(matrix_ref == 0 & matrix_imputed == 1)
  FN <- sum(matrix_ref == 1 & matrix_imputed == 0)
  
  accuracy <- (TP + TN) / (TP + TN + FP + FN)
  precision <- TP / (TP + FP)
  recall <- TP / (TP + FN)
  f1_score <- 2 * (precision * recall) / (precision + recall)
  
  sensitivity <- recall
  specificity <- TN / (TN + FP)
  
  return(list(accuracy = accuracy,
              precision = precision,
              f1_score = f1_score,
              sensitivity = sensitivity,
              specificity = specificity))
}
 
metrics_1 <- calculate_metrics(matrix_ref, matrix_imputed_1)
metrics_2 <- calculate_metrics(matrix_ref, matrix_imputed_2)
metrics_3 <- calculate_metrics(matrix_ref, matrix_imputed_3)
metrics_4 <- calculate_metrics(matrix_ref, matrix_imputed_4)
metrics_5 <- calculate_metrics(matrix_ref, matrix_imputed_5)
metrics_6 <- calculate_metrics(matrix_ref, matrix_imputed_6)
metrics_7 <- calculate_metrics(matrix_ref, matrix_imputed_7)
metrics_8 <- calculate_metrics(matrix_ref, matrix_imputed_8)
 
methods <- c("MAGs Before Imputation","Matrix factorization",  "BayesianRidge", "DecisionTreeRegressor", "ExtraTreesRegressor", "KNeighborsRegressor", "Simple Imputer", "K-Nearest Neighbor")
metrics_df <- data.frame(Method = methods,
                         Accuracy = c(metrics_1$accuracy, metrics_2$accuracy, metrics_3$accuracy, metrics_4$accuracy, metrics_5$accuracy, metrics_6$accuracy, metrics_7$accuracy, metrics_8$accuracy),
                         Precision = c(metrics_1$precision, metrics_2$precision, metrics_3$precision, metrics_4$precision, metrics_5$precision, metrics_6$precision, metrics_7$precision, metrics_8$precision),
                         F1_Score = c(metrics_1$f1_score, metrics_2$f1_score, metrics_3$f1_score, metrics_4$f1_score, metrics_5$f1_score, metrics_6$f1_score, metrics_7$f1_score, metrics_8$f1_score),
                         Sensitivity = c(metrics_1$sensitivity, metrics_2$sensitivity, metrics_3$sensitivity, metrics_4$sensitivity, metrics_5$sensitivity, metrics_6$sensitivity, metrics_7$sensitivity, metrics_8$sensitivity),
                         Specificity = c(metrics_1$specificity, metrics_2$specificity, metrics_3$specificity, metrics_4$specificity, metrics_5$specificity, metrics_6$specificity, metrics_7$specificity, metrics_8$specificity))

 
 
accuracy_plot <- ggplot(metrics_df, aes(x = Method, y = Accuracy)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Accuracy", x = "Method", y = "Accuracy")

 
precision_plot <- ggplot(metrics_df, aes(x = Method, y = Precision)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  labs(title = "Precision", x = "Method", y = "Precision")

 
f1_score_plot <- ggplot(metrics_df, aes(x = Method, y = F1_Score)) +
  geom_bar(stat = "identity", fill = "lightpink") +
  labs(title = "F1-Score", x = "Method", y = "F1-Score")

 
sensitivity_plot <- ggplot(metrics_df, aes(x = Method, y = Sensitivity)) +
  geom_bar(stat = "identity", fill = "lightyellow") +
  labs(title = "Sensitivity", x = "Method", y = "Sensitivity")

 
specificity_plot <- ggplot(metrics_df, aes(x = Method, y = Specificity)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  labs(title = "Specificity", x = "Method", y = "Specificity")
 
print(accuracy_plot)
print(precision_plot)
print(f1_score_plot)
print(sensitivity_plot)
print(specificity_plot)





###############Run 2 

 
matrix_imputed_1_2 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/before_imputation/Final_updated_node_matrice.csv")
matrix_imputed_2_2 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/CF_SVD_1.csv")
matrix_imputed_3_2 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/BR_mags.csv")
matrix_imputed_4_2 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/DTR_mags.csv")
matrix_imputed_5_2 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/ETR_mags.csv")
matrix_imputed_6_2 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/KNR_mags.csv")
matrix_imputed_7_2 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/SI_mags.csv")
matrix_imputed_8_2 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation//KNN_mags.csv")

 
matrix_ref_2 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/ground_truth/Final_updated_node_matrice.csv")

 
metrics_1_2 <- calculate_metrics(matrix_ref_2, matrix_imputed_1_2)
metrics_2_2 <- calculate_metrics(matrix_ref_2, matrix_imputed_2_2)
metrics_3_2 <- calculate_metrics(matrix_ref_2, matrix_imputed_3_2)
metrics_4_2 <- calculate_metrics(matrix_ref_2, matrix_imputed_4_2)
metrics_5_2 <- calculate_metrics(matrix_ref_2, matrix_imputed_5_2)
metrics_6_2 <- calculate_metrics(matrix_ref_2, matrix_imputed_6_2)
metrics_7_2 <- calculate_metrics(matrix_ref_2, matrix_imputed_7_2)
metrics_8_2 <- calculate_metrics(matrix_ref_2, matrix_imputed_8_2)
 
methods <- c("MAGs before imputation","Matrix factorization", "BayesianRidge", "DecisionTreeRegressor", "ExtraTreesRegressor", "KNeighborsRegressor", "Simple Imputer", "K-Nearest Neighbor")
metrics_df_2 <- data.frame(Method = methods,
                           Accuracy = c(metrics_1_2$accuracy, metrics_2_2$accuracy, metrics_3_2$accuracy, metrics_4_2$accuracy, metrics_5_2$accuracy, metrics_6_2$accuracy, metrics_7_2$accuracy, metrics_8_2$accuracy),
                           Precision = c(metrics_1_2$precision, metrics_2_2$precision, metrics_3_2$precision, metrics_4_2$precision, metrics_5_2$precision, metrics_6_2$precision, metrics_7_2$precision, metrics_8_2$precision),
                           F1_Score = c(metrics_1_2$f1_score, metrics_2_2$f1_score, metrics_3_2$f1_score, metrics_4_2$f1_score, metrics_5_2$f1_score, metrics_6_2$f1_score, metrics_7_2$f1_score, metrics_8_2$f1_score),
                           Sensitivity = c(metrics_1_2$sensitivity, metrics_2_2$sensitivity, metrics_3_2$sensitivity, metrics_4_2$sensitivity, metrics_5_2$sensitivity, metrics_6_2$sensitivity, metrics_7_2$sensitivity, metrics_8_2$sensitivity),
                           Specificity = c(metrics_1_2$specificity, metrics_2_2$specificity, metrics_3_2$specificity, metrics_4_2$specificity, metrics_5_2$specificity, metrics_6_2$specificity, metrics_7_2$specificity, metrics_8_2$specificity))
 
 
accuracy_plot <- ggplot(metrics_df_2, aes(x = Method, y = Accuracy)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Accuracy", x = "Method", y = "Accuracy")

 
precision_plot <- ggplot(metrics_df_2, aes(x = Method, y = Precision)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  labs(title = "Precision", x = "Method", y = "Precision")

 
f1_score_plot <- ggplot(metrics_df_2, aes(x = Method, y = F1_Score)) +
  geom_bar(stat = "identity", fill = "lightpink") +
  labs(title = "F1-Score", x = "Method", y = "F1-Score")


sensitivity_plot <- ggplot(metrics_df_2, aes(x = Method, y = Sensitivity)) +
  geom_bar(stat = "identity", fill = "lightyellow") +
  labs(title = "Sensitivity", x = "Method", y = "Sensitivity")


specificity_plot <- ggplot(metrics_df_2, aes(x = Method, y = Specificity)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  labs(title = "Specificity", x = "Method", y = "Specificity")


print(accuracy_plot)
print(precision_plot)
print(f1_score_plot)
print(sensitivity_plot)
print(specificity_plot)






#############Run 3 : same


matrix_imputed_1_3 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/before_imputation/Final_updated_node_matrice.csv")
matrix_imputed_2_3 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/CF_SVD_1.csv")
matrix_imputed_3_3 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/BR_mags.csv")
matrix_imputed_4_3 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/DTR_mags.csv")
matrix_imputed_5_3 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/ETR_mags.csv")
matrix_imputed_6_3 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/KNR_mags.csv")
matrix_imputed_7_3 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/SI_mags.csv")
matrix_imputed_8_3 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation//KNN_mags.csv")

matrix_ref_3 <- read.csv( "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/ground_truth/Final_updated_node_matrice.csv")



metrics_1_3 <- calculate_metrics(matrix_ref_3, matrix_imputed_1_3)
metrics_2_3 <- calculate_metrics(matrix_ref_3, matrix_imputed_2_3)
metrics_3_3 <- calculate_metrics(matrix_ref_3, matrix_imputed_3_3)
metrics_4_3 <- calculate_metrics(matrix_ref_3, matrix_imputed_4_3)
metrics_5_3 <- calculate_metrics(matrix_ref_3, matrix_imputed_5_3)
metrics_6_3 <- calculate_metrics(matrix_ref_3, matrix_imputed_6_3)
metrics_7_3 <- calculate_metrics(matrix_ref_3, matrix_imputed_7_3)
metrics_8_3 <- calculate_metrics(matrix_ref_3, matrix_imputed_8_3)


methods <- c( "MAGs before imputation", "Matrix factorization","BayesianRidge", "DecisionTreeRegressor", "ExtraTreesRegressor", "KNeighborsRegressor", "Simple Imputer", "K-Nearest Neighbor")
metrics_df_3 <- data.frame(Method = methods,
                           Accuracy = c(metrics_1_3$accuracy, metrics_2_3$accuracy, metrics_3_3$accuracy, metrics_4_3$accuracy, metrics_5_3$accuracy, metrics_6_3$accuracy, metrics_7_3$accuracy, metrics_8_3$accuracy),
                           Precision = c(metrics_1_3$precision, metrics_2_3$precision, metrics_3_3$precision, metrics_4_3$precision, metrics_5_3$precision, metrics_6_3$precision, metrics_7_3$precision, metrics_8_3$precision),
                           F1_Score = c(metrics_1_3$f1_score, metrics_2_3$f1_score, metrics_3_3$f1_score, metrics_4_3$f1_score, metrics_5_3$f1_score, metrics_6_3$f1_score, metrics_7_3$f1_score, metrics_8_3$f1_score),
                           Sensitivity = c(metrics_1_3$sensitivity, metrics_2_3$sensitivity, metrics_3_3$sensitivity, metrics_4_3$sensitivity, metrics_5_3$sensitivity, metrics_6_3$sensitivity, metrics_7_3$sensitivity, metrics_8_3$sensitivity),
                           Specificity = c(metrics_1_3$specificity, metrics_2_3$specificity, metrics_3_3$specificity, metrics_4_3$specificity, metrics_5_3$specificity, metrics_6_3$specificity, metrics_7_3$specificity, metrics_8_3$specificity))



accuracy_plot <- ggplot(metrics_df_3, aes(x = Method, y = Accuracy)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(title = "Accuracy", x = "Method", y = "Accuracy")


precision_plot <- ggplot(metrics_df_3, aes(x = Method, y = Precision)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  labs(title = "Precision", x = "Method", y = "Precision")


f1_score_plot <- ggplot(metrics_df_3, aes(x = Method, y = F1_Score)) +
  geom_bar(stat = "identity", fill = "lightpink") +
  labs(title = "F1-Score", x = "Method", y = "F1-Score")

sensitivity_plot <- ggplot(metrics_df_3, aes(x = Method, y = Sensitivity)) +
  geom_bar(stat = "identity", fill = "lightyellow") +
  labs(title = "Sensitivity", x = "Method", y = "Sensitivity")


specificity_plot <- ggplot(metrics_df_3, aes(x = Method, y = Specificity)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  labs(title = "Specificity", x = "Method", y = "Specificity")


print(accuracy_plot)
print(precision_plot)
print(f1_score_plot)
print(sensitivity_plot)
print(specificity_plot)


ggsave("accuracy_plot.svg", accuracy_plot, width = 12, height = 18)
ggsave("precision_plot.svg", precision_plot, width = 12, height = 18)
ggsave("f1_score_plot.svg", f1_score_plot, width = 12, height = 18)
ggsave("sensitivity_plott.svg", sensitivity_plot, width = 12, height = 18)
ggsave("specificity_plot.svg", specificity_plot, width = 12, height = 18)






methods <- c("MAGs before imputation","Matrix factorization",  "BayesianRidge", "DecisionTreeRegressor", "ExtraTreesRegressor", "KNeighborsRegressor", "Simple Imputer", "K-Nearest Neighbor")

metrics_df <- data.frame(Method = methods,
                         Accuracy = c(metrics_1$accuracy, metrics_2$accuracy, metrics_3$accuracy, metrics_4$accuracy, metrics_5$accuracy, metrics_6$accuracy, metrics_7$accuracy, metrics_8$accuracy),
                         Precision = c(metrics_1$precision, metrics_2$precision, metrics_3$precision, metrics_4$precision, metrics_5$precision, metrics_6$precision, metrics_7$precision, metrics_8$precision),
                         F1_Score = c(metrics_1$f1_score, metrics_2$f1_score, metrics_3$f1_score, metrics_4$f1_score, metrics_5$f1_score, metrics_6$f1_score, metrics_7$f1_score, metrics_8$f1_score),
                         Sensitivity = c(metrics_1$sensitivity, metrics_2$sensitivity, metrics_3$sensitivity, metrics_4$sensitivity, metrics_5$sensitivity, metrics_6$sensitivity, metrics_7$sensitivity, metrics_8$sensitivity),
                         Specificity = c(metrics_1$specificity, metrics_2$specificity, metrics_3$specificity, metrics_4$specificity, metrics_5$specificity, metrics_6$specificity, metrics_7$specificity, metrics_8$specificity))

metrics_df_2 <- data.frame(Method = methods,
                           Accuracy = c(metrics_1_2$accuracy, metrics_2_2$accuracy, metrics_3_2$accuracy, metrics_4_2$accuracy, metrics_5_2$accuracy, metrics_6_2$accuracy, metrics_7_2$accuracy, metrics_8_2$accuracy),
                           Precision = c(metrics_1_2$precision, metrics_2_2$precision, metrics_3_2$precision, metrics_4_2$precision, metrics_5_2$precision, metrics_6_2$precision, metrics_7_2$precision, metrics_8_2$precision),
                           F1_Score = c(metrics_1_2$f1_score, metrics_2_2$f1_score, metrics_3_2$f1_score, metrics_4_2$f1_score, metrics_5_2$f1_score, metrics_6_2$f1_score, metrics_7_2$f1_score, metrics_8_2$f1_score),
                           Sensitivity = c(metrics_1_2$sensitivity, metrics_2_2$sensitivity, metrics_3_2$sensitivity, metrics_4_2$sensitivity, metrics_5_2$sensitivity, metrics_6_2$sensitivity, metrics_7_2$sensitivity, metrics_8_2$sensitivity),
                           Specificity = c(metrics_1_2$specificity, metrics_2_2$specificity, metrics_3_2$specificity, metrics_4_2$specificity, metrics_5_2$specificity, metrics_6_2$specificity, metrics_7_2$specificity, metrics_8_2$specificity))

metrics_df_3 <- data.frame(Method = methods,
                           Accuracy = c(metrics_1_3$accuracy, metrics_2_3$accuracy, metrics_3_3$accuracy, metrics_4_3$accuracy, metrics_5_3$accuracy, metrics_6_3$accuracy, metrics_7_3$accuracy, metrics_8_3$accuracy),
                           Precision = c(metrics_1_3$precision, metrics_2_3$precision, metrics_3_3$precision, metrics_4_3$precision, metrics_5_3$precision, metrics_6_3$precision, metrics_7_3$precision, metrics_8_3$precision),
                           F1_Score = c(metrics_1_3$f1_score, metrics_2_3$f1_score, metrics_3_3$f1_score, metrics_4_3$f1_score, metrics_5_3$f1_score, metrics_6_3$f1_score, metrics_7_3$f1_score, metrics_8_3$f1_score),
                           Sensitivity = c(metrics_1_3$sensitivity, metrics_2_3$sensitivity, metrics_3_3$sensitivity, metrics_4_3$sensitivity, metrics_5_3$sensitivity, metrics_6_3$sensitivity, metrics_7_3$sensitivity, metrics_8_3$sensitivity),
                           Specificity = c(metrics_1_3$specificity, metrics_2_3$specificity, metrics_3_3$specificity, metrics_4_3$specificity, metrics_5_3$specificity, metrics_6_3$specificity, metrics_7_3$specificity, metrics_8_3$specificity))


##Combining the plots






metrics_df$Run <- "Run1"
metrics_df_2$Run <- "Run2"
metrics_df_3$Run <- "Run3"

# Combine the dataframes
combined_metrics_df <- rbind(metrics_df, metrics_df_2, metrics_df_3)

# Reorder the methods
combined_metrics_df$Method <- factor(combined_metrics_df$Method, levels = c("MAGs before imputation","Matrix factorization", "BayesianRidge", "DecisionTreeRegressor", 
                                                                            "ExtraTreesRegressor", "KNeighborsRegressor", "Simple Imputer", "K-Nearest Neighbor"))


#######


library(ggplot2)
library(dplyr)



run_colors <- c("Run1" = "#eab595", "Run2" = "#79616f", "Run3" = "#7e9680")


add_vertical_labels <- function(plot, metric) {
  plot + 
    geom_text(aes(label = sprintf("%.2f", !!as.symbol(metric))), 
              position = position_dodge(width = 0.8), vjust = -0.3, angle = 90, hjust = 1, color = "white", size = 3.5)
}


accuracy_plot <- ggplot(combined_metrics_df, aes(x = Method, y = Accuracy, fill = Run)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  labs(title = "Accuracy by Method and Run", x = "Method", y = "Accuracy") +
  scale_fill_manual(values = run_colors) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Adding vertical labels to the plot
accuracy_plot <- add_vertical_labels(accuracy_plot, "Accuracy")

# Similarly for other metrics
precision_plot <- ggplot(combined_metrics_df, aes(x = Method, y = Precision, fill = Run)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  labs(title = "Precision by Method and Run", x = "Method", y = "Precision") +
  scale_fill_manual(values = run_colors) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
precision_plot <- add_vertical_labels(precision_plot, "Precision")

f1_score_plot <- ggplot(combined_metrics_df, aes(x = Method, y = F1_Score, fill = Run)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  labs(title = "F1-Score by Method and Run", x = "Method", y = "F1-Score") +
  scale_fill_manual(values = run_colors) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
f1_score_plot <- add_vertical_labels(f1_score_plot, "F1_Score")

sensitivity_plot <- ggplot(combined_metrics_df, aes(x = Method, y = Sensitivity, fill = Run)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  labs(title = "Sensitivity by Method and Run", x = "Method", y = "Sensitivity") +
  scale_fill_manual(values = run_colors) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
sensitivity_plot <- add_vertical_labels(sensitivity_plot, "Sensitivity")

specificity_plot <- ggplot(combined_metrics_df, aes(x = Method, y = Specificity, fill = Run)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  labs(title = "Specificity by Method and Run", x = "Method", y = "Specificity") +
  scale_fill_manual(values = run_colors) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
specificity_plot <- add_vertical_labels(specificity_plot, "Specificity")

 
print(accuracy_plot)
print(precision_plot)
print(f1_score_plot)
print(sensitivity_plot)
print(specificity_plot)


##BAR PLOTS for each run and method

metrics_df$Run <- "Run1"
metrics_df_2$Run <- "Run2"
metrics_df_3$Run <- "Run3"


combined_metrics_df <- rbind(metrics_df, metrics_df_2, metrics_df_3)


combined_metrics_df$Method <- factor(combined_metrics_df$Method, levels = c("MAGs before imputation","Matrix factorization", "BayesianRidge", "DecisionTreeRegressor", 
                                                                            "ExtraTreesRegressor", "KNeighborsRegressor", "Simple Imputer", "K-Nearest Neighbor"))


run_colors <- c("Run1" = "#eab595", "Run2" = "#79616f", "Run3" = "#7e9680")

# Function to create a plot with points
create_plot <- function(data, metric, y_label, title) {
  ggplot(data, aes_string(x = "Method", y = metric, color = "Run", shape = "Run")) +
    geom_point(position = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.8), size = 3) +
    labs(title = title, x = "Method", y = y_label) +
    scale_color_manual(values = run_colors) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    geom_text(aes_string(label = sprintf("round(%s, 2)", metric)), position = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.8), vjust = -1.5, size = 3.5)
}


accuracy_plot <- create_plot(combined_metrics_df, "Accuracy", "Accuracy", "Accuracy by Method and Run")
precision_plot <- create_plot(combined_metrics_df, "Precision", "Precision", "Precision by Method and Run")
f1_score_plot <- create_plot(combined_metrics_df, "F1_Score", "F1-Score", "F1-Score by Method and Run")
sensitivity_plot <- create_plot(combined_metrics_df, "Sensitivity", "Sensitivity", "Sensitivity by Method and Run")
specificity_plot <- create_plot(combined_metrics_df, "Specificity", "Specificity", "Specificity by Method and Run")


print(accuracy_plot)
print(precision_plot)
print(f1_score_plot)
print(sensitivity_plot)
print(specificity_plot)

library(ggplot2)
library(gridExtra)
library(grid)


empty <- ggplot() + theme_void()


combined_plots <- grid.arrange(
  accuracy_plot, precision_plot,
  f1_score_plot, sensitivity_plot,
  specificity_plot, empty,
  ncol = 2,
  layout_matrix = rbind(c(1, 2),
                        c(3, 4),
                        c(5, 6))
)


ggsave("combined_plots.svg", combined_plots, width = 18, height = 14)


combined_plots



#########################Heatplots

# Function to load and preprocess data matrices
load_and_preprocess <- function(paths) {
  matrices <- lapply(paths, function(path) {
    mat <- read.csv(path, header = FALSE)
    mat <- mat[-1, -1]  # Remove the first row and first column (containing genes names and samples IDs)
    mat <- as.data.frame(lapply(mat, as.numeric))
    return(mat)
  })
  return(matrices)
}


# Paths to the data files for each run
paths_run1 <- c(
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/before_imputation/Final_updated_node_matrice.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/CF_SVD_1.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/BR_mags.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/DTR_mags.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/ETR_mags.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/KNR_mags.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/SI_mags.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation//KNN_mags.csv"
)

paths_run2 <- c(
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/before_imputation/Final_updated_node_matrice.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/CF_SVD_1.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/BR_mags.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/DTR_mags.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/ETR_mags.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/KNR_mags.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/SI_mags.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation//KNN_mags.csv"
)

paths_run3 <- c(
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/before_imputation/Final_updated_node_matrice.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/CF_SVD_1.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/BR_mags.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/DTR_mags.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/ETR_mags.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/KNR_mags.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/SI_mags.csv",
  "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation//KNN_mags.csv"
)

 
data_run1 <- load_and_preprocess(paths_run1)
data_run2 <- load_and_preprocess(paths_run2)
data_run3 <- load_and_preprocess(paths_run3)

# Function to create and plot heatmap
create_heatmap <- function(data, methods, run_name) {
  plots <- lapply(seq_along(data), function(i) {
    method_data <- data[[i]]
    method_name <- methods[i]
    melted_data <- melt(as.matrix(method_data))
    ggplot(melted_data, aes(Var2, Var1, fill = factor(value))) +
      geom_tile() +
      scale_fill_manual(values = c("1" = "#3f007d", "0" = "#f5f0e1")) +
      labs(title = method_name, x = "", y = "", fill = "Value") +
      theme_minimal() +
      theme(axis.text.x = element_blank(), axis.text.y = element_blank(), 
            axis.ticks.x = element_blank(), axis.ticks.y = element_blank())
  })
  grid.arrange(grobs = plots, ncol = 4, top = paste("Heatmaps for", run_name))
}

methods <- c("MAGs", "Matrix Factorization", "Bayesian Ridge", "Decision Tree Regressor", "Extra Trees Regressor", "K Neighbors Regressor", "Simple Imputer", "K-Nearest Neighbor")


RUN1 <- create_heatmap(data_run1, methods, "Run 1")
RUN2 <-create_heatmap(data_run2, methods, "Run 2")
RUN3 <-create_heatmap(data_run3, methods, "Run 3")



ggsave("RUN1_heatmaps.svg", RUN1, width = 12, height = 18)

ggsave("RUN2_heatmaps.svg", RUN2, width = 12, height = 18)

ggsave("RUN3_heatmaps.svg", RUN3, width = 12, height = 18)


 


########################## Euclidien distances between matrices for each RUN ############################




# Function to calculate Euclidean distance between two matrices
calculate_distance <- function(matrix1, matrix2) {
  dist <- sqrt(sum((matrix1 - matrix2)^2))
  return(dist)
}

# Function to process a single run and calculate Euclidean distances for all methods
process_run_distances <- function(paths, reference_path) {
  matrix_ref <- read.csv(reference_path, header = FALSE)
  matrix_ref <- matrix_ref[-1, -1]  # Remove the first row and first column
  matrix_ref <- as.data.frame(lapply(matrix_ref, as.numeric))  # Convert to numeric
  
  # Load and preprocess each imputed matrix
  matrices <- lapply(paths, function(path) {
    mat <- read.csv(path, header = FALSE)
    mat <- mat[-1, -1]  # Remove the first row and first column
    mat <- as.data.frame(lapply(mat, as.numeric))  # Convert to numeric
    return(mat)
  })
  
  # Calculate Euclidean distances for each method
  distances <- sapply(matrices, function(matrix_imputed) {
    calculate_distance(matrix_ref, matrix_imputed)
  })
  
  return(distances)
}


distances_run1 <- process_run_distances(paths_run1, reference_run1)
distances_run2 <- process_run_distances(paths_run2, reference_run2)
distances_run3 <- process_run_distances(paths_run3, reference_run3)


methods <- c("MAGs", "Matrix Factorization", "Bayesian Ridge", "Decision Tree Regressor", "Extra Trees Regressor", "K Neighbors Regressor", "Simple Imputer", "K-Nearest Neighbor")


distance_df_run1 <- data.frame(Method = methods, Distance = distances_run1)
distance_df_run2 <- data.frame(Method = methods, Distance = distances_run2)
distance_df_run3 <- data.frame(Method = methods, Distance = distances_run3)


plot_distances <- function(distance_df, run_name) {
  ggplot(distance_df, aes(x = reorder(Method, Distance), y = Distance)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    coord_flip() +
    labs(title = paste("Euclidean Distance Between Imputed Matrices and Reference -", run_name),
         x = "Imputation Method",
         y = "Euclidean Distance") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))
}


plot_run1 <- plot_distances(distance_df_run1, "Run 1")
plot_run2 <- plot_distances(distance_df_run2, "Run 2")
plot_run3 <- plot_distances(distance_df_run3, "Run 3")

# Combine the plots into one plot
combined_plot <- grid.arrange(plot_run1, plot_run2, plot_run3, ncol = 1)

ggsave("combined_euclidean_distances.svg", combined_plot, width = 8, height = 12)






#########################











###Completenesses plots






data <- read_tsv("completeness.tsv", col_names = c("File_name", "Completeness", "Removed"))

# Clean up the Completeness column to ensure it's numeric
data$Completeness <- as.numeric(data$Completeness)


ggplot(data, aes(x = reorder(File_name, -Completeness), y = Completeness)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Genome Completeness",
       x = "Genome Files",
       y = "Completeness") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 8))


ggsave("genome_completeness_plot.png", width = 10, height = 6)





data <- read_tsv("completeness.tsv", col_names = c("File_name", "Completeness", "Removed"))


data$Completeness <- as.numeric(data$Completeness)

hist_plot <- ggplot(data, aes(x = Completeness)) +
  geom_histogram(binwidth = 0.05, fill = "steelblue", color = "black") +
  labs(title = "Distribution of Genome Completeness",
       x = "Completeness",
       y = "Frequency") +
  theme_minimal()


density_plot <- ggplot(data, aes(x = Completeness)) +
  geom_density(fill = "steelblue", alpha = 0.5) +
  labs(title = "Density of Genome Completeness",
       x = "Completeness",
       y = "Density") +
  theme_minimal()


ggsave("genome_completeness_histogram.png", plot = hist_plot, width = 10, height = 6)
ggsave("genome_completeness_density.png", plot = density_plot, width = 10, height = 6)
ggsave("genome_completeness_histogram.svg", plot = hist_plot, width = 10, height = 6)
ggsave("genome_completeness_density.svg", plot = density_plot, width = 10, height = 6)

print(hist_plot)
print(density_plot)
