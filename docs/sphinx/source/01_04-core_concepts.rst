---
title: "Core Package and MLflow XGBoost Quickstart"
---
# Core Package and MLflow XGBoost Quickstart

> Core package metadata plus a practical MLflow + XGBoost tracking example.

This notebook defines core package metadata and a practical MLflow + XGBoost quickstart.


## MLflow + XGBoost example

The example below follows the MLflow XGBoost autologging pattern and shows a complete traditional-ML flow.

```{python}
#| eval: false
__author__ = """ML Engineer"""
__email__ = 'ml@example.com'
__version__ = '0.1.0'

import mlflow
import xgboost as xgb
from sklearn.datasets import load_diabetes
from sklearn.model_selection import train_test_split

mlflow.xgboost.autolog()

data = load_diabetes()
X_train, X_test, y_train, y_test = train_test_split(
    data.data, data.target, test_size=0.2, random_state=42
)

dtrain = xgb.DMatrix(X_train, label=y_train)
dtest = xgb.DMatrix(X_test, label=y_test)

with mlflow.start_run(run_name="xgboost_diabetes_regressor"):
    params = {
        "objective": "reg:squarederror",
        "max_depth": 6,
        "learning_rate": 0.1,
        "random_state": 42,
    }

    model = xgb.train(
        params=params,
        dtrain=dtrain,
        num_boost_round=100,
        evals=[(dtrain, "train"), (dtest, "test")],
    )

    mlflow.xgboost.log_model(
        xgb_model=model,
        name="model",
        model_format="json",
        registered_model_name="diabetes_xgboost_model",
    )
```
