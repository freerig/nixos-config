{
	description = "Super Very Cool Home Manager Configuration For Both Standalone And NixOS Module";

	inputs = {
		# Specify the source of Home Manager and Nixpkgs.
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nixvim = {
			url = "github:nix-community/nixvim";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		hyprland = {
			url = "github:hyprwm/Hyprland";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		hyprland-plugins = {
	  url = "github:hyprwm/hyprland-plugins";
	  inputs.hyprland.follows = "hyprland";
	};
		hyprgrass = {
			url = "github:horriblename/hyprgrass";
			inputs.hyprland.follows = "hyprland";
		};

		# firefox-addons = {
		# 	url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
		# 	inputs.nixpkgs.follows = "nixpkgs";
		# };

		stylix = {
			url = "github:danth/stylix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, ...} @ inputs:
		let
			system = "x86_64-linux";
			pkgs = nixpkgs.legacyPackages.${system};
			hyprPackages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
		in {

			# === Default ===

			homeModules.default = ./default.nix;

			# === HM Standalone ===

			homeConfigurations.default = { params, extraConfig }: (home-manager.lib.homeManagerConfiguration {
				inherit pkgs;

				extraSpecialArgs = { inherit inputs params; };

				modules = [
					self.homeModules.default
					extraConfig
				];
			});

			# === HM NixOS Module ===

			nixosModules.default = { params, extraConfig }: 
				{imports = [
					# inputs.hyprland.nixosModules.default
					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;

						home-manager.users.${params.user} = self.homeModules.default;

						home-manager.extraSpecialArgs = { inherit inputs params; };
					} 
				];};

			# === Themes ===

			nixosThemeModules.WindowsXP = {imports = [
				inputs.stylix.nixosModules.stylix
				./WindowsXP.nix
				{
					programs.dconf.enable = true;
					stylix.targets.grub.useImage = true;
				}
			];};
		};
}
