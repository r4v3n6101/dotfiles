{ inputs, ... }:
{
  flake.homeModules.nixvim =
    { pkgs, ... }:
    {
      imports = [
        inputs.nixvim.homeModules.default
      ];

      home.packages = [
        pkgs.nil
      ];

      programs.nixvim = {
        nixpkgs.config.allowUnfree = true;

        enable = true;
        enableMan = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        withPython3 = true;

        clipboard.providers = {
          pbcopy.enable = true;
          xclip.enable = true;
        };

        globals = {
          mapleader = " ";
        };

        opts = {
          wrap = false;
          number = true;
          relativenumber = true;
          signcolumn = "yes";
          ignorecase = true;
          smartcase = true;
          list = false;
          expandtab = true;
          shiftwidth = 4;
          tabstop = 4;
          smartindent = true;
          termguicolors = true;
          updatetime = 300;
          undofile = true;
          foldlevel = 99;
          foldlevelstart = 99;
          clipboard = [
            "unnamed"
            "unnamedplus"
          ];
          completeopt = [
            "fuzzy"
            "menuone"
            "noinsert"
            "popup"
          ];
          winborder = "rounded";
        };

        autoCmd = [
          {
            desc = "Hightlight after yanking";
            event = [ "TextYankPost" ];
            command = ''
              silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
            '';
          }
        ];

        colorschemes.catppuccin = {
          enable = true;
          settings = {
            no_italic = true;
            term_colors = true;
            transparent_background = false;
            color_overrides = {
              mocha = {
                base = "#000000";
                mantle = "#000000";
                crust = "#000000";
              };
            };
          };
        };

        lsp = {
          inlayHints.enable = true;
          servers = {
            nil_ls = {
              enable = true;
              config = {
                cmd = [ "nil" ];
                filetypes = [ "nix" ];
                root_markers = [
                  "flake.nix"
                  ".git"
                ];
              };
            };
            copilot = {
              enable = true;
            };
          };
        };

        keymaps = [
          # Basic
          {
            mode = "n";
            key = "<leader>n";
            action.__raw = ''
              require"oil".toggle_float
            '';
            options.desc = "Toggle Oil window";
          }
          {
            mode = "n";
            key = "[c";
            action.__raw = ''
              function() require"treesitter-context".go_to_context(vim.v.count1) end
            '';
            options.desc = "Jump back to treesitter context header";
          }

          # Slop
          {
            mode = "n";
            key = "<leader>aa";
            action.__raw = ''
              function() require"sidekick.cli".toggle() end
            '';
            options.desc = "Toggle Sidekick CLI";
          }
          {
            mode = [
              "n"
              "x"
            ];
            key = "<leader>at";
            action.__raw = ''
              function() require"sidekick.cli".send({ msg = "{this}" }) end
            '';
            options.desc = "Send @this to Sidekick";
          }
          {
            mode = "n";
            key = "<leader>af";
            action.__raw = ''
              function() require"sidekick.cli".send({ msg = "{file}" }) end
            '';
            options.desc = "Send @file to Sidekick";
          }
          {
            mode = "n";
            key = "<leader>ap";
            action.__raw = ''
              function() require"sidekick.cli".prompt() end
            '';
            options.desc = "Send @file to Sidekick";
          }

          # Picker (fuzzy finder)
          {
            mode = "n";
            key = "<leader>fc";
            action = "<cmd>Pick resume<cr>";
            options.desc = "Continue last search";
          }
          {
            mode = "n";
            key = "<leader>ff";
            action = "<cmd>Pick files<cr>";
            options.desc = "Find files";
          }
          {
            mode = "n";
            key = "<leader>fg";
            action = "<cmd>Pick grep_live<cr>";
            options.desc = "Find by grep";
          }
          {
            mode = "n";
            key = "<leader>fb";
            action = "<cmd>Pick buffers<cr>";
            options.desc = "Find in opened buffers";
          }
          {
            mode = "n";
            key = "<leader>fh";
            action = "<cmd>Pick help<cr>";
            options.desc = "Find in help tags";
          }
          {
            mode = "n";
            key = "<leader>fr";
            action = "<cmd>Pick registers<cr>";
            options.desc = "Find in registers";
          }
          {
            mode = "n";
            key = "<leader>fm";
            action = "<cmd>Pick marks<cr>";
            options.desc = "Find in marks";
          }
          {
            mode = "n";
            key = "<leader>fd";
            action = "<cmd>Pick diagnostic<cr>";
            options.desc = "Find in diagnostics";
          }
          {
            mode = "n";
            key = "<leader>fk";
            action = "<cmd>Pick keymaps<cr>";
            options.desc = "Find in keymaps";
          }
          {
            mode = "n";
            key = "<leader>fo";
            action = "<cmd>Pick options<cr>";
            options.desc = "Find in options";
          }

          # Git
          {
            mode = "n";
            key = "<leader>hq";
            action.__raw = ''
              function() require"gitsigns".setqflist('all') end
            '';
            options.desc = "Open qfix (hunks for git directory)";
          }
        ];

        perfomance.byteCompileLua.enable = true;
        plugins = {
          lualine.enable = true;
          vim-suda.enable = true;
          nvim-web-devicons.enable = true;
          indent-blankline-nvim.enable = true;
          mini-extra.enable = true;
          mini-pick.enable = true;
          nix-develop.enable = true;
          sidekick.enable = true;
          nvim-bqf = {
            enable = true;
            settings = {
              preview.winblend = 0;
            };
          };
          oil = {
            enable = true;
            settings = {
              delete_to_trash = true;
              default_file_explorer = true;
              win_options = {
                signcolumn = "yes:2";
              };
            };
          };
          oil-git-status = {
            enable = true;
          };
          which-key = {
            enable = true;
            settings = {
              delay = 300;
            };
          };
          origami = {
            enable = true;
          };
          treesitter = {
            enable = true;
            settings = {
              highlight = {
                enable = true;
                disable = [ "rust" ];
              };
              indent.enable = true;
            };
          };
          treesitter-context = {
            enable = true;
            settings = {
              max_lines = 3;
            };
          };
          gitsigns = {
            enable = true;
            settings = {
              numhl = true;
              attach_to_untracked = true;
              on_attach = ''
                  function(bufnr)
                    local gs = require('gitsigns')
                    vim.keymap.set('n', ']h', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ ']h', bang = true })
                        else
                            gs.nav_hunk('next')
                        end
                    end, { buffer = bufnr, desc = "Next hunk" })

                    vim.keymap.set('n', '[h', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ '[h', bang = true })
                        else
                            gs.nav_hunk('prev')
                        end
                    end, { buffer = bufnr, desc = "Previous hunk" })

                    vim.keymap.set('n', '<leader>hs', gs.stage_hunk,
                        { buffer = bufnr, desc = "Stage hunk" })
                    vim.keymap.set('n', '<leader>hr', gs.reset_hunk,
                        { buffer = bufnr, desc = "Reset hunk" })
                    vim.keymap.set('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                        { buffer = bufnr, desc = "Stage hunk (visual)" })
                    vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                        { buffer = bufnr, desc = "Reset hunk (visual)" })

                    vim.keymap.set('n', '<leader>hS', gs.stage_buffer,
                        { buffer = bufnr, desc = "Stage buffer" })
                    vim.keymap.set('n', '<leader>hR', gs.reset_buffer,
                        { buffer = bufnr, desc = "Reset buffer" })

                    vim.keymap.set('n', '<leader>hp', gs.preview_hunk,
                        { buffer = bufnr, desc = "Preview hunk" })
                    vim.keymap.set('n', '<leader>hb', function() gs.blame_line { full = true } end,
                        { buffer = bufnr, desc = "Blame line" })

                    vim.keymap.set('n', '<leader>hd', gs.diffthis, { buffer = bufnr, desc = "Show diff" })
                    vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end,
                        { buffer = bufnr, desc = "Show diff" })

                    vim.keymap.set('n', '<leader>hl', gs.setloclist,
                        { buffer = bufnr, desc = "Open loclist (hunks for file)" })

                    vim.keymap.set({ 'o', 'x' }, 'ih', gs.select_hunk,
                        { buffer = bufnr, desc = "Select hunk (text object)" })
                end
              '';
            };
          };
          fidget = {
            enable = true;
            settings = {
              notification = {
                window = {
                  winblend = 0;
                };
              };
            };
          };
          rustaceanvim = {
            enable = true;
            settings = {
              server.default_settings.rust-analyzer = {
                files = {
                  excludeDirs = [
                    ".direnv"
                    ".git"
                    ".gitlab"
                  ];
                };
                cargo = {
                  allFeatures = true;
                };
                completion = {
                  autoimport = {
                    enable = true;
                  };
                };
                inlayHints = {
                  bindingModeHints = {
                    enable = true;
                  };
                  closureReturnTypeHints = {
                    enable = "always";
                  };
                  discriminantHints = {
                    enable = "always";
                  };
                  lifetimeElisionHints = {
                    enable = "skip_trivial";
                    useParameterNames = true;
                  };
                  rangeExclusiveHints = {
                    enable = true;
                  };
                  expressionAdjustmentHints = {
                    enable = "reborrow";
                    mode = "postfix";
                  };
                };
                procMacro = {
                  enable = true;
                };
              };
            };
          };
        };

        extraFiles = {
          "after/ftplugin/nix.lua".text = ''
            vim.opt_local.tabstop = 2
            vim.opt_local.shiftwidth = 2
            vim.opt_local.expandtab = true
          '';
          "after/ftplugin/json.lua".text = ''
            vim.bo.formatprg = "jq"
          '';
        };

        extraConfigLua = ''
          -- Remove default bindings
          vim.keymap.del('n', 'grn')
          vim.keymap.del('n', 'gra')
          vim.keymap.del('n', 'grr')
          vim.keymap.del('n', 'gri')
          vim.keymap.del('n', 'gO')
          vim.keymap.del('i', '<C-s>')

          -- Configuration for buffers when LSP attached to them
          vim.api.nvim_create_autocmd('LspAttach', {
              group = vim.api.nvim_create_augroup('UserLspConfig', {}),
              callback = function(ev)
                  local client = vim.lsp.get_client_by_id(ev.data.client_id)

                  -- Enable auto-completion
                  if client:supports_method('textDocument/completion') then
                      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
                  end

                  -- LSP actions
                  vim.keymap.set('n', "<leader>gd", vim.lsp.buf.definition,
                      { buffer = ev.buf, desc = "Go to definition" })
                  vim.keymap.set('n', "<leader>gD", vim.lsp.buf.declaration,
                      { buffer = ev.buf, desc = "Go to declaration" })
                  vim.keymap.set('n', "<leader>gt", vim.lsp.buf.type_definition,
                      { buffer = ev.buf, desc = "Go to type definition" })
                  vim.keymap.set('n', "<leader>ga", vim.lsp.buf.code_action,
                      { buffer = ev.buf, desc = "Show code action" })
                  vim.keymap.set('n', "<leader>gn", vim.lsp.buf.rename,
                      { buffer = ev.buf, desc = "Rename" })
                  vim.keymap.set('n', "<leader>gr", vim.lsp.buf.references,
                      { buffer = ev.buf, desc = "Go to references" })
                  vim.keymap.set('n', "<leader>gi", vim.lsp.buf.implementation,
                      { buffer = ev.buf, desc = "Go to implementation" })
                  vim.keymap.set('n', "<leader>gs", vim.lsp.buf.document_symbol,
                      { buffer = ev.buf, desc = "Open document symbols in loclist" })
                  vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help,
                      { buffer = ev.buf, desc = "Signature help" })

                  -- Format on save
                  vim.api.nvim_create_autocmd('BufWritePre', {
                      buffer = ev.buf,
                      callback = function()
                          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id })
                      end,
                  })
              end
          })

          -- Diagnostics and inlay hints
          SHOW_VIRTUAL_TEXT = false
          DIAGNOSTICS_VIRTUAL_TEXT = true

          vim.lsp.inlay_hint.enable(SHOW_VIRTUAL_TEXT)
          vim.diagnostic.config {
              underline = true,
              signs = true,
              severity_sort = true,
              update_in_insert = true,
              virtual_text = DIAGNOSTICS_VIRTUAL_TEXT and SHOW_VIRTUAL_TEXT,
              virtual_lines = not DIAGNOSTICS_VIRTUAL_TEXT and SHOW_VIRTUAL_TEXT,
          }

          -- Show/hide diagnostics and inlay hints
          vim.keymap.set('n', '<leader>t', function()
              SHOW_VIRTUAL_TEXT = not SHOW_VIRTUAL_TEXT
              vim.lsp.inlay_hint.enable(SHOW_VIRTUAL_TEXT)
              vim.diagnostic.config {
                  virtual_text = DIAGNOSTICS_VIRTUAL_TEXT and SHOW_VIRTUAL_TEXT,
                  virtual_lines = not DIAGNOSTICS_VIRTUAL_TEXT and SHOW_VIRTUAL_TEXT,
              }
              vim.cmd [[ normal "hl" ]]
          end, { desc = "Show/hide diagnostics and inlay hints" })

          -- Change type of diagnostics (virtual lines or virtual text)
          vim.keymap.set('n', '<leader>l', function()
              DIAGNOSTICS_VIRTUAL_TEXT = not DIAGNOSTICS_VIRTUAL_TEXT
              vim.diagnostic.config {
                  virtual_text = DIAGNOSTICS_VIRTUAL_TEXT and SHOW_VIRTUAL_TEXT,
                  virtual_lines = not DIAGNOSTICS_VIRTUAL_TEXT and SHOW_VIRTUAL_TEXT,
              }
              vim.cmd [[ normal "hl" ]]
          end, { desc = "Toggle virtual text/lines for diagnostics" })
        '';
      };
    };
}
