{pkgs, lib, inputs, config, ...}: 

let
	hyprPackages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  nix.settings.substituters = ["https://hyprland.cachix.org"];

	home.packages = with pkgs; [
		hyprsunset

		jq
	];
#	systemd.user.services.iio-hyprland = {
#		Service = {
#			ExecStart = lib.getExe pkgs.iio-hyprland;
#		};
#		Installer = {
#			WantedBy = "graphical.target";
#		};
#	};

	xdg.portal = {
		enable = true;
		extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
		config.common.default = "*";
	};

	wayland.windowManager.hyprland = {
		enable = true;
		package = hyprPackages.hyprland;
		xwayland.enable = true;
		systemd.enableXdgAutostart = true;
		settings = {
			general = {
			};

			monitor = [
				"DVI-D-1,preferred,auto,auto"
				"eDP-1,preferred,auto,1"
			];

			exec-once = [
				"${lib.getExe pkgs.iio-hyprland}"
			];

			env = [
			#	"HYPRCURSOR_SIZE,48"
			];

			input = {
				kb_layout = "fr";
				numlock_by_default = true;
				touchpad = {
					natural_scroll = true;
					drag_lock = true;
					scroll_factor = 0.75;
				};
				sensitivity = 0.3;
			};

			gestures = {
				workspace_swipe = true;
				workspace_swipe_touch = true;
				workspace_swipe_cancel_ratio = 0.1;
			};

			animations = {
				bezier = "windows, 0.05, 0.9, 0.1, 1.05";
				animation = [
					"windows, 1, 3, windows"
					"windowsOut, 1, 7, default, popin 80%"
					"border, 1, 10, default"
					"borderangle, 1, 8, default"
					"fade, 1, 7, default"
					"workspaces, 1, 2, default, slidevert"
				];
			};

			decoration = {
				blur = {
					enabled = false; # true;
					size = 1;
					passes = 6;
				};
				shadow.enabled = false;
			};

			misc = {
				force_default_wallpaper = false;
				vfr = true;
			};

			dwindle = {
				preserve_split = true;
			};

			"$mod" = "SUPER";

			bind = [
				"$mod, Return, exec, $TERMINAL --hold fastfetch"
				"$mod, B, exec, $MY_BROWSER"
				", Print, exec, ${lib.getExe pkgs.grim} -g \"$(${lib.getExe pkgs.slurp} -d)\" - | ${lib.getExe pkgs.swappy} -f -"
				"$mod, W, exec, VBoxManage startvm 'Windows 11 Pro Edu'"
				"$mod, Q, exec, ${lib.getExe pkgs.qalculate-gtk}"

				# === Secial keys ===

				", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
				", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
				", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

				", XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} play-pause"
				", XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} next"
				", XF86AudioPrev, exec, ${lib.getExe pkgs.playerctl} previous"
				
				", XF86MonBrightnessDown, exec, ${lib.getExe pkgs.brightnessctl} s 5%-"
				", XF86MonBrightnessUp, exec, ${lib.getExe pkgs.brightnessctl} s +5%"

				# === Windows managing ===

				"$mod, Backspace, killactive,"
				"$mod, V, togglefloating,"
				"$mod, F, fullscreen,"
				"$mod, P, pin,"
				"$mod, H, togglesplit,"

				"$mod, G, togglegroup,"
				"$mod, Tab, changegroupactive, f"
				"$mod SHIFT, Tab, changegroupactive, b"

				# === Workspaces navigation ===

				"$mod, mouse_down, workspace, e-1"
				"$mod, mouse_up, workspace, e+1"

				"$mod, page_up, workspace, e-1"
				"$mod, page_down, workspace, e+1"

				"$mod SHIFT, page_up, movetoworkspace, e-1"
				"$mod SHIFT, page_down, movetoworkspace, e+1"
				
				"$mod, K, workspace, -1"
				"$mod, J, workspace, +1"

				"$mod SHIFT, K, movetoworkspace, -1"
				"$mod SHIFT, J, movetoworkspace, +1"

				"$mod, left, movefocus, l"
				"$mod, right, movefocus, r"
				"$mod, up, movefocus, u"
				"$mod, down, movefocus, d"

				"$mod, S, togglespecialworkspace, magic"
				"$mod SHIFT, S, movetoworkspace, special:magic"

				# === Misc ===

				"$mod, C, exec, ${lib.getExe pkgs.hyprpicker} -a"
				"$mod, L, exec, ${lib.getExe pkgs.hyprlock}"
			]
			++ (
				# workspaces
				# binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
				builtins.concatLists (builtins.genList (i:
					let ws = i + 1;
					in [
						"$mod, code:1${toString i}, workspace, ${toString ws}"
						"$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
					]
				)
				9)
			);

			bindm = [
				# Windows managing

				"$mod, mouse:272, movewindow"
				"$mod, mouse:273, resizewindow"
				"$mod SHIFT, mouse:273, resizewindow 1"

				"$mod, Control_L, movewindow"
				"$mod, ALT_L, resizewindow"
				"$mod SHIFT, ALT_L, resizewindow 1"
			];

			plugin = {
				touch_gestures = {
					hyprgrass-bindm = [
						", longpress:2, movewindow"
						", longpress:3, resizewindow"
					];
				};
			};
		};

		plugins = [
			#inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprgrass
			inputs.hyprgrass.packages.${pkgs.system}.default
		];
	};

	services.mako = {
		enable = true;
		defaultTimeout = 10000;
	};

	# programs.iio-hyprland.enable = true;
	services.hypridle = {
		enable = true;
		settings = {
			general = {
				lock_cmd = "pidof ${lib.getExe pkgs.hyprlock} || ${lib.getExe pkgs.hyprlock}";
				before_sleep_cmd = "loginctl lock-session";
				after_sleep_cmd = "hyprctl dispatch dpms on";
			};
			listeners = [
				{
					timeout = 120;
					on-timeout = "loginctl lock-session";
				}
			];
		};
	};
	programs.hyprlock = {
		enable = true;
		settings = {
			general = {
				disable_loading_bar = true;
				hide_cursor = true;
				no_fade_in = false;
			};

			input-field = {
				size = "300, 50";
				position = "0, 0";
				monitor = "";
				dots_center = true;
				fade_on_empty = false;
				outline_thickness = 5;
				placeholder_text = "Ho ! Touche pas !";
			};

			label = with config.lib.stylix.colors; [
				{
					text = "cmd[update:60000] ${lib.getExe pkgs.fortune-kind}";
					valign = "bottom";
					halign = "center";
					position = "0, 50";
					color = "rgb(${base05})";
				}
				{
					text = "cmd[update:3000] echo $(cat /sys/class/power_supply/BAT0/capacity)%";
					valign = "bottom";
					halign = "left";
					position = "20, 20";
					color = "rgb(${base05})";
				}
			];
		};
	};

	services.hyprpaper.enable = true;
	
	programs.waybar = {
		enable = true;
		systemd.enable = true;
		settings = {
			mainBar = {
				layer = "top";
				position = "left";
				#height = 30;
				"spacing" = 5;
				modules-left = [ "hyprland/workspaces" "hyprland/submap" ];
				modules-center = [ "mpris" ];
				modules-right = [ "pulseaudio/slider#audio-slider" "battery" "disk" "clock" ];
				"pulseaudio/slider#audio-slider" = {
					# "orientation" = "vertical";
					"min" = 0;
					"max" = 150;

				};
				"mpris" = {
					"rotate" = 90;
				};
				"disk" = {
					"interval" = 30;
					"format" = "{used}";
					"tooltip-format" = "{used}/{total} : {free} free (COUCOU)";
					"path" = "/";
				};
				"clock" = {
					"format" = "{:%H\n%M}";
					"tooltip" = true;
					"tooltip-format" = "<small>{calendar}</small>";

					"calendar" = {
						"mode" = "month";
						"weeks-pos" = "left";
					};

					"actions" = {
						"on-scroll-up" = "shift_up";
						"on-scroll-down" = "shift_down";
					};
				};
			};
		};

		style = ''
			#audio-slider slider {
				min-height: 0px;
				min-width: 0px;
				opacity: 0;
				background-image: none;
				border: none;
				box-shadow: none;
			}
			#audio-slider trough {
				min-height: 10px;
				min-width: 80px;
				border-radius: 5px;
				background-color: black;
			}
			#audio-slider highlight {
				min-width: 10px;
				border-radius: 5px;
				background-color: green;
			}
		'';
	};
}
