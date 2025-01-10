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
      clipboard = "unnamedplus";
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
      listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";
      # inccommand = "split";  # live s/prev/final/g
      cursorline = true;
      scrolloff = 10;
      hlsearch = true;
      shell = "fish";
      # Complete behavior
      completeopt = ["menu" "menuone" "noselect"];
    };
    userCommands = {
        Q.command = "q";
        Q.bang = true;
        Wq.command = "wq";
        Wq.bang = true;
        WQ.command = "wq";
        WQ.bang = true;
        W.command = "w";
        W.bang = true;
    };
    keymaps = [
      # TODO execute lines evaluate stuff
      # lua: <cmd>.lua<CR>
      # lua: <cmd>source %<CR>

      # Commentss
      {
        mode = "n";
        key = "<C-/>";
        action = ":normal gcc<CR>";
        options.desc = "Toggle comment";
      }
      # Terminal
      {
        mode = "t";
        key = "<esc><esc>";
        action = "<c-\\><c-n>";
        options.desc = "Exit terminal mode";
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
        action = "<cmd>b#<CR>";
	options.desc = "Alternate Buffer";
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
        key = "<leader>bN";
        action.__raw = ''
          function()
            local new_buff = vim.api.nvim_create_buf({listed=true}, {scratch=false})
            local curr_win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_buf(curr_win, new_buff)
          end
        '';
        options.desc = "Create [N]ew buffer";
      }
      {
        mode = "n";
        key = "<leader>bk";
        action.__raw = ''
          function()
            local is_term = vim.bo.filetype == "toggleterm"
            local buff = vim.api.nvim_get_current_buf()
            if is_term then
              vim.api.nvim_buf_delete(buff, {force = true})
            else
              vim.api.nvim_buf_delete(buff, {})
            end
          end
        '';
	options.desc = "Kill Buffer";
      }
      {
        mode = "n";
        key = "<leader>bK";
        action = "<cmd>%bd<CR>";
	options.desc = "Kill All Buffers";
      }

      # Basics
      {
        mode = "n";
        key = "<leader><leader>";
        action = "<cmd>Telescope find_files<CR>";
	options.desc = "Find file"; # TODO maybe files + buffers in project
      }
      {
        mode = "n";
        key = "<leader>d";
        action = "<cmd>Oil<CR>";
        options.desc = "open [d]irectory listing (oil)";
      }

      # Files
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find [f]iles";
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>Telescope oldfiles<CR>";
        options.desc = "Find [r]ecent files";
      }

      # Search & Grepping
      {
        mode = "n";
        key = "/";
        action = "<cmd>Telescope current_buffer_fuzzy_find<CR>";
        options.desc = "Find in buffer";
      }
      {
        mode = "n";
        key = "<leader>ss";
        action = "<cmd>Telescope grep_string<CR>";
        options.desc = "grep string under cursor";
      }
      {
        mode = "n";
        key = "<leader>sp";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "live grep in current dir";
      }

      # Code / Lsp
      {
        mode = "n";
        key = "<leader>cl";
        action = "<cmd>Telescope diagnostics<CR>";
        options.desc = "[l]ist lsp diagnostics";
      }
      {
        mode = "n";
        key = "<leader>cn";
        action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        options.desc = "[n]ext diagnostic";
      }
      {
        mode = "n";
        key = "<leader>cp";
        action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        options.desc = "[p]revious diagnostic";
      }
      {
        mode = "n";
        key = "<leader>c<CR>";
        action.__raw = ''
        function()
          vim.lsp.buf.code_action()
        end
        '';
        options.desc = "code actions";
      }
      {
        mode = "n";
        key = "<leader>cd";
        action = "<cmd>Telescope lsp_definitions<CR>";
        options.desc = "goto [d]efinitions";
      }
      {
        mode = "n";
        key = "<leader>cr";
        action = "<cmd>Telescope lsp_references<CR>";
        options.desc = "goto [r]eferences";
      }

      # Terminal
      {
        mode = "n";
        key = "<leader>tT";
        action = "<cmd>ToggleTermToggleAll<CR>";
        options.desc = "Toggle all [T]erminals";
      }
      {
        mode = "n";
        key = "<leader>tl";
        action = "<cmd>TermSelect<CR>";
        options.desc = "[l]ist terminals";
      }

      # Other
      {
        mode = "n";
        key = "G";
        action = "Gzz";
        options.desc = "Center when scrolling to the end of file";
      }
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
        options.desc = "Clear highlights on search when pressing <Esc> in normal mode";
      }
    ];


    # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
    autoGroups = {
 #     neovim-startup = { clear = true; };
      kickstart-highlight-yank = { clear = true; }; 
#      customize-term-open = { clear = true; }; 
    };

    # [[ Basic Autocommands ]]
    #  See `:help lua-guide-autocommands`
    # https://nix-community.github.io/nixvim/NeovimOptions/autoCmd/index.html
    autoCmd = [

      # Highlight-Yank
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

      # TODO startup to a custom buffer
    ];

    plugins = {
      lualine = {
        enable = true;
        settings.extensions = [ "oil" ];
      };
      web-devicons.enable = true;
      sleuth.enable = true;
      # TODO NEXT completions!!!
      # TODO autoformatter
      # TODO magit
      # TODO org-mode
      # TODO org-roam
     # toggleterm = {
        # enable = true;
        # settings = {
        #   open_mapping = "[[<leader>tt]]";
        #   direction = "vertical";
        #   size = ''
        #     function(term)
        #       if term.direction == "horizontal" then
        #         return vim.o.rows * 0.3
        #       elseif term.direction == "vertical" then
        #         return vim.o.columns * 0.5
        #       end
        #     end'';
        #   autochdir = true;
        #   shade = false;
        # };
      # };
      which-key = {
        enable = true;
        settings = {
          delay = 500;
          sort = [ "alphanum" ];
          spec = [
            { __unkeyed-1 = "<leader>b"; desc = "[b]uffer";}
            { __unkeyed-1 = "<leader>c"; desc = "[c]ode";}
            { __unkeyed-1 = "<leader>d"; desc = "[d]irectory";}
            { __unkeyed-1 = "<leader>f"; desc = "[f]ile";}
            { __unkeyed-1 = "<leader>s"; desc = "[s]earch";}
            { __unkeyed-1 = "<leader>w"; desc = "[w]indow";}
          ];
        };
      };
      telescope = {
          enable = true;
          extensions = {
            ui-select.enable = true;
            fzf-native.enable = true;
            project = {
              enable = true;
              settings = { 
                base_dirs = [
                  "~/projects"
                  "~/dotfiles"
                ];
              };
            };
          };
      };
      oil = {
        enable = true;
        settings = {
          default_file_explorer = true;
          columns = [
            "permissions"
            "size"
            {__unkeyed-1 = "mtime"; format = "%Y-%m-%d %H:%M";}
            "icon" 
          ];
          buf_options = { buflisted = true; };
          win_options = {
            wrap = false;
            signcolumn = "no";
            cursorcolumn = false;
            foldcolumn = "0";
            spell = false;
            list = false;
            conceallevel = 3;
            concealcursor = "nvic";
          };
          delete_to_trash = true;
          skip_confirm_for_simple_edits = false;
          cleanup_delay_ms = 5000;
          constrain_cursor = "editable";
          watch_for_changes = false;
          use_default_keymaps = false;
          keymaps = {
            "<left>" = "actions.parent";
            "h" = "actions.parent";
            "<right>" = "actions.select";
            "l" = "actions.select";
            "<CR>" = "actions.select";
            "<C-CR>" = "actions.select_vsplit";
            "q" = "actions.close";
            "gr" = "actions.refresh";
            "H" = "actions.toggle_hidden";
            "<leader>oe" = "actions.open_external";
            "cd" = "actions.cd";
          };
          view_options = {
            show_hidden = false;
           # highlight_filename.__raw = ''
           #   function(entry, is_hidden, is_link_target, is_link_orphan)
           #     return "Special"
           #   end'';
          };
        };
      };

      treesitter = {
        enable = true;
        settings = {
          highlight = { 
            additional_vim_regex_highlighting = false;
            enable = true; 
            # can disbale individual grammars
            # disable = [ rust ];
          };
          indent.enable = true;
          incremental_selection.enable = false;
        }; 
        # languageRegister = { cpp = "onelab"; python = [ "foo" "bar" ]; };  # if you want to map individual filetypes to a given grammar
      };

      lsp = {
        enable = true;
          servers = {
          lua_ls.enable = true;
          nixd.enable = true;
          ruff.enable = true;
          pylsp.enable = true;
        };
      };

      # TODO - test the defaults and modify - TOMORROW!!!!!!!!!!!!
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp";}
            { name = "path";}
            { name = "buffer";}
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };
    };

    colorschemes.monokai-pro = {
      enable = true;
      settings = {
       devicons = true;
       terminal_colors = true;
       filter = "pro";
        #inc_search = "";
#        background_clear = [
        #    "toggleterm"
        #    "telescope"
        #    "renamer"
        #    "notify"
#            "oil"
#        ];
      };
    };
#    extraPlugins = [ pkgs.vimPlugins.vim-monokai-pro ];
 #   colorscheme = "monokai_pro";
  };
}
