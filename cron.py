import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Load the dataset
df = pd.read_excel('/content/score result (2).xlsx')

# Define function to calculate Cronbach's Alpha
def cronbach_alpha(df):
    # Step 1: Compute correlation matrix
    df_corr = df.corr()
    
    # Step 2: Get the number of variables (items)
    N = df.shape[1]

    # Step 3: Compute average inter-item correlation (mean_r)
    rs = np.array([])
    for i, col in enumerate(df_corr.columns):
        sum_ = df_corr[col][i+1:].values
        rs = np.append(rs, sum_)
    mean_r = np.mean(rs)

    # Step 4: Calculate Cronbach's Alpha
    alpha = (N * mean_r) / (1 + (N - 1) * mean_r)
    print("Cronbach's Alpha:", alpha)

# Call the function
cronbach_alpha(df)
