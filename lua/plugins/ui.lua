local git_ignored = setmetatable({}, {
	__index = function(self, key)
		local proc = vim.system(
		{"git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory"},
		{
			cwd = key,
			text = true
		}
		)

		local result = proc:wait()
		local ret = {}

		if result.code == 0 then
			for line in vim.gsplit(result.stdout, "\n", {plain = true, trimempty = true}) do
				line = line:gsub("/$", "")
				table.insert(ret, line)
			end
		end

		rawset(self, key, ret)
		return ret
	end,
})

local lua_map = require("utils.mapping").lua_map
local cmd_map = require("utils.mapping").cmd_map

return {
	{
		"ibhagwan/fzf-lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			winopts = {
				border = "none",
				preview = {
					border = "none",
					scrollbar = false,
				},
			},
		},
		keys = {
			lua_map("b", "fzf-lua", "buffers", "Buffers"),
			lua_map("ff", "fzf-lua", "files", "Find"),
			lua_map("h", "fzf-lua", "help_tags", "Help", { "lua", "vim" }),
			lua_map("m", "fzf-lua", "manpages", "Man Pages", { "c", "h", "cpp", "makefile" }),
			lua_map("s", "fzf-lua", "live_grep", "Search"),
			lua_map("a", "fzf-lua", "lsp_code_actions", "Actions"),
			lua_map("fl", "fzf-lua", "lsp_document_symbols", "LSP"),
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		dependencies = {
			"arkav/lualine-lsp-progress",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			options = {
				globalstatus = true,
			},
			sections = {
				lualine_a = {
					"mode"
				},
				lualine_b = {
					{
						"filename",
						file_status = true,
						newfile_status = false,
						path = 1,
					},
					-- "filesize",
				},
				lualine_c = {
					-- "branch",
					-- "diff",
				},
				lualine_x = {
					-- "encoding",
					-- "fileformat",
					-- "filetype",
					{
						"diagnostics",
						update_in_insert = true,
					},
				},
				lualine_y = {
					{
						"lsp_progress",
						display_components = {
							"lsp_client_name",
							{
								"title",
								"percentage",
								"message",
							},
						},
						separators = {
							component = " ",
							progress = " | ",
							message = {
								pre = "(",
								post = ")",
								commenced = "In Progress",
								completed = "Completed",
							},
							percentage = {
								pre = "",
								post = "%% ",
							},
							title = {
								pre = "",
								post = ": ",
							},
							lsp_client_name = {
								pre = "[",
								post = "]",
							},
							spinner = {
								pre = "",
								post = "",
							},
						},
					},
				},
				lualine_z = {
					"progress",
					"location",
				}
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {}
			},
			extensions = {
				"fzf",
				"lazy",
				"mason",
				"oil",
				"trouble",
			}
		}
	},
	-- {
	-- 	"uga-rosa/ccc.nvim",
	-- 	config = function (_, _)
	-- 		require("ccc").setup({
	-- 			highlighter = {
	-- 				auto_enable = true,
	-- 				lsp = true,
	-- 				update_insert = true,
	-- 			},
	-- 			win_opts = { border = "none" },
	-- 			mappings = {
	-- 				["<Left>"] = require("ccc").mapping.decrease,
	-- 				["<Right>"] = require("ccc").mapping.increase,
	-- 			},
	-- 			pickers = {
	-- 				require("ccc").picker.ansi_escape(),
	-- 			},
	-- 			recognize = { output = true },
	-- 		})
	-- 	end,
	-- 	keys = {
	-- 		cmd_map("c", "CccPick", "Color"),
	-- 	}
	-- },
	{
		"folke/which-key.nvim",
		init = function ()
			vim.o.timeout = true
			vim.o.timeoutlen = 0
		end,
		opts = {
			preset = "classic",
			win = {
				border = "none",
				title = true,
			},
			triggers = {
				{ "<auto>", mode = "nixsotc" },
				{ "<leader>", mode = { "n", "v" } },
			},
			icons = { mappings = false },
			show_help = false,
		},
		config = function (_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.add({
				mode = { "n" },
				{ "<leader>f", group = "Files" },
				{ "<leader>D", group = "Debug" },
				{ "<leader>t", group = "Terminal" },
				{ "<leader>T", group = "TODO" },
			})
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {
			auto_close = true,
			auto_preview = true,
			auto_refresh = true,
			preview = { type = "main" },
		},
		keys = {
			cmd_map("d", "Trouble diagnostics toggle", "Diagnostics"),
		}
	},
	{
		"stevearc/oil.nvim",
		opts = {
			delete_to_trash = true,
			watch_for_changes = true,
			view_options = {
				show_hidden = true,
				is_always_hidden = function (name, _)
					if name == ".git" then
						return true
					end

					local dir = require("oil").get_current_dir()
					if not dir then
						return false
					end

					return vim.list_contains(git_ignored[dir], name)
				end
			},
			float = {
				padding = 10,
				border = "none",
			},
			preview = { border = "none" },
			progress = { border = "none" },
			ssh = { border = "none" },
			keymaps_help = { border = "none" },
		},
		keys = {
			lua_map("fb", "oil", "toggle_float", "Browser"),
		}
	},
	{
		"numToStr/FTerm.nvim",
		opts = {
			cmd = "fish",
		},
		keys = {
			lua_map("tt", "FTerm", "toggle", "Toggle"),
			{
				"<Leader>tb",
				function ()
					require("FTerm").scratch({ cmd = "make build-release" })
				end,
				desc = "Build",
				ft = { "c", "h", "cpp", "makefile" }
			},
			{
				"<Leader>tr",
				function ()
					require("FTerm").scratch({ cmd = "make run" })
				end,
				desc = "Run",
				ft = { "c", "h", "cpp", "makefile" }
			},
			{
				"<Leader>td",
				function ()
					require("FTerm").scratch({ cmd = "make build-debug"})
				end,
				desc = "Build Debug",
				ft = { "c", "h", "cpp", "makefile" }
			},
			{
				"<Leader>tc",
				function ()
					require("FTerm").scratch({ cmd = "make clean"})
				end,
				desc = "Clean",
				ft = { "c", "h", "cpp", "makefile" }
			},
			{
				"<Leader>tg",
				function ()
					require("FTerm").scratch({ cmd = "lazygit"})
				end,
				desc = "LazyGit",
			},
		},
	},
}
