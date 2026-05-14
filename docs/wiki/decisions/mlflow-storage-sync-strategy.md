---
updated: 2026-05-14
summary: Decision record for MLflow model storage synchronization strategy between local and cloud environments.
read_when:
  - You are configuring MLflow storage infrastructure
  - You need to understand local-cloud model synchronization requirements
  - You are evaluating storage sync strategies for MLflow artifacts
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - ../queries/spec-quality-elicitation-session-01.md
  - ../decisions/mlflow-postgres-s3-contract.md
  - ../decisions/nix-containerization-boundary.md
---

# Decision: MLflow Storage Sync Strategy (Local-Cloud)

**What this page is for**: Decision record specifying the contracted behavior for synchronizing MLflow model storage between local development machines and cloud environments while maintaining immutability and data consistency.

**When to read**: When configuring MLflow storage infrastructure, implementing local-cloud synchronization, or ensuring data consistency across environments.

**Upstream spec**: `specs/ml-deploy-reference-repo.allium` — `MLflowStorageBackends`, `LocalEmulationStack`, `CloudProfileRequirements`

---

## Decision

### Hybrid Sync Strategy: Bidirectional Sync with Conflict Resolution

**RECOMMENDATION**: Implement a hybrid synchronization strategy that maintains separate local and cloud storage while providing bidirectional sync with intelligent conflict resolution. This approach preserves local development speed while ensuring cloud consistency and immutability.

#### Core Principles

1. **Separate but Synchronized**: Local storage (filesystem) and cloud storage (S3) remain separate but synchronized
2. **Immutability First**: All synced artifacts maintain their immutable references (git commit hashes)
3. **Conflict Resolution**: Intelligent detection and resolution of sync conflicts
4. **Metadata Consistency**: Git commit metadata preserved across all environments
5. **Performance Optimized**: Local development not slowed by cloud operations

#### Storage Architecture

```
┌─────────────────┐    Sync    ┌─────────────────┐
│   Local Dev     │ <────────> │   Cloud Prod    │
│   Environment   │            │   Environment   │
│                 │            │                 │
│ ┌─────────────┐ │            │ ┌─────────────┐ │
│ │ MLflow      │ │            │ │ MLflow      │ │
│ │ Local DB    │ │            │ │ Cloud DB    │ │
│ │ (SQLite)    │ │            │ │ (PostgreSQL) │ │
│ └─────────────┘ │            │ └─────────────┘ │
│                 │            │                 │
│ ┌─────────────┐ │            │ ┌─────────────┐ │
│ │ Local FS    │ │            │ │ Cloud S3     │ │
│ │ (Artifacts) │ │            │ │ (Artifacts) │ │
│ └─────────────┘ │            │ └─────────────┘ │
└─────────────────┘            └─────────────────┘
         │                           │
         ▼                           ▼
    ┌─────────────────┐       ┌─────────────────┐
    │   Sync Service │       │   Cloud Sync    │
    │ (Local-Cloud)  │       │   Service       │
    └─────────────────┘       └─────────────────┘
```

#### Sync Components

**1. Local Development Storage**
```yaml
# docker-compose.dev.yml
services:
  mlflow-local:
    image: mlflow-go:latest
    environment:
      MLFLOW_BACKEND_STORE_URI: sqlite:///mlflow.db
      MLFLOW_DEFAULT_ARTIFACT_ROOT: /mlflow/artifacts
      MLFLOW_TRACKING_USERNAME: ${USER}
    volumes:
      - mlflow-data:/mlflow
      - ./artifacts:/mlflow/artifacts
    ports:
      - "5000:5000"

volumes:
  mlflow-data:
```

**2. Cloud Production Storage**
```yaml
# docker-compose.cloud.yml
services:
  mlflow-cloud:
    image: mlflow-go:latest
    environment:
      MLFLOW_BACKEND_STORE_URI: postgresql://mlflow:mlflow@postgres:5432/mlflow
      MLFLOW_DEFAULT_ARTIFACT_ROOT: s3://mlflow-artifacts/mlflow
      MLFLOW_TRACKING_USERNAME: ${USER}
    depends_on:
      - postgres
      - s3
    ports:
      - "5001:5000"

  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: mlflow
      POSTGRES_USER: mlflow
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres-data:/var/lib/postgresql/data

  s3:
    image: minio/minio:latest
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: ${S3_ACCESS_KEY}
      MINIO_ROOT_PASSWORD: ${S3_SECRET_KEY}
    volumes:
      - s3-data:/data
    ports:
      - "9001:9001"
```

