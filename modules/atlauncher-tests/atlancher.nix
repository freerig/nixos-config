{ pkgs, lib, ... }:

{
	options = {
		configs = {
			ATLauncher = lib.mkOption {
				type = lib.types.attrs;
				default = { };
				description = "File to put in configs/ATLauncher.json";
			};
		};
	};

	config = {

	};
}
