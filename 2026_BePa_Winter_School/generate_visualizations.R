# Statistical Visualizations for Proteomics Data Analysis
# This script generates all visualizations for the presentation
# Copyright (c) 2026 Ph. Grosjean (philippe.grosjean@umons.ac.be)
# Draft generated using Manus 1.6 Lite, further edited and verified by a human
# ============================================================================

# Set up output directory
dir.create("proteomics_figures", showWarnings = FALSE)

# Set seed for reproducibility
set.seed(42)

# ============================================================================
# 1. Experimental Probability - Coin Flip Simulation
# ============================================================================
png("proteomics_figures/01_experimental_probability.png",
  width = 800, height = 600, res = 100)
par(mar = c(5, 5, 4, 2))

n_flips <- 1000
flips <- sample(c(0, 1), n_flips, replace = TRUE)
cumulative_prob <- cumsum(flips) / (1:n_flips)

plot(1:n_flips, cumulative_prob, type = "l", lwd = 2, col = "steelblue",
  xlab = "Number of Coin Flips", ylab = "Estimated P(Heads)",
  main = "Experimental Probability Converges to Theoretical Value",
  ylim = c(0.3, 0.7), cex.lab = 1.2, cex.main = 1.3)
abline(h = 0.5, col = "red", lwd = 2, lty = 2)
legend("topright",
  legend = c("Experimental P(Heads)", "Theoretical P(Heads) = 0.5"),
  col = c("steelblue", "red"), lwd = 2, lty = c(1, 2), cex = 1.1)
grid()

dev.off()

# ============================================================================
# 2. Normal Distribution with 68-95-99.7 Rule
# ============================================================================
png("proteomics_figures/02_normal_distribution.png",
  width = 800, height = 600, res = 100)
par(mar = c(5, 5, 4, 2))

x <- seq(-4, 4, length.out = 1000)
y <- dnorm(x)

plot(x, y, type = "l", lwd = 3, col = "darkblue",
  xlab = "Standard Deviations from Mean", ylab = "Density",
  main = "Normal Distribution: 68-95-99.7 Rule",
  cex.lab = 1.2, cex.main = 1.3)

# Shade regions
polygon(c(x[x >= -1 & x <= 1], 1, -1), c(y[x >= -1 & x <= 1], 0, 0),
  col = rgb(0, 0, 1, 0.2), border = NA)
polygon(c(x[x >= -2 & x <= 2], 2, -2), c(y[x >= -2 & x <= 2], 0, 0),
  col = rgb(0, 0, 1, 0.1), border = NA)
polygon(c(x[x >= -3 & x <= 3], 3, -3), c(y[x >= -3 & x <= 3], 0, 0),
  col = rgb(0, 0, 1, 0.05), border = NA)

# Add vertical lines
abline(v = c(-3, -2, -1, 0, 1, 2, 3), lty = 2, col = "gray50")

# Add text annotations
text(0, 0.2, "68%", cex = 1.3, font = 2)
text(0, 0.1, "95%", cex = 1.3, font = 2)
text(0, 0.05, "99.7%", cex = 1.3, font = 2)

dev.off()

# ============================================================================
# 3. P-value Visualization
# ============================================================================
png("proteomics_figures/03_pvalue_illustration.png",
  width = 800, height = 600, res = 100)
par(mar = c(5, 5, 4, 2))

x <- seq(-4, 4, length.out = 1000)
y <- dnorm(x)

plot(x, y, type = "l", lwd = 3, col = "darkblue",
  xlab = "Test Statistic", ylab = "Density",
  main = "P-value: Probability of Observing Data as Extreme Under H₀",
  cex.lab = 1.2, cex.main = 1.3)

# Observed test statistic
observed <- 2.5
abline(v = observed, col = "red", lwd = 2, lty = 1)

# Shade p-value region (two-tailed)
x_right <- x[x >= observed]
y_right <- y[x >= observed]
polygon(c(observed, x_right, 4), c(0, y_right, 0), col = rgb(1, 0, 0, 0.3),
  border = NA)

