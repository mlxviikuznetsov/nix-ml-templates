# ml-service

ML package with a CLI (typer) and an HTTP service (FastAPI)

```bash
ml-service train          # train the model (iris) -> model.joblib
ml-service serve          # start the API at http://127.0.0.1:8000/docs
pytest                    # run the tests
nix run . -- serve        # run the built app without entering the devShell
```

Example request:
```bash
curl -X POST localhost:8000/predict -H 'content-type: application/json' \
  -d '{"sepal_length":5.1,"sepal_width":3.5,"petal_length":1.4,"petal_width":0.2}'
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
