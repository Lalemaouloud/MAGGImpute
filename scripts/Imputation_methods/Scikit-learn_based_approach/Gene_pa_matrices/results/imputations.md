## descriptions of script imputation-methods.py : This script perform various scikit-learn imputation methods.

## Table of Contents
- [Imputation Methods for MAGs Data](#imputation-methods-for-mags-data)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Imputation Methods](#imputation-methods)
  - [Example](#example)
  - [Contributing](#contributing)
  - [License](#license)

## Features
- Implements multiple imputation methods:
  - Simple Imputer
  - Bayesian Ridge Regressor
  - Decision Tree Regressor
  - Extra Trees Regressor
  - K-Neighbors Regressor
  - KNN Imputer
- Uses `argparse` for flexible command-line arguments.
- Generates output matrices with imputed values.

## Installation
1. Clone the repository or download the files.
2. Create and activate a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows, use `venv\Scripts\activate`
   ```
3. Install the required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Usage
The script can be executed by providing the necessary command-line arguments.

### Command-Line Arguments
- `--method`: The imputation method to use. Options:
  - `SimpleImputer`
  - `BayesianRidge`
  - `DecisionTreeRegressor`
  - `ExtraTreesRegressor`
  - `KNeighborsRegressor`
  - `KNNImputer`
- `--input-reference`: Path to the reference matrix CSV file.
- `--input-simulated`: Path to the simulated MAGs matrix CSV file.
- `--output`: Path to the output CSV file.

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
python your_script.py --method BayesianRidge --input-reference gene_pa_SP_Before_simulation.csv --input-simulated gene_pa_SP_After_simulation.csv --output BayesianRidge_Imatrix_1.csv
```

### Using the Script in a Jupyter Notebook
You can also simulate command-line arguments in a Jupyter notebook like this:

```python
import sys

# Simulate command-line arguments
sys.argv = ['notebook', '--method', 'BayesianRidge',
            '--input-reference', 'gene_pa_SP_Before_simulation.csv',
            '--input-simulated', 'gene_pa_SP_After_simulation.csv',
            '--output', 'BayesianRidge_Imatrix_1.csv']

# Call the main function (assuming it is defined in the notebook)
main()
```

### Contributing
Contributions are welcome! Please open a pull request or issue if you want to contribute or report a bug.

### License
This project is licensed under the MIT License. See the `LICENSE` file for more information.
```

### Additional Steps

1. **Save as `README.md`**:
   - Create a new file named `README.md` in your project directory and copy the above content into it.

2. **Include a `requirements.txt` File**:
   - This file should list all the necessary dependencies for your project. Here's an example:

```txt
numpy
pandas
scikit-learn
```

3. **Add the `LICENSE` File**:
   - If using the MIT license, you can create a `LICENSE` file with the following content:

```text
MIT License

Copyright (c) [YEAR] [YOUR NAME]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

Replace `[YEAR]` and `[YOUR NAME]` with appropriate values.
