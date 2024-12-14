{ pkgs, inputs, config, ... }:

{
	# programs.librewolf = {
	# 	enable = true;
	# 	settings = {
	# 		"network.http.referer.XOriginPolicy" = 2;
	# 	};
	# };
	programs.firefox = {
		enable = true;
		package = pkgs.librewolf;
		profiles.default = {
			settings = {
				# === Privacy ===
				"network.http.referer.XOriginPolicy" = 2;

				# === UI ===
				"sidebar.verticalTabs" = true;
			};

			search = {
				default = "Brave";
				engines = {
					"Bing".metaData.hidden = true;
					"Amazon.com".metaData.hidden = true;
					"Google".metaData.hidden = true;

					"Brave" = {
						urls = [{
							template = "https://search.brave.com/search";
							params = [
								{ name = "q"; value = "{searchTerms}"; }
							];
						}];
					};
				};
				force = true;
			};
			
			# extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
			# 	ublock-origin
			# 	proton-pass
			# ];
		};
	};

	home.file.".librewolf" = {
		source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.mozilla/firefox";
		recursive = true;
	};
}
