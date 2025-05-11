local M = {}

function M.on_gui() return vim.g.neovide or vim.g.fvim_loaded or vim.g.vscode end

function M.on_v_modes()
  local v_block_mode = vim.api.nvim_replace_termcodes('<C-V>', true, true, true)
  local v_mode, v_line_mode = 'v', 'V'
  local v_modes = { v_mode, v_line_mode, v_block_mode }
  return vim.tbl_contains(v_modes, vim.fn.mode())
end

function M.get_flutter_path()
  local path = vim.fn.exepath('flutter')
  return vim.fn.has('win32') == 1 and path .. '.bat' or path
end

function M.disable_diagnostic(buf)
  if vim.diagnostic.is_enabled({ bufnr = buf }) then pcall(vim.diagnostic.enable, false, { bufnr = buf }) end
end

function M.get_mason_path() return vim.fn.stdpath('data') .. '/mason' end

function M.lsp_with_server(name, fn)
  local path = M.lsp_server_path(name)
  if path then fn(path) end
end

function M.lsp_server_path(name)
  local on_windows = vim.fn.has('win32') == 1

  -- 查找顺序：
  -- 1. mason 目录
  local path = M.get_mason_path() .. '/bin/' .. name
  if on_windows then path = path .. '.cmd' end
  if vim.fn.executable(path) == 1 then return path end

  -- 2. 环境变量 PATH
  path = vim.fn.exepath(name)
  if path == '' then path = nil end
  -- windows: 如果 path 没有扩展名，添加 .cmd
  if path and on_windows then
    local path_ext = vim.fn.split(vim.fs.basename(path), '\\.')[2]
    if not path_ext then path = path .. '.cmd' end
  end

  return path
end

function M.lsp_server_package_path(name) return M.get_mason_path() .. '/packages/' .. name end

function M.lsp_capabilities()
  return vim.tbl_deep_extend('force', require('blink.cmp').get_lsp_capabilities(), {
    textDocument = { semanticTokens = { multilineTokenSupport = true } },
    workspace = { fileOperations = { didRename = true, willRename = true } },
  })
end

function M.lsp_on_attach(client, buf)
  vim.bo[buf].omnifunc = nil -- Unset 'omnifunc'
  require('core.maps').lsp(buf)
  lsp_format_on_save(client, buf)
  lsp_codelens_refresh(client, buf)
end

function lsp_format_on_save(client, buf)
  -- Use conform format
  local has_conform, _ = pcall(require, 'conform')
  if has_conform then return end
  -- Else use lsp format
  if client:supports_method('textDocument/formatting') then
    local grp = vim.api.nvim_create_augroup('lsp_format_on_save', {})
    vim.api.nvim_clear_autocmds({ group = grp, buffer = buf })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = grp,
      buffer = buf,
      callback = function() vim.lsp.buf.format({ bufnr = buf, timeout_ms = 1000 }) end,
    })
  end
end

function lsp_codelens_refresh(client, buf)
  if client:supports_method('textDocument/codeLens') then
    local grp = vim.api.nvim_create_augroup('lsp_codelens_refresh', {})
    vim.api.nvim_clear_autocmds({ group = grp, buffer = buf })
    vim.lsp.codelens.refresh()
    vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
      group = grp,
      buffer = buf,
      callback = vim.lsp.codelens.refresh,
    })
  end
end

function M.system_open(path)
  if vim.fn.has('win32') == 1 then
    vim.notify('system_open path=' .. path, vim.log.levels.INFO)
    vim.fn.jobstart("explorer.exe '" .. path .. "'")
  elseif vim.fn.has('macunix') == 1 then
    vim.notify('system_open path=' .. path, vim.log.levels.INFO)
    vim.fn.jobstart("open -g '" .. path .. "' &", { detach = true })
  else
    vim.notify('system_open path=' .. path, vim.log.levels.INFO)
    vim.fn.jobstart("xdg-open '" .. path .. "' &", { detach = true })
  end
end

function M.tbl_includes(a, b)
  vim.validate('a', a, 'table')
  vim.validate('b', b, 'table')

  if #a < #b then return false end

  for _, bv in pairs(b) do
    local found = false
    for _, av in pairs(a) do
      if av == bv then
        found = true
        break
      end
    end
    if not found then return false end
  end
  return true
end

function M.get_buffer_count()
  local result = 0
  local b = vim.api.nvim_list_bufs()
  for i = 1, #b do
    if vim.bo[b[i]].buflisted then result = result + 1 end
  end
  return result
end

function M.get_selection_line_range()
  local a, b = vim.fn.line('v'), vim.fn.line('.')
  return a <= b and a, b or b, a
end

function M.get_last_selection_text()
  vim.cmd('normal! gv"xy')
  return vim.fn.trim(vim.fn.getreg('x'))
end

function M.get_current_selection_text()
  vim.cmd('exe  "normal \\<Esc>"')
  vim.cmd('normal! gv"xy')
  return vim.fn.trim(vim.fn.getreg('x'))
end

function M.open_hover_window(text_or_lines, title, cb)
  local lines = type(text_or_lines) == 'string' and vim.fn.split(text_or_lines, '\n', true) or text_or_lines
  local max_cols = 0
  for _, l in ipairs(lines) do
    max_cols = math.max(max_cols, vim.api.nvim_strwidth(l))
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, #lines, false, lines)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'cursor',
    row = 1,
    col = 0,
    width = max_cols,
    height = math.min(16, #lines),
    style = 'minimal',
    title = title,
  })

  M.disable_diagnostic(buf)

  vim.bo[buf].readonly = true
  vim.bo[buf].modifiable = false
  vim.wo[win].wrap = false

  if cb then cb(buf, win) end
end

function M.get_justfile_tasks(justfile)
  local tasks = {}
  local cmd = { 'just', '-f', justfile, '--list' }
  local cmd_result = vim.system(cmd, { text = true }):wait()
  for _, line in pairs(vim.fn.split(cmd_result.stdout, '\n', false)) do
    if vim.startswith(line, '   ') then
      local name, desc = unpack(vim.fn.split(line, '#', false))
      local item = { name = vim.trim(name), desc = desc and vim.trim(desc), justfile = justfile }
      table.insert(tasks, item)
    end
  end
  return tasks
end

function M.run_justfile_task(task)
  local task_name, task_args = unpack(vim.fn.split(task.name, ' ', false))
  local cmd = 'just -f ' .. task.justfile .. ' ' .. task_name
  if task_args then
    local on_confirm = function(input)
      if input then vim.cmd('AsyncRun ' .. cmd .. ' ' .. input) end
    end
    vim.ui.input({ prompt = 'just ' .. task.name .. ': ' }, on_confirm)
  else
    vim.cmd('AsyncRun ' .. cmd)
  end
end

return M
