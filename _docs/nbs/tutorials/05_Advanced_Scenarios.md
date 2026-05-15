# Advanced ML Scenarios


# Advanced ML Scenarios

This tutorial explores advanced ML deployment scenarios that build upon
the core EX-01 → EX-03 patterns. These scenarios demonstrate how to
extend the platform for distributed training, batch inference, and
online serving with comprehensive governance and monitoring.

## Overview

After mastering the core workflow, you’ll want to explore more complex
scenarios that leverage the full power of the ML Deploy platform:

1.  **Distributed Training**: Scaling training across multiple
    GPUs/nodes
2.  **Batch Inference**: Processing large volumes of predictions
    efficiently
3.  **Online Serving**: Real-time model deployment with monitoring and
    rollback
4.  **Multi-Environment Deployment**: Managing deployments across
    different environments

Each scenario follows the same architectural principles but extends them
for specific use cases.

## Scenario 1: Distributed Training (EX-04)

### Overview

Distributed training extends EX-01 to handle large-scale model training
across multiple GPUs and nodes using Lambda.ai with Slurm coordination.

### Architecture

    ┌─────────────────────────────────────────────────────────────────┐
    │                      Distributed Training                        │
    ├─────────────────────────────────────────────────────────────────┤
    │  User Interface                                                 │
    │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
    │  │ Notebook        │  │ Execution       │  │ Results         │ │
    │  │ Request         │◀▶│ Orchestrator    │◀▶│ Dashboard       │ │
    │  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
    ├─────────────────────────────────────────────────────────────────┤
    │  Distributed Layer                                               │
    │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
    │  │ Parameter       │  │ Gradient        │  │ Model           │ │
    │  │ Server          │  │ Synchronization│  │ Parallelism      │ │
    │  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
    ├─────────────────────────────────────────────────────────────────┤
    │  Compute Layer                                                  │
    │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
    │  │ Lambda.ai       │  │ Slurm           │  │ Kubernetes      │ │
    │  │ Cluster         │  │ Job Management  │  │ Node Management │ │
    │  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
    ├─────────────────────────────────────────────────────────────────┤
    │  Data & Model Layer                                            │
    │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
    │  │ Distributed     │  │ Model           │  │ Checkpoints     │ │
    │  │ Data Loading    │  │ Sharding        │  │ & Artifacts     │ │
    │  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
    └─────────────────────────────────────────────────────────────────┘

### Implementation

#### 1. Distributed Training Configuration

``` python
from dataclasses import dataclass
from typing import Dict, Any, List
from pathlib import Path

@dataclass
class DistributedTrainingConfig:
    """Configuration for distributed training."""
    
    # Model configuration
    model_type: str
    model_architecture: Dict[str, Any]
    
    # Distributed training parameters
    strategy: str  # 'dp', 'ddp', 'fsdp', 'deepspeed'
    num_gpus: int
    nodes: int
    workers_per_node: int
    
    # Data configuration
    batch_size: int
    num_epochs: int
    learning_rate: float
    warmup_steps: int
    
    # Lambda.ai configuration
    lambda_project: str
    lambda_queue: str
    lambda_priority: str
    
    # Slurm configuration
    slurm_partition: str
    slurm_time_limit: str
    slurm_memory: str

def create_distributed_training_config() -> DistributedTrainingConfig:
    """Create distributed training configuration."""
    return DistributedTrainingConfig(
        model_type="transformer",
        model_architecture={
            "num_layers": 12,
            "hidden_size": 768,
            "num_attention_heads": 12,
            "intermediate_size": 3072,
            "max_position_embeddings": 512
        },
        strategy="ddp",  # Distributed Data Parallel
        num_gpus=4,
        nodes=2,
        workers_per_node=1,
        batch_size=32,
        num_epochs=10,
        learning_rate=1e-4,
        warmup_steps=1000,
        lambda_project="ml-distributed-training",
        lambda_queue="gpu-high",
        lambda_priority="high",
        slurm_partition="gpu",
        slurm_time_limit="24:00:00",
        slurm_memory="64G"
    )
```

#### 2. Distributed Training Script

