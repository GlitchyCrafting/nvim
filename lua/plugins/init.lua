-- Setup Lazy.nvim
local lazypath = vim.fn.stdpath("data").."/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath
	})
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup("plugins", {
	ui = { border = "none" },
	install = { colorscheme = { "slate" } },
	-- dev = {
		-- path = "~/Projects/",
		-- patterns = { "glitchcandy-nvim" },
	-- }
})

return {
	{
		"glitchcandy/glitchcandy-nvim",
		lazy = false,
		priority = 1000,
		config = function ()
			vim.cmd("colorscheme glitchcandy")
		end
	}
}
