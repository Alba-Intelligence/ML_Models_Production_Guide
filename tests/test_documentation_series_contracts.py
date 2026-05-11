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
        cls.platform_narrative = cls.nbs_dir / "01_platform_narrative.ipynb"
        cls.index_notebook = cls.nbs_dir / "index.ipynb"
        cls.vertical_slice = cls.nbs_dir / "06_vertical_slice.ipynb"

    @staticmethod
    def _load_notebook_text(path: Path) -> str:
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
        text = self._load_notebook_text(self.platform_narrative)
        self.assertIn("## Platform architecture", text)
        self.assertIn("```{mermaid}", text)

    def test_docs_site_module_section_exists(self) -> None:
        text = self._load_notebook_text(self.index_notebook)
        self.assertIn("## Lifecycle notebooks", text)
        self.assertIn("## Topology and operations notebooks", text)
        self.assertIn("[Vertical slice reference]", text)
        self.assertIn("[Execution backends]", text)

    def test_python_implementation_module_exists(self) -> None:
        self.assertTrue(self.vertical_slice.exists())
        text = self._load_notebook_text(self.vertical_slice)
        self.assertIn("#| default_exp vertical_slice", text)
        self.assertIn("def execute_first_vertical_slice", text)

    def test_docs_pages_render_for_module_links(self) -> None:
        expected = {
            "vertical_slice.html",
            "webui_contracts.html",
            "execution_backends.html",
            "terraform_bootstrap.html",
        }
        rendered = {p.name for p in self.docs_dir.glob("*.html")}
        self.assertTrue(expected.issubset(rendered))


class TestDocumentationSeriesAspirationalObligations(unittest.TestCase):
    """Aspirational obligations kept in spec but not yet implemented."""

    @classmethod
    def setUpClass(cls) -> None:
        cls.repo_root = Path(__file__).resolve().parents[1]
        cls.platform_narrative = cls.repo_root / "nbs" / "01_platform_narrative.ipynb"

    @staticmethod
    def _load_notebook_text(path: Path) -> str:
        payload = json.loads(path.read_text(encoding="utf-8"))
        chunks: list[str] = []
        for cell in payload.get("cells", []):
            source = cell.get("source", [])
            if isinstance(source, list):
                chunks.append("".join(source))
            elif isinstance(source, str):
                chunks.append(source)
        return "\n".join(chunks)

    @unittest.skip("Aspirational obligation: dedicated trade-off analysis section not yet authored")
    def test_tradeoff_analysis_present(self) -> None:
        text = self._load_notebook_text(self.platform_narrative)
        self.assertIn("## Trade-offs", text)

    @unittest.skip("Aspirational obligation: usage examples section not yet authored")
    def test_usage_examples_present(self) -> None:
        text = self._load_notebook_text(self.platform_narrative)
        self.assertIn("## Examples of use", text)

    @unittest.skip("Aspirational obligation: ML researcher learning path not yet authored")
    def test_ml_researcher_learning_path_present(self) -> None:
        text = self._load_notebook_text(self.platform_narrative)
        self.assertIn("## ML researcher learning path", text)


if __name__ == "__main__":
    unittest.main()
