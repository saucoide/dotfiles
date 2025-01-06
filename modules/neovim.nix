{ inputs, pkgs, ... }: {

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      { plugin = nvim-lspconfig; }
      { plugin = telescope-nvim; }
      { plugin = lualine-nvim; }
      # { plugin = lualine-nvim; type = "lua"; config = "something something something"; }
      
      # treesitter
      { plugin = (pkgs.vimPlugins.nvim-treesitter.withPlugins( p: [
         p.tree-sitter-nix
         p.tree-sitter-vim
         p.tree-sitter-bash
         p.tree-sitter-python
         p.tree-sitter-lua
         p.tree-sitter-json
         ]));
       }
    ];
    extraLuaConfig = ''
      -- basic stuff
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '
      vim.g.have_nerd_font = true
      vim.opt.number = true
      vim.opt.relativenumber = false
      vim.opt.mouse = 'a'
      vim.opt.showmode = false

      -- sync clipboard with the OS, scheduler after UiEnter
      vim.schedule(function()
        vim.opt.clipboard = 'unnamedplus'
      end)

      -- Enable break indent
      vim.opt.breakindent = true
      
      -- Save undo history
      vim.opt.undofile = true

      -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
      vim.opt.ignorecase = true
      vim.opt.smartcase = true

      -- Keep signcolumn on by default
      vim.opt.signcolumn = 'yes'

      -- Decrease update time
      vim.opt.updatetime = 250

      -- Decrease mapped sequence wait time
      vim.opt.timeoutlen = 300

      -- Configure how new splits should be opened
      vim.opt.splitright = true
      vim.opt.splitbelow = true

      -- Sets how neovim will display certain whitespace characters in the editor.
      --  See `:help 'list'`
      --  and `:help 'listchars'`
      vim.opt.list = true
      vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

      -- Preview substitutions live, as you type!
      vim.opt.inccommand = 'split'
      
      -- Show which line your cursor is on
      vim.opt.cursorline = true
      
      -- Minimal number of screen lines to keep above and below the cursor.
      vim.opt.scrolloff = 10

    '';
    # extraPackages = [
    #     pkgs.luajitPackages.lua-lsp
    #     -- Here go dependency packages for neovim, e.g. lsps etc

  };
}
