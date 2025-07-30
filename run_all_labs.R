# Master Script: Run All Structure Learning Labs
# This script runs all three labs sequentially and provides a summary

cat("=== Structure Learning Labs - Master Script ===\n")
cat("Starting execution of all labs...\n\n")

# Function to run a lab and capture output
run_lab <- function(lab_name, script_path) {
  cat("=== Running", lab_name, "===\n")
  cat("Script:", script_path, "\n")
  cat("Timestamp:", Sys.time(), "\n\n")
  
  # Source the lab script
  tryCatch({
    source(script_path)
    cat("\n", lab_name, "completed successfully!\n")
    return(TRUE)
  }, error = function(e) {
    cat("Error in", lab_name, ":", e$message, "\n")
    return(FALSE)
  })
}

# Check if required packages are installed
required_packages <- c("bnlearn", "Rgraphviz", "gRain")
missing_packages <- required_packages[!required_packages %in% installed.packages()[,"Package"]]

if(length(missing_packages) > 0) {
  cat("Installing missing packages:", paste(missing_packages, collapse = ", "), "\n")
  install.packages(missing_packages)
}

# Load required libraries
library(bnlearn)
library(Rgraphviz)
library(gRain)

cat("All required packages loaded successfully!\n\n")

# Run Lab 1
lab1_success <- run_lab("Lab 1: Structure Learning", 
                        "Lab1_Structure_Learning/lab1_structure_learning.R")

# Run Lab 2
lab2_success <- run_lab("Lab 2: Parameter Learning and Inference", 
                        "Lab2_Parameter_Learning_Inference/lab2_parameter_learning_inference.R")

# Run Lab 3
lab3_success <- run_lab("Lab 3: Custom BN & Model Evaluation", 
                        "Lab3_Custom_BN_Model_Evaluation/lab3_custom_bn_model_evaluation.R")

# Summary
cat("\n=== EXECUTION SUMMARY ===\n")
cat("Lab 1 (Structure Learning):", if(lab1_success) "✓ COMPLETED" else "✗ FAILED", "\n")
cat("Lab 2 (Parameter Learning):", if(lab2_success) "✓ COMPLETED" else "✗ FAILED", "\n")
cat("Lab 3 (Model Evaluation):", if(lab3_success) "✓ COMPLETED" else "✗ FAILED", "\n")

if(all(c(lab1_success, lab2_success, lab3_success))) {
  cat("\n🎉 ALL LABS COMPLETED SUCCESSFULLY! 🎉\n")
  cat("Check the output files in each lab folder for results.\n")
} else {
  cat("\n⚠️  Some labs failed. Check error messages above.\n")
}

cat("\n=== OUTPUT FILES CREATED ===\n")

# List expected output files
expected_files <- list(
  "Lab1_Structure_Learning" = c("hc_network.pdf", "tabu_network.pdf", 
                                "hc_model_string.txt", "tabu_model_string.txt"),
  "Lab2_Parameter_Learning_Inference" = c("fitted_bn.rds"),
  "Lab3_Custom_BN_Model_Evaluation" = c("manual_structure.pdf", "fitted_manual_bn.rds", 
                                        "cv_results.rds", "network_metrics.csv")
)

for(folder in names(expected_files)) {
  cat("\n", folder, ":\n")
  for(file in expected_files[[folder]]) {
    file_path <- file.path(folder, file)
    if(file.exists(file_path)) {
      cat("  ✓", file, "\n")
    } else {
      cat("  ✗", file, "(not found)\n")
    }
  }
}

cat("\n=== NEXT STEPS ===\n")
cat("1. Review the console output for detailed results\n")
cat("2. Check the generated PDF files for network visualizations\n")
cat("3. Examine the saved R objects for further analysis\n")
cat("4. Refer to the README.md for detailed explanations\n")

cat("\nExecution completed at:", Sys.time(), "\n") 