#!/usr/bin/env python3
"""
Simple HTML renderer for Quarto documentation without code execution.
This converts markdown to HTML without trying to execute Python code.
"""

import subprocess
import os
from pathlib import Path
import re
import shutil

def markdown_to_html(md_content, title="ML Documentation"):
    """Convert markdown content to simple HTML."""
    # Extract title from markdown
    title_match = re.search(r'^#\s+(.+)$', md_content, re.MULTILINE)
    if title_match:
        title = title_match.group(1)
    
    # Convert common markdown to HTML
    html_content = md_content
    
    # Headers
    html_content = re.sub(r'^# (.+)$', r'<h1>\1</h1>', html_content, flags=re.MULTILINE)
    html_content = re.sub(r'^## (.+)$', r'<h2>\1</h2>', html_content, flags=re.MULTILINE)
    html_content = re.sub(r'^### (.+)$', r'<h3>\1</h3>', html_content, flags=re.MULTILINE)
    html_content = re.sub(r'^#### (.+)$', r'<h4>\1</h4>', html_content, flags=re.MULTILINE)
    
    # Paragraphs
    html_content = re.sub(r'^([^<].+)$', r'<p>\1</p>', html_content, flags=re.MULTILINE)
    
    # Bold and italic
    html_content = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', html_content)
    html_content = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html_content)
    
    # Code blocks
    html_content = re.sub(r'```.*?\n(.*?)```', r'<pre><code>\1</code></pre>', html_content, flags=re.DOTALL)
    html_content = re.sub(r'`(.+?)`', r'<code>\1</code>', html_content)
    
    # Lists
    html_content = re.sub(r'^- (.+)$', r'<li>\1</li>', html_content, flags=re.MULTILINE)
    html_content = re.sub(r'(<li>.*?</li>)', r'<ul>\1</ul>', html_content, flags=re.DOTALL)
    
    # Links
    html_content = re.sub(r'\[([^\]]+)\]\(([^)]+)\)', r'<a href="\2">\1</a>', html_content)
    
    # Create full HTML document
    full_html = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title}</title>
    <style>
        body {{ font-family: Arial, sans-serif; line-height: 1.6; max-width: 800px; margin: 0 auto; padding: 20px; }}
        h1 {{ color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }}
        h2 {{ color: #34495e; margin-top: 30px; }}
        h3 {{ color: #5d6d7e; }}
        h4 {{ color: #85929e; }}
        pre {{ background: #f4f4f4; padding: 15px; border-radius: 5px; overflow-x: auto; }}
        code {{ background: #f4f4f4; padding: 2px 4px; border-radius: 3px; }}
        ul {{ margin: 10px 0; }}
        li {{ margin: 5px 0; }}
        a {{ color: #3498db; text-decoration: none; }}
        a:hover {{ text-decoration: underline; }}
        .warning {{ background: #fff3cd; border: 1px solid #ffeaa7; padding: 10px; border-radius: 5px; margin: 10px 0; }}
    </style>
</head>
<body>
    {html_content}
</body>
</html>"""
    
    return full_html

def render_file_simple(qmd_file, output_dir):
    """Render a Quarto file to simple HTML without code execution."""
    try:
        # Read the markdown content
        with open(qmd_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Extract filename without extension
        filename = qmd_file.stem + '.html'
        
        # Convert to HTML
        html_content = markdown_to_html(content)
        
        # Write HTML file
        output_path = Path(output_dir) / filename
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(html_content)
        
        print(f"✅ Successfully rendered: {qmd_file.name} → {filename}")
        return True
        
    except Exception as e:
        print(f"❌ Error rendering {qmd_file.name}: {e}")
        return False

def main():
    """Render all Quarto files to simple HTML."""
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
        if render_file_simple(qmd_file, output_dir):
            successful.append(qmd_file)
        else:
            failed.append(qmd_file)
        print()
    
    # Summary
    print("=" * 50)
    print("📊 SIMPLE HTML RENDERING SUMMARY")
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
    print("🎉 Simple HTML rendering complete!")
    print("\nNote: This is a basic HTML conversion without code execution.")
    print("For full Quarto features, use 'quarto render' without code execution.")

if __name__ == "__main__":
    main()