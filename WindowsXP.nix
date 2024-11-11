{ inputs, pkgs, ... }:

{
	# Oh yeah
	stylix.enable = true;
	# stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
	stylix.image = ./WindowsXP.jpg;
	stylix.polarity = "dark";
	stylix.autoEnable = true;
	stylix.cursor.size = 24;
	stylix.fonts = {
		monospace = {
			package = pkgs.fira-code-nerdfont;
			name = "Fira Code Nerfont";
		};
	};

	programs.dconf.enable = true;
}
