#R script used for generating Data visualisations and analysis for the final MAGGImpute workflow

library(ggplot2)
library(reshape2)
library(dplyr)
library(ggpubr)
library(tidyr)
# Function to read and clean the matrix
read_and_clean_matrix <- function(file_path) {
  matrix <- read.csv(file_path, header = TRUE)
  matrix <- matrix[-1, -1]  # Remove the first row and column which contains Samples and genes IDs
  matrix <- as.matrix(matrix)  # Convert to matrix
  matrix <- apply(matrix, 2, as.numeric) # Ensure all elements are numeric (verification)
  return(matrix)
}

# Universal function to calculate metrics including F1 score, Cohen's Kappa and other metrics as well
calculate_metrics <- function(reference, mags_run, input_df) {
  # Only consider values that were 0 in the Mags_Run
  mags_zeros <- which(mags_run == 0, arr.ind = TRUE)
  
  TP <- sum(reference[mags_zeros] == 1 & input_df[mags_zeros] == 1)  # MAG 0 -> ref 1 -> feature 1
  TN <- sum(reference[mags_zeros] == 0 & input_df[mags_zeros] == 0)  # MAG 0 -> ref 0 -> feature 0
  FP <- sum(reference[mags_zeros] == 0 & input_df[mags_zeros] == 1)  # MAG 0 -> ref 0 -> feature 1
  FN <- sum(reference[mags_zeros] == 1 & input_df[mags_zeros] == 0)  # MAG 0 -> ref 1 -> feature 0
  
  sensitivity <- TP / (TP + FN)
  specificity <- TN / (TN + FP)
  precision <- TP / (TP + FP)
  f1_score <- 2 * ((precision * sensitivity) / (precision + sensitivity))
  
  total <- TP + TN + FP + FN
  po <- (TP + TN) / total
  pe <- ((TP + FP) / total) * ((TP + FN) / total) + ((FN + TN) / total) * ((FP + TN) / total)
  kappa <- (po - pe) / (1 - pe)
  
  return(data.frame(TP = TP, TN = TN, FP = FP, FN = FN, Sensitivity = sensitivity, Specificity = specificity, Precision = precision, F1_Score = f1_score, Kappa = kappa))
}

# Initialize an empty data frame to store the results
results <- data.frame(Run = character(), Method = character(), TP = numeric(), TN = numeric(), FP = numeric(), FN = numeric(), Sensitivity = numeric(), Specificity = numeric(), Precision = numeric(), F1_Score = numeric(), Kappa = numeric(), stringsAsFactors = FALSE)




