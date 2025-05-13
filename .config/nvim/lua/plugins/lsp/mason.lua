return {
  {
    "williamboman/mason.nvim",
    opts = {
      ui = { border = "rounded" },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = { auto_install = true },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "basedpyright",
        "ruff",
        "prettierd",
        "stylelint",
        "bash-language-server",
        "html-lsp",
        "shfmt",
      },
    },
  },
}
