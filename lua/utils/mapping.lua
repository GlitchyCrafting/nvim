local mod = {}

function mod.cmd_map(k, c, d, ft)
	local keybind = "<leader>"..k
	local cmd = "<cmd>"..c.."<cr>"

	if ft then
		return { keybind, cmd, desc = d, ft = ft }
	end

	return { keybind, cmd, desc = d }
end

function mod.lua_map(k, m, f, d, ft)
	local keybind = "<leader>"..k

	local cmd = function ()
		require(m)[f]()
	end

	if ft then
		return { keybind, cmd, desc = d, ft = ft }
	end

	return { keybind, cmd, desc = d }
end

return mod
