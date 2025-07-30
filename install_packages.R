# Installation Script for Structure Learning Labs
# This script installs all required R packages

cat("=== Installing Required Packages for Structure Learning Labs ===\n")

# List of required packages
required_packages <- c(
  "bnlearn",      # Bayesian network structure learning and inference
  "Rgraphviz",    # Graph visualization
  "gRain",        # Graphical independence networks
  "graph",        # Graph package (dependency of Rgraphviz)
  "RBGL"          # R interface to BOOST graph library
)

cat("Required packages:\n")
for(pkg in required_packages) {
  cat("  -", pkg, "\n")
}

cat("\nChecking which packages are already installed...\n")

# Check which packages are already installed
installed_packages <- installed.packages()[,"Package"]
missing_packages <- required_packages[!required_packages %in% installed_packages]

if(length(missing_packages) == 0) {
  cat("✓ All required packages are already installed!\n")
} else {
  cat("Missing packages:", paste(missing_packages, collapse = ", "), "\n")
  cat("Installing missing packages...\n")
  
  # Install missing packages
  for(pkg in missing_packages) {
    cat("Installing", pkg, "...\n")
    tryCatch({
      install.packages(pkg, dependencies = TRUE)
      cat("✓", pkg, "installed successfully\n")
    }, error = function(e) {
      cat("✗ Failed to install", pkg, ":", e$message, "\n")
    })
  }
}

cat("\nLoading packages to verify installation...\n")

# Try to load each package
load_errors <- c()
for(pkg in required_packages) {
  tryCatch({
    library(pkg, character.only = TRUE)
    cat("✓", pkg, "loaded successfully\n")
  }, error = function(e) {
    cat("✗ Failed to load", pkg, ":", e$message, "\n")
    load_errors <- c(load_errors, pkg)
  })
}

if(length(load_errors) == 0) {
  cat("\n🎉 All packages installed and loaded successfully!\n")
  cat("You can now run the labs using:\n")
  cat("  source('run_all_labs.R')\n")
} else {
  cat("\n⚠️  Some packages failed to load:", paste(load_errors, collapse = ", "), "\n")
  cat("Please check your R installation and try again.\n")
}

cat("\nInstallation check completed at:", Sys.time(), "\n") 