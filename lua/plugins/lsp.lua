local function lsp_setup(_, opts)
	local lspconfig = vim.lsp.config

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
		lspconfig(lsp, vim.tbl_deep_extend("force", default_conf, o))
		vim.lsp.enable(lsp)
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
				lua_ls = {},
				cmake = {},
				rust_analyzer = {},
				pyright = {},
				-- glsl_analyzer = {},
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
						"--enable-config",
					},
					filetypes = { "c", "h", "cpp", "hpp" },
					root_markers = {".git", "compile_commands.json", "compile_flags.json"},
				},
				html = {
					filetypes = { "html", "hxml", "htmx", "tera", "hbs" },
				},
			},
		},
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ui = { border = "none" },
		},
	},
	-- {
	-- 	"ray-x/lsp_signature.nvim",
	-- 	opts = {
	-- 		bind = true,
	-- 		handler_opts = { border = "none" },
	-- 		floating_window = true,
	-- 		fix_pos = true,
	-- 		hint_prefix = {
	-- 			above = "↙ ",
	-- 			current = "← ",
	-- 			below = "↖ ",
	-- 		},
	-- 		auto_close_after = nil,
	-- 	},
	-- 	dependencies = {
	-- 		"neovim/nvim-lspconfig",
	-- 	},
	-- },
}
