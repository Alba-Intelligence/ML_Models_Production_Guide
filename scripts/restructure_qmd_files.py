#!/usr/bin/env python3
"""
Script to restructure Quarto documentation files according to hierarchical naming convention.

This script renames all .qmd files in the nbs/ directory to follow the pattern:
SS_XX-DescriptiveName.qmd

Where:
- SS: Section number (01-05)
- XX: Position within section (01, 02, 03, etc.)
- DescriptiveName: Clear, descriptive name with hyphens

Mapping based on the restructure plan:
Section 1: Platform Overview & Foundations (01_)
Section 2: ML Development Lifecycle (02_)
Section 3: Infrastructure & Operations (03_)
Section 4: System Integration & Governance (04_)
Section 5: Architecture & Design (05_)
"""

import os
import shutil
import re
from pathlib import Path
from typing import Dict, Tuple

class QmdRestructure:
    def __init__(self, source_dir: str = "nbs"):
        self.source_dir = Path(source_dir)
        self.backup_dir = Path("nbs_backup")
        self.file_mapping = {
            # Section 1: Platform Overview & Foundations (01_)
            "index.qmd": "01_01-getting_started.qmd",
            "00_introduction.qmd": "01_02-platform_introduction.qmd",
            "01_platform_narrative.qmd": "01_03-platform_architecture.qmd",
            "00_core.qmd": "01_04-core_concepts.qmd",
            
            # Section 2: ML Development Lifecycle (02_)
            "02_data.qmd": "02_01-data_management.qmd",
            "03_model_training.qmd": "02_02-model_development.qmd",
            "07_mlflow_parity.qmd": "02_03-mlflow_integration.qmd",
            "06_vertical_slice.qmd": "02_04-complete_workflow.qmd",
            
            # Section 3: Infrastructure & Operations (03_)
            "13_opentofu_infra.qmd": "03_01-infrastructure_as_code.qmd",
            "14_infrastructure_mcp.qmd": "03_02-infrastructure_management.qmd",
            "15_aws_emulator.qmd": "03_03-local_development.qmd",
            "16_terranix_infra.qmd": "03_04-terraniq_integration.qmd",
            
            # Section 4: System Integration & Governance (04_)
            "08_execution_backends.qmd": "04_01-execution_framework.qmd",
            "09_notebook_intake.qmd": "04_02-notebook_management.qmd",
            "05_webui_contracts.qmd": "04_03-api_contracts.qmd",
            "04_web_ui.qmd": "04_04-user_interfaces.qmd",
            "17_governance_gates.qmd": "04_05-governance_framework.qmd",
            
            # Section 5: Architecture & Design (05_)
            "12_system_interaction_analysis.qmd": "05_01-system_architecture.qmd"
        }
        
        # Files that should be removed (duplicates or no longer needed)
        self.files_to_remove = [
            "README.md"  # Will be replaced with our structured README
        ]
    
    def create_backup(self):
        """Create a backup of the current nbs directory."""
        print("Creating backup of nbs directory...")
        if self.backup_dir.exists():
            shutil.rmtree(self.backup_dir)
        
        shutil.copytree(self.source_dir, self.backup_dir)
        print(f"Backup created at: {self.backup_dir}")
    
    def rename_files(self):
        """Rename files according to the mapping."""
        print("Renaming files...")
        
        for old_name, new_name in self.file_mapping.items():
            old_path = self.source_dir / old_name
            new_path = self.source_dir / new_name
            
            if old_path.exists():
                print(f"Renaming: {old_name} → {new_name}")
                old_path.rename(new_path)
            else:
                print(f"Warning: {old_name} not found, skipping")
    
    def remove_duplicate_files(self):
        """Remove duplicate or obsolete files."""
        print("Removing duplicate/obsolete files...")
        
        for file_name in self.files_to_remove:
            file_path = self.source_dir / file_name
            if file_path.exists():
                print(f"Removing: {file_name}")
                file_path.unlink()
    
    def update_internal_links(self):
        """Update internal links in renamed files."""
        print("Updating internal links...")
        
        for new_name in self.file_mapping.values():
            file_path = self.source_dir / new_name
            if file_path.exists():
                self._update_file_links(file_path)
    
    def _update_file_links(self, file_path: Path):
        """Update internal links in a single file."""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Replace old links with new links
            for old_name, new_name in self.file_mapping.items():
                # Handle relative links like [](old_name)
                old_link = f"]({old_name})"
                new_link = f"]({new_name})"
                
                if old_link in content:
                    content = content.replace(old_link, new_link)
                    print(f"Updated link in {file_path.name}: {old_name} → {new_name}")
                
                # Handle markdown links like [text](old_name)
                old_md_link = f"]({old_name})"
                new_md_link = f"]({new_name})"
                if old_md_link in content:
                    content = content.replace(old_md_link, new_md_link)
            
            # Write updated content back
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
                
        except Exception as e:
            print(f"Error updating links in {file_path.name}: {e}")
    
    def create_section_structure(self):
        """Create section directories and organize files."""
        print("Creating section directories...")
        
        sections = {
            "01_": "01_platform_overview_foundations",
            "02_": "02_ml_development_lifecycle", 
            "03_": "03_infrastructure_operations",
            "04_": "04_system_integration_governance",
            "05_": "05_architecture_design"
        }
        
        for prefix, dir_name in sections.items():
            section_dir = self.source_dir / dir_name
            section_dir.mkdir(exist_ok=True)
            print(f"Created directory: {section_dir}")
    
    def verify_structure(self):
        """Verify the new structure is correct."""
        print("Verifying new structure...")
        
        expected_files = set(self.file_mapping.values())
        actual_files = set()
        
        for file_path in self.source_dir.glob("*.qmd"):
            actual_files.add(file_path.name)
        
        missing_files = expected_files - actual_files
        extra_files = actual_files - expected_files
        
        if missing_files:
            print(f"Missing files: {missing_files}")
        
        if extra_files:
            print(f"Extra files: {extra_files}")
        
        if not missing_files and not extra_files:
            print("✅ All files accounted for!")
        else:
            print("❌ Structure verification failed!")
    
    def run(self):
        """Run the complete restructure process."""
        print("Starting Quarto documentation restructure...")
        print("=" * 50)
        
        # Step 1: Create backup
        self.create_backup()
        
        # Step 2: Rename files
        self.rename_files()
        
        # Step 3: Remove duplicates
        self.remove_duplicate_files()
        
        # Step 4: Update internal links
        self.update_internal_links()
        
        # Step 5: Create section structure
        self.create_section_structure()
        
        # Step 6: Verify structure
        self.verify_structure()
        
        print("=" * 50)
        print("✅ Restructure completed successfully!")
        print("\nNext steps:")
        print("1. Review the new structure")
        print("2. Test Quarto build: quarto render")
        print("3. Update any external documentation referencing old names")
        print("4. Test navigation in the rendered documentation")

if __name__ == "__main__":
    restructure = QmdRestructure()
    restructure.run()