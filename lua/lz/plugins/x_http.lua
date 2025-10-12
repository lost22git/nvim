-- [nfnl] fnl/lz/plugins/x_http.fnl
local function _1_()
  local function create_keymaps(bufid)
    vim.keymap.set("n", "<Leader>ee", "<Cmd>HurlRunnerAt<CR>", {buffer = bufid, silent = true, desc = "[hurl] HurlRunnerAt"})
    return vim.keymap.set("n", "<Leader>eb", "<Cmd>HurlRunner<CR>", {buffer = bufid, silent = true, desc = "[hurl] HurlRunner"})
  end
  local function _2_(_241)
    return create_keymaps(_241.buf)
  end
  return vim.api.nvim_create_autocmd("FileType", {pattern = "hurl", callback = _2_})
end
local function _3_()
  local function create_usercmds(bufid)
    local data = {{"Run", "run"}, {"RunAll", "run_all"}, {"ToggleView", "toggle_view"}, {"Relay", "relay"}, {"Open", "open"}, {"Inspect", "inspect"}, {"ShowStats", "show_stats"}, {"Copy", "copy"}, {"FromCurl", "from_curl"}, {"Search", "search"}, {"JumpPrev", "jump_prev"}, {"JumpNext", "jump_next"}, {"ClearCachedFiles", "clear_cached_files"}, {"Scratchpad", "scratchpad"}, {"DownloadGraphqlSchema", "download_graphql_schema"}}
    for _, _4_ in pairs(data) do
      local k = _4_[1]
      local v = _4_[2]
      local function _5_()
        return require("kulala")[v]()
      end
      vim.api.nvim_buf_create_user_command(bufid, ("Kulala" .. k), _5_, {nargs = 0})
    end
    local function _6_(_241)
      return require("kulala").scripts_clear_global(unpack(_241.fargs))
    end
    return vim.api.nvim_buf_create_user_command(bufid, "KulalaScriptsClearGlobal", _6_, {nargs = "*"})
  end
  local function create_keymaps(bufid)
    local data = {{"<Leader>ee", "<Cmd>KulalaRun<CR>"}, {"<Leader>E", "<Cmd>KulalaSearch<CR>"}, {"<Leader>eb", "<Cmd>KulalaRunAll<CR>"}, {"<Leader>el", "<Cmd>KulalaOpen<CR>"}}
    for _, _7_ in pairs(data) do
      local k = _7_[1]
      local v = _7_[2]
      vim.keymap.set("n", k, v, {buffer = bufid, silent = true})
    end
    return nil
  end
  local function _9_(_8_)
    local bufid = _8_.buf
    create_usercmds(bufid)
    return create_keymaps(bufid)
  end
  return vim.api.nvim_create_autocmd("FileType", {pattern = {"http", "rest"}, callback = _9_})
end
return {{"jellydn/hurl.nvim", ft = "hurl", opts = {mode = "split", formatters = {json = {"jq"}, html = {"prettier", "--parser", "html"}}, debug = false, show_notification = false}, init = _1_}, {"mistweaverco/kulala.nvim", ft = {"http", "rest"}, opts = {winbar = true, show_variable_info_text = "float"}, init = _3_}}