**3. Sync Service Architecture**
```python
# mlflow_sync_service.py
import os
import hashlib
import json
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional
import boto3
from botocore.exceptions import ClientError
import sqlite3
import logging

class MLflowStorageSyncService:
    """
    Service for synchronizing MLflow artifacts between local filesystem and cloud S3.
    """
    
    def __init__(self, config: Dict):
        self.config = config
        self.local_root = Path(config['local_root'])
        self.s3_bucket = config['s3_bucket']
        self.s3_prefix = config.get('s3_prefix', 'mlflow')
        self.git_metadata_dir = self.local_root / '.git_sync_metadata'
        
        # Initialize AWS client
        self.s3_client = boto3.client(
            's3',
            aws_access_key_id=config.get('aws_access_key_id'),
            aws_secret_access_key=config.get('aws_secret_access_key'),
            region_name=config.get('aws_region', 'us-east-1')
        )
        
        # Initialize metadata database
        self._init_metadata_db()
        
        # Setup logging
        logging.basicConfig(level=logging.INFO)
        self.logger = logging.getLogger(__name__)
    
    def _init_metadata_db(self):
        """Initialize metadata database for tracking sync state."""
        metadata_db = self.git_metadata_dir / 'sync_metadata.db'
        
        with sqlite3.connect(metadata_db) as conn:
            conn.execute('''
                CREATE TABLE IF NOT EXISTS sync_metadata (
                    local_path TEXT PRIMARY KEY,
                    s3_path TEXT,
                    git_commit TEXT,
                    local_hash TEXT,
                    s3_hash TEXT,
                    last_sync_time TEXT,
                    sync_status TEXT,
                    conflict_resolution TEXT
                )
            ''')
    
    def get_git_commit_hash(self, artifact_path: Path) -> str:
        """Get git commit hash for artifact path."""
        try:
            import git
            repo = git.Repo(search_parent_directories=True)
            return repo.head.commit.hexsha
        except ImportError:
            # Fallback to file-based hash if git not available
            return self._get_file_hash(artifact_path)
    
    def _get_file_hash(self, file_path: Path) -> str:
        """Get SHA256 hash of file."""
        hash_sha256 = hashlib.sha256()
        with open(file_path, "rb") as f:
            for chunk in iter(lambda: f.read(4096), b""):
                hash_sha256.update(chunk)
        return hash_sha256.hexdigest()
    
    def scan_local_artifacts(self) -> Dict[str, Dict]:
        """Scan local artifacts and return metadata."""
        artifacts = {}
        
        for artifact_path in self.local_root.rglob('*'):
            if artifact_path.is_file():
                relative_path = artifact_path.relative_to(self.local_root)
                git_commit = self.get_git_commit_hash(artifact_path)
                file_hash = self._get_file_hash(artifact_path)
                
                artifacts[str(relative_path)] = {
                    'local_path': str(artifact_path),
                    'relative_path': str(relative_path),
                    'git_commit': git_commit,
                    'local_hash': file_hash,
                    'size': artifact_path.stat().st_size,
                    'modified_time': datetime.fromtimestamp(artifact_path.stat().st_mtime).isoformat()
                }
        
        return artifacts
    
    def scan_s3_artifacts(self) -> Dict[str, Dict]:
        """Scan S3 artifacts and return metadata."""
        artifacts = {}
        
        try:
            # List all objects in S3 bucket
            paginator = self.s3_client.get_paginator('list_objects_v2')
            for page in paginator.paginate(Bucket=self.s3_bucket, Prefix=self.s3_prefix):
                if 'Contents' in page:
                    for obj in page['Contents']:
                        s3_key = obj['Key']
                        if s3_key.startswith(self.s3_prefix):
                            relative_path = s3_key[len(self.s3_prefix)+1:] if s3_prefix.endswith('/') else s3_key[len(self.s3_prefix):]
                            
                            artifacts[relative_path] = {
                                's3_key': s3_key,
                                'relative_path': relative_path,
                                'size': obj['Size'],
                                'last_modified': obj['LastModified'].isoformat(),
                                'etag': obj['ETag'].strip('"')
                            }
        except ClientError as e:
            self.logger.error(f"Error scanning S3: {e}")
        
        return artifacts
    
    def detect_conflicts(self, local_artifacts: Dict, s3_artifacts: Dict) -> List[Dict]:
        """Detect conflicts between local and cloud artifacts."""
        conflicts = []
        
        # Check for modified files in both locations
        all_paths = set(local_artifacts.keys()) | set(s3_artifacts.keys())
        
        for path in all_paths:
            if path in local_artifacts and path in s3_artifacts:
                local_meta = local_artifacts[path]
                s3_meta = s3_artifacts[path]
                
                # Check if file was modified in both locations
                if (local_meta['local_hash'] != s3_meta.get('etag', '') and 
                    local_meta['git_commit'] != s3_meta.get('git_commit', '')):
                    
                    conflicts.append({
                        'path': path,
                        'local_commit': local_meta['git_commit'],
                        's3_commit': s3_meta.get('git_commit', 'unknown'),
                        'local_hash': local_meta['local_hash'],
                        's3_hash': s3_meta.get('etag', ''),
                        'local_modified': local_meta['modified_time'],
                        's3_modified': s3_meta['last_modified'],
                        'resolution': 'pending'
                    })
        
        return conflicts
    
    def resolve_conflicts(self, conflicts: List[Dict], resolution_strategy: str = 'local_wins') -> List[Dict]:
        """Resolve conflicts using specified strategy."""
        resolved_conflicts = []
        
        for conflict in conflicts:
            if resolution_strategy == 'local_wins':
                # Keep local version, update cloud
                conflict['resolution'] = 'local_wins'
                conflict['action'] = 'update_cloud'
            elif resolution_strategy == 'cloud_wins':
                # Keep cloud version, update local
                conflict['resolution'] = 'cloud_wins'
                conflict['action'] = 'update_local'
            elif resolution_strategy == 'manual':
                # Require manual intervention
                conflict['resolution'] = 'manual'
                conflict['action'] = 'manual_required'
            else:
                # Default: local wins
                conflict['resolution'] = 'local_wins'
                conflict['action'] = 'update_cloud'
            
            resolved_conflicts.append(conflict)
        
        return resolved_conflicts
    
    def sync_to_cloud(self, artifacts: Dict[str, Dict]) -> Dict[str, bool]:
        """Sync local artifacts to cloud S3."""
        results = {}
        
        for relative_path, artifact_meta in artifacts.items():
            try:
                # Upload file to S3
                s3_key = f"{self.s3_prefix}/{relative_path}"
                
                self.s3_client.upload_file(
                    artifact_meta['local_path'],
                    self.s3_bucket,
                    s3_key,
                    ExtraArgs={
                        'Metadata': {
                            'git-commit': artifact_meta['git_commit'],
                            'sync-time': datetime.now().isoformat(),
                            'local-hash': artifact_meta['local_hash']
                        }
                    }
                )
                
                # Update metadata
                self._update_sync_metadata(
                    relative_path,
                    s3_key,
                    artifact_meta['git_commit'],
                    artifact_meta['local_hash']
                )
                
                results[relative_path] = True
                self.logger.info(f"Synced {relative_path} to cloud")
                
            except Exception as e:
                results[relative_path] = False
                self.logger.error(f"Failed to sync {relative_path}: {e}")
        
        return results
    
    def sync_from_cloud(self, artifacts: Dict[str, Dict]) -> Dict[str, bool]:
        """Sync cloud artifacts to local filesystem."""
        results = {}
        
        for relative_path, artifact_meta in artifacts.items():
            try:
                # Download file from S3
                local_path = self.local_root / relative_path
                local_path.parent.mkdir(parents=True, exist_ok=True)
                
                s3_key = artifact_meta['s3_key']
                self.s3_client.download_file(
                    self.s3_bucket,
                    s3_key,
                    str(local_path)
                )
                
                # Update metadata
                self._update_sync_metadata(
                    relative_path,
                    s3_key,
                    artifact_meta.get('git_commit', ''),
                    artifact_meta.get('etag', '')
                )
                
                results[relative_path] = True
                self.logger.info(f"Synced {relative_path} from cloud")
                
            except Exception as e:
                results[relative_path] = False
                self.logger.error(f"Failed to sync {relative_path} from cloud: {e}")
        
        return results
    
    def _update_sync_metadata(self, relative_path: str, s3_path: str, git_commit: str, file_hash: str):
        """Update sync metadata database."""
        with sqlite3.connect(self.git_metadata_dir / 'sync_metadata.db') as conn:
            conn.execute('''
                INSERT OR REPLACE INTO sync_metadata 
                (local_path, s3_path, git_commit, local_hash, s3_hash, last_sync_time, sync_status, conflict_resolution)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ''', (
                relative_path,
                s3_path,
                git_commit,
                file_hash,
                file_hash,
                datetime.now().isoformat(),
                'synced',
                'none'
            ))
    
    def get_sync_status(self) -> Dict:
        """Get current sync status summary."""
        with sqlite3.connect(self.git_metadata_dir / 'sync_metadata.db') as conn:
            cursor = conn.execute('''
                SELECT sync_status, COUNT(*) as count
                FROM sync_metadata
                GROUP BY sync_status
            ''')
            
            status_counts = dict(cursor.fetchall())
            
            return {
                'total_artifacts': sum(status_counts.values()),
                'synced_artifacts': status_counts.get('synced', 0),
                'conflicted_artifacts': status_counts.get('conflicted', 0),
                'pending_sync': status_counts.get('pending', 0)
            }
```

