# Lab 1: Structure Learning
# Bayesian Network Structure Learning using bnlearn package

# Load required libraries
library(bnlearn)

# Check if Rgraphviz is available
if(require(Rgraphviz, quietly = TRUE)) {
  library(Rgraphviz)
  can_plot <- TRUE
} else {
  can_plot <- FALSE
  cat("Rgraphviz not available - plots will be skipped\n")
}

# Q1. Load the built-in dataset learning.test
# What are the variables in this dataset? How many observations does it contain?

cat("=== Q1. Dataset Exploration ===\n")
data(learning.test)
cat("Dataset loaded: learning.test\n")
cat("Variables in the dataset:\n")
print(names(learning.test))
cat("Number of observations:", nrow(learning.test), "\n")
cat("Number of variables:", ncol(learning.test), "\n")
cat("Data structure:\n")
str(learning.test)
cat("\n")

# Q2. Learn the BN structure using the hill-climbing algorithm
# What are the arcs (edges) generated?

cat("=== Q2. Hill-Climbing Structure Learning ===\n")
# Learn structure using hill-climbing
hc_bn <- hc(learning.test)
cat("Hill-climbing algorithm completed\n")
cat("Number of arcs in the learned network:", nrow(arcs(hc_bn)), "\n")
cat("Arcs (edges) generated:\n")
print(arcs(hc_bn))
cat("\n")

# Q3. Visualize the learned BN structure
# Which variable has the highest number of parents?

cat("=== Q3. Network Visualization and Analysis ===\n")
# Plot the network if possible
if(can_plot) {
  pdf("Lab1_Structure_Learning/hc_network.pdf")
  graphviz.plot(hc_bn, main = "Bayesian Network - Hill Climbing")
  dev.off()
  cat("Network plot saved as 'hc_network.pdf'\n")
} else {
  cat("Network visualization skipped (Rgraphviz not available)\n")
}

# Calculate number of parents for each variable
parent_counts <- sapply(nodes(hc_bn), function(node) {
  length(parents(hc_bn, node))
})
cat("Number of parents for each variable:\n")
print(parent_counts)
max_parents <- which.max(parent_counts)
cat("Variable with highest number of parents:", names(max_parents), 
    "with", parent_counts[max_parents], "parents\n")
cat("\n")

# Q4. Try learning the network using the tabu algorithm
# How does the structure differ from hc?

cat("=== Q4. Tabu Search Structure Learning ===\n")
# Learn structure using tabu search
tabu_bn <- tabu(learning.test)
cat("Tabu search algorithm completed\n")
cat("Number of arcs in tabu network:", nrow(arcs(tabu_bn)), "\n")
cat("Arcs (edges) from tabu search:\n")
print(arcs(tabu_bn))
cat("\n")

# Compare structures
cat("=== Structure Comparison ===\n")
cat("Hill-climbing arcs:", nrow(arcs(hc_bn)), "\n")
cat("Tabu search arcs:", nrow(arcs(tabu_bn)), "\n")

# Find differences in arcs
hc_arcs <- arcs(hc_bn)
tabu_arcs <- arcs(tabu_bn)

# Convert to character for comparison
hc_arcs_char <- apply(hc_arcs, 1, paste, collapse = " -> ")
tabu_arcs_char <- apply(tabu_arcs, 1, paste, collapse = " -> ")

# Find arcs unique to each method
unique_to_hc <- setdiff(hc_arcs_char, tabu_arcs_char)
unique_to_tabu <- setdiff(tabu_arcs_char, hc_arcs_char)

cat("Arcs unique to hill-climbing:\n")
if(length(unique_to_hc) > 0) {
  print(unique_to_hc)
} else {
  cat("None\n")
}

cat("Arcs unique to tabu search:\n")
if(length(unique_to_tabu) > 0) {
  print(unique_to_tabu)
} else {
  cat("None\n")
}

# Plot tabu network for comparison if possible
if(can_plot) {
  pdf("Lab1_Structure_Learning/tabu_network.pdf")
  graphviz.plot(tabu_bn, main = "Bayesian Network - Tabu Search")
  dev.off()
  cat("Tabu network plot saved as 'tabu_network.pdf'\n")
} else {
  cat("Tabu network visualization skipped (Rgraphviz not available)\n")
}
cat("\n")

# Q5. Export the BN model as a string
# What is the model string representation?

cat("=== Q5. Model String Representation ===\n")
# Export hill-climbing model as string
hc_model_string <- modelstring(hc_bn)
cat("Hill-climbing model string representation:\n")
cat(hc_model_string, "\n\n")

# Export tabu model as string
tabu_model_string <- modelstring(tabu_bn)
cat("Tabu search model string representation:\n")
cat(tabu_model_string, "\n\n")

# Save models to files
writeLines(hc_model_string, "Lab1_Structure_Learning/hc_model_string.txt")
writeLines(tabu_model_string, "Lab1_Structure_Learning/tabu_model_string.txt")
cat("Model strings saved to files\n")

# Additional analysis: Network properties
cat("=== Additional Network Analysis ===\n")
cat("Hill-climbing network properties:\n")
print(summary(hc_bn))

cat("\nTabu search network properties:\n")
print(summary(tabu_bn))

cat("\n=== Lab 1 Complete ===\n")
cat("All results have been saved to the Lab1_Structure_Learning folder\n") 