# List of file paths for each run and method
run_paths <- list(
  run1 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/ground_truth/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/before_imputation/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/CF.csv",
      BR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/BR.csv",
      DTR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/DTR.csv",
      ETR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/ETR.csv",
      KNR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/KNR.csv",
      SI = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/SI.csv",
      KNN = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/KNN.csv"
    )
  ),
  run2 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/ground_truth/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/before_imputation/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/CF.csv",
      BR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/BR_mags.csv",
      DTR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/DTR_mags.csv",
      ETR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/ETR_mags.csv",
      KNR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/KNR_mags.csv",
      SI = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/SI_mags.csv",
      KNN = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/KNN_mags.csv"
    )
  ),
  run3 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/ground_truth/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/before_imputation/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/CF.csv",
      BR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/BR_mags.csv",
      DTR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/DTR_mags.csv",
      ETR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/ETR_mags.csv",
      KNR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/KNR_mags.csv",
      SI = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/SI_mags.csv",
      KNN = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/KNN_mags.csv"
    )
  ),
  run4 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run1/before_sim/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run1/after_sim/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run1/imputation/imputation/CF.csv",
      BR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run1/imputation/imputation/BR_mags.csv",
      DTR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run1/imputation/imputation/DTR_mags.csv",
      ETR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run1/imputation/imputation/ETR_mags.csv",
      KNR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run1/imputation/imputation/KNR_mags.csv",
      SI = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run1/imputation/imputation/SI_mags.csv",
      KNN = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run1/imputation/imputation/KNN_mags.csv"
    )
  ),
  run5 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run2/before_sim/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run2/after_sim/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run2/imputation/imputation/CF.csv",
      BR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run2/imputation/imputation/BR_mags.csv",
      DTR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run2/imputation/imputation/DTR_mags.csv",
      ETR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run2/imputation/imputation/ETR_mags.csv",
      KNR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run2/imputation/imputation/KNR_mags.csv",
      SI = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run2/imputation/imputation/SI_mags.csv",
      KNN = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run2/imputation/imputation/KNN_mags.csv"
    )
  ),
  run6 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run3/before_sim/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run3/after_sim/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run3/imputation/imputation/CF.csv",
      BR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run3/imputation/imputation/BR_mags.csv",
      DTR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run3/imputation/imputation/DTR_mags.csv",
      ETR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run3/imputation/imputation/ETR_mags.csv",
      KNR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run3/imputation/imputation/KNR_mags.csv",
      SI = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run3/imputation/imputation/SI_mags.csv",
      KNN = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run3/imputation/imputation/KNN_mags.csv"
    )
  ),
  run7 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run1/before_sim/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run1/after_sim/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run1/imputation/imputation/CF.csv",
      BR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run1/imputation/imputation/BR_mags.csv",
      DTR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run1/imputation/imputation/DTR_mags.csv",
      ETR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run1/imputation/imputation/ETR_mags.csv",
      KNR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run1/imputation/imputation/KNR_mags.csv",
      SI = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run1/imputation/imputation/SI_mags.csv",
      KNN = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run1/imputation/imputation/KNN_mags.csv"
    )
  ),
  run8 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run2/before_sim/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run2/after_sim/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run2/imputation/imputation/CF.csv",
      BR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run2/imputation/imputation/BR_mags.csv",
      DTR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run2/imputation/imputation/DTR_mags.csv",
      ETR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run2/imputation/imputation/ETR_mags.csv",
      KNR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run2/imputation/imputation/KNR_mags.csv",
      SI = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run2/imputation/imputation/SI_mags.csv",
      KNN = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run2/imputation/imputation/KNN_mags.csv"
    )
  ),
  run9 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run1/ground_truth/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run1/before_imputation/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run1/after_imputation/imputation/CF.csv",
      BR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run1/after_imputation/imputation/BR.csv",
      DTR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run1/after_imputation/imputation/DTR.csv",
      ETR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run1/after_imputation/imputation/ETR.csv",
      KNR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run1/after_imputation/imputation/KNR.csv",
      SI = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run1/after_imputation/imputation/SI.csv",
      KNN = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run1/after_imputation/imputation/KNN.csv"
    )
  ),
  run10 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run2/before_sim/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run2/after_sim/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run2/imputation/imputation/CF.csv",
      BR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run2/imputation/imputation/BR_mags.csv",
      DTR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run2/imputation/imputation/DTR_mags.csv",
      ETR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run2/imputation/imputation/ETR_mags.csv",
      KNR = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run2/imputation/imputation/KNR_mags.csv",
      SI = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run2/imputation/imputation/SI_mags.csv",
      KNN = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run2/imputation/imputation/KNN_mags.csv"
    )
  )
)


# Loop through each run and method
for (run in names(run_paths)) {
  reference <- read_and_clean_matrix(run_paths[[run]]$reference)
  mags_run <- read_and_clean_matrix(run_paths[[run]]$methods$Mags_Run)
  
  # Calculate metrics for Mags_Run
  mags_metrics <- calculate_metrics(reference, mags_run, mags_run)
  mags_metrics$Run <- run
  mags_metrics$Method <- "Mags_Run"
  results <- rbind(results, mags_metrics)
  
  # Calculate metrics for imputed methods
  for (method in names(run_paths[[run]]$methods)[-1]) {
    imputed <- read_and_clean_matrix(run_paths[[run]]$methods[[method]])
    metrics <- calculate_metrics(reference, mags_run, imputed)
    
    metrics$Run <- run
    metrics$Method <- method
    
    results <- rbind(results, metrics)
  }
}

# Print the results
print(results)

# Melt the results for ggplot2
results_melted <- melt(results, id.vars = c("Run", "Method"), measure.vars = c("Sensitivity", "Specificity", "Precision", "F1_Score", "Kappa"))

# Bar plot for each metric
ggplot(results_melted, aes(x = Method, y = value, fill = Run)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~ variable, scales = "free_y") +
  theme_minimal() +
  labs(title = "Metrics of Imputation Methods", x = "Method", y = "Value")

# Box plot for each metric with jitter points
ggplot(results_melted, aes(x = Method, y = value, fill = Method)) +
  geom_boxplot() +
  geom_jitter(aes(color = Run), width = 0.2, size = 1.5) +
  facet_wrap(~ variable, scales = "free_y") +
  theme_minimal() +
  labs(title = "Box Plots of Metrics Across Runs", x = "Method", y = "Value")

# Function to create new individual plots for each metric
create_plot <- function(metric) {
  # Filter the data for the current metric
  data <- subset(results_melted, variable == metric)
  
  # Box plot with jitter points
  p <- ggplot(data, aes(x = Method, y = value)) +
    geom_boxplot(color = "black", fill = "aquamarine4", alpha = 0.3) +
    geom_jitter(aes(color = Run), width = 0.2, size = 1.5) +
    scale_color_manual(values = rep("red", length(unique(data$Run))), guide = "none") +
    theme_minimal() +
    labs(title = paste("Box Plot of", metric, "Across Runs"), x = "Method", y = "Value") +
    theme(legend.position = "none")  # This line removes the legend
  ggsave(filename = paste0(metric, "_box_plot.png"), plot = p, width = 10, height = 7)
  
  return(p)
}

