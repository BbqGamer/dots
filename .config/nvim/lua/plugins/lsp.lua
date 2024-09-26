return { -- LSP Configuration & Plugins
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	keys = function(_, keys)
		local builtin = require("telescope.builtin")
		return {
			{ "gd", builtin.lsp_definitions, "[G]oto [D]efinition" },
			{ "gr", builtin.lsp_references, "[G]oto [R]eferences" },
			{ "gI", builtin.lsp_implementations, "[G]oto [I]mplementation" },
			{ "<leader>D", builtin.lsp_type_definitions, "Type [D]efinition" },
			{ "<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols" },
			{ "<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols" },
			{ "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame" },
			{ "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction" },
			{ "K", vim.lsp.buf.hover, "Hover Documentation" },
			{ "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration" },
			unpack(keys),
		}
	end,
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("nvim", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end
			end,
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local servers = {
			gopls = {},
			pyright = {},
			clangd = {},
			lua_ls = {
				-- cmd = {...},
				-- filetypes = { ...},
				-- capabilities = {},
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			},
		}

		require("mason").setup()
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
