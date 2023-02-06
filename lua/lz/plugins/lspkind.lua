local M = {
  'onsails/lspkind-nvim'
}

function M.config()
  local lspkind = require("lspkind")
  lspkind.init({
    -- enables text annotations
    --
    -- default: true
    mode = 'symbol',

    -- default symbol map
    -- can be either 'default' (requires nerd-fonts font) or
    -- 'codicons' for codicon preset (requires vscode-codicons font)
    --
    -- default: 'default'
    preset = 'codicons',

    -- override preset symbols
    --
    -- default: {}
    -- symbol_map = {
    --   Text = "",
    --   Method = "",
    --   Function = "",
    --   Constructor = "",
    --   Field = "ﰠ",
    --   Variable = "",
    --   Class = "ﴯ",
    --   Interface = "",
    --   Module = "",
    --   Property = "ﰠ",
    --   Unit = "塞",
    --   Value = "",
    --   Enum = "",
    --   Keyword = "",
    --   Snippet = "",
    --   Color = "",
    --   File = "",
    --   Reference = "",
    --   Folder = "",
    --   EnumMember = "",
    --   Constant = "",
    --   Struct = "פּ",
    --   Event = "",
    --   Operator = "",
    --   TypeParameter = ""
    -- },
    symbol_map = {
      Text = "文本",
      Method = "方法",
      Function = "函数",
      Constructor = "构造",
      Field = "字段",
      Variable = "变量",
      Class = "类",
      Interface = "接口",
      Module = "模块",
      Property = "属性",
      Unit = "单元",
      Value = "值",
      Enum = "枚举",
      Keyword = "关键字",
      Snippet = "片段",
      Color = "颜色",
      File = "文件",
      Reference = "引用",
      Folder = "目录",
      EnumMember = "枚举值",
      Constant = "常量",
      Struct = "结构体",
      Event = "事件",
      Operator = "运算",
      TypeParameter = "类型参数"
    },

  })
end

function M.cmp_format()
  local lspkind = require('lspkind')
  return lspkind.cmp_format {
    with_text = false,
    maxwidth = 100,
    menu = {
      nvim_lsp = "[LS]",
      nvim_lsp_signature_help = "[Sig]",
      buffer = "[Buf]",
      luasnip = "[Snip]",
      treesitter = "[TS]",
      path = "[Path]",
      cmdline = "[Cmd]",
      neorg = "[Norg]",
      crates = "[Crates]"
    },
  }
end

return M
