return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = function()
      local ret = {
        -- Options for vim.diagnostic.config()
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
          },
          severity_sort = true,
          -- Replaced global LazyVim icons with universal text indicators
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = "✘",
              [vim.diagnostic.severity.WARN]  = "⚠",
              [vim.diagnostic.severity.HINT]  = "⚑",
              [vim.diagnostic.severity.INFO]  = "ℹ",
            },
          },
        },
        -- Builtin LSP inlay hints
        inlay_hints = {
          enabled = true,
          exclude = { "vue" }, 
        },
        -- Target server configurations
        servers = {
          lua_ls = {
            settings = {
              Lua = {
                workspace = { checkThirdParty = false },
                codeLens = { enable = true },
                completion = { callSnippet = "Replace" },
                doc = { privateName = { "^_" } },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
        },
      }
      return ret
    end,
    config = function(_, opts)
      -- 1. Apply diagnostics configurations
      vim.diagnostic.config(opts.diagnostics)

      -- 2. Define standard keymaps via an Autocommand when an LSP attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
          end

          -- Traditional Neovim LSP definitions (Removed Snacks/LazyVim wrappers)
          map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
          map("n", "gr", vim.lsp.buf.references, "References")
          map("n", "gI", vim.lsp.buf.implementation, "Goto Implementation")
          map("n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition")
          map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
          map("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Help")
          map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")

          -- Toggle inlay hints dynamically if supported
          if opts.inlay_hints.enabled and vim.lsp.inlay_hint then
            local ft = vim.bo[ev.buf].filetype
            if not vim.tbl_contains(opts.inlay_hints.exclude or {}, ft) then
              vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
            end
          end
        end,
      })

      -- 3. Orchestrate Mason and Lspconfig together
      require("mason").setup()
      
      -- Setup capabilities for auto-completion (standard nvim-cmp framework structure)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if has_cmp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- Loop through servers defined in `opts.servers` and hook them up
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(opts.servers),
        handlers = {
          function(server_name)
            local server_opts = opts.servers[server_name] or {}
            server_opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})
            require("lspconfig")[server_name].setup(server_opts)
          end,
        },
      })
    end,
  },
}

