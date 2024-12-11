{ inputs, pkgs, lib, ... }:

		# ${lib.getExe pkgs.figlet}
let
	init = pkgs.writeShellScript "nvim-init" ''


read message
fail=1
while [ $fail -ne 0 ]; do
	font=$(${pkgs.figlet}/bin/figlist | tail -n +4 | shuf -n 1)
	${lib.getExe pkgs.figlet} -f $font $message > /dev/null 2>&1
	fail=$?
done

echo $font
${lib.getExe pkgs.figlet} -w 75 -f $font $message


'';
in
{
	imports = [ inputs.nixvim.homeManagerModules.nixvim ];
	programs.nixvim = {
		enable = true;
		plugins = {

			# === Editor ===
			dashboard = {
				enable = true;
				settings = {
					config = {
						center = [
							{
								action = "Telescope find_files cwd=";
								desc = "Files";
								icon = " ";
								key = "f";
								key_format = "(percutez '%s')";
							}
							{
								action = "lua print(vim.fn.system('${lib.getExe pkgs.fortune} -n 200 -s')) --";
								desc = "Gimme joke";
								icon = " ";
								key = "b";
								key_format = "(pressez '%s')";
							}
							{
								action = "lua require('persistence').select() --";
								desc = "Load session";
								icon = " ";
								key = "s";
								key_format = "(déclanchez '%s')";
							}
						];

						header = lib.generators.mkLuaInline /*lua*/ ''


(function(command)
	local result = vim.fn.system(command)

	local lines = {}
	for i = 1, 5 do
		table.insert(lines, "")
	end
	for line in result:gmatch("[^\r\n]+") do
		table.insert(lines, line)
	end
	for i = 1, 5 do
		table.insert(lines, "")
	end
	return lines
end)("${lib.getExe pkgs.fortune} -s -n 30 | ${init}")


'';
					};
					theme = "doom";
				};
			};
			# persisted = {
			# 	enable = true;
			# 	preSave = "function() require('neo-tree.command').execute({ action = 'close' }) end";
			# };
			# spider, specs, why not ?
			# oil.enable = true;
			# leap.enable = true;
			# neoscroll.enable = true;
			mini = {
				enable = true;
				mockDevIcons = true;
				modules = {
					animate = {
						cursor.enable = true;
						scroll.enable = true;
					};
					icons.enable = true;
				};
			};
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


			# === Code ===
			fugitive.enable = true;
			gitsigns.enable = true;
			undotree.enable = true;
			todo-comments.enable = true;
			indent-blankline = {
				enable = true;
				settings = {
					exclude.filetypes = ["dashboard"];
				};
			};
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
								"-cli" "${lib.getExe pkgs.arduino-cli}"
								"-clangd" "${pkgs.clang-tools}/bin/clangd"
							];
						};
					};
					clangd.enable = true;
					pyright.enable = true;
					glsl_analyzer.enable = true;
					# glslls.enable = true;
					svelte.enable = true;
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