``` python
import torch
import torch.distributed as dist
import torch.multiprocessing as mp
from torch.nn.parallel import DistributedDataParallel as DDP
from typing import Any, Dict
import os
import json
from pathlib import Path
from ml_deploy.mlflow_parity import resolve_mlflow_storage_config

class DistributedTrainer:
    def __init__(self, config: DistributedTrainingConfig):
        self.config = config
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.local_rank = int(os.environ.get("LOCAL_RANK", 0))
        self.global_rank = int(os.environ.get("RANK", 0))
        self.world_size = int(os.environ.get("WORLD_SIZE", 1))
        
    def setup_distributed(self):
        """Setup distributed training environment."""
        os.environ['MASTER_ADDR'] = 'localhost'
        os.environ['MASTER_PORT'] = '12355'
        
        # Initialize process group
        dist.init_process_group(
            backend='nccl',
            rank=self.global_rank,
            world_size=self.world_size
        )
        
        # Set device for this process
        torch.cuda.set_device(self.local_rank)
        self.device = torch.device(f"cuda:{self.local_rank}", index=self.local_rank)
        
    def cleanup_distributed(self):
        """Cleanup distributed training environment."""
        dist.destroy_process_group()
        
    def create_model(self) -> torch.nn.Module:
        """Create model for distributed training."""
        # Create your model architecture
        model = self.create_transformer_model()
        
        # Wrap model for distributed training
        if torch.cuda.is_available():
            model = DDP(model, device_ids=[self.local_rank])
        
        return model
    
    def create_transformer_model(self) -> torch.nn.Module:
        """Create transformer model architecture."""
        class SimpleTransformer(torch.nn.Module):
            def __init__(self, config):
                super().__init__()
                self.config = config
                
                # Transformer layers
                self.layers = torch.nn.ModuleList([
                    torch.nn.TransformerEncoderLayer(
                        d_model=config.model_architecture["hidden_size"],
                        nhead=config.model_architecture["num_attention_heads"],
                        dim_feedforward=config.model_architecture["intermediate_size"]
                    ) for _ in range(config.model_architecture["num_layers"])
                ])
                
                self.position_embedding = torch.nn.Embedding(
                    config.model_architecture["max_position_embeddings"],
                    config.model_architecture["hidden_size"]
                )
                
                self.output_layer = torch.nn.Linear(
                    config.model_architecture["hidden_size"],
                    10  # Output dimension
                )
            
            def forward(self, x):
                # Add position embeddings
                positions = torch.arange(x.size(1), device=x.device).unsqueeze(0)
                x = x + self.position_embedding(positions)
                
                # Pass through transformer layers
                for layer in self.layers:
                    x = layer(x)
                
                # Output layer
                return self.output_layer(x)
        
        return SimpleTransformer(self.config)
    
    def train_epoch(self, model: torch.nn.Module, dataloader, optimizer, epoch: int):
        """Train for one epoch."""
        model.train()
        total_loss = 0.0
        
        for batch_idx, (data, target) in enumerate(dataloader):
            # Move data to device
            data, target = data.to(self.device), target.to(self.device)
            
            # Forward pass
            optimizer.zero_grad()
            output = model(data)
            loss = torch.nn.CrossEntropyLoss()(output, target)
            
            # Backward pass
            loss.backward()
            optimizer.step()
            
            # Accumulate loss
            total_loss += loss.item()
            
            # Synchronize loss across processes
            if self.global_rank == 0:
                avg_loss = total_loss / (batch_idx + 1)
                print(f"Epoch {epoch}, Batch {batch_idx}, Loss: {avg_loss:.4f}")
        
        # Average loss across all processes
        total_loss = torch.tensor(total_loss).to(self.device)
        dist.all_reduce(total_loss, op=dist.ReduceOp.SUM)
        total_loss = total_loss.item() / self.world_size
        
        return total_loss
    
    def train_distributed(self, dataloader, work_dir: Path):
        """Execute distributed training."""
        self.setup_distributed()
        
        try:
            # Create model
            model = self.create_model().to(self.device)
            
            # Create optimizer
            optimizer = torch.optim.Adam(model.parameters(), lr=self.config.learning_rate)
            
            # Training loop
            for epoch in range(self.config.num_epochs):
                loss = self.train_epoch(model, dataloader, optimizer, epoch)
                
                # Save checkpoint
                if self.global_rank == 0:
                    checkpoint_path = work_dir / f"checkpoint_epoch_{epoch}.pt"
                    torch.save({
                        'epoch': epoch,
                        'model_state_dict': model.state_dict(),
                        'optimizer_state_dict': optimizer.state_dict(),
                        'loss': loss,
                    }, checkpoint_path)
                
                # Log to MLflow
                if self.global_rank == 0:
                    mlflow_config = resolve_mlflow_storage_config()
                    # Log metrics to MLflow
                    pass
            
            # Save final model
            if self.global_rank == 0:
                final_model_path = work_dir / "final_model.pt"
                torch.save(model.state_dict(), final_model_path)
            
        finally:
            self.cleanup_distributed()
```

#### 3. Lambda.ai Integration

