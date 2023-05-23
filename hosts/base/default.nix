{ config, pkgs, user, ... }:

{ 
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };

      grub = {
        efiSupport = true;
        device = "nodev";
      };

      timeout = 1;
    };
  };
 
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
    };
    overlays = [
      (self: super: {
        discord = super.discord.overrideAttrs (
          _: {
            src = builtins.fetchTarball {
              url = "https://discord.com/api/download?platform=linux&format=tar.gz";
              sha256 = "0mr1az32rcfdnqh61jq7jil6ki1dpg7bdld88y2jjfl2bk14vq4s";
            };
          }
        );
      })
    ];
  }; 

  # HIP for programs like Blender
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];

  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };

  security.polkit.enable = true;
}
