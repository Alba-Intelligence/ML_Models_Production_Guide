---
title: "Documentation Restructuring Plan"
---

# 📋 Documentation Restructuring Plan

> **Status**: 🟡 IN PROGRESS  
> **Owner**: Emmanuel  
> **Priority**: High  
> **Last Updated**: 2026-05-15

This plan restructures the documentation into separate Tutorial and Technical Reference sections with clear audience targeting and proper terminology explanation.

## 🎯 Current Issues

### Problems with Current Structure
1. **Unclear Terminology**: "First Vertical Slice (EX-01 -> EX-03)" comes out of nowhere
2. **Mixed Content**: Tutorial explanations mixed with technical implementation code  
3. **No Clear Learning Path**: Users don't know where to start based on their role/goal
4. **Unclear Audience Targeting**: Same content for both beginners and experts

### Content Analysis Summary
- **18 QMD files** total in current structure
- **Mixed content types** (tutorial + technical) in most files
- **Unclear terminology** that needs explanation
- **Poor navigation** for different audience types

## 📊 Progress Tracking

### ✅ Phase 1: Analysis and Planning (COMPLETE - 6 hours)
- [x] Content analysis and mapping complete
- [x] Audience personas defined  
- [x] New structure designed and planned
- [x] File mapping created

### 🟡 Phase 2: Content Restructuring (IN PROGRESS - ~28 hours remaining)
- [ ] Tutorial Section Creation (NEXT TASK)
- [ ] Reference Section Creation
- [ ] Terminology Standardization and Explanation
- [ ] Content Splitting and Refactoring

### ⏳ Phase 3: Configuration and Navigation (PENDING)
- [ ] Quarto Configuration Update
- [ ] Navigation and Reading Guides

### ⏳ Phase 4: Testing and Quality Assurance (PENDING)
- [ ] Content Validation
- [ ] Rendering and Build Testing

### ⏳ Phase 5: Documentation and Training (PENDING)
- [ ] Documentation Updates
- [ ] Training and Rollout

## 🗂️ New Structure Design

### Tutorial Section (`tutorials/`)
Learning-focused content for different audience types:

#### `tutorials/01_Getting_Started.qmd`
- **Purpose**: Quick start guide for new users
- **Content**: Platform overview, setup, first run, basic concepts
- **Audience**: All new users

#### `tutorials/02_Concepts_and_Architecture.qmd`  
- **Purpose**: High-level understanding of the system
- **Content**: Platform components, ML workflow, key concepts
- **Key Addition**: EX-01, EX-02, EX-03 explanations
- **Audience**: ML Engineers, Platform Engineers

#### `tutorials/03_End_to_End_Workflow.qmd`
- **Purpose**: Step-by-step tutorial with explanations
- **Content**: Complete example from data to deployment
- **Audience**: Developers implementing workflows

#### `tutorials/04_Advanced_Scenarios.qmd`
- **Purpose**: Advanced use cases and patterns
- **Content**: Multi-model workflows, cloud deployment, monitoring
- **Audience**: Experienced users

### Reference Section (`reference/`)
Technical implementation details:

#### `reference/01_Implementation_Patterns.qmd`
- **Purpose**: Technical implementation patterns
- **Content**: EX-01, EX-02, EX-03 detailed implementation
- **Rename from**: `nbs/02_04-complete_workflow.qmd`
- **New Title**: "Implementation Patterns: EX-01 → EX-03"

#### `reference/02_API_Documentation.qmd`
- **Purpose**: Complete API reference
- **Content**: All exported functions, classes, methods
- **From**: `nbs/04_03-api_contracts.qmd`

#### `reference/03_Infrastructure_Setup.qmd`
- **Purpose**: Technical infrastructure setup
- **Content**: Local/cloud deployment, infrastructure as code
- **From**: `nbs/03_01-03_04.qmd`

#### `reference/04_Architecture_Details.qmd`
- **Purpose**: Deep technical architecture
- **Content**: System design, performance, security
- **From**: `nbs/05_01-system_architecture.qmd`

## ⚠️ Critical Issues to Address

### 1. Terminology Standardization
**Problem**: "First Vertical Slice (EX-01 -> EX-03)" is unclear

**Solution**: 
- Rename to "Implementation Patterns: EX-01 → EX-03"
- Add clear explanation:
  - **EX-01**: Training with Traceability (MLflow integration)
  - **EX-02**: Artifact Bundling and Versioning (model packaging)
  - **EX-03**: Local Deployment and Serving (prediction infrastructure)

