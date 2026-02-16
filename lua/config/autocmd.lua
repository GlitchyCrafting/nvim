local gruff_au = vim.api.nvim_create_augroup('gruff', { clear = true })

-- Hide yank highlightht
vim.api.nvim_create_autocmd('TextYankPost', {
	group = gruff_au,
	callback = function()
		vim.highlight.on_yank({higroup = 'Visual', timeout = 2000})
	end
})

vim.api.nvim_create_autocmd('FileType', {
	group = gruff_au,
	pattern = { "*.md" },
	callback = function()
		vim.opt_local.tabstop = 2
	end
})

vim.api.nvim_create_autocmd('CmdlineEnter', {
	group = gruff_au,
	pattern = { "/", "?" },
	callback = function()
		vim.o.hlsearch = true
	end
})

vim.api.nvim_create_autocmd('CmdlineLeave', {
	group = gruff_au,
	pattern = { "/", "?" },
	callback = function()
		vim.o.hlsearch = false
	end
})
