import argparse
import numpy as np
import pandas as pd
from sklearn.impute import SimpleImputer, KNNImputer
from sklearn.experimental import enable_iterative_imputer
from sklearn.impute import IterativeImputer
from sklearn.linear_model import BayesianRidge
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import ExtraTreesRegressor
from sklearn.neighbors import KNeighborsRegressor


def get_options():
    description = 'Imputation methods.'
    parser = argparse.ArgumentParser(description=description)

    IO = parser.add_argument_group('Input/Output options')
    IO.add_argument('--method',
                    choices=['SimpleImputer', 'BayesianRidge', 'DecisionTreeRegressor',
                             'ExtraTreesRegressor', 'KNeighborsRegressor', 'KNNImputer'],
                    required=True,
                    help='Choose an imputation method.')
    IO.add_argument('--input-reference', required=True, help='Path to the reference matrix CSV file.')
    IO.add_argument('--input-simulated', required=True, help='Path to the simulated MAGs matrix CSV file.')
    IO.add_argument('--output', required=True, help='Path to the output CSV file.')
    return parser.parse_args()

def main():
    args = get_options()

    reference_matrix = pd.read_csv(args.input_reference, index_col=0).T
    simulated_MAGs_matrix = pd.read_csv(args.input_simulated, index_col=0).T

    imputed_matrix = pd.DataFrame()
    mask = simulated_MAGs_matrix == 0
    simulated_MAGs_matrix[mask] = np.nan



    if args.method == 'SimpleImputer':
        for index, row in simulated_MAGs_matrix.iterrows():
            temporary_matrix = pd.concat([reference_matrix, row.to_frame().T])
            imputer = SimpleImputer(strategy='most_frequent')
            for column in temporary_matrix.columns:
                if temporary_matrix[column].isnull().any():
                    temporary_matrix[column] = imputer.fit_transform(temporary_matrix[[column]]).ravel()
            imputed_matrix = pd.concat([imputed_matrix, temporary_matrix.loc[[index]]])
        imputed_matrix = imputed_matrix.astype(int)

    elif args.method == 'BayesianRidge':
        def custom_round(x):
            return np.where(x >= 0.5, 1, 0)
        for index, row in simulated_MAGs_matrix.iterrows():
            temporary_matrix = pd.concat([reference_matrix, row.to_frame().T])
            iterative_imputer = IterativeImputer(estimator=BayesianRidge())
            for column in temporary_matrix.columns:
                if temporary_matrix[column].isnull().any():
                    temporary_matrix[column] = iterative_imputer.fit_transform(temporary_matrix[[column]])
            temporary_matrix = temporary_matrix.apply(custom_round)
            imputed_matrix = pd.concat([imputed_matrix, temporary_matrix.loc[[index]]])
        imputed_matrix = imputed_matrix.astype(int)

    elif args.method == 'DecisionTreeRegressor':
        for index, row in simulated_MAGs_matrix.iterrows():
            temporary_matrix = pd.concat([reference_matrix, row.to_frame().T])
            iterative_imputer = IterativeImputer(estimator = DecisionTreeRegressor(max_features='sqrt', random_state=0))
            for column in temporary_matrix.columns:
                if temporary_matrix[column].isnull().any():
                    temporary_matrix[column] = iterative_imputer.fit_transform(temporary_matrix[[column]]).ravel()
            temporary_matrix = temporary_matrix.round()
            imputed_matrix = pd.concat([imputed_matrix, temporary_matrix.loc[[index]]])
        imputed_matrix = imputed_matrix.astype(int)

    elif args.method == 'ExtraTreesRegressor':
        for index, row in simulated_MAGs_matrix.iterrows():
            temporary_matrix = pd.concat([reference_matrix, row.to_frame().T])
            iterative_imputer = IterativeImputer(estimator =ExtraTreesRegressor(n_estimators=180, random_state=0, n_jobs=-1))
            for column in temporary_matrix.columns:
                if temporary_matrix[column].isnull().any():
                    temporary_matrix[column] = iterative_imputer.fit_transform(temporary_matrix[[column]]).ravel()
            temporary_matrix = temporary_matrix.round()
            imputed_matrix = pd.concat([imputed_matrix, temporary_matrix.loc[[index]]])
        imputed_matrix = imputed_matrix.astype(int)

    elif args.method == 'KNeighborsRegressor':
        for index, row in simulated_MAGs_matrix.iterrows():
            temporary_matrix = pd.concat([reference_matrix, row.to_frame().T])
            estimator = KNeighborsRegressor(n_neighbors=1, weights='uniform')
            iterative_imputer = IterativeImputer(estimator=estimator, max_iter=150, random_state=0)
            for column in temporary_matrix.columns:
                if temporary_matrix[column].isnull().any():
                    temporary_matrix[column] = iterative_imputer.fit_transform(temporary_matrix[[column]]).ravel()
            temporary_matrix = temporary_matrix.round()
            imputed_matrix = pd.concat([imputed_matrix, temporary_matrix.loc[[index]]])
        imputed_matrix = imputed_matrix.astype(int)

    elif args.method == 'KNNImputer':
        iterative_imputer = KNNImputer(n_neighbors=1)
        for index, row in simulated_MAGs_matrix.iterrows():
            temporary_matrix = pd.concat([reference_matrix, row.to_frame().T])
            for column in temporary_matrix.columns:
                if temporary_matrix[column].isnull().any():
                    temporary_matrix[column] = iterative_imputer.fit_transform(temporary_matrix[[column]]).ravel()
            temporary_matrix = temporary_matrix.round()
            imputed_matrix = pd.concat([imputed_matrix, temporary_matrix.loc[[index]]])
        imputed_matrix = imputed_matrix.astype(int)

    #start_index = len(reference_matrix)
    imputed_simulated_MAGs_matrix = imputed_matrix.T
    imputed_simulated_MAGs_matrix.to_csv(args.output, index=True)

if __name__ == '__main__':
    main()


