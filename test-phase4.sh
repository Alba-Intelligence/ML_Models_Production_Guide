#!/usr/bin/env bash

# Phase 4: Documentation Testing and Quality Assurance
# This script tests the documentation structure without executing code

set -e

echo "🧪 Phase 4: Testing and Quality Assurance"
echo "====================================="

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS_DIR="${SCRIPT_DIR}/nbs"
OUTPUT_DIR="${SCRIPT_DIR}/_docs/nbs"
TEST_LOG="phase4_test_results.log"

# Initialize log
> "$TEST_LOG"

# Function to log test results
log_test() {
    local status="$1"
    local message="$2"
    echo "$status $message" | tee -a "$TEST_LOG"
}

log_test "🔍" "Starting Phase 4 testing..."

# Test 1: Content Structure Validation
echo ""
echo "📋 Test 1: Content Structure Validation"
echo "-------------------------------------"

# Check all required files exist
required_files=(
    "${DOCS_DIR}/index.qmd"
    "${DOCS_DIR}/navigation-guide.qmd"
    "${DOCS_DIR}/reading-paths.qmd"
    "${DOCS_DIR}/styles.css"
    "${DOCS_DIR}/_quarto.yml"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        log_test "✅" "Required file exists: $(basename "$file")"
    else
        log_test "❌" "Required file missing: $(basename "$file")"
    fi
done

# Check tutorial files
tutorial_files=(
    "01_Terminology_Glossary.qmd"
    "02_Getting_Started.qmd"
    "03_Concepts_and_Architecture.qmd"
    "04_End_to_End_Workflow.qmd"
    "05_Advanced_Scenarios.qmd"
    "06_Migration_Guide.qmd"
)

echo ""
log_test "📚" "Checking tutorial files..."
for file in "${tutorial_files[@]}"; do
    if [ -f "${DOCS_DIR}/tutorials/$file" ]; then
        log_test "✅" "Tutorial file: $file"
        # Check file size
        size=$(wc -l < "${DOCS_DIR}/tutorials/$file")
        log_test "📊" "  - Size: $size lines"
    else
        log_test "❌" "Tutorial file missing: $file"
    fi
done

# Check reference files
reference_files=(
    "01_Implementation_Patterns.qmd"
    "02_API_Documentation.qmd"
)

echo ""
log_test "🔧" "Checking reference files..."
for file in "${reference_files[@]}"; do
    if [ -f "${DOCS_DIR}/reference/$file" ]; then
        log_test "✅" "Reference file: $file"
        # Check file size
        size=$(wc -l < "${DOCS_DIR}/reference/$file")
        log_test "📊" "  - Size: $size lines"
    else
        log_test "❌" "Reference file missing: $file"
    fi
done

# Test 2: Quarto Configuration Validation
echo ""
echo "🔧 Test 2: Quarto Configuration Validation"
echo "----------------------------------------"

# Check Quarto configuration
if [ -f "${DOCS_DIR}/_quarto.yml" ]; then
    log_test "✅" "Quarto configuration file exists"
    
    # Check for required configurations
    if grep -q "tutorials/" "${DOCS_DIR}/_quarto.yml"; then
        log_test "✅" "Quarto config includes tutorials directory"
    else
        log_test "❌" "Quarto config missing tutorials directory"
    fi
    
    if grep -q "reference/" "${DOCS_DIR}/_quarto.yml"; then
        log_test "✅" "Quarto config includes reference directory"
    else
        log_test "❌" "Quarto config missing reference directory"
    fi
    
    if grep -q "navigation-guide.qmd" "${DOCS_DIR}/_quarto.yml"; then
        log_test "✅" "Quarto config includes navigation guide"
    else
        log_test "❌" "Quarto config missing navigation guide"
    fi
else
    log_test "❌" "Quarto configuration file missing"
fi

# Test 3: Content Validation
echo ""
echo "📝 Test 3: Content Validation"
echo "-----------------------------"

# Check for content in key files
content_checks=(
    "${DOCS_DIR}/index.qmd:ML Deploy Documentation"
    "${DOCS_DIR}/navigation-guide.qmd:How to Use This Documentation"
    "${DOCS_DIR}/reading-paths.qmd:Role-Based Reading Paths"
    "${DOCS_DIR}/tutorials/01_Terminology_Glossary.qmd:Terminology"
    "${DOCS_DIR}/tutorials/02_Getting_Started.qmd:Getting Started"
)

for check in "${content_checks[@]}"; do
    file="${check%%:*}"
    content="${check#*:}"
    if [ -f "$file" ] && grep -q "$content" "$file"; then
        log_test "✅" "Content check passed: $content"
    else
        log_test "⚠️" "Content check failed: $content"
    fi
done

# Test 4: File Organization Validation
echo ""
echo "🗂️ Test 4: File Organization Validation"
echo "------------------------------------"

# Check directory structure
directories=(
    "${DOCS_DIR}/tutorials"
    "${DOCS_DIR}/reference"
)

for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        log_test "✅" "Directory exists: $dir"
        file_count=$(find "$dir" -name "*.qmd" | wc -l)
        log_test "📊" "  - QMD files: $file_count"
    else
        log_test "❌" "Directory missing: $dir"
    fi
done

# Test 5: CSS Validation
echo ""
echo "🎨 Test 5: CSS Validation"
echo "-------------------------"

if [ -f "${DOCS_DIR}/styles.css" ]; then
    log_test "✅" "CSS file exists"
    
    # Check for key CSS styles
    css_checks=(
        "h1"
        "h2"
        "h3"
        "tutorial"
        "reference"
        "alert"
        "learning-path"
    )
    
    for style in "${css_checks[@]}"; do
        if grep -q "$style" "${DOCS_DIR}/styles.css"; then
            log_test "✅" "CSS style present: $style"
        else
            log_test "⚠️" "CSS style missing: $style"
        fi
    done
else
    log_test "❌" "CSS file missing"
fi

# Test 6: Navigation Structure Validation
echo ""
echo "🧭 Test 6: Navigation Structure Validation"
echo "----------------------------------------"

# Check sidebar configuration
sidebar_config="${DOCS_DIR}/_quarto.yml"
if [ -f "$sidebar_config" ]; then
    # Check for main sections
    sections=("📚 Tutorials" "🔧 Technical Reference" "🏗️ Original Documentation")
    
    for section in "${sections[@]}"; do
        if grep -q "$section" "$sidebar_config"; then
            log_test "✅" "Sidebar section: $section"
        else
            log_test "❌" "Sidebar section missing: $section"
        fi
    done
fi

# Test 7: Build Test (Simple Files Only)
echo ""
echo "🏗️ Test 7: Build Test (Simple Files Only)"
echo "-----------------------------------------"

# Test building only new files that don't have complex kernels
test_files=(
    "${DOCS_DIR}/index.qmd"
    "${DOCS_DIR}/navigation-guide.qmd"
    "${DOCS_DIR}/reading-paths.qmd"
    "${DOCS_DIR}/simple-test.qmd"
)

build_success_count=0
for file in "${test_files[@]}"; do
    if [ -f "$file" ]; then
        log_test "🔄" "Testing build: $(basename "$file")"
        if quarto render "$file" --quiet --no-execute; then
            log_test "✅" "Build successful: $(basename "$file")"
            build_success_count=$((build_success_count + 1))
            
            # Check if output was created
            output_file="${OUTPUT_DIR}/$(basename "$file" .qmd).html"
            if [ -f "$output_file" ]; then
                log_test "✅" "Output created: $(basename "$output_file")"
            else
                log_test "❌" "Output missing: $(basename "$output_file")"
            fi
        else
            log_test "❌" "Build failed: $(basename "$file")"
        fi
    fi
done

echo ""
echo "📊 Test 7 Results: $build_success_count/${#test_files[@]} files built successfully"

# Test 8: Link Validation (Internal Links)
echo ""
echo "🔗 Test 8: Link Validation (Internal)"
echo "-----------------------------------"

# Check for internal links in new files
for file in "${DOCS_DIR}/"*.qmd "${DOCS_DIR}/tutorials/"*.qmd "${DOCS_DIR}/reference/"*.qmd; do
    if [ -f "$file" ]; then
        # Check for internal links (simplified check)
        if grep -q "\[.*\](.*/.*\.qmd)" "$file"; then
            log_test "📝" "Internal links found: $(basename "$file")"
        fi
    fi
done

# Test 9: File Size Validation
echo ""
echo "📏 Test 9: File Size Validation"
echo "-----------------------------"

# Check total content size
total_size=$(find "${DOCS_DIR}" -name "*.qmd" -exec wc -l {} + | tail -1 | awk '{print $1}')
log_test "📊" "Total QMD content: $total_size lines"

# Check individual section sizes
tutorial_size=$(find "${DOCS_DIR}/tutorials" -name "*.qmd" -exec wc -l {} + | tail -1 | awk '{print $1}')
reference_size=$(find "${DOCS_DIR}/reference" -name "*.qmd" -exec wc -l {} + | tail -1 | awk '{print $1}')
nav_size=$(find "${DOCS_DIR}" -maxdepth 1 -name "*.qmd" -exec wc -l {} + | tail -1 | awk '{print $1}')

log_test "📊" "Tutorial content: $tutorial_size lines"
log_test "📊" "Reference content: $reference_size lines"
log_test "📊" "Navigation content: $nav_size lines"

# Test 10: Quality Metrics
echo ""
echo "🎯 Test 10: Quality Metrics"
echo "---------------------------"

# Calculate quality score
quality_score=0
max_score=0

# Content structure (20 points)
max_score=$((max_score + 20))
required_files_count=0
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        required_files_count=$((required_files_count + 1))
    fi
done
quality_score=$((quality_score + (required_files_count * 20 / ${#required_files[@]})))

# Tutorial files (20 points)
max_score=$((max_score + 20))
tutorial_files_count=0
for file in "${tutorial_files[@]}"; do
    if [ -f "${DOCS_DIR}/tutorials/$file" ]; then
        tutorial_files_count=$((tutorial_files_count + 1))
    fi
done
quality_score=$((quality_score + (tutorial_files_count * 20 / ${#tutorial_files[@]})))

# Reference files (20 points)
max_score=$((max_score + 20))
reference_files_count=0
for file in "${reference_files[@]}"; do
    if [ -f "${DOCS_DIR}/reference/$file" ]; then
        reference_files_count=$((reference_files_count + 1))
    fi
done
quality_score=$((quality_score + (reference_files_count * 20 / ${#reference_files[@]})))

# Configuration (20 points)
max_score=$((max_score + 20))
if [ -f "${DOCS_DIR}/_quarto.yml" ] && grep -q "tutorials/" "${DOCS_DIR}/_quarto.yml" && grep -q "reference/" "${DOCS_DIR}/_quarto.yml"; then
    quality_score=$((quality_score + 20))
fi

# CSS (20 points)
max_score=$((max_score + 20))
if [ -f "${DOCS_DIR}/styles.css" ]; then
    css_checks_passed=0
    for style in "${css_checks[@]}"; do
        if grep -q "$style" "${DOCS_DIR}/styles.css"; then
            css_checks_passed=$((css_checks_passed + 1))
        fi
    done
    quality_score=$((quality_score + (css_checks_passed * 20 / ${#css_checks[@]})))
fi

log_test "🎯" "Quality Score: $quality_score/$max_score"

# Final Summary
echo ""
echo "📋 Phase 4 Test Summary"
echo "====================="

# Count test results
success_count=$(grep -c "✅" "$TEST_LOG")
warning_count=$(grep -c "⚠️" "$TEST_LOG")
error_count=$(grep -c "❌" "$TEST_LOG")

log_test "📊" "Tests passed: $success_count"
log_test "📊" "Warnings: $warning_count"
log_test "📊" "Errors: $error_count"

# Determine overall status
if [ $error_count -eq 0 ] && [ $warning_count -le 2 ]; then
    log_test "🎉" "Phase 4 testing PASSED - Documentation ready for production"
    exit 0
elif [ $error_count -eq 0 ]; then
    log_test "⚠️" "Phase 4 testing completed with minor warnings - Documentation ready with caveats"
    exit 0
else
    log_test "❌" "Phase 4 testing FAILED - Documentation needs fixes"
    exit 1
fi

# Cleanup
rm -f "$TEST_LOG"