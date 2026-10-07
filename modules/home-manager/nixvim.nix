{ inputs, ... }:
{
  flake.modules.homeManager.nixvim =
    { pkgs, ... }:
    {
      imports = [
        inputs.nixvim.homeModules.default
      ];

      programs.nixvim = {
        nixpkgs = {
          source = inputs.nixpkgs;
          config.allowUnfree = true;
        };

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
          complete = [
            "o"
            "."
            "w"
            "b"
            "u"
            "f"
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
            color_overrides.mocha = {
              base = "#000000";
              mantle = "#000000";
              crust = "#000000";
            };
          };
        };

        lsp = {
          inlayHints.enable = true;
          semanticTokens.enable = true;
          codelens.enable = true;
          completion = {
            enable = true;
            settings.autotrigger = true;
          };
          onAttach = ''
            -- Format on save
            vim.api.nvim_create_autocmd('BufWritePre', {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
                end,
            })
          '';
          keymaps = [
            {
              mode = "n";
              key = "<leader>gd";
              lspBufAction = "definition";
              options.desc = "Go to definition";
            }
            {
              mode = "n";
              key = "<leader>gD";
              lspBufAction = "declaration";
              options.desc = "Go to declaration";
            }
            {
              mode = "n";
              key = "<leader>gt";
              lspBufAction = "type_definition";
              options.desc = "Go to type definition";
            }
            {
              mode = "n";
              key = "<leader>ga";
              lspBufAction = "code_action";
              options.desc = "Show code action";
            }
            {
              mode = "n";
              key = "<leader>gn";
              lspBufAction = "rename";
              options.desc = "Rename";
            }
            {
              mode = "n";
              key = "<leader>gr";
              lspBufAction = "references";
              options.desc = "Go to references";
            }
            {
              mode = "n";
              key = "<leader>gi";
              lspBufAction = "implementation";
              options.desc = "Go to implementation";
            }
            {
              mode = "n";
              key = "<leader>gs";
              lspBufAction = "document_symbol";
              options.desc = "Open document symbols in loclist";
            }
            {
              mode = [
                "n"
                "i"
              ];
              key = "<C-k>";
              lspBufAction = "signature_help";
              options.desc = "Signature help";
            }
          ];

          servers = {
            nixd = {
              enable = true;
              config = {
                cmd = [ "nixd" ];
                filetypes = [ "nix" ];
                root_markers = [
                  "flake.nix"
                  ".git"
                ];
                settings.nixd = {
                  nixpkgs.expr = "import ${inputs.nixpkgs} { }";
                  formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
                };
              };
            };
          };
        };

        plugins = {
          lualine.enable = true;
          vim-suda.enable = true;
          web-devicons.enable = true;
          indent-blankline.enable = true;
          nix-develop.enable = true;
          origami.enable = true;
          which-key = {
            enable = true;
            settings.delay = 300;
          };

          # mini-s
          mini-extra.enable = true;
          mini-trailspace.enable = true;
          mini-surround.enable = true;
          mini-notify.enable = true;
          mini-pick = {
            enable = true;
            luaConfig.post = ''
              vim.keymap.set("n", "<leader>fc", "<cmd>Pick resume<cr>", { desc = "Continue last search" })
              vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "Find files" })
              vim.keymap.set("n", "<leader>fg", "<cmd>Pick grep_live<cr>", { desc = "Find by grep" })
              vim.keymap.set("n", "<leader>fb", "<cmd>Pick buffers<cr>", { desc = "Find in opened buffers" })
              vim.keymap.set("n", "<leader>fh", "<cmd>Pick help<cr>", { desc = "Find in help tags" })
              vim.keymap.set("n", "<leader>fr", "<cmd>Pick registers<cr>", { desc = "Find in registers" })
              vim.keymap.set("n", "<leader>fm", "<cmd>Pick marks<cr>", { desc = "Find in marks" })
              vim.keymap.set("n", "<leader>fd", "<cmd>Pick diagnostic<cr>", { desc = "Find in diagnostics" })
              vim.keymap.set("n", "<leader>fk", "<cmd>Pick keymaps<cr>", { desc = "Find in keymaps" })
              vim.keymap.set("n", "<leader>fo", "<cmd>Pick options<cr>", { desc = "Find in options" })
            '';
          };

          nvim-bqf = {
            enable = true;
            settings.preview.winblend = 0;
          };
          quicker = {
            enable = true;
            settings = {
              highlight = {
                lsp = false;
                treesitter = true;
                load_buffers = true;
              };
              edit.enabled = false;
              constrain_cursor = true;
              keys = [
                {
                  __unkeyed-1 = ">";
                  __unkeyed-2.__raw = ''
                    function()
                      require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
                    end
                  '';
                  desc = "Expand quickfix context";
                }
                {
                  __unkeyed-1 = "<";
                  __unkeyed-2.__raw = "require('quicker').collapse";
                  desc = "Collapse quickfix context";
                }
              ];
            };
          };

          oil = {
            enable = true;
            settings = {
              delete_to_trash = true;
              default_file_explorer = true;
              win_options.signcolumn = "yes:2";
            };
            luaConfig.post = ''
              vim.keymap.set("n", "<leader>n", require("oil").toggle_float, { desc = "Toggle Oil window" })
            '';
          };
          oil-git-status.enable = true;

          diffview.enable = true;
          neogit = {
            enable = true;
            settings = {
              auto_show_console_on = "error";
              disable_hint = true;
              disable_context_highlighting = true;
              disable_insert_on_commit = true;
              treesitter_diff_highlight = true;

              diff_viewer = "diffview";
              integrations = {
                mini_pick = true;
                diffview = true;
              };
              commit_editor = {
                spell_check = false;
                staged_diff_split_kind = "auto";
              };
            };
            luaConfig.post = ''
              vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Show Neogit UI" })
            '';
          };
          gitsigns = {
            enable = true;
            settings = {
              numhl = true;
              signcolumn = false;
              linehl = false;
              word_diff = false;
              current_line_blame = false;
              attach_to_untracked = true;
              on_attach = ''
                function(bufnr)
                  local gs = require("gitsigns")
                  vim.keymap.set("n", "]h", function()
                    if vim.wo.diff then
                      vim.cmd.normal({ "]c", bang = true })
                    else
                      gs.nav_hunk("next")
                    end
                  end, { buffer = bufnr, desc = "Next hunk" })
                  vim.keymap.set("n", "[h", function()
                    if vim.wo.diff then
                      vim.cmd.normal({ "[c", bang = true })
                    else
                      gs.nav_hunk("prev")
                    end
                  end, { buffer = bufnr, desc = "Previous hunk" })

                  vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
                  vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
                  vim.keymap.set("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                  end, { buffer = bufnr, desc = "Stage hunk (visual)" })
                  vim.keymap.set("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                  end, { buffer = bufnr, desc = "Reset hunk (visual)" })

                  vim.keymap.set("n", "<leader>hS", gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
                  vim.keymap.set("n", "<leader>hR", gs.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
                  vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
                  vim.keymap.set("n", "<leader>hb", function()
                    gs.blame_line({ full = true })
                  end, { buffer = bufnr, desc = "Blame line" })

                  vim.keymap.set("n", "<leader>hd", gs.diffthis, { buffer = bufnr, desc = "Show diff" })
                  vim.keymap.set("n", "<leader>hD", function()
                    gs.diffthis("~")
                  end, { buffer = bufnr, desc = "Show diff" })
                  vim.keymap.set("n", "<leader>hl", gs.setloclist, { buffer = bufnr, desc = "Open loclist (hunks for file)" })
                  vim.keymap.set({ "o", "x" }, "ih", gs.select_hunk, { buffer = bufnr, desc = "Select hunk (text object)" })
                end
              '';
            };
            luaConfig.post = ''
              vim.keymap.set("n", "<leader>hq", function()
                require("gitsigns").setqflist("all")
              end, { desc = "Open qfix (hunks for git directory)" })
            '';
          };

          treesitter = {
            enable = true;
            indent.enable = true;
            highlight = {
              enable = true;
              disable = [ "rust" ];
            };
          };
          treesitter-context = {
            enable = true;
            settings.max_lines = 3;
            luaConfig.post = ''
              vim.keymap.set("n", "[c", function()
                require("treesitter-context").go_to_context(vim.v.count1)
              end, { desc = "Jump back to treesitter context header" })
            '';
          };
          rustaceanvim = {
            enable = true;
            settings = {
              server.default_settings.rust-analyzer = {
                lens = {
                  enable = true;
                  implementations.enable = true;
                  references = {
                    adt.enable = true;
                    enumVariant.enable = true;
                    method.enable = true;
                    trait.enable = true;
                  };
                  run.enable = false;
                  debug.enable = false;
                  updateTest.enable = false;
                };
                hover.memoryLayout.niches = true;

                procMacro.enable = true;
                cargo.allFeatures = true;
                completion.autoimport.enable = true;

                files.excludeDirs = [
                  ".direnv"
                  ".git"
                  ".gitlab"
                ];

                inlayHints = {
                  bindingModeHints.enable = true;
                  closureReturnTypeHints.enable = "always";
                  discriminantHints.enable = "always";
                  rangeExclusiveHints.enable = true;
                  lifetimeElisionHints = {
                    enable = "skip_trivial";
                    useParameterNames = true;
                  };
                  expressionAdjustmentHints = {
                    enable = "reborrow";
                    mode = "postfix";
                  };
                };
              };
            };
          };
        };

        extraConfigLua = ''
          -- Remove default bindings
          vim.keymap.del('n', 'grn')
          vim.keymap.del('n', 'gra')
          vim.keymap.del('n', 'grr')
          vim.keymap.del('n', 'gri')
          vim.keymap.del('n', 'gO')
          vim.keymap.del('i', '<C-s>')

          -- Diagnostics, inlay hints and CodeLens
          VERBOSE_MODE = false
          DIAGNOSTICS_VIRTUAL_TEXT = true

          vim.lsp.inlay_hint.enable(VERBOSE_MODE)
          vim.lsp.codelens.enable(VERBOSE_MODE)
          vim.diagnostic.config {
              underline = true,
              signs = true,
              severity_sort = true,
              update_in_insert = true,
              virtual_text = DIAGNOSTICS_VIRTUAL_TEXT and VERBOSE_MODE,
              virtual_lines = not DIAGNOSTICS_VIRTUAL_TEXT and VERBOSE_MODE,
          }

          -- Show/hide diagnostics, inlay hints and CodeLens
          vim.keymap.set('n', '<leader>t', function()
              VERBOSE_MODE = not VERBOSE_MODE
              vim.lsp.inlay_hint.enable(VERBOSE_MODE)
              vim.lsp.codelens.enable(VERBOSE_MODE)
              vim.diagnostic.config {
                  virtual_text = DIAGNOSTICS_VIRTUAL_TEXT and VERBOSE_MODE,
                  virtual_lines = not DIAGNOSTICS_VIRTUAL_TEXT and VERBOSE_MODE,
              }
              vim.cmd [[ normal "hl" ]]
          end, { desc = "Toggle verbose mode (diagnostics, inlay hints, CodeLens)" })

          -- Change type of diagnostics (virtual lines or virtual text)
          vim.keymap.set('n', '<leader>l', function()
              DIAGNOSTICS_VIRTUAL_TEXT = not DIAGNOSTICS_VIRTUAL_TEXT
              vim.diagnostic.config {
                  virtual_text = DIAGNOSTICS_VIRTUAL_TEXT and VERBOSE_MODE,
                  virtual_lines = not DIAGNOSTICS_VIRTUAL_TEXT and VERBOSE_MODE,
              }
              vim.cmd [[ normal "hl" ]]
          end, { desc = "Toggle virtual text/lines for diagnostics" })
        '';
      };
    };
}
