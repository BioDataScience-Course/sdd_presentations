# ============================================================================
# R Code Examples for Proteomics Statistical Analysis
# Copyright (c) 2026 Ph. Grosjean (philippe.grosjean@umons.ac.be)
# Draft generated using Manus 1.6 Lite, further edited and verified by a human
# ============================================================================

# Install required packages (run once)
# install.packages("BiocManager")
# BiocManager::install(c("limma", "DEqMS"))

# Load libraries
library(limma)

# ============================================================================
# Example 1: Data Preparation and Normalization
# ============================================================================

# Simulate proteomics data matrix
# Rows = proteins, Columns = samples
set.seed(123)
n_proteins <- 2000
n_samples_per_group <- 6

# Create expression matrix (log2 intensities)
expression_data <- matrix(
  rnorm(n_proteins * n_samples_per_group * 2, mean = 20, sd = 2),
  nrow = n_proteins,
  ncol = n_samples_per_group * 2
)

# Add differential expression to 200 proteins
de_proteins <- 1:200
expression_data[de_proteins, (n_samples_per_group+1):(n_samples_per_group*2)] <-
  expression_data[de_proteins, (n_samples_per_group+1):(n_samples_per_group*2)] +
  rnorm(200, mean = 2, sd = 0.5)

# Set row and column names
rownames(expression_data) <- paste0("Protein_", 1:n_proteins)
colnames(expression_data) <- c(
  paste0("Control_", 1:n_samples_per_group),
  paste0("Treatment_", 1:n_samples_per_group)
)

# Create experimental design
group <- factor(rep(c("Control", "Treatment"), each = n_samples_per_group))
design <- model.matrix(~0 + group)
colnames(design) <- c("Control", "Treatment")

# View data structure
head(expression_data)
print(design)

# ============================================================================
# Example 2: Quality Control - Boxplot
# ============================================================================

# Boxplot to check data distribution across samples
boxplot(expression_data,
  main = "Protein Expression Distribution",
  xlab = "Samples",
  ylab = "Log2 Intensity",
  las = 2,
  col = rep(c("lightblue", "lightcoral"), each = n_samples_per_group))

# ============================================================================
# Example 3: Statistical Testing with limma
# ============================================================================

# Fit linear model
fit <- lmFit(expression_data, design)

# Define contrast (Treatment vs Control)
contrast_matrix <- makeContrasts(
  TreatmentVsControl = Treatment - Control,
  levels = design
)

# Apply contrast
fit2 <- contrasts.fit(fit, contrast_matrix)

# Empirical Bayes moderation
fit2 <- eBayes(fit2)

# Extract results
results <- topTable(fit2, coef = "TreatmentVsControl", number = Inf, sort.by = "P")

# View top differentially expressed proteins
head(results, 10)

# ============================================================================
# Example 4: Multiple Testing Correction
# ============================================================================

# Extract p-values
raw_pvalues <- results$P.Value

# Apply different correction methods
bonferroni_adj <- p.adjust(raw_pvalues, method = "bonferroni")
bh_fdr <- p.adjust(raw_pvalues, method = "BH")  # Benjamini-Hochberg

# Compare number of significant proteins
cat("Significant proteins (raw p < 0.05):", sum(raw_pvalues < 0.05), "\n")
cat("Significant proteins (Bonferroni < 0.05):", sum(bonferroni_adj < 0.05), "\n")
cat("Significant proteins (FDR < 0.05):", sum(bh_fdr < 0.05), "\n")

# Add adjusted p-values to results
results$Bonferroni <- bonferroni_adj
results$FDR <- bh_fdr

# ============================================================================
# Example 5: Volcano Plot
# ============================================================================

# Create volcano plot
plot(results$logFC, -log10(results$P.Value),
  pch = 20, cex = 0.5,
  xlab = "Log2 Fold Change",
  ylab = "-Log10(P-value)",
  main = "Volcano Plot: Treatment vs Control",
  col = ifelse(results$FDR < 0.05 & abs(results$logFC) > 1, "red", "gray"))

# Add threshold lines
abline(h = -log10(0.05), col = "blue", lty = 2)
abline(v = c(-1, 1), col = "blue", lty = 2)

# Add legend
legend("topright",
  legend = c("Significant (FDR<0.05, |FC|>2)", "Not significant"),
  col = c("red", "gray"),
  pch = 20)

# ============================================================================
# Example 6: P-value Histogram (Diagnostic)
# ============================================================================

# Histogram of p-values
hist(results$P.Value,
  breaks = 50,
  col = "lightblue",
  xlab = "P-value",
  main = "P-value Distribution",
  freq = TRUE)

# Add expected uniform line
abline(h = nrow(results) / 50, col = "red", lty = 2, lwd = 2)

# ============================================================================
# Example 7: Heatmap of Top Proteins
# ============================================================================

# Select top 50 differentially expressed proteins
top_proteins <- rownames(results)[1:50]
heatmap_data <- expression_data[top_proteins, ]

# Create heatmap with clustering
heatmap(heatmap_data,
  col = colorRampPalette(c("blue", "white", "red"))(100),
  main = "Top 50 Differentially Expressed Proteins",
  cexRow = 0.6,
  cexCol = 0.8,
  margins = c(8, 10))

# ============================================================================
# Example 8: MA Plot
# ============================================================================

# MA plot: Average expression vs Fold change
plotMA(fit2, coef = "TreatmentVsControl",
  main = "MA Plot: Treatment vs Control",
  status = results$FDR < 0.05)

# ============================================================================
# Example 9: Export Results
# ============================================================================

# Save significant proteins to CSV
significant_proteins <- results[results$FDR < 0.05, ]
write.csv(significant_proteins,
  file = "significant_proteins_FDR005.csv",
  row.names = TRUE)

cat("Exported", nrow(significant_proteins), "significant proteins to CSV\n")

# ============================================================================
# Example 10: Bayes' Theorem Application
# ============================================================================

# Function to calculate Positive Predictive Value (PPV)
calculate_ppv <- function(sensitivity, specificity, prevalence) {
  ppv <- (sensitivity * prevalence) /
    (sensitivity * prevalence + (1 - specificity) * (1 - prevalence))
  return(ppv)
}

# Example: Test with 95% sensitivity and specificity
# at different prevalences
prevalences <- c(0.01, 0.05, 0.10, 0.20, 0.50)
ppv_values <- calculate_ppv(0.95, 0.95, prevalences)

# Display results
ppv_table <- data.frame(
  Prevalence = paste0(prevalences * 100, "%"),
  PPV = paste0(round(ppv_values * 100, 1), "%"),
  FalsePositiveRate = paste0(round((1 - ppv_values) * 100, 1), "%")
)

print("Positive Predictive Value at Different Prevalences:")
print(ppv_table)

# ============================================================================
# Summary Statistics
# ============================================================================

cat("\n=== Analysis Summary ===\n")
cat("Total proteins analyzed:", nrow(results), "\n")
cat("Significant at FDR < 0.05:", sum(results$FDR < 0.05), "\n")
cat("Up-regulated (FC > 2):", sum(results$FDR < 0.05 & results$logFC > 1), "\n")
cat("Down-regulated (FC < 0.5):", sum(results$FDR < 0.05 & results$logFC < -1), "\n")
cat("Median p-value:", median(results$P.Value), "\n")
cat("========================\n")