``` python
from ml_deploy.vertical_slice import SlurmExecutionAdapter
from typing import Dict, Any

class LambdaTrainingAdapter:
    """Adapter for Lambda.ai distributed training."""
    
    def __init__(self, lambda_project: str, lambda_queue: str):
        self.lambda_project = lambda_project
        self.lambda_queue = lambda_queue
        self.slurm_adapter = SlurmExecutionAdapter()
    
    def submit_distributed_job(self, config: DistributedTrainingConfig, 
                             work_dir: Path) -> Dict[str, Any]:
        """Submit distributed training job to Lambda.ai."""
        
        # Generate Slurm script for Lambda.ai
        slurm_script = self._generate_lambda_slurm_script(config, work_dir)
        
        # Submit to Slurm (Lambda.ai handles the rest)
        job_result = self.slurm_adapter.submit(
            self._create_slurm_request(config),
            work_dir=work_dir
        )
        
        return {
            "job_id": job_result["job_id"],
            "backend": "lambda_ai",
            "status": "submitted",
            "submission_time": job_result["submission_time"]
        }
    
    def _generate_lambda_slurm_script(self, config: DistributedTrainingConfig, 
                                    work_dir: Path) -> str:
        """Generate Slurm script for Lambda.ai."""
        script = f"""#!/bin/bash
#SBATCH --job-name=distributed_training
#SBATCH --partition={config.slurm_partition}
#SBATCH --nodes={config.nodes}
#SBATCH --ntasks-per-node={config.workers_per_node}
#SBATCH --gres=gpu:{config.num_gpus}
#SBATCH --time={config.slurm_time_limit}
#SBATCH --mem={config.slurm_memory}
#SBATCH --output={work_dir}/slurm_%j.out
#SBATCH --error={work_dir}/slurm_%j.err

# Set environment variables
export MASTER_ADDR=localhost
export MASTER_PORT=12355
export WORLD_SIZE={config.nodes * config.workers_per_node}
export CUDA_VISIBLE_DEVICES=0-{config.num_gpus-1}

# Activate Python environment
source /opt/conda/bin/activate ml_deploy

# Run distributed training
python -m torch.distributed.launch \\
    --nproc_per_node={config.workers_per_node} \\
    --nnodes={config.nodes} \\
    --master_addr=$MASTER_ADDR \\
    --master_port=$MASTER_PORT \\
    train_distributed.py \\
    --config {work_dir}/config.json \\
    --output_dir {work_dir}/output
"""
        return script
    
    def _create_slurm_request(self, config: DistributedTrainingConfig):
        """Create Slurm request for Lambda.ai."""
        from ml_deploy.webui_contracts import NotebookExecutionRequest
        from pathlib import Path
        from datetime import datetime
        
        return NotebookExecutionRequest(
            notebook_ref="distributed_training_script",
            notebook_path=Path("/distributed_training/train_distributed.py"),
            parameters={
                "config": {
                    "model_type": config.model_type,
                    "strategy": config.strategy,
                    "num_gpus": config.num_gpus,
                    "batch_size": config.batch_size,
                    "learning_rate": config.learning_rate
                }
            },
            environment="production",
            resource_requirements={
                "gpu_count": config.num_gpus,
                "memory_gb": 64,
                "cpu_count": 16
            },
            user_id="system",
            request_id=f"lambda_job_{datetime.now().strftime('%Y%m%d_%H%M%S')}",
            timestamp=datetime.now()
        )

# Submit distributed training job
lambda_adapter = LambdaTrainingAdapter(
    lambda_project="ml-distributed-training",
    lambda_queue="gpu-high"
)

config = create_distributed_training_config()
job_result = lambda_adapter.submit_distributed_job(config, Path("/tmp/distributed_training"))
print(f"Distributed training job submitted: {job_result['job_id']}")
```

## Scenario 2: Batch Inference (EX-05)

### Overview

Batch inference extends EX-03 to handle large volumes of predictions
efficiently with lineage preservation and cost controls.

### Architecture

    ┌─────────────────────────────────────────────────────────────────┐
    │                        Batch Inference                          │
    ├─────────────────────────────────────────────────────────────────┤
    │  Input Layer                                                    │
    │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
    │  │ Data            │  │ Validation     │  │ Queue           │ │
    │  │ Sources         │  │ Pipeline       │  │ Management      │ │
    │  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
    ├─────────────────────────────────────────────────────────────────┤
    │  Processing Layer                                               │
    │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
    │  │ Batch           │  │ Model          │  │ Results         │ │
    │  │ Processing      │  │ Loading        │  │ Aggregation     │ │
    │  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
    ├─────────────────────────────────────────────────────────────────┤
    │  Output Layer                                                   │
    │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
    │  │ Predictions     │  │ Lineage        │  │ Cost            │ │
    │  │ Storage         │  │ Tracking       │  │ Attribution     │ │
    │  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
    └─────────────────────────────────────────────────────────────────┘

### Implementation

#### 1. Batch Processing Configuration

