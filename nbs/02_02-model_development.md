# OpenTofu Infrastructure Profiles


This section will be expanded to show how a single notebook can be used
to train a model, log metrics and parameters with MLflow, and save the
trained model for later use. This will be executed as part of the
vertical slice reference in `02_04-complete_workflow.qmd` to demonstrate
how the training step fits into the overall workflow.

# Model Training

> This notebook demonstrates how to train a simple machine learning
> model.

We will use the data prepared in the previous notebook to train a
logistic regression model.

``` python
import pandas as pd
import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
import mlflow
import mlflow.sklearn
```

## Load Processed Data

In a real project, we would load the data that was prepared and saved.
For simplicity, we’ll regenerate the same data split as in the previous
notebook.

``` python
# Regenerate the same data split for consistency
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler

# Create sample data (same as in 02_data.ipynb)
np.random.seed(42)  # for reproducibility
data = {
    'feature_1': np.random.randn(100),
    'feature_2': np.random.randn(100) * 2 + 1,
    'feature_3': np.random.randn(100) * 0.5,
    'target': (np.random.randn(100) > 0).astype(int)
}
df = pd.DataFrame(data)

# Prepare features and target
X = df.drop('target', axis=1)
y = df['target']

# Split into train and test sets
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Scale features
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Convert back to DataFrame
X_train_scaled = pd.DataFrame(X_train_scaled, columns=X.columns, index=X_train.index)
X_test_scaled = pd.DataFrame(X_test_scaled, columns=X.columns, index=X_test.index)

print(f"Training set shape: {X_train_scaled.shape}")
print(f"Test set shape: {X_test_scaled.shape}")
```

## Model Training with MLflow Tracking

We will use MLflow to track our experiment, parameters, and metrics.

``` python
# Set MLflow tracking URI (optional, for local tracking)
mlflow.set_tracking_uri("file://./mlruns")

# Set experiment
mlflow.set_experiment("ml_deploy_baseline")

# Start an MLflow run
with mlflow.start_run(run_name="logistic_regression_baseline") as run:
    # Log parameters
    max_iter = 1000
    solver = 'liblinear'
    mlflow.log_param("max_iter", max_iter)
    mlflow.log_param("solver", solver)

    # Create and train model
    model = LogisticRegression(max_iter=max_iter, solver=solver, random_state=42)
    model.fit(X_train_scaled, y_train)

    # Make predictions
    y_pred = model.predict(X_test_scaled)

    # Calculate metrics
    accuracy = accuracy_score(y_test, y_pred)

    # Log metrics
    mlflow.log_metric("accuracy", accuracy)

    # Log the model
    mlflow.sklearn.log_model(model, "model")

    # Print results
    print(f"Accuracy: {accuracy:.4f}")
    print("\nClassification Report:")
    print(classification_report(y_test, y_pred))
    print("\nConfusion Matrix:")
    print(confusion_matrix(y_test, y_pred))
```

## Model Serialization

We can also save the model using joblib or pickle for later use.
However, MLflow already provides a way to save and load the model. For
completeness, let’s also save the scaler so we can preprocess new data
the same way.

``` python
import joblib
import os

# Create a directory to save artifacts
os.makedirs("models", exist_ok=True)

# Save the model
joblib.dump(model, "models/logistic_regression_model.joblib")

# Save the scaler
joblib.dump(scaler, "models/standard_scaler.joblib")

print("Model and scaler saved to 'models/' directory.")
```

## Summary

In this notebook, we’ve: 1. Loaded and prepared the data (same as in the
previous notebook) 2. Trained a logistic regression model 3. Tracked the
experiment with MLflow (parameters, metrics, and model) 4. Evaluated the
model on the test set 5. Saved the model and scaler for later use

The next steps would be to: - Package the model for deployment - Create
a serving API using the stack’s chosen Python web layer - Set up
monitoring for the deployed model

------------------------------------------------------------------------

