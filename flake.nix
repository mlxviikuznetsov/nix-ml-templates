{
  description = "ML/DS project templates for Python (uv2nix, CPU)";

  outputs =
    { self }:
    let
      welcome = ''
        Next steps:
          git init && git add -A
          nix run nixpkgs#uv -- lock && git add uv.lock
          nix develop        # or: direnv allow
        See README.md for details.
      '';
    in
    {
      templates = {
        jupyter = {
          path = ./templates/jupyter;
          description = "Jupyter notebooks: numpy, pandas, matplotlib, jupytext";
          welcomeText = welcome;
        };
        classic-ml = {
          path = ./templates/classic-ml;
          description = "Classic ML: pandas, scikit-learn, JupyterLab";
          welcomeText = welcome;
        };
        pytorch = {
          path = ./templates/pytorch;
          description = "Deep learning: PyTorch (CPU) + JupyterLab";
          welcomeText = welcome;
        };
        ml-service = {
          path = ./templates/ml-service;
          description = "ML package: CLI (typer) + HTTP API (FastAPI) + pytest";
          welcomeText = welcome;
        };

        default = self.templates.jupyter;
      };
    };
}
