require("config.settings")
-- vim.tbl_deep_extend("force", vim, require("config.settings"))
vim.filetype.add(require("config.filetypes"))
require("config.autocmd")
