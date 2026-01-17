---@type LazySpec
return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  dependencies = {
    "mfussenegger/nvim-dap",
    "williamboman/mason.nvim",
  },
  opts = function()
    -- Use mason's data directory directly
    local mason_path = vim.fn.stdpath("data") .. "/mason/packages"

    -- Paths
    local jdtls_path = mason_path .. "/jdtls"
    local java_debug_path = mason_path .. "/java-debug-adapter"
    local java_test_path = mason_path .. "/java-test"

    -- Build bundles for debugging
    local bundles = {}
    vim.list_extend(
      bundles,
      vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")
    )
    vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n"))

    -- Determine OS-specific config folder
    local os_config = "config_linux"
    if vim.fn.has "mac" == 1 then
      os_config = "config_mac"
    elseif vim.fn.has "win32" == 1 then
      os_config = "config_win"
    end

    return {
      cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration",
        jdtls_path .. "/" .. os_config,
        "-data",
        vim.fn.stdpath "cache" .. "/jdtls/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
      },
      root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
      settings = {
        java = {
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*",
            },
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*",
              "sun.*",
            },
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            hashCodeEquals = {
              useJava7Objects = true,
            },
            useBlocks = true,
          },
          configuration = {
            -- Add runtimes here if you have multiple Java versions
            -- runtimes = {
            --   { name = "JavaSE-17", path = "/path/to/java-17" },
            --   { name = "JavaSE-21", path = "/path/to/java-21" },
            -- },
          },
          eclipse = {
            downloadSources = true,
          },
          maven = {
            downloadSources = true,
          },
          references = {
            includeDecompiledSources = true,
          },
          inlayHints = {
            parameterNames = {
              enabled = "all",
            },
          },
        },
      },
      init_options = {
        bundles = bundles,
        extendedClientCapabilities = require("jdtls").extendedClientCapabilities,
      },
    }
  end,
  config = function(_, opts)
    -- Setup autocmd to start jdtls when opening java files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        require("jdtls").start_or_attach(opts)

        -- Setup keymaps for Java-specific actions
        local bufnr = vim.api.nvim_get_current_buf()
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Java-specific keymaps
        map("n", "<leader>jo", require("jdtls").organize_imports, "Organize imports")
        map("n", "<leader>jv", require("jdtls").extract_variable, "Extract variable")
        map("v", "<leader>jv", function() require("jdtls").extract_variable { visual = true } end, "Extract variable")
        map("n", "<leader>jc", require("jdtls").extract_constant, "Extract constant")
        map("v", "<leader>jc", function() require("jdtls").extract_constant { visual = true } end, "Extract constant")
        map("v", "<leader>jm", function() require("jdtls").extract_method { visual = true } end, "Extract method")

        -- Test keymaps
        map("n", "<leader>jt", require("jdtls").test_nearest_method, "Test nearest method")
        map("n", "<leader>jT", require("jdtls").test_class, "Test class")

        -- Debug keymaps
        map("n", "<leader>jd", function()
          require("jdtls").test_nearest_method { config_overrides = { noDebug = false } }
        end, "Debug nearest method")
        map("n", "<leader>jD", function()
          require("jdtls").test_class { config_overrides = { noDebug = false } }
        end, "Debug class")
      end,
    })
  end,
}
