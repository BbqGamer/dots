return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        vim.schedule(function()
            local ok, configs = pcall(require, "nvim-treesitter.configs")
            if not ok then
                return
            end

            configs.setup({
                highlight = { enable = true },
                auto_install = true,
            })
        end)
    end,
}
