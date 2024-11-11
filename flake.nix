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
		hyprgrass = {
    	url = "github:horriblename/hyprgrass";
			inputs.nixpkgs.follows = "nixpkgs";
  		inputs.hyprland.follows = "hyprland";
    };
		firefox-addons = {
			url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		stylix = {
			url = "github:danth/stylix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, ...} @ inputs:
		let
			system = "x86_64-linux";
			pkgs = nixpkgs.legacyPackages.${system};
		in {
			homeModules.default = ./default.nix;

			homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;

				extraSpecialArgs = { inherit inputs; };

				modules = [
					self.homeModules.default
				];
			};

			nixosModules.default = { user }: 
			let
				params = { inherit user; };
			in
			{imports = [
				home-manager.nixosModules.home-manager
				{
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;

					home-manager.users.${params.user} = import self.homeModules.default;

					home-manager.extraSpecialArgs = { inherit inputs params; };
				} 
			];};

			nixosThemeModules.WindowsXP = {imports = [
				inputs.stylix.nixosModules.stylix
				./WindowsXP.nix
				{
					programs.dconf.enable = true;
				}
			];};
		};
}
