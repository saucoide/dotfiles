{
  inputs,
  pkgs,
  ...
}: {
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

      # Quitting
      {
        mode = "n";
        key = "<leader>qq";
        action = "<cmd>qall<CR>";
        options.desc = "[q]uit neovim";
      }
      {
        mode = "n";
        key = "<leader>qQ";
        action = "<cmd>qall!<CR>";
        options.desc = "[Q]uit neovim - discard unsaved";
      }

      # Terminal
      {
        mode = "t";
        key = "<esc>";
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
            local is_term = vim.bo.filetype == "terminal"
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
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>Neogit<CR>";
        options.desc = "open [g]it";
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

      # vim.keymap.set("n", "<leader>/", function() require'hop'.hint_patterns({direction = require'hop.hint'.HintDirection.AFTER_CURSOR}) end)

      # Search & Grepping
      {
        mode = "n";
        key = "S";
        action.__raw = ''
          function()
            require'hop'.hint_patterns(
              {direction = require'hop.hint'.HintDirection.BEFORE_CURSOR}
            )
          end
        '';
        options.desc = "Hop backwards in buffer";
      }
      {
        mode = "n";
        key = "s";
        action.__raw = ''
          function()
            require'hop'.hint_patterns(
              {direction = require'hop.hint'.HintDirection.AFTER_CURSOR}
            )
          end
        '';
        options.desc = "Hop forwards in buffer";
      }
      {
        mode = "n";
        key = "/";
        action = "<cmd>Telescope current_buffer_fuzzy_find<CR>";
        options.desc = "Find in buffer";
      }
      {
        mode = "n";
        key = "<leader>sr";
        action = "<cmd>Telescope grep_string<CR>";
        options.desc = "grep for [r]eferences to the string under cursor";
      }
      {
        mode = "n";
        key = "<leader>ss";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "live grep in current dir";
      }

      # Code / Lsp
      {
        mode = "n";
        key = "<leader>cf";
        action = "<cmd>Format<CR>";
        options.desc = "[f]ormat buffer";
      }
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
        key = "<leader>ot";
        action.__raw = "function() ToggleTerminal() end";
        options.desc = "Toggle [t]erminal";
      }
      {
        mode = "n";
        key = "<leader>oT";
        action.__raw = ''function() 
          local terminal = CreateTerminal() 
          local window = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_buf(window, terminal)
          vim.cmd.startinsert()
        end'';
        options.desc = "Open new [T]erminal";
      }
      {
        mode = "n";
        key = "<leader>lt";
        action.__raw = "function() ListTerminals() end";
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
      kickstart-highlight-yank = {clear = true;};
      customize-term-open = {clear = true;};
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
      # Terminal customiization
      {
        event = ["TermOpen"];
        desc = " yanking (copying) text";
        group = "customize-term-open";
        callback.__raw = ''
          function()
            vim.opt.number = false
            vim.opt.relativenumber = false

          end
        '';
      }
    ];

    plugins = {
      lualine = {
        enable = true;
        settings.extensions = ["oil"];
      };
      web-devicons.enable = true;
      sleuth.enable = true;
      # leap.enable = true;
      hop.enable = true;

      # TODO org-mode -> obsidian.nvim + markdown.nvim |OR| orgmode.nvim, need to see if tags are nicely supported
      # TODO looks like orgmove.nvim is the better option for me at the moment
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
          sort = ["alphanum"];
          spec = [
            {
              __unkeyed-1 = "<leader>b";
              desc = "[b]uffer";
            }
            {
              __unkeyed-1 = "<leader>c";
              desc = "[c]ode";
            }
            {
              __unkeyed-1 = "<leader>d";
              desc = "[d]irectory";
            }
            {
              __unkeyed-1 = "<leader>f";
              desc = "[f]ile";
            }
            {
              __unkeyed-1 = "<leader>s";
              desc = "[s]earch";
            }
            {
              __unkeyed-1 = "<leader>w";
              desc = "[w]indow";
            }
          ];
        };
      };
      telescope = {
        enable = true;
        settings = {
          pickers = {
            buffers.mappings.i = {"<C-d>" = "delete_buffer";};
            find_files.hidden = true;
          };
        };
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
            {
              __unkeyed-1 = "mtime";
              format = "%Y-%m-%d %H:%M";
            }
            "icon"
          ];
          buf_options = {buflisted = true;};
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

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            {name = "nvim_lsp";}
            {name = "path";}
            {name = "buffer";}
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

      neogit = {
        enable = true;
        settings = {
          graph_style = "ascii";
          disable_insert_on_commit = true;
          mappings = {
            popup = {
              F = "PullPopup";
              p = "PushPopup";
            };
          };
        };
      };

      orgmode = {
        enable = true;
        settings = {
          org_agenda_files = "~/notes/agenda/**/*";
          org_default_notes_file = "~/notes/todo.org";
          org_todo_keywords = ["TODO" "WIP" "DONE"];
          # TODO continue  https://github.com/nvim-orgmode/orgmode/blob/master/lua/orgmode/config/defaults.lua
        };
      };

      startup = {
        enable = true;
        mappings = {
          executeCommand = "<CR>";
          openFile = "<CR>";
          openFileSplit = "<C-o>";
        };
        parts = ["header" "recent"];
        options.paddings = [4 4];
        sections = {
          header = {
            type = "text";
            oldfilesDirectory = false;
            align = "center";
            foldSection = false;
            title = "Header";
            margin = 5;
            content = [
              "                        _           "
              "  _ __   ___  _____   _(_)_ __ ___  "
              " | '_ \\ / _ \\/ _ \\ \\ / / | '_ ` _ \\ "
              " | | | |  __/ (_) \\ V /| | | | | | |"
              " |_| |_|\\___|\\___/ \\_/ |_|_| |_| |_|"
            ];
            highlight = "Statement";
            defaultColor = "";
            oldfilesAmount = 0;
          };
          recent = {
            type = "oldfiles";
            #   oldfilesDirectory = true;
            align = "center";
            foldSection = false;
            title = "Recent Files";
            content = "";
            margin = 5;
            highlight = "String";
            oldfilesAmount = 10;
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

    # TODO eventually move this to nixvim proper - not supported atm
    extraPlugins = [pkgs.vimPlugins.formatter-nvim];
    extraConfigLua = ''
      require("formatter").setup {
        logging = true,
        filetype = {
          lua = { require("formatter.filetypes.lua").stylua },
          nix = { require("formatter.filetypes.nix").alejandra },
          python = { require("formatter.filetypes.python").ruff },
          terraform = { require("formatter.filetypes.terraform").terraformfmt },
          toml = { require("formatter.filetypes.toml").taplo },
          yaml = {
            function()
              return {
                exe = "yamlfmt",
                args = { "-in", "-formatter", "retain_line_breaks_single=true"},
                stdin = true,
              }
            end
          },
          json = { require("formatter.filetypes.json").jq },
          ["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace, }
        }
      }

      --  ** Terminal Toggling Functions **

      -- create new terminal
      function CreateTerminal()
        local buf = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_buf_call(buf, function()
          vim.cmd.term()
          vim.bo.filetype = "terminal"
        end)
        return buf
      end

      -- list terminasl
      function ListTerminals()
        local terminal_buffers = {}

        -- Iterate through all buffers
        for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
          -- Check if the buffer is valid and its filetype is 'terminal'
          if vim.bo[bufnr].filetype == "terminal" then
            table.insert(terminal_buffers, bufnr)
          end
        end

        -- show them to pick
        vim.ui.select(terminal_buffers, {
          prompt = "List of Terminals:",
          format_item = function(bufnr)
            return string.format("%s (Buffer %d)", item.name, item.bufnr)
          end,
        }, function(choice)
            if choice then
              vim.api.nvim_set_current_buf(choice)
            end
          end)
      end

      -- toggling behavior
      function ToggleTerminal()
        local windows = vim.api.nvim_tabpage_list_wins(0)
        local current_win = vim.api.nvim_get_current_win()
        local terminal_win = nil
        local terminal_buf = nil

        -- Find existing terminal buffer
        for _, buf in pairs(vim.api.nvim_list_bufs()) do
          if vim.bo[buf].buftype == 'terminal' then
            terminal_buf = buf
            break
          end
        end

        -- Create terminal buffer if it doesn't exist
        if not terminal_buf then
          terminal_buf = CreateTerminal()
        end

        -- Find existing terminal window
        for _, win in pairs(windows) do
          if vim.api.nvim_win_get_buf(win) == terminal_buf then
            terminal_win = win
            break
          end
        end

        -- If terminal window exists, close it and return
        if terminal_win then
          vim.api.nvim_win_close(terminal_win, true)
          return
        end

        -- If no terminal window, open one
        if #windows == 1 then
          -- Only one window, create a new vsplit
          vim.api.nvim_command('vsplit')
          local new_win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_buf(new_win, terminal_buf)
        else
          -- Multiple windows, use the first non-active window
          for _, win in ipairs(windows) do
            if win ~= current_win then
              vim.api.nvim_win_set_buf(win, terminal_buf)
              vim.api.nvim_set_current_win(win)
              break
            end
          end
        end
        vim.cmd.startinsert()
      end
      '';
    #   colorscheme = "monokai_pro";
  };
}
