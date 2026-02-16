local lua_map = require("utils.mapping").lua_map

return {
	{
		"rcarriga/nvim-dap-ui",
		opts = {},
		keys = {
			lua_map("Du", "dapui", "toggle", "Toggle UI", { "c", "h", "cpp", "makefile" }),
		},
		dependencies = {
			"mfussenegger/nvim-dap",
			"jay-babu/mason-nvim-dap.nvim",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
	},
	{
		"Weissle/persistent-breakpoints.nvim",
		opts = {
			load_breakpoints_event = "BufReadPost",
			always_reload = true,
		},
		keys = {
			lua_map("Db", "persistent-breakpoints.api", "toggle_breakpoint", "Breakpoint", { "c", "h", "cpp", "makefile" }),
			lua_map("Dc", "persistent-breakpoints.api", "set_conditional_breakpoint", "Cond Break", { "c", "h", "cpp", "makefile" }),
			lua_map("Dl", "persistent-breakpoints.api", "set_log_point", "Logpoint", { "c", "h", "cpp", "makefile" }),
			lua_map("DC", "persistent-breakpoints.api", "clear_all_breakpoints", "Clear Breaks", { "c", "h", "cpp", "makefile" }),
		},
	},
	{
		"mfussenegger/nvim-dap",
		opts = {},
		config = function (_, opts)
			local dap = require("dap")
			local dapui = require("dapui")

			dap.listeners.after.event_initialized["dapui_config"] = function ()
				dapui.open()
			end
			dap.listeners.after.event_terminated["dapui_config"] = function ()
				dapui.close()
			end
			dap.listeners.after.event_exited["dapui_config"] = function ()
				dapui.close()
			end

			vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error" })
			vim.fn.sign_define("DapStopped", { text = "󰁗", texthl = "Constant" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "Error" })
			vim.fn.sign_define("DapLogPoint", { text = "", texthl = "SpellCap" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "Error" })

			vim.keymap.set("n", "<F5>", dap.continue)
			vim.keymap.set("n", "<F10>", dap.step_over)
			vim.keymap.set("n", "<F11>", dap.step_into)
			vim.keymap.set("n", "<F12>", dap.step_out)

			-- dap.adapters.lldb = {
			-- 	type = "executable",
			-- 	command = "/usr/bin/lldb-dap",
			-- 	name = "lldb"
			-- }
			-- dap.configurations.c = {
			-- 	{
			-- 		name = "Launch",
			-- 		type = "lldb",
			-- 		request = "launch",
			-- 		progam = function ()
			-- 			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			-- 		end,
			-- 		cwd = "${workspaceFolder}",
			-- 		stopOnEntry = false,
			-- 		args = {},
			-- 	},
			-- }
		end,
		keys = {
			lua_map("DD", "dap", "continue", "Start", { "c", "h", "cpp", "makefile" }),
			lua_map("Dt", "dap", "terminate", "Terminate", { "c", "h", "cpp", "makefile" }),
		},
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		opts = {
			handlers = {},
			automatic_installation = {},
			ensure_installed = {
				"codelldb",
			},
		},
		dependencies = {
			"mfussenegger/nvim-dap",
			"williamboman/mason.nvim",
		},
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		opts = {
			all_frames = true,
			show_stop_reason = true,
			highlight_changed_variables = true,
		},
	},
}
