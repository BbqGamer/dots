return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"mfussenegger/nvim-dap",
		"mfussenegger/nvim-dap-python",
	},
	config = function()
		local dapui = require("dapui")
		dapui.setup()
		vim.keymap.set("n", "<leader>du", dapui.toggle)
		vim.keymap.set("n", "<leader>dc", dapui.close)
		vim.keymap.set("n", "<leader>do", dapui.open)

		require("dap-python").setup("python")

		local dap = require("dap")
		vim.keymap.set("n", "<leader>db", dap.set_breakpoint)
		vim.keymap.set("n", "<F1>", dap.continue)
		vim.keymap.set("n", "<F2>", dap.step_into)
		vim.keymap.set("n", "<F3>", dap.step_over)
		vim.keymap.set("n", "<F4>", dap.step_out)
		vim.keymap.set("n", "<F5>", dap.step_back)
		vim.keymap.set("n", "<F12>", dap.restart)

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
	end,
}
