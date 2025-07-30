# Lab 2: Parameter Learning and Inference
# Bayesian Network Parameter Learning and Inference using bnlearn and gRain

# Load required libraries
library(bnlearn)
library(gRain)

# Check if Rgraphviz is available
if(require(Rgraphviz, quietly = TRUE)) {
  library(Rgraphviz)
  can_plot <- TRUE
} else {
  can_plot <- FALSE
  cat("Rgraphviz not available - plots will be skipped\n")
}

# Load the dataset and learn structure (reusing from Lab 1)
cat("=== Loading Data and Learning Structure ===\n")
data(learning.test)
cat("Dataset loaded: learning.test\n")

# Learn structure using hill-climbing (from Lab 1)
hc_bn <- hc(learning.test)
cat("Structure learned using hill-climbing\n")
cat("Number of arcs:", nrow(arcs(hc_bn)), "\n\n")

# Q1. Fit the parameters (CPTs) of the structure obtained from Lab 1
# Display the CPT for a selected variable (e.g., A)

cat("=== Q1. Parameter Learning (CPT Fitting) ===\n")
# Fit the parameters using maximum likelihood estimation
fitted_bn <- bn.fit(hc_bn, learning.test)
cat("Parameters fitted using maximum likelihood estimation\n")

# Display CPT for variable A
cat("Conditional Probability Table (CPT) for variable A:\n")
print(fitted_bn$A)

# Display CPTs for all variables
cat("\nCPTs for all variables:\n")
for(var in names(fitted_bn)) {
  cat("\nCPT for variable", var, ":\n")
  print(fitted_bn[[var]])
}

# Save fitted network
saveRDS(fitted_bn, "Lab2_Parameter_Learning_Inference/fitted_bn.rds")
cat("\nFitted network saved to 'fitted_bn.rds'\n\n")

# Q2. Using gRain, convert your fitted BN into a junction tree for inference
# What is the marginal probability of variable B?

cat("=== Q2. Junction Tree Creation and Marginal Probability ===\n")
# Convert bnlearn object to gRain format
junction_tree <- as.grain(fitted_bn)
cat("Bayesian network converted to junction tree for inference\n")

# Compile the junction tree
compiled_jt <- compile(junction_tree)
cat("Junction tree compiled successfully\n")

# Get marginal probability of variable B
marginal_b <- querygrain(compiled_jt, nodes = "B")
cat("Marginal probability of variable B:\n")
print(marginal_b$B)

# Get marginal probabilities for all variables
cat("\nMarginal probabilities for all variables:\n")
all_marginals <- querygrain(compiled_jt, nodes = names(fitted_bn))
for(var in names(all_marginals)) {
  cat("\nMarginal probability of", var, ":\n")
  print(all_marginals[[var]])
}
cat("\n")

# Q3. Perform inference with evidence:
# What is the probability distribution of B given A = a?

cat("=== Q3. Inference with Evidence: B given A = a ===\n")
# Set evidence: A = a
evidence_a <- setEvidence(compiled_jt, nodes = "A", states = "a")
cat("Evidence set: A = a\n")

# Query probability distribution of B given A = a
b_given_a <- querygrain(evidence_a, nodes = "B")
cat("Probability distribution of B given A = a:\n")
print(b_given_a$B)

# Compare with prior (marginal) probability of B
cat("\nComparison - Prior vs Posterior:\n")
cat("Prior probability of B:\n")
print(marginal_b$B)
cat("Posterior probability of B given A = a:\n")
print(b_given_a$B)
cat("\n")

# Q4. Change the evidence to A = b and C = c
# How does the probability of B change?

cat("=== Q4. Inference with Multiple Evidence: B given A = b and C = c ===\n")
# Set evidence: A = b and C = c
evidence_ab_c <- setEvidence(compiled_jt, nodes = c("A", "C"), states = c("b", "c"))
cat("Evidence set: A = b and C = c\n")

# Query probability distribution of B given A = b and C = c
b_given_ab_c <- querygrain(evidence_ab_c, nodes = "B")
cat("Probability distribution of B given A = b and C = c:\n")
print(b_given_ab_c$B)

# Compare all three scenarios
cat("\n=== Comparison of B's probability under different evidence ===\n")
cat("1. Prior probability of B:\n")
print(marginal_b$B)
cat("\n2. Posterior probability of B given A = a:\n")
print(b_given_a$B)
cat("\n3. Posterior probability of B given A = b and C = c:\n")
print(b_given_ab_c$B)

# Calculate changes
cat("\n=== Changes in B's probability ===\n")
cat("Change from prior to B|A=a:\n")
change_1 <- b_given_a$B - marginal_b$B
print(change_1)

cat("\nChange from prior to B|A=b,C=c:\n")
change_2 <- b_given_ab_c$B - marginal_b$B
print(change_2)

cat("\nChange from B|A=a to B|A=b,C=c:\n")
change_3 <- b_given_ab_c$B - b_given_a$B
print(change_3)
cat("\n")

# Q5. Explain how evidence affects posterior distributions in Bayesian networks
# using your results

cat("=== Q5. Analysis of Evidence Effects ===\n")
cat("Evidence Propagation Analysis:\n\n")

# Analyze the effects systematically
cat("1. Prior vs Single Evidence (A = a):\n")
cat("   - Prior probability of B:", paste(round(marginal_b$B, 4), collapse = ", "), "\n")
cat("   - Posterior probability of B given A = a:", paste(round(b_given_a$B, 4), collapse = ", "), "\n")
cat("   - Maximum change:", max(abs(change_1)), "in state", names(which.max(abs(change_1))), "\n\n")

cat("2. Prior vs Multiple Evidence (A = b, C = c):\n")
cat("   - Posterior probability of B given A = b, C = c:", paste(round(b_given_ab_c$B, 4), collapse = ", "), "\n")
cat("   - Maximum change:", max(abs(change_2)), "in state", names(which.max(abs(change_2))), "\n\n")

cat("3. Single vs Multiple Evidence:\n")
cat("   - Change from B|A=a to B|A=b,C=c:", paste(round(change_3, 4), collapse = ", "), "\n")
cat("   - Maximum change:", max(abs(change_3)), "in state", names(which.max(abs(change_3))), "\n\n")

cat("Key Insights:\n")
cat("- Evidence propagates through the network structure\n")
cat("- Multiple evidence can have stronger effects than single evidence\n")
cat("- The direction and magnitude of changes depend on the network structure\n")
cat("- Variables connected to the evidence nodes show the strongest changes\n")

# Additional analysis: Test different evidence combinations
cat("\n=== Additional Evidence Analysis ===\n")
# Test evidence on different variables
for(var in c("C", "D", "E", "F")) {
  if(var %in% names(fitted_bn)) {
    # Get states for this variable
    states <- names(fitted_bn[[var]]$prob)
    if(length(states) > 0) {
      # Set evidence to first state
      evidence_test <- setEvidence(compiled_jt, nodes = var, states = states[1])
      b_given_evidence <- querygrain(evidence_test, nodes = "B")
      cat("B given", var, "=", states[1], ":", paste(round(b_given_evidence$B, 4), collapse = ", "), "\n")
    }
  }
}

cat("\n=== Lab 2 Complete ===\n")
cat("All results have been saved to the Lab2_Parameter_Learning_Inference folder\n") 