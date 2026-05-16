# OpenTofu Infrastructure Profiles


# Data Loading and Exploration

> This notebook demonstrates how to load and explore data for ML
> projects.

In a real ML deployment project, this would typically involve: - Loading
data from various sources (databases, APIs, files) - Performing
exploratory data analysis (EDA) - Data cleaning and preprocessing -
Feature engineering - Splitting data into train/validation/test sets

------------------------------------------------------------------------

## Setup

First, let’s import the necessary libraries.

``` python
import pandas as pd
import numpy as np
```

## Creating Sample Data

For demonstration purposes, we’ll create a simple dataset.

``` python
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

## Basic Data Exploration

Let’s look at basic statistics.

``` python
df.describe()
```

## Check for Missing Values

It’s important to check for missing values in real datasets.

``` python
missing_values = df.isnull().sum()
print("Missing values per column:")
print(missing_values)
print(f"Total missing values: {missing_values.sum()}")
```

## Target Variable Distribution

Let’s examine the distribution of our target variable.

``` python
target_counts = df['target'].value_counts()
print("Target distribution:")
print(target_counts)
print(f"\nClass balance: {target_counts[0]/len(df):.2%} negative, {target_counts[1]/len(df):.2%} positive")
```

## Data Preprocessing

Now let’s prepare our data for modeling by splitting and scaling.

``` python
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

## Feature Scaling

Many ML algorithms perform better when features are scaled.

``` python
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

## Summary

In this notebook, we’ve: 1. Created a sample dataset 2. Performed basic
exploratory data analysis 3. Checked for missing values 4. Examined
target distribution 5. Split data into train/test sets 6. Applied
feature scaling

The processed data is now ready for model training, which we’ll cover in
the next notebook.

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
