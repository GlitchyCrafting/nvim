
local function has_words_before()
	local unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line-1, line, true)[1]:sub(col, col):match('%s') == nil
end

local function cmp_next(fallback)
	local cmp = require("cmp")
	local luasnip = require('luasnip')

	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	elseif has_words_before() then
		cmp.complete()
	else
		fallback()
	end
end

local function cmp_prev(fallback)
	local cmp = require("cmp")
	local luasnip = require('luasnip')

	if cmp.visible() then
		cmp.select_prev_item()
	elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end

return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline",
			"onsails/lspkind.nvim",
			"FelipeLema/cmp-async-path",
			"amarakon/nvim-cmp-fonts",
			"f3fora/cmp-spell",
			"windwp/nvim-autopairs",
			"rcarriga/cmp-dap",
		},
		config = function (_, _)
			local cmp = require("cmp")
			cmp.setup({
				enabled = function ()
					local disabled = false

					disabled = disabled or (vim.api.nvim_get_option_value('buftype', { buf = 0 }) == 'prompt')
					disabled = disabled or (vim.fn.reg_recording() ~= '')
					disabled = disabled or (vim.fn.reg_executing() ~= '')
					disabled = disabled or require('cmp.config.context').in_treesitter_capture('comment')

					return true
				end,
				snippet = {
					expand = function (args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				mapping = {
					['<C-e>'] = cmp.mapping.abort(),
					['<Tab>'] = cmp.mapping(cmp_next, {"i", "s"}),
					['<S-Tab>'] = cmp.mapping(cmp_prev, {"i", "s"}),
					['<S-CR>'] = cmp.mapping.confirm({ select = true }),
					['<C-Tab>'] = cmp.mapping.scroll_docs(-4),
					['<C-S-Tab>'] = cmp.mapping.scroll_docs(4),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lua" },
					{ name = "luasnip" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "nerdfont" },
					{ name = "async_path" },
				}, {
					{ name = "buffer" },
				}),
				formatting = {
					fields = { 'abbr', 'icon', 'kind', 'menu' },
					format = require("lspkind").cmp_format({
						mode = "symbol_text",
						maxwidth = {
							menu = 40,
							abbr = 40,
						},
						ellipsis_char = '...',
						show_labelDetails = true,
					}),
					expandable_indicator = true,
				},
				view = {
					docs = { auto_open = false },
					entries = {
						name = "custom",
						selection_order = "near_cursor"
					},
				},
				window = {
					completion = {
						border = "none",
						max_height = 20,
					},
					documentation = {
						border = "none",
						max_width = 40,
						max_height = 20,
					},
				},
			})

			cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())

			cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				}
			})

			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = 'async_path' },
				}, {
					{ name = 'cmdline' },
				}),
				matching = { disallow_symbol_nonprefix_matching = false, }
			})

			cmp.setup.filetype({
				"markdown",
				"text",
			}, {
				{
					sources = {
						{ name = "async_path" },
						{ name = "spell" },
						{ name = "buffer" },
					},
				},
			})

			cmp.setup.filetype({
				"css",
				"yaml",
				"toml",
				"conf",
			}, {
				sources = {
					{ name = "luasnip" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "async_path" },
					{ name = "fonts", option = { space_filter = "-" } },
					{ name = "buffer" },
				}
			})

			cmp.setup.filetype({
				"dap-repl",
				"dapui_watches",
				"dapui_hover",
			}, {
				sources = {
					{ name = "dap" },
				}
			})

		end,
	},
}