x_left <- x[x <= -observed]
y_left <- y[x <= -observed]
polygon(c(-4, x_left, -observed), c(0, y_left, 0), col = rgb(1, 0, 0, 0.3),
  border = NA)

# Calculate p-value
pval <- 2 * (1 - pnorm(observed))
text(observed, 0.3, paste0("Observed\nStatistic = ", observed), pos = 4,
  cex = 1.1, col = "red")
text(0, 0.35, paste0("P-value = ", round(pval, 4)), cex = 1.3, font = 2)

dev.off()

# ============================================================================
# 4. Type I and Type II Errors
# ============================================================================
png("proteomics_figures/04_error_types.png",
  width = 900, height = 600, res = 100)
par(mfrow = c(1, 2), mar = c(5, 5, 4, 2))

# Distribution under H0 and H1
x <- seq(-4, 8, length.out = 1000)
y_h0 <- dnorm(x, mean = 0, sd = 1)
y_h1 <- dnorm(x, mean = 3, sd = 1)

# Critical value
critical <- qnorm(0.95)

# Plot 1: Type I Error
plot(x, y_h0, type = "l", lwd = 3, col = "blue",
  xlab = "Test Statistic", ylab = "Density",
  main = "Type I Error (α = 0.05)",
  ylim = c(0, max(y_h0, y_h1)), cex.lab = 1.2, cex.main = 1.3)
abline(v = critical, col = "red", lwd = 2, lty = 2)

# Shade Type I error region
x_type1 <- x[x >= critical]
y_type1 <- y_h0[x >= critical]
polygon(c(critical, x_type1, 8), c(0, y_type1, 0), col = rgb(1, 0, 0, 0.3),
  border = NA)

text(critical, 0.35, "Critical\nValue", pos = 4, cex = 1.1)
text(2.5, 0.05, "Type I Error\n(False Positive)\nα = 0.05", cex = 1.1, font = 2)
legend("topright", legend = "H₀ is True", col = "blue", lwd = 3, cex = 1.1)

# Plot 2: Type II Error
plot(x, y_h1, type = "l", lwd = 3, col = "darkgreen",
  xlab = "Test Statistic", ylab = "Density",
  main = "Type II Error (β)",
  ylim = c(0, max(y_h0, y_h1)), cex.lab = 1.2, cex.main = 1.3)
lines(x, y_h0, lwd = 2, col = "blue", lty = 2)
abline(v = critical, col = "red", lwd = 2, lty = 2)

# Shade Type II error region
x_type2 <- x[x <= critical]
y_type2 <- y_h1[x <= critical]
polygon(c(-4, x_type2, critical), c(0, y_type2, 0), col = rgb(1, 0.5, 0, 0.3), border = NA)

# Shade Power region
x_power <- x[x >= critical]
y_power <- y_h1[x >= critical]
polygon(c(critical, x_power, 8), c(0, y_power, 0), col = rgb(0, 1, 0, 0.2), border = NA)

text(1, 0.05, "Type II Error\n(False Negative)\nβ", cex = 1.1, font = 2)
text(5, 0.15, "Power\n1-β", cex = 1.1, font = 2, col = "darkgreen")
legend("topright", legend = c("H₁ is True", "H₀ Distribution"),
  col = c("darkgreen", "blue"), lwd = c(3, 2), lty = c(1, 2), cex = 1.0)

dev.off()

# ============================================================================
# 5. Multiple Testing Problem
# ============================================================================
png("proteomics_figures/05_multiple_testing.png",
  width = 800, height = 600, res = 100)
par(mar = c(5, 5, 4, 2))

n_tests <- seq(1, 100, by = 1)
fwer <- 1 - (1 - 0.05)^n_tests

plot(n_tests, fwer, type = "l", lwd = 3, col = "red",
  xlab = "Number of Tests", ylab = "Family-Wise Error Rate (FWER)",
  main = "Multiple Testing Inflates False Positive Rate",
  cex.lab = 1.2, cex.main = 1.3, ylim = c(0, 1))
abline(h = 0.05, col = "blue", lwd = 2, lty = 2)
grid()