#### Sync Workflow Integration

**1. Local Development Workflow**
```python
# local_dev_workflow.py
from mlflow_sync_service import MLflowStorageSyncService

class LocalDevSync:
    """Local development workflow with sync integration."""
    
    def __init__(self):
        self.sync_service = MLflowStorageSyncService({
            'local_root': '/mlflow/artifacts',
            's3_bucket': 'mlflow-artifacts',
            's3_prefix': 'mlflow',
            'aws_access_key_id': 'local-dev-key',
            'aws_secret_access_key': 'local-dev-secret',
            'aws_region': 'us-east-1'
        })
    
    def create_experiment(self, experiment_name: str):
        """Create experiment and sync artifacts."""
        import mlflow
        
        mlflow.set_experiment(experiment_name)
        
        with mlflow.start_run() as run:
            # Create some artifacts
            self.create_sample_artifacts()
            
            # Sync to cloud
            local_artifacts = self.sync_service.scan_local_artifacts()
            sync_results = self.sync_service.sync_to_cloud(local_artifacts)
            
            return {
                'run_id': run.info.run_id,
                'sync_results': sync_results,
                'git_commit': self.sync_service.get_git_commit_hash(Path('/mlflow/artifacts'))
            }
    
    def create_sample_artifacts(self):
        """Create sample artifacts for testing."""
        import matplotlib.pyplot as plt
        import pandas as pd
        import json
        
        # Create plot
        plt.figure()
        plt.plot([1, 2, 3, 4])
        plt.savefig('/mlflow/artifacts/sample_plot.png')
        plt.close()
        
        # Create dataset
        df = pd.DataFrame({'x': [1, 2, 3, 4], 'y': [2, 4, 6, 8]})
        df.to_csv('/mlflow/artifacts/sample_data.csv', index=False)
        
        # Create metadata
        metadata = {
            'experiment': 'sample_experiment',
            'created_by': 'local_dev',
            'git_commit': self.sync_service.get_git_commit_hash(Path('/mlflow/artifacts'))
        }
        with open('/mlflow/artifacts/metadata.json', 'w') as f:
            json.dump(metadata, f)
        
        # Log artifacts to MLflow
        mlflow.log_artifact('/mlflow/artifacts/sample_plot.png')
        mlflow.log_artifact('/mlflow/artifacts/sample_data.csv')
        mlflow.log_artifact('/mlflow/artifacts/metadata.json')
```