``` python
from dataclasses import dataclass
from typing import List, Dict, Any, Optional
from pathlib import Path
import json

@dataclass
class BatchInferenceConfig:
    """Configuration for batch inference processing."""
    
    # Model configuration
    model_name: str
    model_version: str
    model_type: str
    
    # Batch processing parameters
    batch_size: int
    max_batch_wait_time: int  # seconds
    max_concurrent_batches: int
    
    # Data configuration
    input_data_path: Path
    output_data_path: Path
    lineage_output_path: Path
    
    # Performance parameters
    timeout_per_batch: int
    retry_attempts: int
    retry_delay: int
    
    # Cost parameters
    cost_tracking_enabled: bool
    cost_per_prediction: float

def create_batch_inference_config() -> BatchInferenceConfig:
    """Create batch inference configuration."""
    return BatchInferenceConfig(
        model_name="diabetes_xgboost",
        model_version="v1.0",
        model_type="xgboost",
        batch_size=1000,
        max_batch_wait_time=300,
        max_concurrent_batches=10,
        input_data_path=Path("/data/batch_input.csv"),
        output_data_path=Path("/data/batch_output.csv"),
        lineage_output_path=Path("/data/batch_lineage.json"),
        timeout_per_batch=600,
        retry_attempts=3,
        retry_delay=5,
        cost_tracking_enabled=True,
        cost_per_prediction=0.001
    )
```

#### 2. Batch Inference Engine

``` python
import pandas as pd
import numpy as np
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import List, Dict, Any, Callable
import time
from datetime import datetime
import json
from pathlib import Path

class BatchInferenceEngine:
    def __init__(self, config: BatchInferenceConfig, model_serving):
        self.config = config
        self.model_serving = model_serving
        self.prediction_logger = self._setup_prediction_logger()
        self.cost_tracker = self._setup_cost_tracker()
        
    def _setup_prediction_logger(self):
        """Setup prediction logging for batch processing."""
        log_dir = self.config.output_data_path.parent / "logs"
        log_dir.mkdir(parents=True, exist_ok=True)
        return PredictionLogger(log_dir)
    
    def _setup_cost_tracker(self):
        """Setup cost tracking for batch processing."""
        if self.config.cost_tracking_enabled:
            return BatchCostTracker(self.config)
        return None
    
    def process_batch_file(self) -> Dict[str, Any]:
        """Process entire batch file."""
        start_time = time.time()
        
        # Load input data
        print(f"Loading input data from: {self.config.input_data_path}")
        input_df = pd.read_csv(self.config.input_data_path)
        print(f"Loaded {len(input_df)} records")
        
        # Process in batches
        results = []
        total_batches = (len(input_df) + self.config.batch_size - 1) // self.config.batch_size
        
        print(f"Processing in {total_batches} batches...")
        
        # Create batch executor
        with ThreadPoolExecutor(max_workers=self.config.max_concurrent_batches) as executor:
            # Submit all batches
            future_to_batch = {}
            
            for i in range(total_batches):
                start_idx = i * self.config.batch_size
                end_idx = min((i + 1) * self.config.batch_size, len(input_df))
                batch_data = input_df.iloc[start_idx:end_idx]
                
                future = executor.submit(self._process_single_batch, batch_data, i)
                future_to_batch[future] = i
            
            # Collect results
            completed_batches = 0
            for future in as_completed(future_to_batch):
                batch_idx = future_to_batch[future]
                try:
                    batch_result = future.result()
                    results.extend(batch_result)
                    completed_batches += 1
                    
                    print(f"Completed batch {batch_idx + 1}/{total_batches}")
                    
                except Exception as e:
                    print(f"Batch {batch_idx + 1} failed: {str(e)}")
        
        # Save results
        output_df = pd.DataFrame(results)
        output_df.to_csv(self.config.output_data_path, index=False)
        print(f"Results saved to: {self.config.output_data_path}")
        
        # Save lineage
        lineage_info = self._save_lineage_info(input_df, output_df)
        
        # Calculate total cost
        total_cost = self.cost_tracker.calculate_total_cost(len(input_df)) if self.cost_tracker else 0
        
        end_time = time.time()
        total_duration = end_time - start_time
        
        return {
            "total_records": len(input_df),
            "total_batches": total_batches,
            "completed_batches": completed_batches,
            "output_path": str(self.config.output_data_path),
            "lineage_path": str(self.config.lineage_output_path),
            "total_duration_seconds": total_duration,
            "records_per_second": len(input_df) / total_duration,
            "total_cost": total_cost,
            "timestamp": datetime.now().isoformat()
        }
    
    def _process_single_batch(self, batch_data: pd.DataFrame, batch_idx: int) -> List[Dict[str, Any]]:
        """Process a single batch of data."""
        
        # Make predictions
        predictions = self.model_serving.predict(batch_data)
        
        # Create prediction records
        results = []
        for i, prediction in enumerate(predictions["predictions"]):
            record = {
                "record_id": f"{batch_idx * self.config.batch_size + i}",
                "input_data": batch_data.iloc[i].to_dict(),
                "prediction": prediction,
                "model_version": predictions["model_version"],
                "model_type": predictions["model_type"],
                "timestamp": datetime.now().isoformat(),
                "batch_id": batch_idx,
                "batch_position": i
            }
            results.append(record)
        
        # Log batch predictions
        batch_metadata = {
            "batch_id": batch_idx,
            "batch_size": len(batch_data),
            "start_time": datetime.now().isoformat(),
            "model_version": predictions["model_version"]
        }
        
        self.prediction_logger.log_prediction(
            {"predictions": predictions["predictions"], "batch_size": len(batch_data)},
            batch_metadata
        )
        
        return results
    
    def _save_lineage_info(self, input_df: pd.DataFrame, output_df: pd.DataFrame) -> Dict[str, Any]:
        """Save batch processing lineage information."""
        
        lineage_info = {
            "batch_processing": {
                "timestamp": datetime.now().isoformat(),
                "input_records": len(input_df),
                "output_records": len(output_df),
                "model_name": self.config.model_name,
                "model_version": self.config.model_version,
                "batch_size": self.config.batch_size,
                "processing_duration": 0,  # Would be calculated in real implementation
                "success_rate": len(output_df) / len(input_df),
                "input_schema": list(input_df.columns),
                "output_schema": list(output_df.columns)
            },
            "data_quality": {
                "missing_values": input_df.isnull().sum().to_dict(),
                "data_types": input_df.dtypes.to_dict(),
                "value_ranges": {col: [input_df[col].min(), input_df[col].max()] 
                               for col in input_df.columns}
            }
        }
        
        # Save lineage file
        with self.config.lineage_output_path.open('w') as f:
            json.dump(lineage_info, f, indent=2)
        
        print(f"Lineage information saved to: {self.config.lineage_output_path}")
        
        return lineage_info

class BatchCostTracker:
    """Tracker for batch inference costs."""
    
    def __init__(self, config: BatchInferenceConfig):
        self.config = config
        self.start_time = time.time()
        self.prediction_count = 0
    
    def record_predictions(self, count: int):
        """Record number of predictions made."""
        self.prediction_count += count
    
    def calculate_total_cost(self, total_predictions: int) -> float:
        """Calculate total cost for batch processing."""
        compute_time = time.time() - self.start_time
        compute_cost = compute_time * 0.01  # $0.01 per compute hour
        
        prediction_cost = total_predictions * self.config.cost_per_prediction
        
        total_cost = compute_cost + prediction_cost
        
        return {
            "compute_cost": compute_cost,
            "prediction_cost": prediction_cost,
            "total_cost": total_cost,
            "compute_hours": compute_time / 3600,
            "predictions": total_predictions
        }

# Execute batch inference
config = create_batch_inference_config()
batch_engine = BatchInferenceEngine(config, local_serving)
batch_result = batch_engine.process_batch_file()

print(f"Batch inference completed:")
print(f"  Total records: {batch_result['total_records']}")
print(f"  Processing time: {batch_result['total_duration_seconds']:.2f} seconds")
print(f"  Throughput: {batch_result['records_per_second']:.2f} records/second")
print(f"  Total cost: ${batch_result['total_cost']:.4f}")
```

