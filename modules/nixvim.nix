{pkgs, ...}: {
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
      wrap = false;
      shiftwidth = 4;
      tabstop = 4;
      mouse = "a";
      showmode = false;
      clipboard = "unnamedplus";
      conceallevel = 2;
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
      incsearch = true;
      termguicolors = true;
      # colorcolumn = "88";
      shell = "fish";
      # Complete behavior
      completeopt = ["menu" "menuone" "noselect"];
      swapfile = false;
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

    # colorschemes = {
    #   monokai-pro = {
    #     enable = true;
    #     lazyLoad.enable = true;
    #     settings = {
    #       devicons = true;
    #       terminal_colors = true;
    #       filter = "pro";
    #     };
    #   };
    colorscheme = "monokai-pro";

    keymaps = [
      # TODO
      # leader h-f for built-in help via telescope and stuff like i had in emacs
      # TODO other keymaps
      # - YASSNIPPET for =+begin_src etc
      # - Make telescope / search and s hop jump emit a search afterwards so i can n n n n n
      # - :help diffget   check how to resolve conflicts in neogit
      # - to remove lsp diagnostics when editing https://github.com/neovim/neovim/issues/13324#issuecomment-1592038788
      #  - or maybe - check how to get them to be less obnoxious

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
            local force_close = vim.bo.filetype == "terminal"
            local buff = vim.api.nvim_get_current_buf()

            local ok, _ = pcall(vim.cmd, "buffer #")
            if not ok then
              vim.cmd("enew")
            end
            vim.api.nvim_buf_delete(buff, {force = force_close})
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
        action = "<cmd>Telescope git_files<CR>";
        options.desc = "find git files";
      } # TODO maybe files + buffers in project
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
      {
        mode = "n";
        key = "gr";
        action = "<cmd>checktime<CR>";
        options.desc = ":checktime to refresh buffer";
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
      # Project
      # {
      #   mode = "n";
      #   key = "<leader>pp";
      #   action = "<cmd>Telescope projects<CR>";
      #   options.desc = "Switch [p]roject";
      # }
      {
        mode = "n";
        key = "<leader>pf";
        action = "<cmd>Telescope git_files<CR>";
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
        action.__raw = "function() vim.lsp.buf.code_action() end";
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
      {
        mode = "n";
        key = "<leader>cR";
        action.__raw = "function() vim.lsp.buf.rename() end";
        options.desc = "goto [r]eferences";
      }
      {
        mode = "i";
        key = "<C-h>";
        action.__raw = "function() vim.lsp.buf.signature_help() end";
        options.desc = "Show signature help";
      }

      # [T]erminal
      {
        mode = "n";
        key = "<leader>tt";
        action.__raw = "function() ToggleTerminal() end";
        options.desc = "Toggle [t]erminal";
      }
      {
        mode = "n";
        key = "<leader>tT";
        action.__raw = ''
          function()
            local terminal = CreateTerminal()
            local window = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_buf(window, terminal)
            vim.cmd.startinsert()
          end'';
        options.desc = "Open new [T]erminal";
      }
      {
        mode = "n";
        key = "<leader>tl";
        action.__raw = "function() ListTerminals() end";
        options.desc = "[l]ist terminals";
      }

      # Quickfix
      {
        mode = "n";
        key = "<C-down>";
        action = "<cmd>cnext<CR>";
        options.desc = "next quickfix";
      }
      {
        mode = "n";
        key = "<C-up>";
        action = "<cmd>cprevious<CR>";
        options.desc = "previous quickfix";
      }

      # Other
      {
        mode = "n";
        key = "<leader>ot";
        action = "<cmd>edit ~/notes/agenda/todo.org<CR>";
        options.desc = "open [t]odo.org";
      }
      {
        mode = "n";
        key = "G";
        action = "Gzz";
        options.desc = "Center when scrolling to the end of file";
      }
      {
        mode = "n";
        key = "J";
        action = "mzJ`z";
        options.desc = "Keep cursor inplace when [J]oining below";
      }
      {
        mode = "x";
        key = "p";
        action = "P";
        options.desc = "Do not loose the yank when pasting over a selection";
      }
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
        options.desc = "Clear highlights on search when pressing <Esc> in normal mode";
      }
      {
        mode = "v";
        key = "<M-Up>";
        action = ":m '<-2<CR>gv=gv";
        options.desc = "Shift selection UP";
      }
      {
        mode = "v";
        key = "<M-Down>";
        action = ":m '>+1<CR>gv=gv'";
        options.desc = "Shift selection DOWN";
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
        desc = "Customize terminal buffers on Open";
        group = "customize-term-open";
        callback.__raw = ''
          function()
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.bo.filetype = "terminal"
          end
        '';
      }
    ];

    plugins = {
      lz-n.enable = true; # needed to lazy-load the rest of plugins
      lualine = {
        enable = true;
        settings.extensions = ["oil"];
      };
      web-devicons.enable = true;
      sleuth.enable = true;
      nvim-surround.enable = true;
      colorizer = {
        enable = true;
        lazyLoad.settings.cmd = "ColorizerToggle";
      };
      hop = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
      };

      # Which-Key
      which-key = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
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
            {
              __unkeyed-1 = "<leader>t";
              desc = "[t]erminal";
            }
            {
              __unkeyed-1 = "<leader>o";
              desc = "[o]rgmode";
            }
          ];
        };
      };
      #
      # Telescope
      telescope = {
        enable = true;
        # lazyLoad.settings.event = "DeferredUIEnter";
        settings = {
          defaults = {
            mappings.i = {
              "<CR>" = {__raw = "require('telescope.actions').select_default + require('telescope.actions').center";};
              "<S-CR>" = {__raw = "require('telescope.actions').select_vertical";};
            };
            mappings.n = {
              "<CR>" = {__raw = "require('telescope.actions').select_default + require('telescope.actions').center";};
              "<S-CR>" = {__raw = "require('telescope.actions').select_vertical";};
            };
          };
          pickers = {
            buffers.mappings.i = {"<C-d>" = "delete_buffer";};
            find_files = {
              hidden = true;
              # mappings.i = {"<C-c>" =  {__raw = "require('telescope.actions').select_default";};};  # TODO - these are not taking effect at all - compare with the generate lua
              # mappings.n = {"<C-c>" = "select_vsplit";};
            };
            live_grep.hidden = true;
            current_buffer_fuzzy_find = {
              previewer = false;
              # mappings.i = {"<CR>" = {__raw = "require('telescope.actions').select_default + require('telescope.actions').center";};};
              # mappings.n = {"<CR>" = {__raw = "require('telescope.actions').select_default + require('telescope.actions').center";};};
            };
          };
        };
        extensions = {
          ui-select.enable = true;
          fzf-native.enable = true;
        };
      };


      # harpoon = {
      #   enable = true;
      #    settings = {
      #      save_on_toggle = true;
      #      sync_on_ui_close = false;
      # };
      #   enableTelescope = true;
      #   # lazyLoad.settings.event = "DeferredUIEnter";
      #   keymaps = {
      #     addFile = "<leader>a";
      #     cmdToggleQuickMenu = "<leader>hc";
      #     toggleQuickMenu = "<leader>hh";
      #     gotoTerminal = {
      #       "1" = "<leader>t1";
      #       "2" = "<leader>t2";
      #       "3" = "<leader>t3";
      #       "4" = "<leader>t4";
      #     };
      #     navFile = {
      #       "1" = "<leader>1";
      #       "2" = "<leader>2";
      #       "3" = "<leader>3";
      #       "4" = "<leader>4";
      #       "5" = "<leader>5";
      #       "6" = "<leader>6";
      #     };
      #   };
      # };

      # Oil
      oil = {
        enable = true;
        lazyLoad.settings = {cmd = "Oil";};
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
            "<S-CR>" = "actions.select_vsplit";
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

      # Treesitter
      treesitter = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
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

      # LSP
      lsp = {
        enable = true;
        lazyLoad.settings.ft = ["python" "nix" "lua"];
        servers = {
          lua_ls.enable = true;
          nixd.enable = true;
          ruff.enable = true;
          pylsp = {
            enable = true;
            settings = {plugins.mypy.enabled = true;};
          };
        };
      };

      # Completions
      cmp = {
        enable = true;
        # lazyLoad.settings.event = "DeferredUIEnter";
        autoEnableSources = true;
        settings = {
          sources = [
            {name = "nvim_lsp";}
            {name = "path";}
            {name = "buffer";}
            {name = "orgmode";}
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

      # Neogit / Magit
      neogit = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
        settings = {
          graph_style = "ascii";
          disable_insert_on_commit = true;
          git_services = {
            "git.wrke.in" = "https://git.wrke.in/\${owner}/\${repository}/merge_requests/new?merge_request[source_branch]=\${branch_name}";
          };
          mappings = {
            popup = {
              F = "PullPopup";
              p = "PushPopup";
            };
          };
        };
      };

      # Org-Mode
      orgmode = {
        enable = true;
        # lazyloading this if fully broken
        # lazyLoad.settings = {
        # enable = false;
        # event = "VimEnter";
        # ft = "org";
        # keys = ["<leader>o" ];
        # };
        settings = {
          # ui = {};
          org_agenda_files = "~/notes/agenda/todo.org";
          org_default_notes_file = "~/notes/agenda/todo.org";
          org_archive_location = "~/notes/agenda/todo.org_archive";
          org_hide_leading_stars = false;
          org_hide_emphasis_markers = true;
          org_startup_indented = true; # TODO check
          org_todo_keywords = ["TODO" "WIP" "DONE"];
          org_capture_templates = {
            t = {
              description = "new TODO entry";
              template = "* TODO %?\n  %u\n  DEADLINE: %^t\n  FROM: %a";
            }; # target = "~/notes/somethng.org"  # TODO add deadline
          };
          org_startup_folded = "content";
          mappings = {
            prefix = "<leader>o";
            global = {
              org_agenda = "<prefix>a";
              org_capture = "<prefix>c";
            };
            agenda = {org_agenda_show_help = "?";};
            capture = {
              org_capture_kill = "<leader>bk";
              org_capture_show_help = "?";
            };
            note = {org_note_kill = "<leader>bk";};
            org = {
              org_refile = "<prefix>r";
              org_timestamp_up_day = false;
              org_timestamp_down_day = false;
              org_change_date = "<prefix>dc";
              org_todo = "<S-RIGHT>";
              org_todo_prev = "<S-LEFT>";
              org_toggle_checkbox = "<C-Space>";
              toggle_heading = false;
              open_at_point = "<prefix>o";
              org_add_note = "<prefix>na";
              org_cycle = "<TAB>";
              org_global_cycle = "<S-TAB>";
              org_archive_subtree = "<prefix>$";
              org_set_tags_command = "<prefix>t";
              org_do_promote = false;
              org_do_demote = false;
              org_do_promote_subtree = "<M-LEFT>";
              org_do_demote_subtree = "<M-RIGHT>";
              org_move_subtree_up = "<M-S-UP>";
              org_move_subtree_down = "<M-S-DOWN>";
              org_meta_return = "<leader><CR>";
              org_return = "<CR>";
              org_insert_heading_respect_content = "<prefix>ih";
              org_insert_todo_heading = false;
              org_insert_todo_heading_respect_content = "<S-CR>";
              org_export = "<prefix>e";
              org_deadline = "<prefix>id";
              org_schedule = "<prefix>it";
              org_insert_link = "<prefix>li";
              org_store_link = "<prefix>ls";
              org_babel_table = "<prefix>bt";
              org_show_help = "<prefix>?";
            };
          };
        };
      };
    };

    extraPlugins = [
      # TODO eventually move this to nixvim proper - not supported atm
      pkgs.vimPlugins.formatter-nvim
      # org-roam
      (pkgs.vimUtils.buildVimPlugin {
        doCheck = false;
        name = "org-roam.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "chipsenkbeil";
          repo = "org-roam.nvim";
          rev = "946c3289d8aa5a84b84458b8c9aa869c2a10f836";
          hash = "sha256-PJiZU9tGNCv0ScnLFMPWYXIlCMr+NBBjWJNopRbd9Es=";
        };
      })
    ];
    extraConfigLua = ''
        require("formatter").setup {
          logging = true,
          filetype = {
            lua = { require("formatter.filetypes.lua").stylua },
            nix = { require("formatter.filetypes.nix").alejandra },
            python = { function()
                return {
                  exe = "ruff",
                  args = {"format", "-q", "-"},
                  stdin = true,
                }
              end
            };
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
            c = { require("formatter.filetypes.c").clangformat },
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

      --- TODO package this for nixpkgs
      require("org-roam").setup({
          directory="~/notes/roam/",
          ui = {
            select = {
              ---@type fun(node:org-roam.core.file.Node):org-roam.config.ui.SelectNodeItems
              node_to_items = function(node)
                ---@type string[]
                local items = {}

                local function make_item(label)
                  if #node.tags == 0 then
                    -- We can pass a string if the label and value
                    -- are the same
                    return label
                  else
                    local tags = table.concat(node.tags, ":")

                    -- In the case that the label (displayed) and
                    -- value (injected) are different, we can pass
                    -- a table with `label` and `value` back
                    return {
                      label = ("[%s] %s"):format(tags, label),
                      value = label,
                    }
                  end
                end

                -- For the node's title and its aliases, we want
                -- to create an item where the title/alias is the
                -- value and we show them alongside tags if they exist
                --
                -- This allows us to search tags, but not insert
                -- tags as part of a link if selected
                table.insert(items, make_item(node.title))
                for _, alias in ipairs(node.aliases) do
                  -- Avoid duplicating the title if the alias is the same
                  if alias ~= node.title then
                    table.insert(items, make_item(alias))
                  end
                end

                return items
              end,
            },
          },
        })

        local harpoon = require('harpoon')
        harpoon.setup({ 
          settings = {
            save_on_toggle = true,
          },
          ["terms"] = require("harpoon.terms"):new()
        })

        -- Buffers
        vim.keymap.set( "n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon: Add file" })
        vim.keymap.set( "n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Toggle quick menu" })
        vim.keymap.set( "n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon: Go to file 1" })
        vim.keymap.set( "n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon: Go to file 2" })
        vim.keymap.set( "n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon: Go to file 3" })
        vim.keymap.set( "n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon: Go to file 4" })
        vim.keymap.set( "n", "<leader>5", function() harpoon:list():select(5) end, { desc = "Harpoon: Go to file 5" })

        -- Terminals: Navigation
        vim.keymap.set("n", "<leader>tt", function() harpoon.ui:toggle_quick_menu(harpoon:list("terms")) end, { desc = "Show harpoon terminal menu" })
        vim.keymap.set("n", "<leader>t1", function() harpoon:list("terms"):select(1) end, { desc = "Harpoon: Go to Terminal 1" })
        vim.keymap.set("n", "<leader>t2", function() harpoon:list("terms"):select(2) end, { desc = "Harpoon: Go to Terminal 2" })
        vim.keymap.set("n", "<leader>t3", function() harpoon:list("terms"):select(3) end, { desc = "Harpoon: Go to Terminal 3" })
        vim.keymap.set("n", "<leader>t4", function() harpoon:list("terms"):select(4) end, { desc = "Harpoon: Go to Terminal 4" })
        vim.keymap.set("n", "<leader>t5", function() harpoon:list("terms"):select(5) end, { desc = "Harpoon: Go to Terminal 5" })

        -- Terminals: Commands
        vim.keymap.set("n", "<C-l>1", function() harpoon:list("terms"):send_command(1, "clear") end, { desc = "Harpoon: Clear Terminal 1" })
        vim.keymap.set("n", "<C-l>2", function() harpoon:list("terms"):send_command(2, "clear") end, { desc = "Harpoon: Clear Terminal 2" })
        vim.keymap.set("n", "<C-l>3", function() harpoon:list("terms"):send_command(3, "clear") end, { desc = "Harpoon: Clear Terminal 3" })
        vim.keymap.set("n", "<C-l>4", function() harpoon:list("terms"):send_command(4, "clear") end, { desc = "Harpoon: Clear Terminal 4" })
        vim.keymap.set("n", "<C-l>5", function() harpoon:list("terms"):send_command(5, "clear") end, { desc = "Harpoon: Clear Terminal 5" })
        vim.keymap.set({"n", "v"}, "<C-CR>1", function() harpoon:list("terms"):send_selection(1, true) end, { desc = "Harpoon: Current selection to Terminal 1" })
        vim.keymap.set({"n", "v"}, "<C-CR>2", function() harpoon:list("terms"):send_selection(2, true) end, { desc = "Harpoon: Current selection to Terminal 2" })
        vim.keymap.set({"n", "v"}, "<C-CR>3", function() harpoon:list("terms"):send_selection(3, true) end, { desc = "Harpoon: Current selection to Terminal 3" })
        vim.keymap.set({"n", "v"}, "<C-CR>4", function() harpoon:list("terms"):send_selection(4, true) end, { desc = "Harpoon: Current selection to Terminal 4" })
        vim.keymap.set({"n", "v"}, "<C-CR>5", function() harpoon:list("terms"):send_selection(5, true) end, { desc = "Harpoon: Current selection to Terminal 5" })
        '';
  };
}
