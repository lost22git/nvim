-- [nfnl] fnl/lz/plugins/x_java.fnl
local function _1_()
  local _local_2_ = require("core.utils")
  local lsp_capabilities = _local_2_["lsp_capabilities"]
  local lsp_on_attach = _local_2_["lsp_on_attach"]
  local lsp_server_package_path = _local_2_["lsp_server_package_path"]
  local jdtls_root = lsp_server_package_path("jdtls")
  local jdtls_jar = assert(vim.fn.globpath((jdtls_root .. "/plugins"), "org.eclipse.equinox.launcher_*.jar"), "[nvim-jdtls] jdtls jar not found")
  local lombok_jar = (jdtls_root .. "/lombok.jar")
  local jdtls_config_dir
  local _3_
  if (vim.fn.has("win32") == 1) then
    _3_ = "/config_win"
  else
    if (vim.fn.has("mac") == 1) then
      _3_ = "/config_mac"
    else
      _3_ = "/config_linux"
    end
  end
  jdtls_config_dir = (jdtls_root .. _3_)
  local workspace_root = vim.fs.normalize("~/.cache/jdtls/workspace")
  local function start_or_attach()
    local project_root = assert(vim.fs.root(0, {"mvnw", "gradlew", ".git"}), "[nvim-jdtls] project root not found")
    local project_name = vim.fn.fnamemodify(project_root, ":p:h:t")
    local workspace_dir = (workspace_root .. "/" .. project_name)
    local opts = {capabilities = lsp_capabilities(), on_attach = lsp_on_attach, cmd = {"java", "-Declipse.application=org.eclipse.jdt.ls.core.id1", "-Dosgi.bundles.defaultStartLevel=4", "-Declipse.product=org.eclipse.jdt.ls.core.product", "-Dlog.protocol=true", "-Dlog.level=ALL", "-Xmx1g", "--add-modules=ALL-SYSTEM", "--add-opens", "java.base/java.util=ALL-UNNAMED", "--add-opens", "java.base/java.lang=ALL-UNNAMED", ("-javaagent:" .. lombok_jar), "-jar", jdtls_jar, "-configuration", jdtls_config_dir, "-data", workspace_dir}, root_dir = project_root, settings = {java = {codeGeneration = {hashCodeEquals = {useJava7Objects = true}, toString = {template = "${object.className}{${member.name()}=${member.value} ${otherMembers}}"}, useBlocks = true}, contentProvider = {preferred = "fernflower"}, format = {enabled = true}, implementationsCodeLens = {enabled = true}, inlayHints = {enabled = true}, referencesCodeLens = {enabled = true}, saveActions = {organizeImports = true}, signatureHelp = {enabled = true}}}, init_options = {bundles = {}}, flags = {allow_incremental_sync = true}}
    return require("jdtls").start_or_attach(opts)
  end
  if ("java" == vim.bo.filetype) then
    start_or_attach()
  else
  end
  return vim.api.nvim_create_autocmd("FileType", {group = vim.api.nvim_create_augroup("JdtStartOrAttach", {}), pattern = "java", callback = start_or_attach})
end
return {"mfussenegger/nvim-jdtls", dependencies = {"neovim/nvim-lspconfig"}, cmd = "JdtStart", config = _1_}
