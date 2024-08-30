local function has_words_before()
	local unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line-1, line, true)[1]:sub(col, col):match('%s') == nil
end

local function cmp_enabled()
	local context = require('cmp.config.context')

	if vim.api.nvim_get_mode().mode == 'c' then
		return true
	else
		return not context.in_treesitter_capture('comment')
		and not context.in_syntax_group('Comment')
	end
end

local function cmp_next(fallback)
	local cmp = require('cmp')
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
	local cmp = require('cmp')
	local luasnip = require('luasnip')

	if cmp.visible() then
		cmp.select_prev_item()
	elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end

local function cmp_confirm()
	return {
		i = function(fallback)
			if require("cmp").visible and require("cmp").get_active_entry() then
				require("cmp").confirm({
					behavior = require("cmp").ConfirmBehavior.Replace,
					select = false,
				})
			else
				fallback()
			end
		end,
		s = require("cmp").mapping.confirm({select = true}),
		c = require("cmp").mapping.confirm({
			behavior = require("cmp").ConfirmBehavior.Replace,
			select = true
		})
	}
end

return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
	},
	{
		"saadparwaiz1/cmp_luasnip",
		dependencies = {
			"L3MON4D3/LuaSnip",
		},
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		dependencies = {
			"nvim/nvim-lspconfig",
		}
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline",
			"onsails/lspkind.nvim",
			"FelipeLema/cmp-async-path",
			"chrisgrieser/cmp-nerdfont",
			"hrsh7th/cmp-emoji",
			"amarakon/nvim-cmp-fonts",
			"f3fora/cmp-spell",
			"windwp/nvim-autopairs",
		},
		config = function (_, opts)
			local cmp = require("cmp")

			cmp.setup({
				enabled = { cmp_enabled },
				performance = { max_view_entries = 10 },
				snippet = {
					expand = function (args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				mapping = {
					['<C-Space>'] = cmp.mapping(cmp.mapping.complete()),
					['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
					['<Tab>'] = cmp.mapping(cmp_next, {"i", "s"}),
					['<S-Tab>'] = cmp.mapping(cmp_prev, {"i", "s"}),
					['<S-CR>'] = cmp_confirm(),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lua" },
					{ name = "luasnip" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "nerdfont" },
					{ name = "emoji" },
					{ name = "async_path" },
				}, {
					{ name = "buffer" },
				}),
				formatting = {
					format = require("lspkind").cmp_format("symbol_text"),
					expandable_indicator = true,
				},
				view = {
					docs = { auto_open = true },
					entries = {
						name = "custom",
						selection_order = "near_cursor"
					},
				},
				window = {
					completion = { border = "double" },
					documentation = { border = "double" },
				},
			})

			for _, t in pairs({
				{{ '/', '?' }, { sources = {{ name = "buffer" }} }},
				{{ ':' }, {
					sources = cmp.config.sources({
						{name = "async_path"}
					}, {
						{name = "cmdline"}
					})
				}},
			}) do
				local cmd_opts = {
					mapping = cmp.mapping.preset.cmdline(),
				}
				cmp.setup.cmdline(t[1], vim.tbl_deep_extend("force", cmd_opts, t[2]))
			end

			for _, t in pairs({
				{
					{ "css", "yaml", "toml", "conf" },
					{sources = {
						{ name = "luasnip" },
						{ name = "nvim_lsp" },
						{ name = "nvim_lsp_signature_help" },
						{ name = "async_path" },
						{ name = "fonts", option = { space_filter = "-" } },
					}}
				},
				{
					{ "markdown", "text" },
					{sources = {
						{ name = "nerdfont" },
						{ name = "emoji" },
						{ name = "async_path" },
						{ name = "spell" },
					}}
				},
			}) do
				cmp.setup.filetype(t[1], t[2])
			end

			for e, a in pairs({
				{
					"confirm_done",
					require("nvim-autopairs.completion.cmp").on_confirm_done()
				},
			}) do
				cmp.event:on(e, a)
			end
		end,
	},
}