# Add specific points
points(c(1, 20, 50, 100), 1 - (1 - 0.05)^c(1, 20, 50, 100),
  pch = 19, cex = 2, col = "darkred")
text(20, 0.64, "20 tests\nFWER = 64%", pos = 4, cex = 1.1, font = 2)
text(50, 0.92, "50 tests\nFWER = 92%", pos = 4, cex = 1.1, font = 2)

legend("bottomright",
  legend = c("FWER with α=0.05 per test", "Nominal α=0.05"),
  col = c("red", "blue"), lwd = c(3, 2), lty = c(1, 2), cex = 1.1)

dev.off()

# ============================================================================
# 6. Bonferroni vs FDR Comparison
# ============================================================================
png("proteomics_figures/06_bonferroni_vs_fdr.png",
  width = 900, height = 600, res = 100)
par(mar = c(5, 5, 4, 2))

# Simulate p-values: mix of true nulls and alternatives
n_proteins <- 1000
n_true_positives <- 100
p_values <- c(
  rbeta(n_true_positives, 0.5, 10),  # True positives (small p-values)
  runif(n_proteins - n_true_positives)  # True nulls (uniform)
)
p_values <- sort(p_values)

# Bonferroni correction
bonf_threshold <- 0.05 / n_proteins
bonf_significant <- sum(p_values < bonf_threshold)

# BH FDR correction
bh_threshold <- which(p_values <= (1:n_proteins) / n_proteins * 0.05)
bh_significant <- ifelse(length(bh_threshold) > 0, max(bh_threshold), 0)

plot(1:n_proteins, p_values, pch = 20, cex = 0.5, col = "gray50",
  xlab = "Protein Rank (ordered by p-value)", ylab = "P-value",
  main = "Bonferroni vs. Benjamini-Hochberg FDR Correction",
  log = "y", cex.lab = 1.2, cex.main = 1.3)

# Add threshold lines
abline(h = bonf_threshold, col = "red", lwd = 2, lty = 2)
abline(h = 0.05, col = "orange", lwd = 2, lty = 3)

# BH threshold line
bh_line <- (1:n_proteins) / n_proteins * 0.05
lines(1:n_proteins, bh_line, col = "blue", lwd = 2, lty = 1)

# Highlight significant points
if (bonf_significant > 0) {
  points(1:bonf_significant, p_values[1:bonf_significant],
    pch = 19, cex = 0.8, col = "red")
}
if (bh_significant > 0) {
  points(1:bh_significant, p_values[1:bh_significant],
    pch = 19, cex = 0.6, col = "blue")
}

legend("bottomright",
  legend = c(paste0("Bonferroni (", bonf_significant, " significant)"),
    "Nominal α=0.05",
    paste0("BH FDR (", bh_significant, " significant)")),
  col = c("red", "orange", "blue"),
  lwd = 2, lty = c(2, 3, 1), cex = 1.0)

dev.off()

# ============================================================================
# 7. Confusion Matrix
# ============================================================================
png("proteomics_figures/07_confusion_matrix.png",
  width = 800, height = 700, res = 100)
par(mar = c(2, 2, 4, 2))

# Create confusion matrix visualization
plot(0, 0, type = "n", xlim = c(0, 10), ylim = c(0, 10),
  xlab = "", ylab = "", axes = FALSE,
  main = "Confusion Matrix for Binary Classification", cex.main = 1.5)

# Draw boxes
rect(2, 6, 5, 9, col = rgb(0, 1, 0, 0.3), border = "black", lwd = 2)
rect(5, 6, 8, 9, col = rgb(1, 0.5, 0, 0.3), border = "black", lwd = 2)
rect(2, 3, 5, 6, col = rgb(1, 0, 0, 0.3), border = "black", lwd = 2)
rect(5, 3, 8, 6, col = rgb(0, 0, 1, 0.3), border = "black", lwd = 2)

# Add text
text(3.5, 7.5, "True Positive\n(TP)", cex = 1.5, font = 2)
text(6.5, 7.5, "False Negative\n(FN)\nType II Error", cex = 1.3, font = 2)
text(3.5, 4.5, "False Positive\n(FP)\nType I Error", cex = 1.3, font = 2)
text(6.5, 4.5, "True Negative\n(TN)", cex = 1.5, font = 2)

