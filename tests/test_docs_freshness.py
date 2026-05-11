"""Ensure rendered docs are up to date with Quarto sources."""

from __future__ import annotations

import re
from pathlib import Path
import unittest


def _expected_output_name(qmd_path: Path) -> str:
    stem = qmd_path.stem
    if stem == "index":
        return "index.html"
    return f"{re.sub(r'^\\d+_', '', stem)}.html"


class TestRenderedDocsFreshness(unittest.TestCase):
    """Checks that `_docs/nbs/*.html` are not older than `nbs/*.qmd`."""

    @classmethod
    def setUpClass(cls) -> None:
        cls.repo_root = Path(__file__).resolve().parents[1]
        cls.nbs_dir = cls.repo_root / "nbs"
        cls.docs_nbs_dir = cls.repo_root / "_docs" / "nbs"

    def test_rendered_pages_are_not_stale(self) -> None:
        qmd_files = sorted(self.nbs_dir.glob("*.qmd"))
        self.assertTrue(qmd_files, "No Quarto sources found in nbs/")

        for qmd in qmd_files:
            expected_html = self.docs_nbs_dir / _expected_output_name(qmd)
            self.assertTrue(expected_html.exists(), f"Missing rendered page: {expected_html}")
            self.assertGreaterEqual(
                expected_html.stat().st_mtime,
                qmd.stat().st_mtime,
                f"Stale render: {expected_html} is older than {qmd}",
            )


if __name__ == "__main__":
    unittest.main()
