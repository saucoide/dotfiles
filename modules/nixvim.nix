{ inputs, pkgs, ... }: {
  programs.nixvim = {
    enable = true;
    # defaultEditor = true;
    vimdiffAlias = true;
    globals = {
      mapleader = " ";
      localmapleader = " ";
      have_nerd_font = true;
    };
    opts = {
      number = true;
      relativenumber = false;
      mouse = "a";
      showmode = false;
      clipboard = {
        register = "unnamedplus";
      };
      # clipboard = "unnamedplus"; schedule?
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      splitright = true;
      splitbelow = true;
      list = true;
      # NOTE: .__raw here means that this field is raw lua code
      listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";
      inccommand = "split";
      cursorline = true;
      scrolloff = 10;
      hlsearch = true;
    };
    keymaps = [
      {
        mode = "n";
        key = "/";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Lige grep";
      }
      # Window spliting
      {
        mode = "n";
        key = "<leader>wv";
        action = "<C-w>v";
	options.desc = "Split window vertically";
      }
      {
        mode = "n";
        key = "<leader>ws";
        action = "<C-w>s";
	options.desc = "Split window horizontally";
      }
      {
        mode = "n";
        key = "<leader>wc";
        action = "<C-w>q";
	options.desc = "Close window";
      }
# TODO rotate layouts
#       {
#         mode = "n";
#         key = "<leader>w<leader>";
#         action = "<C-w>";
#         options.desc = "Rotate window layouts";
#       }
      {
        mode = "n";
        key = "<leader>w=";
        action = "<C-w>=";
        options.desc = "Equalize window sizes";
      }
      # Window focus
      {
        mode = "n";
        key = "<leader><up>";
        action = "<C-w><up>";
	options.desc = "Move FOCUS to the UPPER WINDOW";
      }
      {
        mode = "n";
        key = "<leader><down>";
        action = "<C-w><down>";
	options.desc = "Move FOCUS to the LOWER WINDOW";
      }
      {
        mode = "n";
        key = "<leader><left>";
        action = "<C-w><left>";
	options.desc = "Move FOCUS to the LEFT WINDOW";
      }
      {
        mode = "n";
        key = "<leader><right>";
        action = "<C-w><right>";
	options.desc = "Move FOCUS to the RIGHT WINDOW";
      }

      # Window moving
      {
        mode = "n";
        key = "<leader>ww";
        action = "<C-w>r";
	options.desc = "Rotate windows clockwise";
      }
      {
        mode = "n";
        key = "<leader>wW";
        action = "<C-w>R";
	options.desc = "Rotate windows anticlockwise";
      }
      {
        mode = "n";
        key = "<leader>w<up>";
        action = "<C-w>K";
	options.desc = "Move window to the TOP";
      }
      {
        mode = "n";
        key = "<leader>w<down>";
        action = "<C-w>J";
	options.desc = "Move window to the BOTTOM";
      }
      {
        mode = "n";
        key = "<leader>w<left>";
        action = "<C-w>H";
	options.desc = "Move window to the LEFT";
      }
      {
        mode = "n";
        key = "<leader>w<right>";
        action = "<C-w>L";
	options.desc = "Move window to the RIGHT";
      }

      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
	options.desc = "Clear highlights on search when pressing <Esc> in normal mode";
      }

      # Leader Maps

      # Buffers
      {
      # TODO list project buffers
        mode = "n";
        key = "<leader>bb";
        action = "<cmd>Telescope buffers<CR>";
	options.desc = "TOOD List relevant Buffers";
      }
      {
        mode = "n";
        key = "<leader>bB";
        action = "<cmd>Telescope buffers<CR>";
	options.desc = "List all Buffers";
      }
      {
        mode = "n";
        key = "<leader><BS>";
        action = "<cmd>bprev<CR>";
	options.desc = "Previous Buffer";
      }
      {
        mode = "n";
        key = "<leader>bp";
        action = "<cmd>bp<CR>";
	options.desc = "Previous Buffer";
      }
      {
        mode = "n";
        key = "<leader>bn";
        action = "<cmd>bn<CR>";
	options.desc = "Next Buffer";
      }
      {
        mode = "n";
        key = "<leader>bk";
        action = "<cmd>bd<CR>";
	options.desc = "Kill Buffer";
      }
      # File stuff
      {
        mode = "n";
        key = "<leader>d";
        action = "<cmd>Oil<CR>";
	options.desc = "open directory listing (oil)";
      }

    ];


    # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
    autoGroups = { kickstart-highlight-yank = { clear = true; }; };

    # [[ Basic Autocommands ]]
    #  See `:help lua-guide-autocommands`
    # https://nix-community.github.io/nixvim/NeovimOptions/autoCmd/index.html
    autoCmd = [
      {
        event = ["TextYankPost"];
        desc = "Highlight when yanking (copying) text";
        group = "kickstart-highlight-yank";
        callback.__raw = ''
          function()
            vim.highlight.on_yank()
          end
        '';
      }
    ];

    plugins = {
      lualine.enable = true;
      web-devicons.enable = true;
      sleuth.enable = true;
      # todo-comments = { enable = true; settings.signs = true; };
      which-key = {
        enable = true;
        settings = {
          delay = 500;
        };
        # keys = [] # TODO add the ones that dont map to anything e.g leader-o

      };
      telescope = {
          enable = true;
          #extensions = {
          #  project.enable = true;
          #};
          # settings = {}; # TODO
      };
      oil = {
        enable = true;
        settings = {
          default_file_explorer = true;
          columns = [ "permissions" "size" "mtime" "icon" ];
          win_options = {
            wrap = false;
            signcolumn = "no";
            cursorcolumn = false;
            foldcolumn = "0";
            spell = false;
            list = false;
            #conceallevel
            #concealcursor
          };
          delete_to_trash = true;
          skip_confirm_for_simple_edits = false;
          cleanup_delay_ms = 2000;
          constrain_cursor = "editable";
          watch_for_changes = false;
          use_default_keymaps = false;
          keymaps = {
            "<left>" = "actions.parent";
            "h" = "actions.parent";
            "<right>" = "actions.select";
            "l" = "actions.select";
            "<CR>" = "actions.select";
            "<shift-CR>" = "actions.select_split";
            "q" = "actions.close";
            "gr" = "actions.refresh";
            "H" = "actions.toggle_hidden";
            "<C-CR>" = "actions.toggle_hidden";
          };
          view_options = {
            show_hidden = false;
          };

        };

      };
      # TODO which-key
      lsp = {
        enable = true;
          servers = {
          lua_ls.enable = true;
        };
      };
    };
      # nvim-cmp = {
      #   enable = true;
      #   autoEnableSources = true;
      #   sources = [
      #     { name = "nvim_lsp";}
      #     { name = "path";}
      #     { name = "buffer";}
      #   ];
      # };
    extraPlugins = [
      pkgs.vimPlugins.vim-monokai-pro
    ];
    # TODO fix side bar line number
    colorscheme = "monokai_pro";

    #colorschemes.onedark = {
    #  enable = true;
    #  settings.style  = "warmer";
#   #   lazyLoad.enable = true;
    #};
#    colorschemes.base16 = {
#      enable = true;
#      colorscheme = "monokai";
#    #   lazyLoad.enable = true;
#    };
  };
}
