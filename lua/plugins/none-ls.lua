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
      null_ls.builtins.formatting.autopep8,
      -- Shell: shfmt 使用 2 个空格缩进（模拟 google 风格）
      null_ls.builtins.formatting.shfmt.with {
        extra_args = { "-i", "2" },
      },
    })
  end,
}
