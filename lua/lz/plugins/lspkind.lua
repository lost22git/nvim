local M = {
  'onsails/lspkind-nvim'
}

function M.config()
  local lspkind = require("lspkind")
  lspkind.init {
    mode = 'symbol',
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
      Keyword = "关键",
      Snippet = "片段",
      Color = "颜色",
      File = "文件",
      Reference = "引用",
      Folder = "目录",
      EnumMember = "枚举值",
      Constant = "常量",
      Struct = "结构",
      Event = "事件",
      Operator = "运算",
      TypeParameter = "类参"
    },
  }
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
      crates = "[Crate]"
    },
  }
end

return M
