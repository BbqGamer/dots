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

		require("dap-python").setup("python")

		dap.adapters.python = {
			type = "executable",
			command = vim.fn.stdpath("data") .. "/mason/bin/debugpy-adapter",
		}

		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				console = "integratedTerminal", -- needed to use dap terminal (for io)
				pythonPath = function()
					local cwd = vim.fn.getcwd()
					if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
						return cwd .. "/venv/bin/python"
					elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
						return cwd .. "/.venv/bin/python"
					else
						return "/usr/bin/python"
					end
				end,
			},
		}
	end,
}
