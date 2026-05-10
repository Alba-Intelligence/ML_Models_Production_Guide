"""Tests for notebook intake validation gates."""

from __future__ import annotations

import json
from pathlib import Path
import tempfile
import unittest

from ml_deploy.notebook_intake import (
    validate_notebook_for_execution,
    validate_notebook_structure,
)
from ml_deploy.webui_contracts import NotebookRevision


def _ok_executor(*args, **kwargs):
    class _Result:
        returncode = 0
        stderr = ""

    _ = args, kwargs
    return _Result()


def _fail_executor(*args, **kwargs):
    class _Result:
        returncode = 1
        stderr = "boom"

    _ = args, kwargs
    return _Result()


class TestNotebookIntake(unittest.TestCase):
    def _write_notebook(self, path: Path) -> None:
        payload = {
            "nbformat": 4,
            "nbformat_minor": 5,
            "metadata": {},
            "cells": [{"cell_type": "markdown", "metadata": {}, "source": ["# test"]}],
        }
        path.write_text(json.dumps(payload), encoding="utf-8")

    def test_validate_notebook_structure(self) -> None:
        with tempfile.TemporaryDirectory() as tmp_dir:
            path = Path(tmp_dir) / "test.ipynb"
            self._write_notebook(path)
            validate_notebook_structure(path)

    def test_validate_for_execution_success(self) -> None:
        with tempfile.TemporaryDirectory() as tmp_dir:
            root = Path(tmp_dir)
            notebook = root / "nbs" / "test.ipynb"
            notebook.parent.mkdir(parents=True, exist_ok=True)
            self._write_notebook(notebook)
            report = validate_notebook_for_execution(
                revision=NotebookRevision(
                    repository="git@github.com:org/repo.git",
                    notebook_path="nbs/test.ipynb",
                    revision="a1b2c3d4e5",
                    revision_kind="commit",
                ),
                notebook_path=notebook,
                repo_root=root,
                run_export_check=True,
                executor=_ok_executor,
            )
            self.assertTrue(report.revision_valid)
            self.assertTrue(report.notebook_structure_valid)
            self.assertTrue(report.nbdev_export_valid)

    def test_validate_for_execution_export_failure(self) -> None:
        with tempfile.TemporaryDirectory() as tmp_dir:
            root = Path(tmp_dir)
            notebook = root / "nbs" / "test.ipynb"
            notebook.parent.mkdir(parents=True, exist_ok=True)
            self._write_notebook(notebook)
            with self.assertRaises(ValueError):
                validate_notebook_for_execution(
                    revision=NotebookRevision(
                        repository="git@github.com:org/repo.git",
                        notebook_path="nbs/test.ipynb",
                        revision="a1b2c3d4e5",
                        revision_kind="commit",
                    ),
                    notebook_path=notebook,
                    repo_root=root,
                    run_export_check=True,
                    executor=_fail_executor,
                )


if __name__ == "__main__":
    unittest.main()
