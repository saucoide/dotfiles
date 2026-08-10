return {
  {
    "mhartington/formatter.nvim",
    enabled = true,
    event = "VeryLazy",
    config = function()
      require("formatter").setup({
        logging = true,
        filetype = {
          lua = {
            function()
              return {
                exe = "stylua",
                args = {
                  "--search-parent-directories",
                  "--stdin-filepath",
                  vim.api.nvim_buf_get_name(0),
                  "--indent-type",
                  "Spaces",
                  "--indent-width",
                  "2",
                  "-",
                },
                stdin = true,
              }
            end,
          },
          nix = { require("formatter.filetypes.nix").nixfmt },
          python = {
            function()
              return {
                exe = "ruff",
                args = { "format", "-q", "-" },
                stdin = true,
              }
            end,
          },
          terraform = { require("formatter.filetypes.terraform").terraformfmt },
          toml = { require("formatter.filetypes.toml").taplo },
          yaml = {
            function()
              return {
                exe = "yamlfmt",
                args = { "-in", "-formatter", "retain_line_breaks_single=true" },
                stdin = true,
              }
            end,
          },
          json = { require("formatter.filetypes.json").jq },
          javascript = { require("formatter.filetypes.javascript").prettier },
          typescript = { require("formatter.filetypes.typescript").prettier },
          rust = { require("formatter.filetypes.rust").rustfmt },
          rust = {
            function()
              return {
                exe = "rustfmt",
                -- args = { "-" },
                stdin = true,
              }
            end,
          },
          c = { require("formatter.filetypes.c").clangformat },
          ["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
        },
      })
    end,
  },
}
