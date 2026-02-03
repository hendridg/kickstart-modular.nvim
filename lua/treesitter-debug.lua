-- Diagnóstico de Treesitter para Ghostty terminal
-- Ejecuta con: :luafile ~/.config/nvim-module/lua/treesitter-debug.lua

print("=== Diagnóstico de Treesitter ===\n")

-- 1. Información del buffer
local bufnr = vim.api.nvim_get_current_buf()
print("📄 Filetype: " .. vim.bo.filetype)
print("📋 Buffer: " .. bufnr)

-- 2. Parser disponible
local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
print("\n🌳 Parser language: " .. (lang or "ninguno"))

if lang then
  local has_parser = pcall(vim.treesitter.language.add, lang)
  print("✅ Parser disponible: " .. tostring(has_parser))
end

-- 3. Estado del highlighter
local highlighter = vim.treesitter.highlighter.active[bufnr]
print("\n🎨 Highlighter activo: " .. tostring(highlighter ~= nil))

if highlighter then
  -- Verificar si está habilitado
  local ts_utils = require('nvim-treesitter.ts_utils')
  local enabled = vim.b[bufnr].ts_highlight
  print("🟢 Highlighting habilitado en buffer: " .. tostring(enabled))
end

-- 4. Configuración de terminal
print("\n💻 Terminal Info:")
print("TERM: " .. vim.env.TERM)
print("COLORTERM: " .. (vim.env.COLORTERM or "no set"))
print("termguicolors: " .. tostring(vim.o.termguicolors))

-- 5. Parsers instalados
print("\n📦 Parsers instalados:")
local parser_dir = vim.fn.stdpath('data') .. '/site/parser'
local handle = vim.loop.fs_scandir(parser_dir)
if handle then
  local count = 0
  while true do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then break end
    if name:match('%.so$') or name:match('%.dll$') or name:match('%.dylib$') then
      local lang_name = name:match('^(.+)%.so$') or name:match('^(.+)%.dll$') or name:match('^(.+)%.dylib$')
      if lang_name then
        print("  ✓ " .. lang_name)
        count = count + 1
      end
    end
  end
  print("\nTotal: " .. count .. " parsers")
else
  print("⚠️  Directorio de parsers no encontrado: " .. parser_dir)
end

-- 6. Auto-fix: Intentar habilitar highlighting usando Lua API
print("\n🔧 Intentando auto-habilitar highlighting...")
vim.schedule(function()
  local success, err = pcall(vim.treesitter.start, bufnr)
  if success then
    print("✅ Highlighting habilitado exitosamente!")
    print("🎨 Los colores deberían aparecer ahora")
  else
    print("❌ Error al habilitar: " .. tostring(err))
  end
end)

print("\n🔧 Comandos útiles:")
print("  :TSHighlight              - Habilitar highlighting (comando personalizado)")
print("  :lua vim.treesitter.start() - Habilitar highlighting (Lua)")
print("  :lua vim.treesitter.stop()  - Deshabilitar highlighting (Lua)")
print("  :Inspect                  - Ver highlight groups bajo cursor")
print("  :InspectTree              - Ver árbol de sintaxis de Treesitter")
print("  :EditQuery                - Editar queries de highlighting")