# Metrics to plot
metrics <- c("Sensitivity", "Specificity", "Precision", "F1_Score", "Kappa")

# Create and print plots for each metric
for (metric in metrics) {
  print(create_plot(metric))
}






######################################################



#Ploting the variation in True Positives (TP), True Negatives (TN), False Positives (FP), and False Negatives (FN) with gene frequency.



######################################################

# Function to calculate TP, TN, FP, FN per gene
calculate_metrics_per_gene <- function(reference, mags_run, input_df) {
  genes <- 1:nrow(reference)
  
  TP <- sapply(genes, function(gene) {
    sum(reference[gene, ] == 1 & mags_run[gene, ] == 0 & input_df[gene, ] == 1)
  })
  
  TN <- sapply(genes, function(gene) {
    sum(reference[gene, ] == 0 & mags_run[gene, ] == 0 & input_df[gene, ] == 0)
  })
  
  FP <- sapply(genes, function(gene) {
    sum(reference[gene, ] == 0 & mags_run[gene, ] == 0 & input_df[gene, ] == 1)
  })
  
  FN <- sapply(genes, function(gene) {
    sum(reference[gene, ] == 1 & mags_run[gene, ] == 0 & input_df[gene, ] == 0)
  })
  
  return(data.frame(Gene = genes, TP = TP, TN = TN, FP = FP, FN = FN))
}

# Function to calculate gene frequencies, which is the sum of each row
calculate_gene_frequency <- function(matrix) {
  return(rowSums(matrix))
}



# List of file paths for each run and CF (matrix factrorization) method
run_paths <- list(
  run1 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/ground_truth/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/before_imputation/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run1/after_imputation/imputation/CF.csv"
    )
  ),
  run2 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/ground_truth/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/before_imputation/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run2/after_imputation/imputation/CF.csv"
    )
  ),
  run3 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/ground_truth/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/before_imputation/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP/Run3/after_imputation/imputation/CF.csv"
    )
  ),
  run4 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run1/before_sim/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run1/after_sim/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run1/imputation/imputation/CF.csv"
    )
  ),
  run5 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run2/before_sim/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run2/after_sim/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run2/imputation/imputation/CF.csv"
    )
  ),
  run6 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run3/before_sim/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run3/after_sim/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP2/Run3/imputation/imputation/CF.csv"
    )
  ),
  run7 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run1/before_sim/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run1/after_sim/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run1/imputation/imputation/CF.csv"
    )
  ),
  run8 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run2/before_sim/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run2/after_sim/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP3/Run2/imputation/imputation/CF.csv"
    )
  ),
  run9 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run1/ground_truth/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run1/before_imputation/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run1/after_imputation/imputation/CF.csv"
    )
  ),
  run10 = list(
    reference = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run2/before_sim/Final_updated_node_matrice.csv",
    methods = list(
      Mags_Run = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run2/after_sim/Final_updated_node_matrice.csv",
      CF = "/Users/lale/Desktop/Imputation_workflow/datasets_runs/SP4/Run2/imputation/imputation/CF.csv"
    )
  )
)


# Initialize a new empty data frame to store results
results_df <- data.frame()

# Loop through each run to calculate TP, TN, FP, FN, and gene frequency per gene
for (run in names(run_paths)) {
  reference <- read_and_clean_matrix(run_paths[[run]]$reference)
  mags_run <- read_and_clean_matrix(run_paths[[run]]$methods$Mags_Run)
  input_df <- read_and_clean_matrix(run_paths[[run]]$methods$CF)
  
  metrics <- calculate_metrics_per_gene(reference, mags_run, input_df)
  metrics$Frequency <- calculate_gene_frequency(reference)
  metrics$Run <- run
  
  results_df <- rbind(results_df, metrics)
}

# Convert results to long format for plotting
results_long <- results_df %>%
  pivot_longer(cols = c(TP, TN, FP, FN), names_to = "Metric", values_to = "Count")

# Plotting all metrics in one plot
plot <- ggplot(results_long, aes(x = Frequency, y = Count, color = Metric)) +
  geom_smooth(method = "loess", se = FALSE, alpha = 0.7) +  # Add a smooth line for trend without confidence interval
  labs(title = "Metrics (TP, TN, FP, FN) by Gene Frequency",
       x = "Gene Frequency",
       y = "Count") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Display the plot
print(plot)

 

