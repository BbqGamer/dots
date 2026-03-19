return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        require("nvim-treesitter.config").setup({
            highlight = { enable = true },
            auto_install = true,
        })
    end,
}
