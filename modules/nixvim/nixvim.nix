{ inputs, pkgs, ... }:

{
	imports = [ inputs.nixvim.homeManagerModules.nixvim ];
	programs.nixvim = {
		enable = true;
		plugins = {
			# Editor
			which-key.enable = true;
			telescope = {
				enable = true;
				extensions.ui-select.enable = true;
				keymaps = {
					"<leader> " = { action = "find_files"; };
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
			};
			noice.enable = true;
			nui.enable = true;
			#dressing.enable = true;


			# Code

			fugitive.enable = true;
			gitsigns.enable = true;

			undotree.enable = true;
			todo-comments.enable = true;
			indent-blankline.enable = true;
			nvim-autopairs.enable = true;
			treesitter = {
				enable = true;
				folding = true;
				settings = {
					highlight.enable = true;
					# incremental_selection.enable = true;
					indent.enable = true;
				};
			};
			treesitter-context.enable = true;
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
					arduino_language_server.enable = true;
					pyright.enable = true;
					glsl_analyzer.enable = true;
				};
				keymaps = {
					lspBuf = {
						"K" = { action = "hover"; };
						"<leader>ca" = { action = "code_action"; };
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
						"<S-j>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
						"<S-k>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
					};
				};
			};
			

			# Other
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
		];
		
		opts = {
			tabstop = 2;
			shiftwidth = 2;
			
			scrolloff = 5;
			sidescrolloff = 5;

			number = true;
			relativenumber = true;

			linebreak = true;
			ignorecase = true;
			cursorline = true;
		};
		globals.mapleader = " ";
		clipboard.providers.wl-copy.enable = true;
		clipboard.register = "unnamedplus";
		filetype.extension = {
			frag = "glsl";
		};
	};
}
