-- [nfnl] fnl/lz/plugins/http.fnl
local function _1_()
  local function create_keymaps(bufid)
    local _local_2_ = require("core.utils")
    local create_keymaps_for_goto_entries = _local_2_["create_keymaps_for_goto_entries"]
    create_keymaps_for_goto_entries("\\v^<(HEAD|GET|POST|PUT|PATCH|DELETE|OPTION)>", "[e", "]e", "hurl_request", bufid)
    vim.keymap.set("n", "<Leader>ee", "<Cmd>HurlRunnerAt<CR>", {buffer = bufid, silent = true, desc = "[hurl] HurlRunnerAt"})
    return vim.keymap.set("n", "<Leader>eb", "<Cmd>HurlRunner<CR>", {buffer = bufid, silent = true, desc = "[hurl] HurlRunner"})
  end
  local function _3_(_241)
    return create_keymaps(_241.buf)
  end
  return vim.api.nvim_create_autocmd("FileType", {pattern = "hurl", callback = _3_})
end
local function _4_()
  local function create_usercmds(bufid)
    local data = {{"Run", "run"}, {"RunAll", "run_all"}, {"ToggleView", "toggle_view"}, {"Relay", "relay"}, {"Open", "open"}, {"Inspect", "inspect"}, {"ShowStats", "show_stats"}, {"Copy", "copy"}, {"FromCurl", "from_curl"}, {"Search", "search"}, {"JumpPrev", "jump_prev"}, {"JumpNext", "jump_next"}, {"ClearCachedFiles", "clear_cached_files"}, {"Scratchpad", "scratchpad"}, {"DownloadGraphqlSchema", "download_graphql_schema"}}
    for _, _5_ in pairs(data) do
      local k = _5_[1]
      local v = _5_[2]
      local function _6_()
        return require("kulala")[v]()
      end
      vim.api.nvim_buf_create_user_command(bufid, ("Kulala" .. k), _6_, {nargs = 0})
    end
    local function _7_(o)
      return require("kulala").scripts_clear_global(unpack(o.fargs))
    end
    return vim.api.nvim_buf_create_user_command(bufid, "KulalaScriptsClearGlobal", _7_, {nargs = "*"})
  end
  local function create_keymaps(bufid)
    local data = {{"<Leader>ee", "<Cmd>KulalaRun<CR>"}, {"<Leader>E", "<Cmd>KulalaSearch<CR>"}, {"<Leader>eb", "<Cmd>KulalaRunAll<CR>"}, {"[e", "<Cmd>KulalaJumpPrev<CR>"}, {"]e", "<Cmd>KulalaJumpNext<CR>"}, {"<Leader>ls", "<Cmd>KulalaOpen<CR>"}}
    for _, _8_ in pairs(data) do
      local k = _8_[1]
      local v = _8_[2]
      vim.keymap.set("n", k, v, {buffer = bufid, silent = true})
    end
    return nil
  end
  local function _10_(_9_)
    local bufid = _9_["buf"]
    create_usercmds(bufid)
    return create_keymaps(bufid)
  end
  return vim.api.nvim_create_autocmd("FileType", {pattern = {"http", "rest"}, callback = _10_})
end
return {{"jellydn/hurl.nvim", ft = "hurl", opts = {mode = "split", formatters = {json = {"jq"}, html = {"prettier", "--parser", "html"}}, debug = false, show_notification = false}, init = _1_}, {"mistweaverco/kulala.nvim", ft = {"http", "rest"}, opts = {winbar = true, show_variable_info_text = "float"}, init = _4_}}
