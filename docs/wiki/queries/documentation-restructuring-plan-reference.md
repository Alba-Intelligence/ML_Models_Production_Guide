# Documentation Restructuring Plan - Quick Reference

**Status**: 🟡 IN PROGRESS  
**Plan Location**: `/docs/wiki/plans/documentation-restructuring-plan.md`

## 🎯 Quick Overview

**Goal**: Restructure documentation into Tutorial and Technical Reference sections  
**Current Issues**: Mixed content, unclear terminology, poor navigation  
**Target**: Clear separation with audience targeting and proper terminology

## 📊 Progress at a Glance

### ✅ Phase 1: Analysis and Planning (COMPLETE - 6 hours)

- Content analysis complete
- Audience personas defined
- New structure designed

### 🟡 Phase 2: Content Restructuring (IN PROGRESS - ~28 hours remaining)

- [ ] Tutorial Section Creation
- [ ] Reference Section Creation
- [ ] Terminology Standardization
- [ ] Content Splitting and Refactoring

### ⏳ Phases 3-5: Configuration, Testing, Documentation (PENDING)

## 🔑 Key Files to Create/Modify

### New Directories

- `tutorials/` - Learning-focused content
- `reference/` - Technical documentation

### File Mappings Needed

- `tutorials/01_Getting_Started.qmd` ← `nbs/01_01-getting_started.qmd`
- `tutorials/02_Concepts_and_Architecture.qmd` ← `nbs/01_02-01_04.qmd`
- `tutorials/03_End_to_End_Workflow.qmd` ← `nbs/02_01-02_03.qmd`
- `tutorials/04_Advanced_Scenarios.qmd` ← `nbs/03_XX-04_XX.qmd`
- `reference/01_Implementation_Patterns.qmd` ← `nbs/02_04-complete_workflow.qmd`
- `reference/02_API_Documentation.qmd` ← `nbs/04_03-api_contracts.qmd`
- `reference/03_Infrastructure_Setup.qmd` ← `nbs/03_01-03_04.qmd`
- `reference/04_Architecture_Details.qmd` ← `nbs/05_01-system_architecture.qmd`

## ⚠️ Critical Issues to Address

### Terminology Problems

- **Issue**: "First Vertical Slice (EX-01 -> EX-03)" is unclear
- **Fix**: Rename to "Implementation Patterns: EX-01 → EX-03"
- **Explanation Needed**:
  - EX-01: Training with Traceability
  - EX-02: Artifact Bundling and Versioning
  - EX-03: Local Deployment and Serving

### Content Separation

- **Issue**: Tutorial and technical content mixed together
- **Fix**: Split into separate directories with clear purposes

### Navigation System

- **Issue**: Poor navigation for different audiences
- **Fix**: Role-based reading paths and clear descriptions

## 🤖 Agent Instructions

### When Starting Work on This Plan

1. **Read Full Plan**: Start with `docs/wiki/plans/documentation-restructuring-plan.md`
2. **Check Dependencies**: Ensure Phase 1 tasks are complete
3. **Update Progress**: Mark tasks as completed in the main plan
4. **Test Changes**: Verify Quarto rendering after each major change
5. **Report Issues**: Add new risks or gaps to the main plan

### Success Checklist

- [ ] All tutorials are beginner-friendly with clear explanations
- [ ] All reference content is technically accurate
- [ ] Terminology is consistent throughout
- [ ] Navigation system works for all audience types
- [ ] Build system generates all HTML files correctly
- [ ] No broken links or references

### Common Questions Future Agents Might Have

**Q: Why split into tutorials and reference?**  
A: Different audiences have different needs - beginners want learning paths, experts want technical details.

**Q: How do I handle the content separation?**  
A: Extract conceptual explanations for tutorials, keep technical implementation in reference.

**Q: What about the EX-01, EX-02, EX-03 terminology?**  
A: These represent execution patterns that need clear explanation in the tutorial section.

**Q: How do I test the changes?**  
A: Use `cd nbs && quarto render --to html --no-execute` and check all HTML files render correctly.

---

**Reference for**: AI Coding Agents  
**Last Updated**: 2026-05-15
