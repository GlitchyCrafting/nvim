local gruff_au = vim.api.nvim_create_augroup('gruff', { clear = true })

-- Hide yank highlightht
vim.api.nvim_create_autocmd('TextYankPost', {
	group = gruff_au,
	callback = function()
		vim.highlight.on_yank({higroup = 'Visual', timeout = 2000})
	end
})
