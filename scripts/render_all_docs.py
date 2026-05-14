#!/usr/bin/env python3
"""
Script to render all Quarto documentation files with timeout.
"""

import subprocess
import os
from pathlib import Path
import sys


def render_file(file_path, output_dir="_site"):
    """Render a single Quarto file with timeout."""
    try:
        # Use timeout to prevent hanging
        result = subprocess.run(
            [
                "timeout",
                "--kill-after",
                "60",
                "30",
                "quarto",
                "render",
                "--no-execute",
                str(file_path),
                "--output-dir",
                str(output_dir),
            ],
            capture_output=True,
            text=True,
            timeout=90,
        )

        if result.returncode == 0:
            print(f"✅ Successfully rendered: {file_path.name}")
            return True
        elif "timeout" in result.stderr or result.returncode == 124:
            print(f"⏰ Timeout rendering: {file_path.name}")
            return False
        else:
            print(f"❌ Error rendering {file_path.name}: {result.stderr}")
            return False

    except subprocess.TimeoutExpired:
        print(f"⏰ Timeout rendering: {file_path.name}")
        return False
    except Exception as e:
        print(f"❌ Exception rendering {file_path.name}: {e}")
        return False


def main():
    """Render all Quarto files in nbs directory."""
    nbs_dir = Path("nbs")
    output_dir = Path("_site")

    # Create output directory if it doesn't exist
    output_dir.mkdir(exist_ok=True)

    # Find all .qmd files
    qmd_files = list(nbs_dir.glob("*.qmd"))
    qmd_files.sort()  # Sort for consistent rendering

    print(f"Found {len(qmd_files)} Quarto files to render")
    print("=" * 50)

    successful = []
    failed = []

    for qmd_file in qmd_files:
        print(f"Rendering: {qmd_file.name}")
        if render_file(qmd_file, output_dir):
            successful.append(qmd_file)
        else:
            failed.append(qmd_file)
        print()

    # Summary
    print("=" * 50)
    print("📊 RENDERING SUMMARY")
    print("=" * 50)
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

    print(f"\n📂 Output directory: {output_dir}")
    print("🎉 Rendering complete!")


if __name__ == "__main__":
    main()

