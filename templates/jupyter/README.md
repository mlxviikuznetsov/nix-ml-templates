# jupyter-playground

Jupyter notebooks: numpy, pandas, matplotlib

Run: `jupyter lab`. Notebooks live in `notebooks/`, reusable code in `src/jupyter_playground/` (available in notebooks as `import jupyter_playground`; edits are picked up without reinstalling).

`jupytext` lets you keep a notebook paired with a `.py` file (cleaner git diffs): `jupytext --set-formats ipynb,py:percent notebooks/00_intro.ipynb`.

## Getting started

```bash
git init && git add -A
nix run nixpkgs#uv -- lock        # once: creates uv.lock (read by uv2nix)
git add uv.lock
nix develop                       # or: direnv allow
```

> A flake only sees files tracked by git. After `uv add ...` run
> `git add uv.lock pyproject.toml` and re-enter the shell (`direnv reload`).

## Dependencies

```bash
uv add <package>                  # updates pyproject.toml and uv.lock
uv add --dev <package>            # into the dev group
```

Nix builds the environment from `uv.lock`, so the shell has to be restarted after dependencies change.
