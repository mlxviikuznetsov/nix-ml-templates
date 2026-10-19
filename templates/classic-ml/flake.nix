{
  description = "Classic ML: pandas, scikit-learn, JupyterLab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      pyproject-nix,
      uv2nix,
      pyproject-build-systems,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = lib.genAttrs systems;

      # The project name is read from pyproject.toml, so it only has to be changed there.
      # (PEP 503 normalization: lowercase, "_" and "." -> "-")
      projectName =
        builtins.replaceStrings [ "_" "." ] [ "-" "-" ]
          (lib.toLower (lib.importTOML ./pyproject.toml).project.name);

      # Reads pyproject.toml + uv.lock
      workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };

      # "wheel" = prefer prebuilt wheels from PyPI (fast, nothing is compiled from source)
      overlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };

      # For the devShell: the project's own package is installed in editable mode
      editableOverlay = workspace.mkEditablePyprojectOverlay { root = "$REPO_ROOT"; };

      pythonSets = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          # Fixes for problematic packages (native libraries etc.) go here
          pyprojectOverrides = final: prev: {

          };
        in
        (pkgs.callPackage pyproject-nix.build.packages { python = pkgs.python312; }).overrideScope (
          lib.composeManyExtensions [
            pyproject-build-systems.overlays.wheel
            overlay
            pyprojectOverrides
          ]
        )
      );
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          pythonSet = pythonSets.${system}.overrideScope (
            lib.composeManyExtensions [
              editableOverlay
              (final: prev: {
                ${projectName} = prev.${projectName}.overrideAttrs (old: {
                  # Filter the sources so the editable package is not rebuilt
                  # on every code change
                  src = lib.fileset.toSource {
                    root = old.src;
                    fileset = lib.fileset.unions [
                      (old.src + "/pyproject.toml")
                      (old.src + "/README.md")
                      (lib.fileset.fileFilter (f: f.name == "__init__.py") (old.src + "/src"))
                    ];
                  };
                  # hatchling needs the `editables` package for editable builds
                  nativeBuildInputs =
                    old.nativeBuildInputs ++ final.resolveBuildSystem { editables = [ ]; };
                });
              })
            ]
          );

          # All dependencies: main + extras + dependency-groups (dev)
          virtualenv = pythonSet.mkVirtualEnv "${projectName}-dev-env" workspace.deps.all;
        in
        {
          default = pkgs.mkShell {
            packages = [
              virtualenv
              pkgs.uv
            ];
            env = {
              # Nix builds the environment; uv is only used for `uv add` / `uv lock`
              UV_NO_SYNC = "1";
              UV_PYTHON = pythonSet.python.interpreter;
              UV_PYTHON_DOWNLOADS = "never";
            };
            shellHook = ''
              unset PYTHONPATH
              d=$PWD
              while [ ! -f "$d/pyproject.toml" ] && [ "$d" != / ]; do d=$(dirname "$d"); done
              export REPO_ROOT=$d
            '';
          };
        }
      );

    };
}
