{ inputs, pkgs, lib, ... }:

{
	imports = [ inputs.nixvim.homeManagerModules.nixvim ];
	programs.nixvim = {
		enable = true;
		plugins = {

			# === Editor ===
			dashboard = {
				enable = true;
				settings.config = {
					header = [ (lib.generators.mkLuaInline ''
""),
"BONJOUR",
(""
					'') ];
				};
			};
			persistence.enable = true;
			# spider, specs, why not ?
			oil.enable = true;
			leap.enable = true;
			neoscroll.enable = true;
			hardtime = {
				enable = true;
			};
			which-key = {
				enable = true;
				settings = {
					spec = [
						{
							__unkeyed-1 = "<leader>c";
							group = "Code & LSP";
						}
					];
				};
			};
			telescope = {
				enable = true;
				extensions.ui-select.enable = true;
				keymaps = {
					"<leader> " = {
						action = "find_files";
						options.desc = "Find files";
					};
				};
			};
			neo-tree = {
				enable = true;
				window = {
					mappings = {
						"l" = "open";
						"h" = "close_node";
					};
				};
			};
			notify = {
				enable = true;
				topDown = false;
				stages = "slide";
				render = "minimal";
			};
			noice.enable = true;
			nui.enable = true;
			#dressing.enable = true;
			lualine.enable = true;
			bufferline.enable = true;


			# === Code ===
			fugitive.enable = true;
			gitsigns.enable = true;
			undotree.enable = true;
			todo-comments.enable = true;
			indent-blankline.enable = true;
			nvim-autopairs.enable = true;
			treesitter = {
				enable = true;
				settings = {
					auto_install = true;
					highlight.enable = true;
					incremental_selection = {
						enable = true;
						keymaps = {
							init_selection = false;
							node_decremental = "grm";
							node_incremental = "grn";
							scope_incremental = "grc";
						};
					};
					indent.enable = true;
				};
			};
			treesitter-context.enable = true;
			trouble = {
				enable = true;
			};
			lsp = {
				enable = true;
				servers = {
					nixd.enable = true;
					rust_analyzer = {
						enable = true;
						installCargo = false;
						installRustc = false;
					};
					lua_ls.enable = true;
					arduino_language_server = {
						enable = true;
						extraOptions = {
							cmd = [
								"arduino-language-server"
								"-cli" "${pkgs.arduino-cli}/bin/arduino-cli"
								# "-cli-config" "/home/linuxuser/.arduino15/arduino-cli.yaml"
								"-clangd" "${pkgs.clang}/bin/clangd"
							];
						};
					};
					pyright.enable = true;
					glsl_analyzer.enable = true;
					# glslls.enable = true;
				};
				keymaps = {
					lspBuf = {
						"<leader>ck" = {
							action = "hover";
							desc = "LSP hover";
						};
						"<leader>ca" = { 
							action = "code_action";
							desc = "Code actions";
						};
					};
				};
			};
			cmp = {
				enable = true;
				autoEnableSources = true;
				settings = {
					sources = [
						{ name = "nvim_lsp"; }
						{ name = "path"; }
						{ name = "buffer"; }
					];
					mapping = {
						"<C-Space>" = "cmp.mapping.complete()";
						"<C-d>" = "cmp.mapping.scroll_docs(-4)";
						"<C-e>" = "cmp.mapping.close()";
						"<C-f>" = "cmp.mapping.scroll_docs(4)";
						"<Tab>" = "cmp.mapping.confirm({ select = true })";
						"J" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
						"K" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
					};
				};
			};
			

			# === Other ===
			web-devicons.enable = true;
		};

		extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
			name = "Cellular Automaton";
			src = pkgs.fetchFromGitHub {
			owner = "Eandrju";
				repo = "cellular-automaton.nvim";
				rev = "11aea08aa084f9d523b0142c2cd9441b8ede09ed";
				hash = "sha256-nIv7ISRk0+yWd1lGEwAV6u1U7EFQj/T9F8pU6O0Wf0s=";
			};
		})];

		keymaps = [
			{
				mode = "n";
				key = "<leader>e";
				action = "<cmd>Neotree<CR>";
			}
			{
				mode = "n";
				key = "K";
				action = "<Nop>";
			}
		];
		
		opts = {
			tabstop = 2;
			shiftwidth = 2;
			
			scrolloff = 5;
			sidescrolloff = 5;

			number = true;
			relativenumber = true;

			splitright = true;
			splitbelow = true;

			ignorecase = true;
			smartcase = true;

			linebreak = true;
			cursorline = true;
			colorcolumn = "80";
			ww = "h,l,<,>,[,]";
			undofile = true;
		};
		globals = {
			mapleader = " ";
		};
		luaLoader.enable = true;
		clipboard.providers.wl-copy.enable = true;
		clipboard.register = "unnamedplus";

		filetype.extension = {
			frag = "glsl";
		};
	};
}
