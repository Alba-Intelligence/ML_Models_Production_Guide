# ML Deploy Reference

A notebook-first reference implementation for ML model development to distributed production deployment.

Built with [nbdev 3](https://nbdev.fast.ai/).

## Installation

```bash
# Clone the repository
git clone https://github.com/your-org/ml_deploy.git
cd ml_deploy

# Install in development mode
pip install -e .
```

## Documentation

Documentation is generated with Quarto via nbdev. To preview locally:

```bash
nbdev_preview
```

This will start a local server at http://localhost:8000.

## Project Structure

- `nbs/` - Source notebooks (the truth)
- `ml_deploy/` - Exported Python package
- `tests/` - Test suite
- `docs/` - Generated documentation (gitignored)
- `docs/wiki/` - Living project memory (separate from nbdev docs)

## Development

This project follows a notebook-first approach:

1. Write code and documentation in Jupyter notebooks in `nbs/`
2. Use `nbdev_export` to generate the Python package
3. Use `nbdev_test` to run tests
4. Use `nbdev_preview` to view documentation

For end-of-task publishable output, run:

```bash
./scripts/finalize-task.sh
```

See [docs/wiki/architecture/target-system.md](docs/wiki/architecture/target-system.md) for the full architectural vision.
