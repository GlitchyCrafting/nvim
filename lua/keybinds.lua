local fzf = "fzf-lua"

local function cmd(c)
	return "<cmd>"..c.."<cr>"
end

local function lua(m, f)
	if f ~= nil then
		return cmd("lua require('"..m.."')."..f.."()")
	else
		return cmd("lua "..m)
	end
end

return {
	f = {
		name = "Files",
		f = {lua(fzf, "files"), "Find"},
		b = {lua("oil", "toggle_float"), "Browser"},
	},

	b = {lua(fzf, "buffers"), "Buffers"},
	s = {lua(fzf, "live_grep_native"), "Search"},
	a = {lua(fzf, "lsp_code_actions"), "Actions"},
	h = {lua(fzf, "help_tags"), "Help"},
	m = {lua(fzf, "manpages"), "Man Pages"},
	c = {cmd("CccPick"), "Color"},
	d = {cmd("Trouble diagnostics"), "Diagnostics"},
	M = {lua("peek", "open"), "Markdown"},
	r = {cmd("OverseerRun"), "Run"},
	t = {cmd("OverseerToggle"), "Tasks"},
}
