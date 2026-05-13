"""Test that all qmd files follow the 5-subsection structure with diagrams."""

from __future__ import annotations

import json
from pathlib import Path
import unittest


class TestDocumentationStructureAndDiagrams(unittest.TestCase):
    """Verify that documentation implements the 5-subsection Platform Overview structure."""

    @classmethod
    def setUpClass(cls) -> None:
        cls.repo_root = Path(__file__).resolve().parents[1]
        cls.nbs_dir = cls.repo_root / "nbs"
        
        # Key files to check
        cls.platform_narrative = cls.nbs_dir / "01_platform_narrative.qmd"
        cls.index = cls.nbs_dir / "index.qmd"
        cls.vertical_slice = cls.nbs_dir / "06_vertical_slice.qmd"
        cls.mlflow_parity = cls.nbs_dir / "07_mlflow_parity.qmd"
        cls.execution_backends = cls.nbs_dir / "08_execution_backends.qmd"
        cls.governance_gates = cls.nbs_dir / "17_governance_gates.qmd"

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

    def test_platform_narrative_has_5_subsections(self) -> None:
        """Platform narrative must have all 5 subsections."""
        text = self._load_document_text(self.platform_narrative)
        
        required_subsections = [
            "## 1. System Components & Roles",
            "## 2. Execution & Data Flow",
            "## 3. Deployment & Infrastructure",
            "## 4. Governance & Safety",
            "## 5. Learning Paths",
        ]
        
        for section in required_subsections:
            self.assertIn(section, text,
                        msg=f"Platform narrative missing: {section}")

    def test_platform_narrative_has_class_diagram(self) -> None:
        """System Components section must have class diagram."""
        text = self._load_document_text(self.platform_narrative)
        self.assertIn("classDiagram", text,
                     msg="Platform narrative missing class diagram")
        self.assertIn("class Repository", text)
        self.assertIn("class DocumentationSeries", text)

    def test_platform_narrative_has_sequence_diagrams(self) -> None:
        """Execution & Data Flow section must have sequence diagrams."""
        text = self._load_document_text(self.platform_narrative)
        self.assertIn("sequenceDiagram", text,
                     msg="Platform narrative missing sequence diagrams")

    def test_platform_narrative_has_state_machines(self) -> None:
        """Governance section must have state machine diagrams."""
        text = self._load_document_text(self.platform_narrative)
        self.assertIn("stateDiagram-v2", text,
                     msg="Platform narrative missing state machine diagrams")

    def test_platform_narrative_has_topology_diagrams(self) -> None:
        """Deployment section must have topology diagrams."""
        text = self._load_document_text(self.platform_narrative)
        # Check for deployment/topology diagram markers
        self.assertIn("graph", text,
                     msg="Platform narrative missing topology diagrams")
        self.assertIn("Local Development", text)
        self.assertIn("Cloud Deployment", text)

    def test_platform_narrative_has_learning_path_diagrams(self) -> None:
        """Learning Paths section must have navigation diagrams."""
        text = self._load_document_text(self.platform_narrative)
        self.assertIn("Software Engineer Learning Path", text)
        self.assertIn("ML Researcher Learning Path", text)

    def test_index_has_navigation_guide(self) -> None:
        """Index page must guide readers through 5 subsections."""
        text = self._load_document_text(self.index)
        
        required_sections = [
            "System Components & Roles",
            "Execution & Data Flow",
            "Deployment & Infrastructure",
            "Governance & Safety",
            "Learning Paths",
        ]
        
        for section in required_sections:
            self.assertIn(section, text,
                        msg=f"Index missing reference to: {section}")

    def test_index_has_learning_path_diagrams(self) -> None:
        """Index must have learning path diagrams for both roles."""
        text = self._load_document_text(self.index)
        self.assertIn("Infrastructure & Operations Engineers", text)
        self.assertIn("Data Scientists & ML Researchers", text)

    def test_platform_narrative_diagram_count(self) -> None:
        """Platform narrative should have multiple diagrams."""
        text = self._load_document_text(self.platform_narrative)
        
        # Count Mermaid diagram blocks
        diagram_count = text.count("```{mermaid}")
        self.assertGreaterEqual(diagram_count, 10,
                              msg=f"Platform narrative has only {diagram_count} diagrams; need at least 10")

    def test_all_key_qmd_files_exist(self) -> None:
        """Verify all key qmd files exist."""
        key_files = [
            self.platform_narrative,
            self.index,
            self.vertical_slice,
            self.mlflow_parity,
            self.execution_backends,
            self.governance_gates,
        ]
        
        for f in key_files:
            self.assertTrue(f.exists(), msg=f"Missing qmd file: {f}")

    def test_platform_narrative_covers_key_entities(self) -> None:
        """Platform narrative must reference all key entities."""
        text = self._load_document_text(self.platform_narrative)
        
        entities = [
            "Repository",
            "DocumentationSeries",
            "OpenTofuConfiguration",
            "MLflowTrackingServer",
            "ModelArtifact",
            "PromotionStage",
        ]
        
        for entity in entities:
            self.assertIn(entity, text,
                        msg=f"Platform narrative missing entity: {entity}")

    def test_platform_narrative_describes_workflows(self) -> None:
        """Platform narrative must describe key workflows."""
        text = self._load_document_text(self.platform_narrative)
        
        workflows = [
            "Notebook Execution Workflow",
            "Model Promotion Workflow",
            "Artifact Tracking Workflow",
        ]
        
        for workflow in workflows:
            self.assertIn(workflow, text,
                        msg=f"Platform narrative missing workflow: {workflow}")

    def test_platform_narrative_covers_deployment_models(self) -> None:
        """Platform narrative must cover both local and cloud deployment."""
        text = self._load_document_text(self.platform_narrative)
        
        deployment_refs = [
            "Local Emulation Stack",
            "Cloud Deployment Topology",
            "Infrastructure Parity",
        ]
        
        for ref in deployment_refs:
            self.assertIn(ref, text,
                        msg=f"Platform narrative missing: {ref}")

    def test_platform_narrative_covers_governance(self) -> None:
        """Platform narrative must cover governance and safety."""
        text = self._load_document_text(self.platform_narrative)
        
        governance_refs = [
            "Promotion Gate Architecture",
            "Spec-First Governance",
            "DEV",
            "UAT",
            "REGRESSION",
            "PROD",
        ]
        
        for ref in governance_refs:
            self.assertIn(ref, text,
                        msg=f"Platform narrative missing governance ref: {ref}")


if __name__ == "__main__":
    unittest.main()