**2. Cloud Production Workflow**
```python
# cloud_prod_workflow.py
from mlflow_sync_service import MLflowStorageSyncService

class CloudProdSync:
    """Cloud production workflow with sync integration."""
    
    def __init__(self):
        self.sync_service = MLflowStorageSyncService({
            'local_root': '/mlflow/artifacts',
            's3_bucket': 'mlflow-artifacts',
            's3_prefix': 'mlflow',
            'aws_access_key_id': '${AWS_ACCESS_KEY_ID}',
            'aws_secret_access_key': '${AWS_SECRET_ACCESS_KEY}',
            'aws_region': '${AWS_REGION}'
        })
    
    def sync_and_deploy(self, model_name: str):
        """Sync from cloud and deploy model."""
        # Scan cloud artifacts
        s3_artifacts = self.sync_service.scan_s3_artifacts()
        
        # Sync from cloud
        sync_results = self.sync_service.sync_from_cloud(s3_artifacts)
        
        # Deploy model
        return self.deploy_model(model_name, sync_results)
    
    def deploy_model(self, model_name: str, sync_results: Dict):
        """Deploy model to production."""
        # Find latest model artifacts
        latest_artifacts = self._find_latest_artifacts(sync_results)
        
        # Deploy model (simplified example)
        deployment_result = {
            'model_name': model_name,
            'artifacts': latest_artifacts,
            'deployment_time': datetime.now().isoformat(),
            'status': 'deployed'
        }
        
        return deployment_result
```

