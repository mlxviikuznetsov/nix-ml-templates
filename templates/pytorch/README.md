# torch-playground

Deep learning with PyTorch (CPU)

torch comes from the PyTorch CPU index (see `[tool.uv.sources]` in `pyproject.toml`), so no gigabytes of CUDA libraries are pulled in.

```bash
train   # fits a small MLP to sin(x) on synthetic data
```

Need torchvision? Run `uv add torchvision` -- it should also come from `pytorch-cpu` (add it to `[tool.uv.sources]` the same way as torch).

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
