{ pkgs, lib, params, ... }:

{
	imports = [
		./modules/modules.nix
	];

	# Home Manager needs a bit of information about you and the paths it should
	# manage
	home.username = params.user;
	home.homeDirectory = "/home/${params.user}";


	# The home.packages option allows you to install Nix packages into your

	# environment.
	home.packages = with pkgs; [
		lf
		radicale
		docker-compose
		rustup

		spotify
		#signal-desktop
		atlauncher

		#tor-browser
		#brave

		wl-clipboard-rs
		# clipboard-jh 	# didn't tried but it seems good

		fastfetch

		pavucontrol
		networkmanagerapplet
		overskride
		wvkbd
	];
	programs = {
		waybar.enable = true;
		bash = {
			enable = true;
			shellAliases = {
				"sudit" = "sudo -E $EDITOR";
			};
		};
		kitty = {
			enable = true;
			settings = {
				background_opacity = lib.mkForce 0.75;
			};
		};
		git = {
			enable = true;
			userName = "freerig";
			userEmail = "github.aeration096@passmail.net";
			extraConfig = {
				init.defaultBranch = "main";
			};
		};
	};
	gtk.enable = true;

	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
		"spotify"
	];

	home.sessionVariables = {
		EDITOR = "nvim";
		BROWSER = lib.getExe pkgs.brave;
		TERMINAL = lib.getExe pkgs.kitty;
	};


	# This value determines the Home Manager release that your configuration is
	# compatible with. This helps avoid breakage when a new Home Manager release
	# introduces backwards incompatible changes.
	#
	# You should not change this value, even if you update Home Manager. If you do
	# want to update the value, then make sure to first check the Home Manager
	# release notes.
	home.stateVersion = "24.05"; # Please read the comment before changing.
	programs.home-manager.enable = true;
}
