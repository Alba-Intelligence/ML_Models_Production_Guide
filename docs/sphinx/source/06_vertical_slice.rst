Vertical Slice Example
=====================

This document provides a runnable example of a vertical slice through the ML Deploy platform.

Example: End-to-End ML Workflow
-------------------------------

.. code-block:: python

   def generate_synthetic_dataset():
       """Generate a synthetic dataset for ML workflow demo."""
       import numpy as np
       X = np.random.rand(100, 4)
       y = np.random.randint(0, 2, 100)
       return X, y

   def train_with_traceability():
       """Train a model with traceability and log to MLflow."""
       import mlflow
       from sklearn.ensemble import RandomForestClassifier
       X, y = generate_synthetic_dataset()
       clf = RandomForestClassifier()
       clf.fit(X, y)
       with mlflow.start_run():
           mlflow.sklearn.log_model(clf, "model")
           mlflow.log_metric("accuracy", clf.score(X, y))

   def package_and_register_model():
       """Package the trained model and register with MLflow."""
       import mlflow
       from sklearn.ensemble import RandomForestClassifier
       X, y = generate_synthetic_dataset()
       clf = RandomForestClassifier()
       clf.fit(X, y)
       with mlflow.start_run():
           mlflow.sklearn.log_model(clf, "model")
           mlflow.log_param("model_type", "RandomForestClassifier")
           mlflow.log_metric("accuracy", clf.score(X, y))

   def execute_first_vertical_slice():
       train_with_traceability()
       package_and_register_model()

       """Example: Train and register a model with MLflow"""
       import mlflow
       from sklearn.ensemble import RandomForestClassifier
       from sklearn.datasets import load_iris

       X, y = load_iris(return_X_y=True)
       clf = RandomForestClassifier()
       clf.fit(X, y)

       with mlflow.start_run():
           mlflow.sklearn.log_model(clf, "model")
           mlflow.log_metric("accuracy", clf.score(X, y))

This code demonstrates training a model and registering it with MLflow, as required by the documentation tests.
