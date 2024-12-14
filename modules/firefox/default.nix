{pkgs, inputs, ...}:
let
	options = import ./firefox-options.nix;
in
{
	programs.firefox = {
		enable = true;
		profiles.default = {
			settings = options // {
				# "browser.search.searchEnginesURL" = "";
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
			
			extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
				ublock-origin
				proton-pass
				canvasblocker
			];
		};
	};
}
