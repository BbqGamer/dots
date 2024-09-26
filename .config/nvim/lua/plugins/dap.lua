return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"mfussenegger/nvim-dap",
		"mfussenegger/nvim-dap-python",
	},
	keys = function(_, keys)
		local dap = require("dap")
		local dapui = require("dapui")
		return {
			-- Basic debugging keymaps, feel free to change to your liking!
			{ "<F1>", dap.step_into, desc = "Debug: Step Into" },
			{ "<F2>", dap.step_over, desc = "Debug: Step Over" },
			{ "<F3>", dap.step_out, desc = "Debug: Step Out" },
			{ "<F4>", dap.step_back, desc = "Debug: Step Back" },
			{ "<F5>", dap.continue, desc = "Debug: Start/Continue" },
			{ "<leader>b", dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
			{ "<F6>", dapui.toggle, desc = "Debug: See last session result." },
			{ "<F12>", dap.restart, desc = "Debug: Restart" },
			unpack(keys),
		}
	end,
	config = function()
		local dapui = require("dapui")
		dapui.setup()

		local dap = require("dap")
		dap.listeners.before.attach.dapui_config = dapui.open
		dap.listeners.before.launch.dapui_config = dapui.open
		dap.listeners.before.event_terminated.dapui_config = dapui.close
		dap.listeners.before.event_exited.dapui_config = dapui.close

		require("dap-python").setup("python")
	end,
}