## Scenario 3: Online Serving (EX-06)

### Overview

Online serving extends EX-03 to provide real-time model deployment with
monitoring, rollback capabilities, and service health management.

### Architecture

    ┌─────────────────────────────────────────────────────────────────┐
    │                         Online Serving                          │
    ├─────────────────────────────────────────────────────────────────┤
    │  API Layer                                                      │
    │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
    │  │ REST API         │  │ GraphQL API     │  │ gRPC API        │ │
    │  │ Endpoint         │  │ Endpoint        │  │ Endpoint        │ │
    │  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
    ├─────────────────────────────────────────────────────────────────┤
    │  Service Layer                                                  │
    │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
    │  │ Model           │  │ Health Check    │  │ Metrics         │ │
    │  │ Serving         │  │ Service         │  │ Collection      │ │
    │  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
    ├─────────────────────────────────────────────────────────────────┤
    │  Model Layer                                                    │
    │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
    │  │ Model Loading   │  │ Version         │  │ A/B Testing     │ │
    │  │ & Caching       │  │ Management      │  │ & Rollbacks     │ │
    │  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
    ├─────────────────────────────────────────────────────────────────┤
    │  Infrastructure Layer                                           │
    │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
    │  │ Kubernetes      │  │ Load Balancer   │  │ Monitoring      │ │
    │  │ Pods            │  │ Service         │  │ Stack           │ │
    │  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
    └─────────────────────────────────────────────────────────────────┘

