{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.spacemacs;
in {
  options.programs.spacemacs = {
    enable = mkEnableOption "Spacemacs, a community-driven Emacs distribution";

    emacsPackage = mkOption {
      type = types.package;
      default = pkgs.emacs;
      defaultText = literalExpression "pkgs.emacs";
      description = "The Emacs package to install.";
    };

    branch = mkOption {
      type = types.str;
      default = "develop";
      description = ''
        The Spacemacs branch to clone.
        "develop" is highly recommended as "master" is rarely updated.
      '';
    };

    revision = mkOption {
      type = types.str;
      default = "develop";
      description = ''
        The git revision to clone.
      '';
    };

    dotfile = mkOption {
      type = types.path;
      description = ''
        The path to the .spacemacs dotfile
      '';
    };
  };

  config = mkIf cfg.enable {
    # Ensure Emacs and Git are available
    home.packages = [
      cfg.emacsPackage
      pkgs.git

      # We include this to avoid having to compile it
      pkgs.emacsPackages.vterm
    ];

    # Add file install dependency on .spacemacs
    home.file.".spacemacs".source = cfg.dotfile;

    # Clone the repository dynamically during the Home Manager switch.
    # We use entryAfter writeBoundary and linkGeneration to ensure this runs after Home Manager 
    # has set up standard symlinks, preventing conflicts.
    home.activation.installSpacemacs = lib.hm.dag.entryAfter [ "linkGeneration" "writeBoundary" ] ''
      if [ ! -d "$HOME/.emacs.d/.git" ]; then
        echo "Cloning Spacemacs (${cfg.branch} branch), rev ${cfg.revision}..."
        $DRY_RUN_CMD ${pkgs.git}/bin/git clone -b ${cfg.branch} https://github.com/syl20bnr/spacemacs "$HOME/.emacs.d"
        $DRY_RUN_CMD cd "$HOME/.emacs.d" && ${pkgs.git}/bin/git checkout ${cfg.revision}
      else
        echo "Spacemacs already exists in ~/.emacs.d, skipping clone."
      fi
    '';
  };
}
