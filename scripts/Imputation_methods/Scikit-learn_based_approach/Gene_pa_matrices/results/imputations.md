## Descriptions of the imputation-methods.py script : This script perform various scikit-learn imputation methods.

## Table of Contents
- [Imputation Methods for MAGs Data](#imputation-methods-for-mags-data)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Usage](#usage)
  - [Imputation Methods](#imputation-methods)
  - [Example](#example)

## Features
- Implements multiple imputation methods:
  - Simple Imputer
  - Bayesian Ridge Regressor
  - Decision Tree Regressor
  - Extra Trees Regressor
  - K-Neighbors Regressor
  - KNN Imputer
- Uses we added `argparse` for flexible command-line arguments.
- Generates output matrices with imputed values.

## Usage
This script can be executed by providing the necessary command-line arguments.

### Command-Line Arguments
- `--method`: The imputation method to use. Options:
  - `SimpleImputer`
  - `BayesianRidge`
  - `DecisionTreeRegressor`
  - `ExtraTreesRegressor`
  - `KNeighborsRegressor`
  - `KNNImputer`
- `--input-reference`: Path to the reference genes presence/absence matrix CSV file.
- `--input-simulated`: Path to the simulated MAGs's queried genes presence/absence matrix CSV file.
- `--output`: Path to the desired output CSV file (choose the name of your final imputed csv file). 

### Imputation Methods
- **Simple Imputer**: Uses the most frequent strategy.
- **Bayesian Ridge Regressor**: Multivariate imputation using Bayesian Ridge Regression.
- **Decision Tree Regressor**: Decision Tree-based imputation.
- **Extra Trees Regressor**: Extra Trees Regressor for iterative imputation.
- **K-Neighbors Regressor**: Uses K-Nearest Neighbors to impute missing values.
- **KNN Imputer**: Similar to K-Neighbors Regressor but with additional distance weighting.

### Example
Run the script using the following command (replace `your_script.py` with your actual script name):

```bash
 python3 scikit_learn_V2.py  --method DecisionTreeRegressor  --input-reference ref.csv --input-simulated mags.csv --output DTR_Imputed_Mags.csv
```