### Implementation

#### 1. Online Serving Configuration

``` python
from dataclasses import dataclass
from typing import Dict, Any, List, Optional
from pathlib import Path
import json

@dataclass
class OnlineServingConfig:
    """Configuration for online model serving."""
    
    # Service configuration
    service_name: str
    service_port: int
    service_workers: int
    service_timeout: int
    
    # Model configuration
    model_name: str
    model_version: str
    model_type: str
    model_path: Path
    
    # Performance configuration
    max_request_size: int
    max_concurrent_requests: int
    request_timeout: int
    
    # Monitoring configuration
    health_check_interval: int
    metrics_port: int
    log_level: str
    
    # Deployment configuration
    deployment_strategy: str  # 'rolling', 'blue_green', 'canary'
    rollout_percentage: int
    rollback_threshold: float
    
    # Security configuration
    authentication_enabled: bool
    authorization_enabled: bool
    rate_limiting_enabled: bool

def create_online_serving_config() -> OnlineServingConfig:
    """Create online serving configuration."""
    return OnlineServingConfig(
        service_name="diabetes-predictor",
        service_port=8000,
        service_workers=4,
        service_timeout=30,
        model_name="diabetes_xgboost",
        model_version="v1.0",
        model_type="xgboost",
        model_path=Path("/tmp/model_bundle_v1.0"),
        max_request_size=1024 * 1024,  # 1MB
        max_concurrent_requests=100,
        request_timeout=10,
        health_check_interval=30,
        metrics_port=8001,
        log_level="INFO",
        deployment_strategy="rolling",
        rollout_percentage=100,
        rollback_threshold=0.05,
        authentication_enabled=False,
        authorization_enabled=False,
        rate_limiting_enabled=True
    )
```

#### 2. Online Serving API

``` python
from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import List, Dict, Any, Optional
import uvicorn
import asyncio
import time
from datetime import datetime
from pathlib import Path
import json

class PredictionRequest(BaseModel):
    """Request model for online predictions."""
    data: List[List[float]]
    model_version: Optional[str] = "v1.0"
    request_id: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = {}

class PredictionResponse(BaseModel):
    """Response model for online predictions."""
    predictions: List[float]
    model_version: str
    request_id: str
    processing_time: float
    timestamp: str
    metadata: Dict[str, Any]

class HealthResponse(BaseModel):
    """Health check response."""
    status: str
    model_version: str
    uptime: float
    metrics: Dict[str, Any]

class OnlineServingAPI:
    """FastAPI-based online serving API."""
    
    def __init__(self, config: OnlineServingConfig):
        self.config = config
        self.app = FastAPI(
            title=config.service_name,
            version="1.0.0",
            description="ML Deploy Online Model Serving API"
        )
        
        # Model serving
        self.model_serving = None
        self.model_version = config.model_version
        
        # Metrics
        self.metrics = {
            "total_requests": 0,
            "successful_requests": 0,
            "failed_requests": 0,
            "average_processing_time": 0.0,
            "start_time": time.time()
        }
        
        # Rate limiting
        self.rate_limiter = {}
        
        # Setup routes
        self._setup_routes()
    
    def _setup_routes(self):
        """Setup API routes."""
        
        @self.app.get("/health")
        async def health_check() -> HealthResponse:
            """Health check endpoint."""
            uptime = time.time() - self.metrics["start_time"]
            
            return HealthResponse(
                status="healthy",
                model_version=self.model_version,
                uptime=uptime,
                metrics=self._get_current_metrics()
            )
        
        @self.app.post("/predict", response_model=PredictionResponse)
        async def predict(request: PredictionRequest) -> PredictionResponse:
            """Prediction endpoint."""
            start_time = time.time()
            
            # Rate limiting
            if self.config.rate_limiting_enabled:
                if not self._check_rate_limit(request.request_id):
                    raise HTTPException(status_code=429, detail="Rate limit exceeded")
            
            try:
                # Convert input to DataFrame
                import pandas as pd
                input_df = pd.DataFrame(request.data)
                
                # Make predictions
                prediction_result = self.model_serving.predict(input_df)
                
                # Update metrics
                processing_time = time.time() - start_time
                self._update_metrics(True, processing_time)
                
                return PredictionResponse(
                    predictions=prediction_result["predictions"],
                    model_version=prediction_result["model_version"],
                    request_id=request.request_id or f"req_{datetime.now().strftime('%Y%m%d_%H%M%S')}",
                    processing_time=processing_time,
                    timestamp=datetime.now().isoformat(),
                    metadata={
                        "input_shape": input_df.shape,
                        "model_type": prediction_result["model_type"]
                    }
                )
                
            except Exception as e:
                # Update metrics
                processing_time = time.time() - start_time
                self._update_metrics(False, processing_time)
                
                raise HTTPException(status_code=500, detail=str(e))
        
        @self.app.get("/metrics")
        async def get_metrics() -> Dict[str, Any]:
            """Get service metrics."""
            return self._get_current_metrics()
        
        @self.app.get("/model/info")
        async def get_model_info() -> Dict[str, Any]:
            """Get model information."""
            return {
                "model_name": self.config.model_name,
                "model_version": self.model_version,
                "model_type": self.config.model_type,
                "service_name": self.config.service_name,
                "service_port": self.config.service_port
            }
    
    def _check_rate_limit(self, request_id: str) -> bool:
        """Check if request is within rate limits."""
        current_time = time.time()
        
        # Clean old entries
        self.rate_limiter = {
            k: v for k, v in self.rate_limiter.items()
            if current_time - v < 60  # 1 minute window
        }
        
        # Check if we've exceeded the limit
        if len(self.rate_limiter) >= self.config.max_concurrent_requests:
            return False
        
        # Add current request
        self.rate_limiter[request_id] = current_time
        return True
    
    def _update_metrics(self, success: bool, processing_time: float):
        """Update service metrics."""
        self.metrics["total_requests"] += 1
        
        if success:
            self.metrics["successful_requests"] += 1
        else:
            self.metrics["failed_requests"] += 1
        
        # Update average processing time
        current_avg = self.metrics["average_processing_time"]
        total_requests = self.metrics["total_requests"]
        self.metrics["average_processing_time"] = (
            (current_avg * (total_requests - 1) + processing_time) / total_requests
        )
    
    def _get_current_metrics(self) -> Dict[str, Any]:
        """Get current service metrics."""
        uptime = time.time() - self.metrics["start_time"]
        
        return {
            "total_requests": self.metrics["total_requests"],
            "successful_requests": self.metrics["successful_requests"],
            "failed_requests": self.metrics["failed_requests"],
            "success_rate": self.metrics["successful_requests"] / max(1, self.metrics["total_requests"]),
            "average_processing_time": self.metrics["average_processing_time"],
            "uptime_seconds": uptime,
            "requests_per_second": self.metrics["total_requests"] / max(1, uptime),
            "rate_limiter_size": len(self.rate_limiter)
        }
    
    def start_service(self):
        """Start the online serving service."""
        import uvicorn
        
        # Initialize model serving
        from ml_deploy.vertical_slice import LocalModelServing
        self.model_serving = LocalModelServing(self.config.model_path)
        
        print(f"Starting {self.config.service_name} on port {self.config.service_port}")
        print(f"Model: {self.config.model_name} v{self.config.model_version}")
        
        uvicorn.run(
            self.app,
            host="0.0.0.0",
            port=self.config.service_port,
            workers=self.config.service_workers,
            log_level=self.config.log_level
        )

# Start online serving
config = create_online_serving_config()
serving_api = OnlineServingAPI(config)
serving_api.start_service()
```

