#  Bayesian Network Structure Learning Labs

A comprehensive collection of three hands-on labs for learning Bayesian Network structure learning, parameter estimation, and inference using R and the `bnlearn` package.

##  Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Lab Structure](#lab-structure)
- [Quick Start](#quick-start)
- [Detailed Usage](#detailed-usage)
- [Expected Results](#expected-results)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

##  Overview

This repository contains three comprehensive labs that cover the complete workflow of Bayesian Network analysis:

- **Lab 1**: Structure Learning - Learn network structures from data
- **Lab 2**: Parameter Learning & Inference - Fit parameters and perform inference
- **Lab 3**: Custom BN & Model Evaluation - Create custom networks and evaluate performance

Each lab includes hands-on exercises with real data analysis, visualization, and interpretation of results.

## System Requirements
- **R** (version 4.0 or higher)
- **RStudio** (recommended for better experience)
- **Git** (for cloning the repository)
- **Graphviz** (optional, for network visualization)

### Operating System Support
- macOS (tested on macOS 12+)
- Linux (Ubuntu 18.04+, CentOS 7+)
- Windows 10/11 (with Rtools)

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/structure-learning-labs.git
cd structure-learning-labs
```

### 2. Install R Dependencies

#### Option A: Automatic Installation (Recommended)
```r
# Run the installation script
source("install_packages.R")
```

#### Option B: Manual Installation
```r
# Install required packages
install.packages(c("bnlearn", "gRain", "gRbase"), 
                repos = "https://cran.rstudio.com/")

# Optional: Install visualization packages
install.packages(c("Rgraphviz", "graph", "RBGL"), 
                repos = "https://cran.rstudio.com/")
```

### 3. Verify Installation

```r
# Test if packages load correctly
library(bnlearn)
library(gRain)
cat("All packages installed successfully!\n")
```

## Lab Structure

```
structure-learning-labs/
├── README.md                                    # This file
├── install_packages.R                           # Package installation script
├── run_all_labs.R                              # Master script to run all labs
├── Lab1_Structure_Learning/
│   └── lab1_structure_learning.R               # Lab 1: Structure Learning
├── Lab2_Parameter_Learning_Inference/
│   └── lab2_parameter_learning_inference.R     # Lab 2: Parameter Learning & Inference
└── Lab3_Custom_BN_Model_Evaluation/
    └── lab3_custom_bn_model_evaluation.R       # Lab 3: Custom BN & Model Evaluation
```

##  Quick Start

### Run All Labs at Once
```r
# Execute the master script
source("run_all_labs.R")
```

### Run Individual Labs
```r
# Lab 1: Structure Learning
source("Lab1_Structure_Learning/lab1_structure_learning.R")

# Lab 2: Parameter Learning & Inference
source("Lab2_Parameter_Learning_Inference/lab2_parameter_learning_inference.R")

# Lab 3: Custom BN & Model Evaluation
source("Lab3_Custom_BN_Model_Evaluation/lab3_custom_bn_model_evaluation.R")
```

### Command Line Execution
```bash
# Run from terminal
Rscript run_all_labs.R

# Or run individual labs
Rscript Lab1_Structure_Learning/lab1_structure_learning.R
Rscript Lab2_Parameter_Learning_Inference/lab2_parameter_learning_inference.R
Rscript Lab3_Custom_BN_Model_Evaluation/lab3_custom_bn_model_evaluation.R
```

## Detailed Usage

### Lab 1: Structure Learning

**Objective**: Learn Bayesian Network structures from data using different algorithms.

**Topics Covered**:
- Dataset exploration and analysis
- Hill-climbing algorithm implementation
- Tabu search algorithm comparison
- Network visualization and analysis
- Model string representation

**Key Commands**:
```r
# Load data
data(learning.test)

# Learn structure with hill-climbing
hc_bn <- hc(learning.test)

# Learn structure with tabu search
tabu_bn <- tabu(learning.test)

# Visualize network
graphviz.plot(hc_bn)

# Get model string
modelstring(hc_bn)
```

**Expected Outputs**:
- Network visualizations (PDF files)
- Model string representations
- Arc comparisons between algorithms

### Lab 2: Parameter Learning & Inference

**Objective**: Fit parameters to learned structures and perform probabilistic inference.

**Topics Covered**:
- Conditional Probability Table (CPT) estimation
- Junction tree compilation
- Marginal probability computation
- Evidence propagation
- Posterior probability analysis

**Key Commands**:
```r
# Fit parameters
fitted_bn <- bn.fit(hc_bn, learning.test)

# Convert to junction tree
junction_tree <- as.grain(fitted_bn)
compiled_jt <- compile(junction_tree)

# Perform inference
marginal_b <- querygrain(compiled_jt, nodes = "B")
evidence_a <- setEvidence(compiled_jt, nodes = "A", states = "a")
b_given_a <- querygrain(evidence_a, nodes = "B")
```

**Expected Outputs**:
- CPTs for all variables
- Marginal probabilities
- Evidence propagation results

### Lab 3: Custom BN & Model Evaluation

**Objective**: Create custom Bayesian Networks and evaluate model performance.

**Topics Covered**:
- Custom dataset creation
- Manual structure definition
- Cross-validation evaluation
- Network metrics computation
- Markov blanket analysis

**Key Commands**:
```r
# Create custom structure
manual_structure <- empty.graph(nodes = names(survey_data))
manual_structure <- set.arc(manual_structure, from = "Education", to = "Income")

# Fit custom model
fitted_manual_bn <- bn.fit(manual_structure, survey_data)

# Cross-validation
cv_results <- bn.cv(survey_data, manual_structure, k = 10, runs = 5)

# Network metrics
mb_sizes <- sapply(nodes(manual_structure), function(node) {
  length(mb(manual_structure, node))
})
```

**Expected Outputs**:
- Custom network visualizations
- Cross-validation scores
- Network metrics summary

## Expected Results

### Lab 1 Results
- **Dataset**: 6 variables (A-F), 5,000 observations
- **Hill-climbing**: Typically 5-7 arcs
- **Tabu search**: Similar structure, may differ slightly
- **Visualization**: Network graphs showing dependencies

### Lab 2 Results
- **CPTs**: Conditional probability tables for all variables
- **Marginal probabilities**: Prior distributions
- **Evidence effects**: Posterior probability changes
- **Inference**: Evidence propagation through network

### Lab 3 Results
- **Custom dataset**: 5 variables, 1,000 observations
- **Manual structure**: 5 arcs based on domain knowledge
- **Cross-validation**: Log-likelihood scores
- **Network metrics**: Markov blanket, neighborhood sizes

## Troubleshooting

### Common Issues

#### 1. Package Installation Errors
```r
# Solution: Use specific CRAN mirror
install.packages("bnlearn", repos = "https://cran.rstudio.com/")
```

#### 2. Rgraphviz Not Available
```bash
# macOS: Install via Homebrew
brew install graphviz

# Ubuntu/Debian
sudo apt-get install graphviz

# Windows: Download from graphviz.org
```

#### 3. Memory Issues
```r
# Increase memory limit
memory.limit(size = 8000)
```

#### 4. Visualization Errors
```r
# Check if Rgraphviz is available
if(require(Rgraphviz, quietly = TRUE)) {
  # Proceed with visualization
} else {
  # Skip visualization
  cat("Rgraphviz not available - plots skipped\n")
}
```

### Error Messages and Solutions

| Error | Solution |
|-------|----------|
| `trying to use CRAN without setting a mirror` | Use `repos = "https://cran.rstudio.com/"` |
| `there is no package called 'bnlearn'` | Run `install_packages.R` first |
| `variable is not supported in bnlearn` | Convert to factors: `as.factor(data$variable)` |
| `Error in data.type(x)` | Ensure all variables are factors or numeric |

## 📈 Performance Tips

### For Large Datasets
```r
# Use sampling for large datasets
sample_data <- learning.test[sample(nrow(learning.test), 1000), ]

# Use faster algorithms
fast_hc <- hc(sample_data, score = "bic")
```

### For Better Visualization
```r
# Install additional visualization packages
install.packages(c("igraph", "networkD3"))

# Use interactive plots
library(networkD3)
# Convert bnlearn object to igraph and then to networkD3
```

## Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Contribution Guidelines
- Add comments to your code
- Include example outputs
- Update documentation
- Test on multiple R versions

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **bnlearn package**: Marco Scutari and Robert Ness
- **gRain package**: Søren Højsgaard
- **R community**: For continuous support and improvements

## Support

If you encounter any issues:

1. **Check** the troubleshooting section above
2. **Search** existing issues on GitHub
3. **Create** a new issue with detailed information

### Issue Template
```markdown
**Environment:**
- R version: 
- Operating system: 
- Package versions: 

**Error:**
```
[Paste error message here]
```

**Expected behavior:**
[Describe what you expected to happen]

**Steps to reproduce:**
1. 
2. 
3. 
```

---
