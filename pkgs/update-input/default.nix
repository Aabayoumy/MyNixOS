{pkgs, ...}:
pkgs.writeShellScriptBin "update-input" ''
  input=$(                                           \
    nix flake metadata --json                        \
    | ${pkgs.jq}/bin/jq -r ".locks.nodes.root.inputs | keys[]" \
    | ${pkgs.fzf}/bin/fzf)
  nix flake lock --update-input $input
''