## Scenario 4: Multi-Environment Deployment

### Overview

Multi-environment deployment manages the same model across different
environments (dev, staging, production) with proper governance and
monitoring.

### Implementation

#### 1. Environment Management

``` python
from dataclasses import dataclass
from typing import Dict, Any, List
from enum import Enum
from pathlib import Path

class Environment(Enum):
    DEVELOPMENT = "dev"
    STAGING = "staging"
    PRODUCTION = "production"

@dataclass
class EnvironmentConfig:
    """Configuration for specific environment."""
    environment: Environment
    kubernetes_namespace: str
    resource_limits: Dict[str, Any]
    monitoring_enabled: bool
    logging_level: str
    auto_scaling: bool
    min_replicas: int
    max_replicas: int

class MultiEnvironmentManager:
    """Manages deployment across multiple environments."""
    
    def __init__(self):
        self.environments = {
            Environment.DEVELOPMENT: EnvironmentConfig(
                environment=Environment.DEVELOPMENT,
                kubernetes_namespace="ml-dev",
                resource_limits={"cpu": "1", "memory": "2Gi"},
                monitoring_enabled=True,
                logging_level="DEBUG",
                auto_scaling=False,
                min_replicas=1,
                max_replicas=1
            ),
            Environment.STAGING: EnvironmentConfig(
                environment=Environment.STAGING,
                kubernetes_namespace="ml-staging",
                resource_limits={"cpu": "2", "memory": "4Gi"},
                monitoring_enabled=True,
                logging_level="INFO",
                auto_scaling=True,
                min_replicas=2,
                max_replicas=5
            ),
            Environment.PRODUCTION: EnvironmentConfig(
                environment=Environment.PRODUCTION,
                kubernetes_namespace="ml-prod",
                resource_limits={"cpu": "4", "memory": "8Gi"},
                monitoring_enabled=True,
                logging_level="WARNING",
                auto_scaling=True,
                min_replicas=3,
                max_replicas=10
            )
        }
    
    def deploy_model(self, model_name: str, model_version: str, 
                     environment: Environment) -> Dict[str, Any]:
        """Deploy model to specific environment."""
        config = self.environments[environment]
        
        # Generate Kubernetes deployment manifest
        deployment_manifest = self._generate_deployment_manifest(
            model_name, model_version, config
        )
        
        # Apply to Kubernetes
        # kubectl apply -f deployment_manifest
        
        return {
            "model_name": model_name,
            "model_version": model_version,
            "environment": environment.value,
            "namespace": config.kubernetes_namespace,
            "deployment_time": datetime.now().isoformat(),
            "resource_limits": config.resource_limits
        }
    
    def _generate_deployment_manifest(self, model_name: str, 
                                    model_version: str, 
                                    config: EnvironmentConfig) -> Dict[str, Any]:
        """Generate Kubernetes deployment manifest."""
        return {
            "apiVersion": "apps/v1",
            "kind": "Deployment",
            "metadata": {
                "name": f"{model_name}-v{model_version}",
                "namespace": config.kubernetes_namespace
            },
            "spec": {
                "replicas": config.min_replicas,
                "selector": {
                    "matchLabels": {
                        "app": model_name,
                        "version": model_version
                    }
                },
                "template": {
                    "metadata": {
                        "labels": {
                            "app": model_name,
                            "version": model_version
                        }
                    },
                    "spec": {
                        "containers": [{
                            "name": model_name,
                            "image": f"registry.example.com/{model_name}:v{model_version}",
                            "ports": [{
                                "containerPort": 8000
                            }],
                            "resources": {
                                "limits": config.resource_limits,
                                "requests": config.resource_limits
                            },
                            "env": [
                                {
                                    "name": "MODEL_NAME",
                                    "value": model_name
                                },
                                {
                                    "name": "MODEL_VERSION",
                                    "value": model_version
                                },
                                {
                                    "name": "LOG_LEVEL",
                                    "value": config.logging_level
                                }
                            ]
                        }]
                    }
                },
                "strategy": {
                    "type": "RollingUpdate",
                    "rollingUpdate": {
                        "maxUnavailable": 1,
                        "maxSurge": 1
                    }
                }
            }
        }
    
    def rollback_deployment(self, model_name: str, environment: Environment) -> Dict[str, Any]:
        """Rollback deployment to previous version."""
        # Implementation for rollback logic
        return {
            "action": "rollback",
            "model_name": model_name,
            "environment": environment.value,
            "rollback_time": datetime.now().isoformat()
        }
```

