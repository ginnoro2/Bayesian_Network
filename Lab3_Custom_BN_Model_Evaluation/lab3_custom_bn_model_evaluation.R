# Lab 3: Custom BN & Model Evaluation
# Custom Bayesian Network Creation and Model Evaluation

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

# Q1. Using a survey dataset (or a custom dataset), manually define a BN structure
# Document the assumed dependencies

cat("=== Q1. Custom Dataset and Manual BN Structure ===\n")

# Create a custom survey dataset for education and employment
set.seed(123)
n <- 1000

# Generate synthetic survey data
education_levels <- c("High School", "Bachelor", "Master", "PhD")
age_groups <- c("18-25", "26-35", "36-45", "46+")
income_levels <- c("Low", "Medium", "High")
job_satisfaction <- c("Low", "Medium", "High")
work_hours <- c("Part-time", "Full-time", "Overtime")

# Create the dataset with realistic dependencies
survey_data <- data.frame(
  Education = sample(education_levels, n, replace = TRUE, prob = c(0.3, 0.4, 0.2, 0.1)),
  Age = sample(age_groups, n, replace = TRUE, prob = c(0.25, 0.35, 0.25, 0.15)),
  Income = sample(income_levels, n, replace = TRUE, prob = c(0.4, 0.4, 0.2)),
  JobSatisfaction = sample(job_satisfaction, n, replace = TRUE, prob = c(0.3, 0.5, 0.2)),
  WorkHours = sample(work_hours, n, replace = TRUE, prob = c(0.2, 0.6, 0.2))
)

# Add realistic dependencies
# Education affects Income
survey_data$Income[survey_data$Education == "PhD"] <- sample(income_levels, sum(survey_data$Education == "PhD"), 
                                                             replace = TRUE, prob = c(0.1, 0.3, 0.6))
survey_data$Income[survey_data$Education == "Master"] <- sample(income_levels, sum(survey_data$Education == "Master"), 
                                                               replace = TRUE, prob = c(0.2, 0.5, 0.3))
survey_data$Income[survey_data$Education == "Bachelor"] <- sample(income_levels, sum(survey_data$Education == "Bachelor"), 
                                                                 replace = TRUE, prob = c(0.3, 0.5, 0.2))
survey_data$Income[survey_data$Education == "High School"] <- sample(income_levels, sum(survey_data$Education == "High School"), 
                                                                   replace = TRUE, prob = c(0.6, 0.3, 0.1))

# Age affects Work Hours
survey_data$WorkHours[survey_data$Age == "18-25"] <- sample(work_hours, sum(survey_data$Age == "18-25"), 
                                                           replace = TRUE, prob = c(0.4, 0.5, 0.1))
survey_data$WorkHours[survey_data$Age == "46+"] <- sample(work_hours, sum(survey_data$Age == "46+"), 
                                                         replace = TRUE, prob = c(0.3, 0.6, 0.1))

# Income and Work Hours affect Job Satisfaction
survey_data$JobSatisfaction[survey_data$Income == "High" & survey_data$WorkHours == "Full-time"] <- 
  sample(job_satisfaction, sum(survey_data$Income == "High" & survey_data$WorkHours == "Full-time"), 
         replace = TRUE, prob = c(0.1, 0.3, 0.6))

# Convert all variables to factors for bnlearn compatibility
for(col in names(survey_data)) {
  survey_data[[col]] <- as.factor(survey_data[[col]])
}

cat("Custom survey dataset created with", nrow(survey_data), "observations\n")
cat("Variables:", paste(names(survey_data), collapse = ", "), "\n")
cat("Dataset structure:\n")
str(survey_data)
cat("\n")

# Manually define BN structure based on domain knowledge
cat("=== Manual BN Structure Definition ===\n")
cat("Assumed dependencies based on domain knowledge:\n")
cat("1. Education -> Income (higher education leads to higher income)\n")
cat("2. Age -> WorkHours (age affects work schedule preferences)\n")
cat("3. Income -> JobSatisfaction (income affects job satisfaction)\n")
cat("4. WorkHours -> JobSatisfaction (work hours affect job satisfaction)\n")
cat("5. Education -> WorkHours (education level may affect work schedule)\n\n")

