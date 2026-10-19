# classic-ml

Classic ML: numpy, pandas, scikit-learn, JupyterLab

Example pipeline (breast cancer dataset, bundled with sklearn): `train` fits a RandomForest, prints metrics and saves the model to `models/model.joblib`.

```bash
train            # script from [project.scripts]
jupyter lab      # for experiments
```

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