**3. Sync Command Line Interface**
```python
# sync_cli.py
import click
from mlflow_sync_service import MLflowStorageSyncService

@click.group()
def cli():
    """MLflow storage sync CLI."""
    pass

@cli.command()
@click.option('--local-root', default='/mlflow/artifacts', help='Local artifacts root')
@click.option('--s3-bucket', required=True, help='S3 bucket name')
@click.option('--s3-prefix', default='mlflow', help='S3 prefix')
@click.option('--direction', type=click.Choice(['push', 'pull', 'both']), default='both')
def sync(local_root, s3_bucket, s3_prefix, direction):
    """Sync MLflow artifacts between local and cloud."""
    config = {
        'local_root': local_root,
        's3_bucket': s3_bucket,
        's3_prefix': s3_prefix,
        'aws_access_key_id': os.getenv('AWS_ACCESS_KEY_ID'),
        'aws_secret_access_key': os.getenv('AWS_SECRET_ACCESS_KEY'),
        'aws_region': os.getenv('AWS_REGION', 'us-east-1')
    }
    
    sync_service = MLflowStorageSyncService(config)
    
    if direction in ['push', 'both']:
        print("Pushing local artifacts to cloud...")
        local_artifacts = sync_service.scan_local_artifacts()
        sync_results = sync_service.sync_to_cloud(local_artifacts)
        print(f"Push results: {sync_results}")
    
    if direction in ['pull', 'both']:
        print("Pulling cloud artifacts to local...")
        s3_artifacts = sync_service.scan_s3_artifacts()
        sync_results = sync_service.sync_from_cloud(s3_artifacts)
        print(f"Pull results: {sync_results}")
    
    # Show sync status
    status = sync_service.get_sync_status()
    print(f"Sync status: {status}")

@cli.command()
def status():
    """Show sync status."""
    config = {
        'local_root': '/mlflow/artifacts',
        's3_bucket': 'mlflow-artifacts',
        's3_prefix': 'mlflow',
        'aws_access_key_id': os.getenv('AWS_ACCESS_KEY_ID'),
        'aws_secret_access_key': os.getenv('AWS_SECRET_ACCESS_KEY'),
        'aws_region': os.getenv('AWS_REGION', 'us-east-1')
    }
    
    sync_service = MLflowStorageSyncService(config)
    status = sync_service.get_sync_status()
    print(f"Sync status: {status}")

if __name__ == '__main__':
    cli()
```

#### Sync Configuration and Deployment

**1. Nix Configuration for Sync Service**
```nix
# nix/services/sync-service.nix
{ 
  pkgs, 
  inputs,
  ...
}:

let
  sync-service = pkgs.writeShellScript "mlflow-sync" ''
    #!/bin/bash
    
    # Sync service script
    export AWS_ACCESS_KEY_ID="local-dev-key"
    export AWS_SECRET_ACCESS_KEY="local-dev-secret"
    export AWS_REGION="us-east-1"
    
    # Run sync
    python ${./sync_service.py} \
      --local-root /mlflow/artifacts \
      --s3-bucket mlflow-artifacts \
      --s3-prefix mlflow \
      --direction both
  '';
  
in
{
  # Service definition
  services.mlflow-sync = {
    description = "MLflow Storage Sync Service";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    
    serviceConfig = {
      Type = "simple";
      ExecStart = "${sync-service}";
      Restart = "on-failure";
      RestartSec = "10s";
      User = "mlflow";
      Group = "mlflow";
      WorkingDirectory = "/mlflow";
    };
    
    environment = {
      AWS_ACCESS_KEY_ID = "local-dev-key";
      AWS_SECRET_ACCESS_KEY = "local-dev-secret";
      AWS_REGION = "us-east-1";
    };
  };
}
```

