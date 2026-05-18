# devenv_modules/profiles/local.nix
# Terranix entrypoint for the local_emulation deployment profile.
#
# Usage (from flake.nix or devenv.nix via mkTerranix):
#   terranix = import (fetchTarball "https://github.com/terranix/terranix/...") {};
#   tfJson = terranix.terranixConfiguration {
#     system = "x86_64-linux";
#     modules = [ ./nix/profiles/local.nix ];
#   };
#
# Then write tfJson to infra/local/main.tf.json and run:
#   cd infra/local && tofu init && tofu apply

{ pkgs, ... }:

{
  imports = [
    ../modules/local.nix
  ];

  # Require local infra stack to be running before apply
  terraform.required_providers.aws = {
    source = "hashicorp/aws";
    version = "~> 5.0";
  };

  terraform.required_providers.kubernetes = {
    source = "hashicorp/kubernetes";
    version = "~> 2.0";
  };
}
