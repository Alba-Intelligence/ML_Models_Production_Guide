---
title: "Data Loading and Exploration"
---

# Data Loading and Exploration

> This notebook demonstrates how to load and explore data for ML projects.

In a real ML deployment project, this would typically involve:
- Loading data from various sources (databases, APIs, files)
- Performing exploratory data analysis (EDA)
- Data cleaning and preprocessing
- Feature engineering
- Splitting data into train/validation/test sets

---

## Setup

First, let's import the necessary libraries.

::: {#d4f4a1ea .cell export='null'}
``` {.python .cell-code}
import pandas as pd
import numpy as np
```
:::


## Creating Sample Data

For demonstration purposes, we'll create a simple dataset.

::: {#4e8b5021 .cell export='null'}
``` {.python .cell-code}
# Create sample data
data = {
    'feature_1': np.random.randn(100),
    'feature_2': np.random.randn(100) * 2 + 1,
    'feature_3': np.random.randn(100) * 0.5,
    'target': (np.random.randn(100) > 0).astype(int)
}
df = pd.DataFrame(data)

print(f"Dataset shape: {df.shape}")
print(df.head())
```
:::


## Basic Data Exploration

Let's look at basic statistics.

::: {#cefea5dc .cell export='null'}
``` {.python .cell-code}
df.describe()
```
:::


## Check for Missing Values

It's important to check for missing values in real datasets.

::: {#ac3fc1d1 .cell export='null'}
``` {.python .cell-code}
missing_values = df.isnull().sum()
print("Missing values per column:")
print(missing_values)
print(f"Total missing values: {missing_values.sum()}")
```
:::


## Target Variable Distribution

Let's examine the distribution of our target variable.

::: {#e6236e07 .cell export='null'}
``` {.python .cell-code}
target_counts = df['target'].value_counts()
print("Target distribution:")
print(target_counts)
print(f"\nClass balance: {target_counts[0]/len(df):.2%} negative, {target_counts[1]/len(df):.2%} positive")
```
:::


## Data Preprocessing

Now let's prepare our data for modeling by splitting and scaling.

::: {#7ae5fc91 .cell export='null'}
``` {.python .cell-code}
# Separate features and target
X = df.drop('target', axis=1)
y = df['target']

# Split into train and test sets
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

print("Training set size: " + str(X_train.shape))
print("Test set size: " + str(X_test.shape))
```
:::


## Feature Scaling

Many ML algorithms perform better when features are scaled.

::: {#c39ea4dd .cell export='null'}
``` {.python .cell-code}
# Initialize scaler
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()

# Fit on training data and transform both train and test
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Convert back to DataFrame for convenience
X_train_scaled = pd.DataFrame(X_train_scaled, columns=X.columns, index=X_train.index)
X_test_scaled = pd.DataFrame(X_test_scaled, columns=X.columns, index=X_test.index)

print("Feature scaling completed.")
print(f"Training data mean: {X_train_scaled.mean().mean():.2f}, std: {X_train_scaled.std().mean():.2f}")
```
:::


## Summary

In this notebook, we've:
1. Created a sample dataset
2. Performed basic exploratory data analysis
3. Checked for missing values
4. Examined target distribution
5. Split data into train/test sets
6. Applied feature scaling

The processed data is now ready for model training, which we'll cover in the next notebook.

---

*This notebook exports functions and variables that can be used in other notebooks.*

