# Nix Machine Learning Templates

Flake templates for ML/DS projects in Python on Nix/NixOS. Dependencies are managed with
[uv](https://docs.astral.sh/uv/) + [uv2nix](https://github.com/pyproject-nix/uv2nix); CPU only.

| template     | contents                                                    |
|--------------|-------------------------------------------------------------|
| `jupyter`    | JupyterLab, numpy, pandas, matplotlib, jupytext             |
| `classic-ml` | pandas, scikit-learn, JupyterLab, example pipeline          |
| `pytorch`    | torch (CPU index), JupyterLab, example training script      |
| `ml-service` | sklearn + FastAPI + typer CLI + pytest, `nix run` support   |

## Usage

```bash
mkdir my-project && cd my-project
nix flake init -t github:mlxviikuznetsov/ml-nix-templates#pytorch

git init && git add -A
nix run nixpkgs#uv -- lock        # create uv.lock (required by uv2nix)
git add uv.lock
nix develop                       # or: direnv allow
```

List the templates: `nix flake show github:mlxviikuznetsov/ml-nix-templates`.

## Renaming a project

1. Change `name` in `pyproject.toml`
2. Rename the directory `src/<name_with_underscores>/`
3. Run `uv lock` again

`flake.nix` does not need to change: it reads the name from `pyproject.toml`.

## How it works

- `uv.lock` is the source of truth for versions; Nix builds a virtual environment from it
  (PyPI wheels, `autoPatchelf` for native libraries).
- The project package (`src/...`) is installed in editable mode, so code edits are visible immediately.
- `uv` inside the devShell is only used for `uv add` / `uv lock`; `UV_NO_SYNC=1`
  stops it from installing packages on its own.
