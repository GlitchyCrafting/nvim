local function lsp_setup(_, opts)
	local lspconfig = require("lspconfig")

	vim.diagnostic.config(opts.vim_diagnostic)

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	for lsp, o in pairs(opts.servers) do
		local default_conf = {
			on_attach = function (_, bufnr)
				vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
			end,
			capabilities = capabilities
		}
		lspconfig[lsp].setup(vim.tbl_deep_extend("force", default_conf, o))
	end
end

return {
	{
		"neovim/nvim-lspconfig",
		config = lsp_setup,
		opts = {
			vim_diagnostic = {
				virtual_text = false,
				signs = true,
				underline = true,
				update_in_insert = true,
				severity_sort = true,
			},
			servers = {
				cssls = {},
				marksman = {},
				jdtls = {},
				clangd = {
					cmd = {
						"clangd",
						"--background-index",
						"--pch-storage=memory",
						"--completion-style=bundled",
						"--clang-tidy",
						"--all-scopes-completion",
						"--pretty",
						"--suggest-missing-includes",
						"--header-insertion=iwyu",
						"--header-insertion-decorators",
						"-j=8",
						"--malloc-trim",
					},
					filetypes = {"c", "h", "cpp", "hpp"},
					root_dir = require("lspconfig").util.root_pattern(".git", "compile_commands.json", "compile_flags.json")
				},
				lua_ls = {
					settings = {
						Lua = {
							runtime = {
								version = {"Lua 5.1"},
							},
						},
					},
				},
				glsl_analyzer = {
					cmd = {"glsl_analyzer"},
					filetypes = {"glsl"},
				},
				html = {
					filetypes = {"html", "hxml", "htmx", "tera", "hbs"},
				},
			},
		},
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
		opts = {
			ui = { border = "double" },
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
	},
	{
		"ray-x/lsp_signature.nvim",
		opts = {
			bind = true,
			handler_opts = { border = "double" },
			floating_window = true,
			fix_pos = true,
			hint_prefix = {
				above = "↙ ",
				current = "← ",
				below = "↖ ",
			},
			auto_close_after = 5,
		},
		dependencies = {
			"neovim/nvim-lspconfig",
		},
	},
}
