# devenv_modules/profiles/cloud.nix
# Terranix entrypoint for the cloud deployment profile.
#
# Usage (from flake.nix or devenv.nix via mkTerranix):
#   tfJson = terranix.terranixConfiguration {
#     system = "x86_64-linux";
#     modules = [ ./nix/profiles/cloud.nix ];
#   };
#
# Then write tfJson to infra/cloud/main.tf.json and run:
#   cd infra/cloud && tofu init && tofu apply
#
# IMPORTANT: Never apply the cloud profile without first verifying
# the local_emulation profile succeeds (see docs/wiki/runbooks/).

{ pkgs, ... }:

{
  imports = [
    ../modules/cloud.nix
  ];

  terraform.required_providers.aws = {
    source = "hashicorp/aws";
    version = "~> 5.0";
  };

  terraform.required_providers.kubernetes = {
    source = "hashicorp/kubernetes";
    version = "~> 2.0";
  };
}