**2. Docker Compose with Sync**
```yaml
# docker-compose.sync.yml
version: '3.8'

services:
  mlflow-local:
    image: mlflow-go:latest
    environment:
      MLFLOW_BACKEND_STORE_URI: sqlite:///mlflow.db
      MLFLOW_DEFAULT_ARTIFACT_ROOT: /mlflow/artifacts
      MLFLOW_TRACKING_USERNAME: local_dev
    volumes:
      - mlflow-data:/mlflow
      - ./artifacts:/mlflow/artifacts
    ports:
      - "5000:5000"

  sync-service:
    image: python:3.11-slim
    depends_on:
      - mlflow-local
    volumes:
      - ./artifacts:/mlflow/artifacts
      - ./sync_service:/app
    command: >
      sh -c "pip install boto3 pandas && 
             python /app/sync_service.py --direction push"

volumes:
  mlflow-data:
```

#### Acceptance Criteria

1. **Bidirectional Sync**: Artifacts can be synced from local to cloud and cloud to local
2. **Conflict Detection**: Automatic detection of conflicts between local and cloud artifacts
3. **Conflict Resolution**: Intelligent conflict resolution with configurable strategies
4. **Metadata Preservation**: Git commit hashes and other metadata preserved during sync
5. **Performance**: Local development not significantly impacted by sync operations
6. **Immutability**: All artifacts maintain their immutable references after sync
7. **Monitoring**: Sync status and conflicts are trackable and monitorable
8. **CLI Integration**: Command line tools for manual sync operations and status checking

### Related Decisions

- [MLflow PostgreSQL+S3 Contract](../decisions/mlflow-postgres-s3-contract.md) - MLflow storage backend requirements
- [Nix Containerization Boundary](../decisions/nix-containerization-boundary.md) - Containerization strategy
- [AWS Kubernetes Contract](../decisions/aws-kubernetes-contract.md) - Cloud deployment requirements
- [Project Scope and Constraints](../decisions/project-scope-and-constraints.md) - Overall architectural direction

### Open Items

- Sync performance optimization for large artifact sets
- Integration with existing CI/CD pipelines
- Sync service reliability and fault tolerance
- Sync service scaling for multiple developers
- Sync service security and access control
- Sync service monitoring and alerting

---

## Rationale

### Why Hybrid Sync Strategy?

1. **Performance**: Local development not slowed by cloud operations
2. **Immutability**: Git commit hashes preserved as immutable references
3. **Flexibility**: Developers can work offline and sync later
4. **Conflict Resolution**: Intelligent handling of concurrent modifications
5. **Cost Efficiency**: Minimize unnecessary cloud storage operations
6. **Development Speed**: Local operations are fast and responsive

### Why Not Pure Cloud-Only?

1. **Development Speed**: Local operations would be slow
2. **Offline Work**: Cannot work without internet connection
3. **Cost**: Constant cloud operations would be expensive
4. **Latency**: Network latency affects development experience
5. **Reliability**: Dependent on cloud service availability

### Why Not Pure Local-Only?

1. **Cloud Consistency**: No guarantee of cloud environment consistency
2. **Collaboration**: Difficult team collaboration with only local storage
3. **Production Deployment**: Cannot reliably deploy to cloud
4. **Backup**: No automatic cloud backup of important artifacts
5. **Scalability**: Local storage limited by developer machine capacity

---

## Implementation Notes

### Sync Service Deployment
1. **Local Development**: Sync service runs as a background process
2. **Cloud Production**: Sync service integrated into CI/CD pipeline
3. **Monitoring**: Sync status and conflicts visible in MLflow UI
4. **Alerting**: Alert on sync failures and conflicts

### Developer Workflow
1. **Local Development**: Create experiments and artifacts normally
2. **Sync**: Push artifacts to cloud when ready
3. **Cloud Access**: Access artifacts from cloud for deployment
4. **Conflict Handling**: Resolve conflicts as they arise

### Maintenance
1. **Regular Sync**: Regular sync operations to keep environments in sync
2. **Conflict Resolution**: Prompt resolution of detected conflicts
3. **Performance Monitoring**: Monitor sync performance and optimize as needed
4. **Cost Monitoring**: Monitor cloud storage and sync costs