### 2. Content Separation
**Problem**: Tutorial and technical content mixed together

**Solution**: 
- Extract conceptual explanations for tutorials
- Keep technical implementation in reference
- Maintain clear separation of concerns

### 3. Navigation System
**Problem**: Poor navigation for different audiences

**Solution**: 
- Create role-based reading paths
- Add clear descriptions for each file
- Create "How to use this documentation" guide

## 🎯 Success Criteria

### Quality Metrics
- [ ] All content properly categorized (Tutorial vs Reference)
- [ ] Terminology is consistent and well-explained
- [ ] Navigation system is intuitive and user-friendly
- [ ] All links and references work correctly
- [ ] Quarto rendering works without errors
- [ ] Content is complete and accurate

### User Experience Metrics
- [ ] New users can find relevant content quickly
- [ ] Each audience has a clear learning path
- [ ] Technical users can find reference information easily
- [ ] Tutorial content is progressive and easy to follow
- [ ] Documentation is searchable and discoverable

### Technical Metrics
- [ ] Build time is reasonable (< 5 minutes)
- [ ] HTML output is properly formatted and responsive
- [ ] Search functionality works correctly
- [ ] All code examples are functional
- [ ] No broken links or references

## 🤖 Agent Instructions

### For Future AI Coding Agents

#### How to Use This Plan
1. **Check Status**: Review current progress above and in `docs/wiki/plans/documentation-restructuring-plan.md`
2. **Identify Next Task**: Start with Tutorial Section Creation (Phase 2.1)
3. **Update Progress**: Mark tasks as completed as work progresses
4. **Report Issues**: Add new risks or gaps to the plan
5. **Check Dependencies**: Verify dependencies are met before starting tasks

#### Common Pitfalls to Avoid
- Don't skip content analysis (already completed)
- Maintain terminology consistency throughout all files
- Keep technical content accurate during restructuring
- Test build system changes incrementally
- Update navigation when structure changes

#### Questions for Future Agents
1. Is the terminology still consistent with the actual implementation?
2. Are there new audience personas that need to be accommodated?
3. Has the build system changed in ways that affect this plan?
4. Are there new tools or frameworks that should be documented?
5. Is the navigation system working well for different user types?

## 🔗 Related Documentation

- [Full Plan Details](docs/wiki/plans/documentation-restructuring-plan.md) - Complete task breakdown and dependencies
- [Quick Reference](docs/wiki/queries/documentation-restructuring-plan-reference.md) - Quick overview for agents
- [Current State](docs/wiki/current-state.md) - Repository status and gaps
- [Agent Guidelines](AGENTS.md) - General agent workflow and constraints

---

## 📋 Implementation Checklist

### Phase 2: Content Restructuring (NEXT)

#### Task 2.1: Tutorial Section Creation
- [ ] Create `tutorials/` directory
- [ ] Split existing conceptual content into tutorial files
- [ ] Write comprehensive introductions and explanations
- [ ] Create progressive learning paths
- [ ] Rename files to new naming convention
- [ ] Add tutorial introductions for each file
- [ ] Add missing conceptual explanations

#### Task 2.2: Reference Section Creation  
- [ ] Create `reference/` directory
- [ ] Move technical content to reference files
- [ ] Maintain technical accuracy while improving organization
- [ ] Add comprehensive API documentation
- [ ] Extract technical patterns from existing code
- [ ] Create API reference documentation

#### Task 2.3: Terminology Standardization and Explanation
- [ ] Create terminology glossary in Tutorial section
- [ ] Explain EX-01, EX-02, EX-03 concepts
- [ ] Rename "First Vertical Slice" to "Implementation Patterns: EX-01 → EX-03"
- [ ] Add context for all technical terms
- [ ] Create cross-references between concepts and implementations
- [ ] Create terminology standardization guide

#### Task 2.4: Content Splitting and Refactoring
- [ ] Separate conceptual explanations from technical code
- [ ] Extract tutorial content from technical files
- [ ] Remove duplicate content between sections
- [ ] Ensure consistent terminology across all files
- [ ] Add missing context and explanations
- [ ] Create content inventory tracking spreadsheet

---

**Status**: 🟡 IN PROGRESS  
**Next Action**: Start Task 2.1 - Tutorial Section Creation  
**Estimate**: ~28 hours remaining in Phase 2