# Add labels
text(1, 7.5, "Actual\nPositive", cex = 1.3, font = 2, srt = 0)
text(1, 4.5, "Actual\nNegative", cex = 1.3, font = 2, srt = 0)
text(3.5, 9.7, "Predicted Positive", cex = 1.3, font = 2)
text(6.5, 9.7, "Predicted Negative", cex = 1.3, font = 2)

# Add metrics
text(5, 1.5, "Precision = TP/(TP+FP)     Recall = TP/(TP+FN)", cex = 1.2,
  font = 2)
text(5, 0.7, "Specificity = TN/(TN+FP)     Accuracy = (TP+TN)/(TP+FP+FN+TN)",
  cex = 1.2, font = 2)

dev.off()

# ============================================================================
# 8. Precision-Recall Trade-off
# ============================================================================
png("proteomics_figures/08_precision_recall_tradeoff.png",
  width = 800, height = 600, res = 100)
par(mar = c(5, 5, 4, 2))

# Simulate scores for true positives and true negatives
scores_positive <- rnorm(200, mean = 0.7, sd = 0.15)
scores_negative <- rnorm(800, mean = 0.3, sd = 0.15)

# Calculate precision and recall at different thresholds
thresholds <- seq(0, 1, by = 0.01)
precision <- numeric(length(thresholds))
recall <- numeric(length(thresholds))

for (i in 1:length(thresholds)) {
  thresh <- thresholds[i]
  tp <- sum(scores_positive >= thresh)
  fp <- sum(scores_negative >= thresh)
  fn <- sum(scores_positive < thresh)

  precision[i] <- ifelse(tp + fp > 0, tp / (tp + fp), 1)
  recall[i] <- ifelse(tp + fn > 0, tp / (tp + fn), 0)
}

plot(recall, precision, type = "l", lwd = 3, col = "purple",
  xlab = "Recall (Sensitivity)", ylab = "Precision (PPV)",
  main = "Precision-Recall Trade-off",
  cex.lab = 1.2, cex.main = 1.3, xlim = c(0, 1), ylim = c(0, 1))
grid()

# Add example points - find closest points on curve
idx_high_recall <- which.min(abs(recall - 0.9))
idx_mid_recall <- which.min(abs(recall - 0.5))
idx_low_recall <- which.min(abs(recall - 0.2))

points(recall[c(idx_high_recall, idx_mid_recall, idx_low_recall)],
  precision[c(idx_high_recall, idx_mid_recall, idx_low_recall)],
  pch = 19, cex = 2, col = c("red", "orange", "green"))

text(recall[idx_high_recall], precision[idx_high_recall],
  "Lenient\nThreshold", pos = 4, cex = 1.0, font = 2)
text(recall[idx_mid_recall], precision[idx_mid_recall],
  "Balanced", pos = 4, cex = 1.0, font = 2)
text(recall[idx_low_recall], precision[idx_low_recall],
  "Strict\nThreshold", pos = 2, cex = 1.0, font = 2)

dev.off()

# ============================================================================
# 9. Bayes' Theorem and Prevalence Effect
# ============================================================================
png("proteomics_figures/09_bayes_prevalence.png",
  width = 800, height = 600, res = 100)
par(mar = c(5, 5, 4, 2))

# Calculate PPV for different prevalences
prevalence <- seq(0.01, 0.5, by = 0.01)
sensitivity <- 0.95
specificity <- 0.95

ppv <- (sensitivity * prevalence) /
  (sensitivity * prevalence + (1 - specificity) * (1 - prevalence))

plot(prevalence * 100, ppv * 100, type = "l", lwd = 3, col = "darkblue",
  xlab = "Prevalence of True Positives (%)",
  ylab = "Positive Predictive Value (PPV) %",
  main = "PPV Depends Critically on Prevalence\n(Sensitivity=95%, Specificity=95%)",
  cex.lab = 1.2, cex.main = 1.3)