# Create the manual structure
manual_structure <- empty.graph(nodes = names(survey_data))

# Add arcs based on assumed dependencies
manual_structure <- set.arc(manual_structure, from = "Education", to = "Income")
manual_structure <- set.arc(manual_structure, from = "Age", to = "WorkHours")
manual_structure <- set.arc(manual_structure, from = "Income", to = "JobSatisfaction")
manual_structure <- set.arc(manual_structure, from = "WorkHours", to = "JobSatisfaction")
manual_structure <- set.arc(manual_structure, from = "Education", to = "WorkHours")

cat("Manual BN structure created with", nrow(arcs(manual_structure)), "arcs:\n")
print(arcs(manual_structure))

# Visualize the manual structure if possible
if(can_plot) {
  pdf("Lab3_Custom_BN_Model_Evaluation/manual_structure.pdf")
  graphviz.plot(manual_structure, main = "Manual BN Structure - Survey Data")
  dev.off()
  cat("Manual structure plot saved as 'manual_structure.pdf'\n")
} else {
  cat("Manual structure visualization skipped (Rgraphviz not available)\n")
}
cat("\n")

# Q2. Fit the BN using bn.fit() and list all conditional probability tables (CPTs)

cat("=== Q2. Parameter Fitting and CPTs ===\n")
# Fit the parameters to the manual structure
fitted_manual_bn <- bn.fit(manual_structure, survey_data)
cat("Parameters fitted to manual structure\n")

# Display all CPTs
cat("Conditional Probability Tables (CPTs):\n")
for(var in names(fitted_manual_bn)) {
  cat("\nCPT for variable", var, ":\n")
  print(fitted_manual_bn[[var]])
}

# Save fitted network
saveRDS(fitted_manual_bn, "Lab3_Custom_BN_Model_Evaluation/fitted_manual_bn.rds")
cat("\nFitted network saved to 'fitted_manual_bn.rds'\n\n")

# Q3. Evaluate the model using a 10-fold cross-validation with bn.cv()
# Report the average log-likelihood

cat("=== Q3. Cross-Validation Model Evaluation ===\n")
# Perform 10-fold cross-validation
cv_results <- bn.cv(survey_data, manual_structure, k = 10, runs = 5)
cat("10-fold cross-validation completed with 5 runs\n")

# Extract log-likelihood scores
log_likelihood_scores <- sapply(cv_results, function(x) attr(x, "mean"))
cat("Log-likelihood scores for each run:\n")
print(log_likelihood_scores)

cat("Average log-likelihood across all runs:", mean(log_likelihood_scores), "\n")
cat("Standard deviation of log-likelihood:", sd(log_likelihood_scores), "\n")

# Save cross-validation results
saveRDS(cv_results, "Lab3_Custom_BN_Model_Evaluation/cv_results.rds")
cat("Cross-validation results saved to 'cv_results.rds'\n\n")

# Q4. Compute the average Markov blanket size, neighbourhood size, and branching factor
# using BN summary

cat("=== Q4. Network Structure Metrics ===\n")
# Get network summary
network_summary <- summary(manual_structure)
cat("Network summary:\n")
print(network_summary)

# Calculate specific metrics
cat("\nDetailed Network Metrics:\n")

# Markov blanket sizes
mb_sizes <- sapply(nodes(manual_structure), function(node) {
  length(mb(manual_structure, node))
})
cat("Markov blanket sizes:\n")
print(mb_sizes)
cat("Average Markov blanket size:", mean(mb_sizes), "\n")

# Neighborhood sizes (parents + children)
neighborhood_sizes <- sapply(nodes(manual_structure), function(node) {
  length(parents(manual_structure, node)) + length(children(manual_structure, node))
})
cat("Neighborhood sizes:\n")
print(neighborhood_sizes)
cat("Average neighborhood size:", mean(neighborhood_sizes), "\n")

