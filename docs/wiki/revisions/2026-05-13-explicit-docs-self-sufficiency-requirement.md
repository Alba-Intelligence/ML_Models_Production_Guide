# 2026-05-13 Explicit docs self-sufficiency requirement

## Overview

Tightened the distilled Allium documentation-series requirement so the intent is explicit: implementation-relevant behavior must be obtainable from published QMD docs without source-tree browsing.

## Spec changes

- Updated `DocumentationSeries` with:
  - `makes_repository_source_browsing_unnecessary: Boolean`
- Updated `RequireImplementationReadyNotebookSeries` with:
  - `ensures: series.makes_repository_source_browsing_unnecessary = true`
- Added explicit guidance text that published docs must be sufficient on their own for behavior, configuration, infrastructure definitions, and operational wiring.

## Why

Previous wording implied this goal but did not enforce it as an explicit obligation. This revision makes the requirement unambiguous and testable.
