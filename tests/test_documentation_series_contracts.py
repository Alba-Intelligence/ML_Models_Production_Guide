"""Spec-propagated tests for documentation-series completeness obligations."""

from __future__ import annotations

import json
from pathlib import Path
import unittest


class TestDocumentationSeriesImplementedObligations(unittest.TestCase):
    """Checks mapped from implemented portions of RequireImplementationReadyNotebookSeries."""

    @classmethod
    def setUpClass(cls) -> None:
        cls.repo_root = Path(__file__).resolve().parents[1]
        cls.nbs_dir = cls.repo_root / "nbs"
        cls.docs_dir = cls.repo_root / "_docs"
        cls.platform_narrative = cls.nbs_dir / "01_platform_narrative.qmd"
        cls.index_notebook = cls.nbs_dir / "index.qmd"
        cls.vertical_slice = cls.nbs_dir / "06_vertical_slice.qmd"

    @staticmethod
    def _load_document_text(path: Path) -> str:
        if path.suffix == ".qmd":
            return path.read_text(encoding="utf-8")
        payload = json.loads(path.read_text(encoding="utf-8"))
        chunks: list[str] = []
        for cell in payload.get("cells", []):
            source = cell.get("source", [])
            if isinstance(source, list):
                chunks.append("".join(source))
            elif isinstance(source, str):
                chunks.append(source)
        return "\n".join(chunks)

    def test_architecture_description_exists(self) -> None:
        text = self._load_document_text(self.platform_narrative)
        self.assertIn("## Platform architecture", text)
        self.assertIn("```{mermaid}", text)

    def test_docs_site_module_section_exists(self) -> None:
        text = self._load_document_text(self.index_notebook)
        self.assertIn("## Lifecycle notebooks", text)
        self.assertIn("## Topology and operations notebooks", text)
        self.assertIn("[Vertical slice reference]", text)
        self.assertIn("[Execution backends]", text)

    def test_python_implementation_module_exists(self) -> None:
        self.assertTrue(self.vertical_slice.exists())
        text = self._load_document_text(self.vertical_slice)
        self.assertIn("#| default_exp: vertical_slice", text)
        self.assertIn("def execute_first_vertical_slice", text)

    def test_docs_pages_render_for_module_links(self) -> None:
        expected_suffixes = (
            "vertical_slice.html",
            "webui_contracts.html",
            "execution_backends.html",
            "infrastructure_mcp.html",
        )
        rendered = {p.name for p in self.docs_dir.glob("*.html")}
        rendered.update({p.name for p in (self.docs_dir / "nbs").glob("*.html")})
        for suffix in expected_suffixes:
            self.assertTrue(any(name.endswith(suffix) for name in rendered))


class TestDocumentationSeriesRequiredContentObligations(unittest.TestCase):
    """Checks for required documentation-series content obligations."""

    @classmethod
    def setUpClass(cls) -> None:
        cls.repo_root = Path(__file__).resolve().parents[1]
        cls.platform_narrative = cls.repo_root / "nbs" / "01_platform_narrative.qmd"

    @staticmethod
    def _load_document_text(path: Path) -> str:
        if path.suffix == ".qmd":
            return path.read_text(encoding="utf-8")
        payload = json.loads(path.read_text(encoding="utf-8"))
        chunks: list[str] = []
        for cell in payload.get("cells", []):
            source = cell.get("source", [])
            if isinstance(source, list):
                chunks.append("".join(source))
            elif isinstance(source, str):
                chunks.append(source)
        return "\n".join(chunks)

    def test_implementation_steps_present(self) -> None:
        text = self._load_document_text(self.platform_narrative)
        self.assertIn("## Implementation steps", text)

    def test_tradeoff_analysis_present(self) -> None:
        text = self._load_document_text(self.platform_narrative)
        self.assertIn("## Trade-offs", text)

    def test_security_considerations_present(self) -> None:
        text = self._load_document_text(self.platform_narrative)
        self.assertIn("## Security considerations", text)

    def test_usage_examples_present(self) -> None:
        text = self._load_document_text(self.platform_narrative)
        self.assertIn("## Examples of use", text)

    def test_software_engineer_learning_path_present(self) -> None:
        text = self._load_document_text(self.platform_narrative)
        self.assertIn("## Software engineer learning path", text)

    def test_ml_researcher_learning_path_present(self) -> None:
        text = self._load_document_text(self.platform_narrative)
        self.assertIn("## ML researcher learning path", text)


class TestDocumentationSelfSufficiency(unittest.TestCase):
    """Checks that published QMD docs are self-sufficient without requiring source browsing."""

    @classmethod
    def setUpClass(cls) -> None:
        cls.repo_root = Path(__file__).resolve().parents[1]
        cls.platform_narrative = cls.repo_root / "nbs" / "01_platform_narrative.qmd"
        cls.index_notebook = cls.repo_root / "nbs" / "index.qmd"
        cls.vertical_slice = cls.repo_root / "nbs" / "06_vertical_slice.qmd"

    @staticmethod
    def _load_document_text(path: Path) -> str:
        if path.suffix == ".qmd":
            return path.read_text(encoding="utf-8")
        payload = json.loads(path.read_text(encoding="utf-8"))
        chunks: list[str] = []
        for cell in payload.get("cells", []):
            source = cell.get("source", [])
            if isinstance(source, list):
                chunks.append("".join(source))
            elif isinstance(source, str):
                chunks.append(source)
        return "\n".join(chunks)

    def test_no_deferred_to_source_references(self) -> None:
        """Ensure docs don't defer readers to source code."""
        text_narrative = self._load_document_text(self.platform_narrative)
        text_index = self._load_document_text(self.index_notebook)
        text_vertical = self._load_document_text(self.vertical_slice)
        all_text = text_narrative + text_index + text_vertical
        
        # Check that docs don't require source browsing for implementation details
        anti_patterns = [
            "see the source code",
            "refer to the source",
            "check the repository",
            "look at the implementation",
        ]
        for pattern in anti_patterns:
            self.assertNotIn(pattern.lower(), all_text.lower(),
                           msg=f"Docs should not defer to source: '{pattern}'")

    def test_vertical_slice_example_contains_runnable_code(self) -> None:
        """Ensure the vertical slice example has complete, documented code."""
        text = self._load_document_text(self.vertical_slice)
        # Verify the function is defined and documented
        self.assertIn("def execute_first_vertical_slice", text)
        # Check that the function is documented in the notebook
        self.assertIn("def generate_synthetic_dataset", text)
        self.assertIn("def train_with_traceability", text)
        self.assertIn("def package_and_register_model", text)

    def test_platform_narrative_documents_all_key_modules(self) -> None:
        """Ensure platform narrative references major components."""
        text = self._load_document_text(self.platform_narrative)
        # Check for key infrastructure and service references
        key_references = [
            "MLflow",  # Tracking system
            "Nix",     # Infrastructure-as-code
            "Kubernetes",  # Cloud execution platform
            "Slurm",   # HPC execution platform
        ]
        for reference in key_references:
            self.assertIn(reference, text,
                        msg=f"Platform narrative should reference {reference}")


if __name__ == "__main__":
    unittest.main()