# Branching factor (average number of children per node)
children_counts <- sapply(nodes(manual_structure), function(node) {
  length(children(manual_structure, node))
})
cat("Number of children per node:\n")
print(children_counts)
cat("Average branching factor:", mean(children_counts), "\n")

# Save metrics
metrics_summary <- data.frame(
  Variable = names(mb_sizes),
  Markov_Blanket_Size = mb_sizes,
  Neighborhood_Size = neighborhood_sizes,
  Children_Count = children_counts
)
write.csv(metrics_summary, "Lab3_Custom_BN_Model_Evaluation/network_metrics.csv", row.names = FALSE)
cat("Network metrics saved to 'network_metrics.csv'\n\n")

# Q5. How would you interpret the Markov blanket of the variable Education in your model?

cat("=== Q5. Markov Blanket Analysis for Education ===\n")
# Get Markov blanket of Education
education_mb <- mb(manual_structure, "Education")
cat("Markov blanket of Education:", paste(education_mb, collapse = ", "), "\n")

# Get parents and children of Education
education_parents <- parents(manual_structure, "Education")
education_children <- children(manual_structure, "Education")
education_spouses <- spouses(manual_structure, "Education")

cat("Parents of Education:", if(length(education_parents) > 0) paste(education_parents, collapse = ", ") else "None", "\n")
cat("Children of Education:", if(length(education_children) > 0) paste(education_children, collapse = ", ") else "None", "\n")
cat("Spouses of Education:", if(length(education_spouses) > 0) paste(education_spouses, collapse = ", ") else "None", "\n")

cat("\nInterpretation of Education's Markov Blanket:\n")
cat("1. The Markov blanket of Education contains all variables that are directly connected to it\n")
cat("2. In our model, Education has no parents (it's a root node)\n")
cat("3. Education has children: Income and WorkHours\n")
cat("4. Education's Markov blanket includes Income and WorkHours\n")
cat("5. This means that Education is conditionally independent of all other variables\n")
cat("   given its children (Income and WorkHours)\n")
cat("6. In practical terms: once we know a person's income and work hours,\n")
cat("   knowing their education level doesn't provide additional information\n")
cat("   about other variables in the network\n\n")

# Additional analysis: Compare with learned structure
cat("=== Additional Analysis: Manual vs Learned Structure ===\n")
# Learn structure from data for comparison
learned_structure <- hc(survey_data)
cat("Structure learned from data using hill-climbing:\n")
print(arcs(learned_structure))

# Compare structures
cat("\nComparison:\n")
cat("Manual structure arcs:", nrow(arcs(manual_structure)), "\n")
cat("Learned structure arcs:", nrow(arcs(learned_structure)), "\n")

# Find common arcs
manual_arcs <- arcs(manual_structure)
learned_arcs <- arcs(learned_structure)

manual_arcs_char <- apply(manual_arcs, 1, paste, collapse = " -> ")
learned_arcs_char <- apply(learned_arcs, 1, paste, collapse = " -> ")

common_arcs <- intersect(manual_arcs_char, learned_arcs_char)
cat("Common arcs between manual and learned structures:", length(common_arcs), "\n")
if(length(common_arcs) > 0) {
  print(common_arcs)
}

# Evaluate learned structure
learned_cv_results <- bn.cv(survey_data, learned_structure, k = 10, runs = 5)
learned_log_likelihood_scores <- sapply(learned_cv_results, function(x) attr(x, "mean"))
cat("\nLearned structure average log-likelihood:", mean(learned_log_likelihood_scores), "\n")
cat("Manual structure average log-likelihood:", mean(log_likelihood_scores), "\n")

if(mean(learned_log_likelihood_scores) > mean(log_likelihood_scores)) {
  cat("Learned structure performs better in terms of log-likelihood\n")
} else {
  cat("Manual structure performs better in terms of log-likelihood\n")
}

cat("\n=== Lab 3 Complete ===\n")
cat("All results have been saved to the Lab3_Custom_BN_Model_Evaluation folder\n") 