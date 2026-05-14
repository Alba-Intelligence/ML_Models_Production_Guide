#!/usr/bin/env python3
"""
Script to render all Quarto files with --no-execute flag to avoid code execution.
"""

import subprocess
import os
from pathlib import Path
import sys

def render_file_with_timeout(qmd_file, output_dir="_site"):
    """Render a single Quarto file with --no-execute and timeout."""
    try:
        # Use timeout to prevent hanging
        result = subprocess.run([
            "timeout", "--kill-after", "45", "30", 
            "quarto", "render", str(qmd_file), "--no-execute", "--output-dir", str(output_dir)
        ], capture_output=True, text=True, timeout=60)
        
        if result.returncode == 0:
            print(f"✅ Successfully rendered: {qmd_file.name}")
            return True
        elif "timeout" in result.stderr or result.returncode == 124:
            print(f"⏰ Timeout rendering: {qmd_file.name}")
            return False
        else:
            print(f"❌ Error rendering {qmd_file.name}: {result.stderr}")
            return False
            
    except subprocess.TimeoutExpired:
        print(f"⏰ Timeout rendering: {qmd_file.name}")
        return False
    except Exception as e:
        print(f"❌ Exception rendering {qmd_file.name}: {e}")
        return False

def main():
    """Render all Quarto files in nbs directory with --no-execute."""
    nbs_dir = Path("nbs")
    output_dir = Path("_site")
    
    # Create output directory if it doesn't exist
    output_dir.mkdir(exist_ok=True)
    
    # Find all .qmd files
    qmd_files = list(nbs_dir.glob("*.qmd"))
    qmd_files.sort()  # Sort for consistent rendering
    
    print(f"Found {len(qmd_files)} Quarto files to render with --no-execute")
    print("=" * 60)
    
    successful = []
    failed = []
    
    for i, qmd_file in enumerate(qmd_files, 1):
        print(f"[{i}/{len(qmd_files)}] Rendering: {qmd_file.name}")
        if render_file_with_timeout(qmd_file, output_dir):
            successful.append(qmd_file)
        else:
            failed.append(qmd_file)
        print()
    
    # Summary
    print("=" * 60)
    print("📊 QUARTO HTML RENDERING SUMMARY (--no-execute)")
    print("=" * 60)
    print(f"✅ Successfully rendered: {len(successful)}")
    print(f"❌ Failed to render: {len(failed)}")
    print(f"📁 Total files: {len(qmd_files)}")
    
    if successful:
        print("\n✅ Successful files:")
        for file in successful:
            print(f"  - {file.name}")
    
    if failed:
        print("\n❌ Failed files:")
        for file in failed:
            print(f"  - {file.name}")
    
    if len(successful) > 0:
        print(f"\n📂 Output directory: {output_dir}")
        print("🎉 Quarto HTML rendering complete (--no-execute)!")
        print("\nNote: Used --no-execute flag to skip code execution.")
        print("HTML files are ready for viewing.")
    else:
        print("\n⚠️  No files were rendered successfully.")
        print("Check the error messages above for issues.")

if __name__ == "__main__":
    main()