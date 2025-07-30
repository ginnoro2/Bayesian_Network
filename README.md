# Structure Learning Labs

This repository contains three comprehensive labs for Bayesian Network Structure Learning using R and the `bnlearn` package.

## Lab Structure

### Lab 1: Structure Learning
**File**: `Lab1_Structure_Learning/lab1_structure_learning.R`

**Topics Covered**:
- Loading and exploring the `learning.test` dataset
- Hill-climbing algorithm for structure learning
- Tabu search algorithm for structure learning
- Network visualization and analysis
- Model string representation

**Questions Answered**:
1. Dataset exploration (variables, observations)
2. Hill-climbing structure learning and arc analysis
3. Network visualization and parent analysis
4. Tabu search comparison with hill-climbing
5. Model string representation

### Lab 2: Parameter Learning and Inference
**File**: `Lab2_Parameter_Learning_Inference/lab2_parameter_learning_inference.R`

**Topics Covered**:
- Parameter fitting (CPT estimation)
- Junction tree creation using gRain
- Marginal probability computation
- Evidence propagation and inference
- Posterior probability analysis

**Questions Answered**:
1. CPT fitting and display
2. Junction tree creation and marginal probabilities
3. Inference with single evidence
4. Inference with multiple evidence
5. Evidence effect analysis

### Lab 3: Custom BN & Model Evaluation
**File**: `Lab3_Custom_BN_Model_Evaluation/lab3_custom_bn_model_evaluation.R`

**Topics Covered**:
- Custom dataset creation
- Manual BN structure definition
- Cross-validation model evaluation
- Network structure metrics
- Markov blanket analysis

**Questions Answered**:
1. Custom dataset and manual structure creation
2. Parameter fitting and CPT analysis
3. Cross-validation with log-likelihood reporting
4. Network metrics computation
5. Markov blanket interpretation

## Requirements

### R Packages
Install the following R packages before running the labs:

```r
install.packages(c("bnlearn", "Rgraphviz", "gRain"))
```

### System Requirements
- R (version 3.6 or higher)
- Graphviz (for network visualization)
- Sufficient memory for large datasets

## How to Run

### Option 1: Run Individual Labs
Navigate to each lab folder and run the R script:

```bash
# Lab 1
cd Lab1_Structure_Learning
Rscript lab1_structure_learning.R

# Lab 2
cd Lab2_Parameter_Learning_Inference
Rscript lab2_parameter_learning_inference.R

# Lab 3
cd Lab3_Custom_BN_Model_Evaluation
Rscript lab3_custom_bn_model_evaluation.R
```

### Option 2: Run from R Console
Open R and source each script:

```r
# Lab 1
source("Lab1_Structure_Learning/lab1_structure_learning.R")

# Lab 2
source("Lab2_Parameter_Learning_Inference/lab2_parameter_learning_inference.R")

# Lab 3
source("Lab3_Custom_BN_Model_Evaluation/lab3_custom_bn_model_evaluation.R")
```

## Output Files

Each lab generates several output files:

### Lab 1 Outputs:
- `hc_network.pdf` - Hill-climbing network visualization
- `tabu_network.pdf` - Tabu search network visualization
- `hc_model_string.txt` - Hill-climbing model string
- `tabu_model_string.txt` - Tabu search model string

### Lab 2 Outputs:
- `fitted_bn.rds` - Fitted Bayesian network object
- Console output with CPTs and inference results

### Lab 3 Outputs:
- `manual_structure.pdf` - Manual BN structure visualization
- `fitted_manual_bn.rds` - Fitted manual network
- `cv_results.rds` - Cross-validation results
- `network_metrics.csv` - Network structure metrics

## Key Concepts Covered

### Structure Learning Algorithms
- **Hill-climbing**: Greedy search algorithm that iteratively improves the network structure
- **Tabu search**: Meta-heuristic that prevents cycling by maintaining a tabu list

### Parameter Learning
- **Maximum Likelihood Estimation**: Fits conditional probability tables to data
- **CPT (Conditional Probability Table)**: Represents conditional dependencies

### Inference
- **Junction Tree**: Efficient data structure for exact inference
- **Evidence Propagation**: Updating probabilities given observed evidence
- **Marginal Probability**: Probability distribution of individual variables

### Model Evaluation
- **Cross-validation**: Assesses model performance on unseen data
- **Log-likelihood**: Measures how well the model fits the data
- **Network Metrics**: Markov blanket, neighborhood size, branching factor

## Expected Results

### Lab 1:
- Dataset with 6 variables (A, B, C, D, E, F) and 5000 observations
- Hill-climbing typically finds 5-7 arcs
- Tabu search may find slightly different structure
- Variable with most parents varies by run

### Lab 2:
- CPTs showing conditional dependencies
- Marginal probabilities for all variables
- Evidence propagation showing probability changes
- Clear demonstration of how evidence affects posteriors

### Lab 3:
- Custom survey dataset with 5 variables
- Manual structure with 5 arcs based on domain knowledge
- Cross-validation log-likelihood scores
- Network metrics showing connectivity patterns

## Troubleshooting

### Common Issues:
1. **Package installation errors**: Ensure you have the latest R version
2. **Graphviz errors**: Install Graphviz system package
3. **Memory issues**: Reduce dataset size for large datasets
4. **Visualization errors**: Check if PDF files can be created in the directory

### Getting Help:
- Check R console for error messages
- Ensure all required packages are installed
- Verify file permissions for output directories

## Learning Objectives

By completing these labs, you will understand:
- How to learn Bayesian network structures from data
- How to fit parameters and perform inference
- How to evaluate model performance
- How to interpret network structures and dependencies
- How to use Bayesian networks for real-world applications

## Additional Resources

- `bnlearn` package documentation: https://www.bnlearn.com/
- `gRain` package documentation: https://cran.r-project.org/package=gRain
- Bayesian Networks tutorial: https://www.bnlearn.com/about/teaching/ 