grid()

# Add reference lines
abline(h = 50, col = "red", lwd = 2, lty = 2)
abline(v = 5, col = "orange", lwd = 2, lty = 2)

# Add specific points
idx_1 <- which.min(abs(prevalence - 0.01))
idx_5 <- which.min(abs(prevalence - 0.05))
idx_10 <- which.min(abs(prevalence - 0.10))
idx_20 <- which.min(abs(prevalence - 0.20))

points(c(1, 5, 10, 20),
  c(ppv[idx_1], ppv[idx_5], ppv[idx_10], ppv[idx_20]) * 100,
  pch = 19, cex = 2, col = "darkred")

text(1, ppv[idx_1] * 100,
  paste0("1% prevalence\nPPV = ", round(ppv[idx_1] * 100, 1), "%"),
  pos = 4, cex = 1.0, font = 2)

text(20, 50, "PPV = 50%\n(half are false positives)", pos = 4, cex = 1.0,
  font = 2)

dev.off()

# ============================================================================
# 10. Simulated Proteomics Data - Volcano Plot
# ============================================================================
png("proteomics_figures/10_volcano_plot.png",
  width = 800, height = 600, res = 100)
par(mar = c(5, 5, 4, 2))

# Simulate proteomics differential expression data
n_proteins <- 2000
n_de <- 200  # Differentially expressed

# Log fold changes
log_fc <- c(
  rnorm(n_de/2, mean = -2, sd = 0.5),  # Down-regulated
  rnorm(n_de/2, mean = 2, sd = 0.5),   # Up-regulated
  rnorm(n_proteins - n_de, mean = 0, sd = 0.3)  # Not DE
)

# P-values
p_values_volcano <- c(
  10^(-runif(n_de, min = 2, max = 10)),  # DE proteins (small p-values)
  runif(n_proteins - n_de, min = 0.05, max = 1)  # Not DE
)

# Adjust p-values (FDR)
adj_p <- p.adjust(p_values_volcano, method = "BH")

# Classify proteins
colors <- ifelse(adj_p < 0.05 & log_fc > 1, "red",
  ifelse(adj_p < 0.05 & log_fc < -1, "blue", "gray"))

plot(log_fc, -log10(p_values_volcano), pch = 20, cex = 0.8, col = colors,
  xlab = "Log2 Fold Change", ylab = "-Log10(P-value)",
  main = "Volcano Plot: Differential Protein Expression",
  cex.lab = 1.2, cex.main = 1.3)

# Add threshold lines
abline(h = -log10(0.05), col = "black", lwd = 2, lty = 2)
abline(v = c(-1, 1), col = "black", lwd = 2, lty = 2)

# Add legend
legend("topright",
  legend = c("Up-regulated (FDR<0.05, FC>2)",
    "Down-regulated (FDR<0.05, FC<0.5)",
    "Not significant"),
  col = c("red", "blue", "gray"), pch = 20, cex = 1.0)

# Add counts
n_up <- sum(colors == "red")
n_down <- sum(colors == "blue")
#text(0, max(-log10(p_values_volcano)) * 0.95,
#  paste0(n_up, " up, ", n_down, " down"), cex = 1.2, font = 2)

dev.off()

# ============================================================================
# 11. P-value Histogram (Diagnostic)
# ============================================================================
png("proteomics_figures/11_pvalue_histogram.png",
  width = 800, height = 600, res = 100)
par(mar = c(5, 5, 4, 2))

hist(p_values_volcano, breaks = 50, col = "lightblue", border = "white",
  xlab = "P-value", ylab = "Frequency",
  main = "P-value Distribution: Diagnostic Plot",
  cex.lab = 1.2, cex.main = 1.3)

# Add expected uniform distribution line for true nulls
abline(h = length(p_values_volcano) / 50, col = "red", lwd = 2, lty = 2)

text(0.7, max(hist(p_values_volcano, breaks = 50, plot = FALSE)$counts) * 0.9,
  "Enrichment at low p-values\nindicates true signal", cex = 1.1, font = 2)

dev.off()
