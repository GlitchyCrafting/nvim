return {
	{
		"numToStr/Comment.nvim",
		opts = {
			ignore = "^$",
		}
	},
	{
		"folke/todo-comments.nvim",
		opts = {}
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		opts = {
			highlight = {
				enable = true,
				disable = { "html" },
				additional_vim_regex_highlighting = { "html" },
			},
			indent = { enable = false },
			auto_install = true,
		},
		config = function (_, opts)
			require('nvim-treesitter.configs').setup(opts)
		end
	},
	{
		"windwp/nvim-autopairs",
		opts = {
			enable_bracket_in_quote = false,
			check_ts = true,
		}
	},
	{
		"windwp/nvim-ts-autotag",
		opts = {}
	},
	{
		"mawkler/modicator.nvim",
		opts = {
			highlight = {
				defaults = {
					bold = true,
					italic = true,
				},
			},
			integration = {
				lualine = {
					enabled = true,
					mode_section = nil,
					highlight = "bg",
				},
			},
		}
	},
	{
		"rmagatti/auto-session",
		opts = {},
	},
}
