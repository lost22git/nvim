(import-macros {: call! : nmap!} :config.macros)

{1 "MeanderingProgrammer/render-markdown.nvim"
 :ft :markdown
 :config (fn []
           (call! :render-markdown :setup {})
           (nmap! "<Tab>p" "<CMD>RenderMarkdown toggle<CR>"))}
