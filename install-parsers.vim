" Script temporal para instalar parsers de Treesitter
" Ejecuta esto con: nvim -u NONE -c 'source install-parsers.vim'
" O desde dentro de Neovim: :source install-parsers.vim

echom "Instalando parsers de Treesitter..."

" Instalar parsers de Elixir primero (los más importantes)
TSInstall elixir
TSInstall heex
TSInstall eex

" Instalar parsers básicos
TSInstall lua
TSInstall vim
TSInstall vimdoc
TSInstall markdown
TSInstall markdown_inline

" Instalar parsers de lenguajes adicionales
TSInstall bash
TSInstall c
TSInstall diff
TSInstall html
TSInstall javascript
TSInstall typescript
TSInstall tsx
TSInstall css
TSInstall json
TSInstall yaml
TSInstall toml
TSInstall python
TSInstall go
TSInstall rust

echom "¡Parsers instalados! Reinicia Neovim para ver los cambios."
