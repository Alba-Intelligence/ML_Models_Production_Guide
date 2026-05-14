#!/usr/bin/env bash

# ML Deploy Documentation Validation Script
# Validates the restructured documentation

set -e

echo "🔍 ML Deploy Documentation Validation"
echo "====================================="

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS_DIR="${SCRIPT_DIR}/nbs"
OUTPUT_DIR="${SCRIPT_DIR}/_docs/nbs"
ERROR_LOG="validation_errors.log"
WARNING_LOG="validation_warnings.log"

# Initialize logs
> "$ERROR_LOG"
> "$WARNING_LOG"

# Function to log errors
log_error() {
    echo "❌ $1" | tee -a "$ERROR_LOG"
}

# Function to log warnings
log_warning() {
    echo "⚠️  $1" | tee -a "$WARNING_LOG"
}

# Function to log success
log_success() {
    echo "✅ $1"
}

# Check required files exist
echo "📁 Checking required files..."

if [ ! -f "$DOCS_DIR/index.qmd" ]; then
    log_error "Main index.qmd not found"
else
    log_success "Main index.qmd found"
fi

if [ ! -f "$DOCS_DIR/_quarto.yml" ]; then
    log_error "Quarto configuration not found"
else
    log_success "Quarto configuration found"
fi

if [ ! -f "$DOCS_DIR/styles.css" ]; then
    log_error "Custom CSS not found"
else
    log_success "Custom CSS found"
fi

# Check tutorial directory
if [ ! -d "$DOCS_DIR/tutorials" ]; then
    log_error "Tutorials directory not found"
else
    log_success "Tutorials directory found"
    
    # Check tutorial files
    tutorial_files=(
        "01_Terminology_Glossary.qmd"
        "02_Getting_Started.qmd"
        "03_Concepts_and_Architecture.qmd"
        "04_End_to_End_Workflow.qmd"
        "05_Advanced_Scenarios.qmd"
        "06_Migration_Guide.qmd"
    )
    
    for file in "${tutorial_files[@]}"; do
        if [ -f "$DOCS_DIR/tutorials/$file" ]; then
            log_success "Tutorial file: $file"
        else
            log_error "Tutorial file missing: $file"
        fi
    done
fi

# Check reference directory
if [ ! -d "$DOCS_DIR/reference" ]; then
    log_error "Reference directory not found"
else
    log_success "Reference directory found"
    
    # Check reference files
    reference_files=(
        "01_Implementation_Patterns.qmd"
        "02_API_Documentation.qmd"
    )
    
    for file in "${reference_files[@]}"; do
        if [ -f "$DOCS_DIR/reference/$file" ]; then
            log_success "Reference file: $file"
        else
            log_error "Reference file missing: $file"
        fi
    done
fi

# Check navigation files
nav_files=(
    "navigation-guide.qmd"
    "reading-paths.qmd"
)

for file in "${nav_files[@]}"; do
    if [ -f "$DOCS_DIR/$file" ]; then
        log_success "Navigation file: $file"
    else
        log_error "Navigation file missing: $file"
    fi
done

# Check Quarto configuration
echo ""
echo "🔧 Checking Quarto configuration..."

if grep -q "tutorials/" "$DOCS_DIR/_quarto.yml"; then
    log_success "Quarto config includes tutorials"
else
    log_error "Quarto config missing tutorials directory"
fi

if grep -q "reference/" "$DOCS_DIR/_quarto.yml"; then
    log_success "Quarto config includes reference"
else
    log_error "Quarto config missing reference directory"
fi

if grep -q "navigation-guide.qmd" "$DOCS_DIR/_quarto.yml"; then
    log_success "Quarto config includes navigation guide"
else
    log_error "Quarto config missing navigation guide"
fi

# Test Quarto build on a single file
echo ""
echo "🧪 Testing Quarto build..."

if [ -f "$DOCS_DIR/test-config.qmd" ]; then
    if quarto render "$DOCS_DIR/test-config.qmd" --quiet; then
        log_success "Quarto build test successful"
        
        # Check if output was created
        if [ -f "$OUTPUT_DIR/test-config.html" ]; then
            log_success "HTML output created successfully"
            # Clean up test file
            rm -f "$OUTPUT_DIR/test-config.html" "$OUTPUT_DIR/test-config.md"
        else
            log_error "HTML output not found"
        fi
    else
        log_error "Quarto build test failed"
    fi
else
    log_warning "Test configuration file not found"
fi

# Check for broken links in new files
echo ""
echo "🔗 Checking for broken links..."

for file in "$DOCS_DIR/tutorials/"*.qmd "$DOCS_DIR/reference/"*.qmd; do
    if [ -f "$file" ]; then
        # Check for internal links that might be broken
        if grep -q "\[.*\](.*/.*\.qmd)" "$file"; then
            log_success "File has internal links: $(basename "$file")"
        fi
    fi
done

# Validate file sizes
echo ""
echo "📊 Checking file sizes..."

for dir in tutorials reference; do
    if [ -d "$DOCS_DIR/$dir" ]; then
        echo "Files in $dir:"
        find "$DOCS_DIR/$dir" -name "*.qmd" -exec wc -l {} \; | sort -n
    fi
done

# Summary
echo ""
echo "📋 Validation Summary"
echo "===================="

if [ -s "$ERROR_LOG" ]; then
    echo ""
    echo "❌ Errors found:"
    cat "$ERROR_LOG"
    exit 1
else
    echo ""
    echo "✅ All validation checks passed!"
fi

if [ -s "$WARNING_LOG" ]; then
    echo ""
    echo "⚠️  Warnings found:"
    cat "$WARNING_LOG"
fi

echo ""
echo "🎉 Documentation structure is ready for Phase 4!"
echo ""

# Clean up logs
rm -f "$ERROR_LOG" "$WARNING_LOG"