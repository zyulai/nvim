-- lua/plugins/none-ls.lua
---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require "null-ls"
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- C++: clang-format，如果项目下存在 .clang-format 文件则使用该文件，否则使用 google 风格
      null_ls.builtins.formatting.clang_format.with {
        extra_args = function(params)
          if vim.fn.filereadable(params.root .. "/.clang-format") == 1 then
            return { "-style=file" }
          else
            return { "-style=google" }
          end
        end,
      },
      -- Python: autopep8 遵循 pep8 风格
      null_ls.builtins.formatting.black.with {
        extra_args = function(params)
          -- 如果项目存在 pyproject.toml 则自动遵循
          if vim.fn.filereadable(params.root .. "/pyproject.toml") == 1 then
            return { "--config", params.root .. "/pyproject.toml" }
          end
          -- 没有配置文件时默认启用~/.config/nvim/.clang-format
          local user_clang_format = vim.fn.expand "$HOME/.config/nvim/.clang-format"
          -- vim.notify("Using " .. user_clang_format, vim.log.levels.INFO)
          return { "--style=file:" .. user_clang_format }
        end,
      },
      -- Shell: shfmt 使用 2 个空格缩进（模拟 google 风格）
      null_ls.builtins.formatting.shfmt.with {
        extra_args = { "-i", "2" },
      },
    })
  end,
}
