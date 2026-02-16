-- AstroLSP configuration enabled

-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

local util = require "lspconfig.util"
local deno_config_root = util.root_pattern(
  "deno.json",
  "deno.jsonc",
  "tsconfig.deno.json",
  "deno.lock",
  "import_map.json",
  "deps.ts"
)
local function supabase_function_root(fname)
  local dir = fname and util.path.dirname(fname) or nil
  while dir and dir ~= "" do
    local normalized = dir:gsub("\\", "/")
    if normalized:match("/supabase/functions/[^/]+$") then return dir end
    local parent = util.path.dirname(dir)
    if parent == dir then break end
    dir = parent
  end
end
local function get_deno_root(fname)
  return deno_config_root(fname) or supabase_function_root(fname)
end
local deno_root = function(fname) return get_deno_root(fname) end
local node_root = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          "elixir",
          "heex",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "tsx",
          "jsx",
          "json",
          "jsonc",
          "css",
          "scss",
          "less",
          "html",
          "markdown",
          "cs",
          -- "java", -- disabled: jdtls formatter corrupts incomplete files
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
      "ts_ls",
      "denols",
      "tailwindcss",
      "elixirls",
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      -- clangd = { capabilities = { offsetEncoding = "utf-8" } },
      ts_ls = {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "tsx", "jsx" },
        single_file_support = false,
        root_dir = function(fname)
          if deno_root(fname) then return nil end
          return node_root(fname)
        end,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      },
      denols = {
        root_dir = deno_root,
        single_file_support = false,
        settings = {
          deno = {
            enable = true,
            lint = true,
            suggest = {
              imports = {
                hosts = {
                  ["https://deno.land"] = true,
                  ["https://cdn.nest.land"] = true,
                  ["https://crux.land"] = true,
                  ["npm:"] = true,
                },
              },
            },
          },
        },
      },
      tailwindcss = {
        filetypes = {
          "astro",
          "astro-markdown",
          "blade",
          "clojure",
          "django-html",
          "htmldjango",
          "edge",
          "eelixir",
          "elixir",
          "ejs",
          "erb",
          "eruby",
          "gohtml",
          "gohtmltmpl",
          "haml",
          "handlebars",
          "hbs",
          "html",
          "html-eex",
          "heex",
          "jade",
          "leaf",
          "liquid",
          "markdown",
          "mdx",
          "mustache",
          "njk",
          "nunjucks",
          "php",
          "razor",
          "slim",
          "twig",
          "css",
          "less",
          "postcss",
          "sass",
          "scss",
          "stylus",
          "sugarss",
          "javascript",
          "javascriptreact",
          "reason",
          "rescript",
          "typescript",
          "typescriptreact",
          "tsx",
          "jsx",
          "vue",
          "svelte",
          "templ",
        },
        settings = {
          tailwindCSS = {
            classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
            lint = {
              cssConflict = "warning",
              invalidApply = "error",
              invalidConfigPath = "error",
              invalidScreen = "error",
              invalidTailwindDirective = "error",
              invalidVariant = "error",
              recommendedVariantOrder = "warning",
            },
            validate = true,
            experimental = {
              classRegex = {
                "class(?:Name)?=\"([^\"]*)\"",
                "classList=\"([^\"]*)\"",
                "class:list=\"([^\"]*)\"",
              },
            },
          },
        },
      },
      elixirls = {
        cmd = { "elixir-ls" },
        settings = {
          elixirLS = {
            -- Dialyzer configuration
            dialyzerEnabled = true,
            dialyzerWarnOpts = {
              "error_handling",
              "no_behaviours",
              "no_contracts",
              "no_fail_call",
              "no_fun_app",
              "no_improper_lists",
              "no_match",
              "no_missing_calls",
              "no_opaque",
              "no_return",
              "no_undefined_callbacks",
              "no_unused",
              "underspecs",
            },
            dialyzerFormat = "dialyzer",
            
            -- Fetch dependencies automatically
            fetchDeps = true,
            
            -- Auto import completion
            autoImport = true,
            
            -- Suggest specs for functions
            suggestSpecs = true,
            
            -- Enable completions
            enableTestLenses = true,
            
            -- Mix configuration
            mixEnv = "dev",
            mixTarget = "host",
            
            -- Sign column settings
            signatureAfterComplete = false,
            
            -- Additional settings
            trace = {
              server = "off",
            },
          },
        },
        on_attach = function(client, bufnr)
          -- Enable inlay hints for Elixir if supported
          if client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(bufnr, true)
          end
        end,
      },
    },
    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
      
      -- Ensure tailwindcss server is properly configured
      tailwindcss = function(_, opts) 
        require("lspconfig").tailwindcss.setup(opts) 
      end,
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_codelens_refresh = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/codeLens",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "InsertLeave", "BufEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        gd = {
          function()
            -- Jump directly to the first definition without showing a picker
            vim.lsp.buf.definition {
              on_list = function(options)
                if options.items and #options.items > 0 then
                  local item = options.items[1]
                  vim.cmd.edit(item.filename)
                  vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
                end
              end,
            }
          end,
          desc = "Go to definition",
          cond = "textDocument/definition",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}