## Best Practices for Advanced Scenarios

### Performance Optimization

1.  **Batch Processing**: Use appropriate batch sizes to balance
    throughput and latency
2.  **Model Caching**: Cache frequently accessed models to reduce
    loading time
3.  **Asynchronous Processing**: Use async/await for non-blocking
    operations
4.  **Load Balancing**: Distribute requests across multiple instances

### Monitoring and Observability

1.  **Metrics Collection**: Track key metrics like request rate,
    latency, error rates
2.  **Health Checks**: Implement comprehensive health checks for all
    components
3.  **Logging**: Use structured logging with proper correlation IDs
4.  **Alerting**: Set up alerts for critical issues

### Security Considerations

1.  **Authentication**: Implement proper authentication for API
    endpoints
2.  **Authorization**: Use role-based access control
3.  **Rate Limiting**: Protect against abuse with rate limiting
4.  **Input Validation**: Validate all inputs to prevent injection
    attacks

### Cost Management

1.  **Resource Optimization**: Right-size resources for each workload
2.  **Auto-scaling**: Use auto-scaling to handle variable loads
3.  **Monitoring**: Track costs and optimize spending
4.  **Spot Instances**: Use spot instances for fault-tolerant workloads

## Next Steps

After completing the advanced scenarios tutorial:

1.  **Explore the documentation**:
    - [Implementation
      Patterns](../reference/01_Implementation_Patterns.qmd)
    - [API Documentation](../reference/02_API_Documentation.qmd)
    - [Infrastructure Setup](../reference/03_Infrastructure_Setup.qmd)
2.  **Set up your environment**:
    - Configure distributed training infrastructure
    - Set up batch processing pipelines
    - Deploy online serving endpoints
3.  **Join the community**:
    - Share your experiences
    - Ask questions
    - Contribute to the project
4.  **Contribute to the platform**:
    - Submit pull requests
    - Report issues
    - Help improve documentation

------------------------------------------------------------------------

*This advanced scenarios tutorial demonstrates how to extend ML Deploy
for complex use cases. Each scenario builds upon the core patterns while
adding specific capabilities for distributed training, batch inference,
online serving, and multi-environment management.*
