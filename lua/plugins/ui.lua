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

return {
	{
		"ibhagwan/fzf-lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			winopts = {
				border = "double",
				preview = {
					border = "double",
					scrollbar = false,
				},
			},
		}
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
					"branch",
					"diff",
					{
						"diagnostics",
						update_in_insert = true,
					},
				},
				lualine_c = {
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
								completed = "Comgleted",
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
				lualine_x = {
					"encoding",
					"fileformat",
					"filetype",
				},
				lualine_y = {
					"filename",
					"filesize",
				},
				lualine_z = {
					"progress",
					"location",
				}
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {"filename"},
				lualine_x = {"location"},
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
	{
		"uga-rosa/ccc.nvim",
		config = function (_, _)
			require("ccc").setup({
			highlighter = {
				auto_enable = true,
				lsp = true,
				update_insert = true,
			},
			win_opts = {border = "double"},
			mappings = {
				["<Left>"] = require("ccc").mapping.decrease,
				["<Right>"] = require("ccc").mapping.increase,
			},
			pickers = {
				require("ccc").picker.ansi_escape(),
			},
			recognize = {output = true},
		})
		end
	},
	{
		"folke/which-key.nvim",
		init = function ()
			vim.o.timeout = true
			vim.o.timeoutlen = 0
		end,
		opts = {
			preset = "classic",
			win = {
				border = "double",
				title = false,
			},
			triggers = {
				{ "<auto>", mode = "nixsotc" },
				{ "<leader>", mode = {"n", "v"} },
			},
			icons = { mappings = false },
			show_help = false,
		},
		config = function (_, opts)
			require("which-key").setup(opts)
			require("which-key").add(require("keybinds"))
		end
	},
	{
		"folke/trouble.nvim",
		opts = {
			auto_close = true,
			auto_preview = true,
			auto_refresh = true,
			preview = { type = "main" },
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
				border = "double",
			},
			preview = {border = "double"},
			progress = {border = "double"},
			ssh = {border = "double"},
			keymaps_help = {border = "double"},
		},
	},
	{
		"toppair/peek.nvim",
		build = "deno task --quiet build:fast",
		opts = {},
	},
}