*This notebook exports functions and variables that can be used in other
notebooks.*

This page summarizes the dual-profile infrastructure posture.

## Profiles

- **local_emulation**: Floci + K3s + Slurm-Docker paired with
  MLflow/PostgreSQL.
- **cloud**: AWS-backed infrastructure with Kubernetes control plane and
  Lambda.ai integration surfaces.

## Generation model

- Terranix modules under `nix/modules/` provide shared plus
  profile-specific definitions.
- Profile entrypoints under `nix/profiles/` compose modules into
  OpenTofu-compatible JSON.
- Apply flow is profile-scoped and local-emulation validation should
  precede cloud rollout.

## Key outputs

- Deployment profile identification.
- MLflow tracking URI per profile.
- Storage and scheduler endpoint references required by orchestration
  layers.

## Copy-pasteable Terranix entrypoints

The notebook pages document the same source that lives under `nix/` so
the infrastructure story can be read without directory spelunking.

``` nix
# nix/modules/local.nix
{ config, lib, ... }:

with lib;

{
  imports = [ ./shared.nix ];

  config.mlDeploy = {
    profile           = "local_emulation";
    mlflowTrackingUri = "http://localhost:5001";
    awsEndpointUrl    = "http://localhost:4566";
    postgresHost      = "localhost";
  };

  config.provider.aws = {
    region                      = config.mlDeploy.awsRegion;
    access_key                  = "test";
    secret_key                  = "test";
    skip_credentials_validation = true;
    skip_metadata_api_check     = true;
    skip_requesting_account_id  = true;
    endpoints = {
      s3             = config.mlDeploy.awsEndpointUrl;
      iam            = config.mlDeploy.awsEndpointUrl;
      sts            = config.mlDeploy.awsEndpointUrl;
      ec2            = config.mlDeploy.awsEndpointUrl;
      secretsmanager = config.mlDeploy.awsEndpointUrl;
      cloudwatch     = config.mlDeploy.awsEndpointUrl;
      logs           = config.mlDeploy.awsEndpointUrl;
    };
  };
}
```

``` nix
# nix/modules/cloud.nix
{ config, lib, ... }:

with lib;

{
  imports = [ ./shared.nix ];

  config.mlDeploy = {
    profile           = "cloud";
    mlflowTrackingUri = "\${var.mlflow_tracking_uri}";
    awsEndpointUrl    = null;
    postgresHost      = "\${var.postgres_host}";
  };

  config.provider.aws = {
    region = config.mlDeploy.awsRegion;
  };
}
```

``` nix
# nix/modules/shared.nix
{ config, lib, ... }:

with lib;

let
  cfg = config.mlDeploy;
in {
  options.mlDeploy = {
    profile = mkOption {
      type = types.enum [ "local_emulation" "cloud" ];
    };
    projectName = mkOption {
      type = types.str;
      default = "ml-deploy";
    };
    mlflowTrackingUri = mkOption {
      type = types.str;
    };
    s3BucketArtifacts = mkOption {
      type = types.str;
      default = "mlflow-artifacts";
    };
    s3BucketModelRegistry = mkOption {
      type = types.str;
      default = "model-registry";
    };
    awsRegion = mkOption {
      type = types.str;
      default = "us-east-1";
    };
    awsEndpointUrl = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    postgresHost = mkOption {
      type = types.str;
    };
    postgresPort = mkOption {
      type = types.int;
      default = 5432;
    };
    postgresDb = mkOption {
      type = types.str;
      default = "mlflow";
    };
  };

  config = {
    resource.aws_s3_bucket."${cfg.projectName}-artifacts" = {
      bucket = cfg.s3BucketArtifacts;
    };

    resource.aws_s3_bucket."${cfg.projectName}-model-registry" = {
      bucket = cfg.s3BucketModelRegistry;
    };

    output.mlflow_tracking_uri = {
      value = cfg.mlflowTrackingUri;
    };
  };
}
```
