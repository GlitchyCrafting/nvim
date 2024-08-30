vim.env.TMPDIR="./.tmp"
vim.o.compatible     = false
vim.o.backspace      = 'eol,indent,start'
vim.o.ruler          = true
vim.o.termguicolors  = true
vim.o.timeoutlen     = 0
vim.o.scrolloff      = 5
vim.o.number         = true
vim.o.numberwidth    = 2
vim.o.relativenumber = true
vim.o.signcolumn     = 'yes'
vim.o.cursorline     = true
vim.o.expandtab      = false
vim.o.smarttab       = true
vim.o.cindent        = true
vim.o.autoindent     = true
vim.o.wrap           = true
vim.o.textwidth      = 80
vim.o.tabstop        = 8
vim.o.shiftwidth     = 0
vim.o.softtabstop    = -1
vim.o.formatoptions  = 'rqn1jp'
vim.o.backup         = false
vim.o.writebackup    = true
vim.o.undofile       = true
vim.o.swapfile       = false
vim.o.history        = 50
vim.o.splitright     = true
vim.o.splitbelow     = true
vim.o.foldmethod     = 'expr'
vim.o.foldexpr       = "nvim_treesitter#foldexpr()"
vim.o.foldlevelstart = 99
vim.o.foldnestmax    = 3
vim.o.foldminlines   = 1
vim.o.encoding       = 'utf-8'
vim.o.showbreak      = '+++ '
vim.o.virtualedit    = 'block'
vim.o.incsearch      = true
vim.o.directory      = vim.env.TMPDIR
vim.opt.clipboard:append('unnamedplus')
vim.opt.mouse        = ""
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

local TMPDIR = "./.tmp"

return {
	env = { TMPDIR = TMPDIR },
	o = {
		compatible = false,
		backspace = "eol,indent,start",
		ruler = true,
		termguicolors = true,
		timeoutlen = 0,
		scrolloff = 5,
		number = true,
		numberwidth = 2,
		relativenumber = true,
		signcolumn = "yes",
		cursorline = true,
		expandtab = false,
		smarttab = true,
		cindent = true,
		autoindent = true,
		wrap = true,
		textwidth = 80,
		tabstop = 8,
		shiftwidth = 0,
		softtabstop = -1,
		formatoptions = "rqn1jp",
		backup = false,
		writebackup = true,
		undofile = true,
		swapfile = false,
		history = 50,
		splitright = true,
		splitbelow = true,
		foldmethod = "expr",
		foldexpr = "nvim_treesitter#foldexpr()",
		foldlevelstart = 99,
		foldnestmax = 3,
		foldminlines = 1,
		encoding = "utf-8",
		showbreak = ">>=>> ",
		virtualedit = "block",
		incsearch = true,
		directory = TMPDIR,
	},
	opt = {
		clipboard = "unnamedplus,unnamed",
		mouse = "",
	},
	g = {
		mapleader = " ",
		maplocalleader = " ",
	},
}
