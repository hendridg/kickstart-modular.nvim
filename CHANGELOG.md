# Changelog de Mejoras - Configuración Neovim

> **Fecha:** 31 de Enero, 2026
> **Respaldo:** `~/.config/nvim-module-backup`

---

## 🔧 Fixes Aplicados

### Compatibilidad Telescope + Treesitter
- **Problema:** Error `ft_to_lang` al usar previews en Telescope
- **Solución:** Removida restricción de versión `branch = '0.1.x'` de Telescope
- **Resultado:** Telescope ahora usa la última versión compatible con nvim-treesitter

### LSP Elixir Configurado Correctamente
- **Problema:** `elixirls` no estaba en la tabla `servers` de lspconfig
- **Solución:** Movido `elixirls` y `tailwindcss` a la tabla `servers`
- **Resultado:** LSP de Elixir se carga automáticamente en archivos `.ex`, `.exs`, `.heex`

### ⚠️ Syntax Highlighting (Treesitter Parsers)
**Si NO ves colores en tu código Elixir, ejecuta esto EN Neovim:**

```vim
:TSInstall elixir heex eex lua vim markdown
```

O instala TODOS los parsers configurados:
```vim
:TSUpdate
```

**Verificar instalación:**
```vim
:TSInstallInfo
```

### Copilot Keybinding Fix
- **Problema:** Conflicto de `<CR>` entre Copilot y nvim-cmp
- **Solución:**
  - Copilot suggestions: `<M-l>` (Alt+L) para aceptar
  - nvim-cmp: `<Tab>` para aceptar completado
  - Copilot next/prev: `<M-]>` / `<M-[>`

### Treesitter + Ghostty Terminal Fix
- **Problema:** Colores funcionan en Telescope previews pero NO en buffer principal
- **Causa:** Treesitter highlighting no se activa automáticamente en Ghostty
- **Soluciones aplicadas:**
  1. **Autocmd automático** - Fuerza `vim.treesitter.start()` en archivos Elixir al abrir (FileType event)
  2. **Compatibilidad Ghostty** - Colores de terminal configurados
  3. **Comando personalizado** - `:TSHighlight` para habilitar manualmente

- **Comandos manuales disponibles:**
  ```vim
  :TSHighlight                 " Habilitar highlighting (comando personalizado)
  :lua vim.treesitter.start()  " Habilitar highlighting (API de Lua)
  :lua vim.treesitter.stop()   " Deshabilitar highlighting
  ```

- **Diagnóstico completo:**
  ```vim
  :luafile ~/.config/nvim-module/lua/treesitter-debug.lua
  ```

  Esto mostrará:
  - ✅ Estado del parser (instalado/no instalado)
  - ✅ Highlighter activo/inactivo
  - ✅ Parsers instalados (elixir, heex, eex)
  - ✅ Configuración de terminal (TERM, COLORTERM)
  - ✅ **Auto-intenta habilitar highlighting**
  - ✅ Comandos útiles

---

## ⚠️ CAMBIO IMPORTANTE DE KEYBINDING

**`<leader>x` ha cambiado a `<leader>bc`** para cerrar el buffer actual.

- **Anterior:** `<leader>x` - Cerrar buffer
- **Nuevo:** `<leader>bc` - [B]uffer [C]lose
- **Razones del cambio:**
  1. `<leader>x` ahora es el prefijo para Trouble.nvim (diagnósticos)
  2. `<leader>bc` no conflictúa con debug breakpoints (`<leader>b`)
- **Keybindings de Trouble:**
  - `<leader>xx` - Ver todos los diagnósticos
  - `<leader>xX` - Ver diagnósticos del buffer
  - `<leader>xs` - Ver símbolos
  - etc.

---

## 📦 Respaldo

Se creó un respaldo completo de la configuración anterior en:
```
~/.config/nvim-module-backup
```

---

## ✅ Cambios Completados

### 🔴 Correcciones Críticas

#### 1. **Nerd Font Habilitada**
- **Archivo:** `init.lua:94`
- **Cambio:** `vim.g.have_nerd_font = false` → `true`
- **Beneficio:** Los iconos de nvim-web-devicons, neo-tree y otros plugins ahora se muestran correctamente

#### 2. **Código Duplicado Eliminado**
- **Archivo:** `init.lua:116-121`
- **Cambio:** Removida función `Scratch` duplicada
- **Beneficio:** Una sola implementación en `keymaps.lua` con mejor funcionalidad

#### 3. **Plugins Comentados Habilitados**
- **Archivo:** `lazy-plugins.lua:60,62`
- **Plugins habilitados:**
  - ✅ `autopairs` - Cierra automáticamente paréntesis, comillas, llaves
  - ✅ `indent_line` - Muestra guías de indentación visuales
- **Beneficio:** Mejor experiencia de edición con auto-cierre y guías visuales

#### 4. **Símbolos de Diagnóstico Habilitados**
- **Archivo:** `lspconfig.lua:156-164`
- **Cambio:** Descomentado bloque de iconos de diagnóstico
- **Iconos añadidos:**
  - `` - ERROR
  - `` - WARN
  - `` - INFO
  - `` - HINT
- **Beneficio:** Mejor visualización de errores y warnings en el gutter

---

### ⚡ Mejoras de Rendimiento y Configuración

#### 5. **Folding Mejorado con nvim-ufo**
- **Archivo:** `options.lua:13-17`
- **Cambios:**
  ```lua
  vim.opt.foldcolumn = '1'        -- Muestra columna de fold
  vim.opt.foldlevel = 99          -- Valor alto para ufo
  vim.opt.foldlevelstart = 99     -- Inicia con todo expandido
  vim.opt.foldenable = true       -- Habilita folding
  vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
  ```
- **Beneficio:** Folding inteligente con Treesitter, mejor rendimiento con archivos grandes

#### 6. **Más Parsers de Treesitter**
- **Archivo:** `treesitter.lua:8-11`
- **Parsers añadidos:**
  - `elixir`, `heex`, `eex` (Phoenix/Elixir)
  - `javascript`, `typescript`, `tsx` (React/TypeScript)
  - `css`, `json`, `yaml`, `toml` (Formatos de configuración)
  - `python`, `go`, `rust` (Lenguajes adicionales)
- **Beneficio:** Mejor syntax highlighting y análisis de código para múltiples lenguajes

#### 7. **Opciones de Calidad de Vida**
- **Archivo:** `options.lua:71-76`
- **Opciones añadidas:**
  ```lua
  vim.opt.pumheight = 10         -- Límite de altura del menú de completado
  vim.opt.conceallevel = 0       -- Ver `` en archivos markdown
  vim.opt.cmdheight = 1          -- Altura de la línea de comandos
  vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
  vim.opt.wrap = false           -- Sin wrap de líneas largas
  ```
- **Beneficio:** Mejor experiencia de edición y lectura de código

#### 8. **Notificaciones Mejoradas**
- **Archivo:** `keymaps.lua:63-78`
- **Cambio:** Reemplazados `print()` con `vim.notify()`
- **Beneficio:** Mensajes más limpios y profesionales sin cluttering del command line

#### 9. **Keybinding de Cerrar Buffer Actualizado**
- **Archivo:** `keymaps.lua:61`
- **Cambio:** `<leader>x` → `<leader>bc` (Buffer Close)
- **Razones:**
  - Conflicto con Trouble.nvim que usa `<leader>x` como prefijo
  - `<leader>bc` no conflictúa con debug breakpoints (`<leader>b`)
- **Beneficio:** Ahora `<leader>x*` está disponible para Trouble y `<leader>b` para debug sin retrasos

---

### 🆕 Nuevos Plugins Añadidos

#### 9. **nvim-treesitter-context**
- **Archivo:** `kickstart/plugins/treesitter-context.lua`
- **Descripción:** Muestra el contexto de la función/clase actual en la parte superior
- **Keybindings:**
  - `<leader>tc` - Toggle treesitter context
- **Beneficio:** Nunca pierdas el contexto en archivos grandes

#### 10. **nvim-treesitter-textobjects**
- **Archivo:** `kickstart/plugins/treesitter-textobjects.lua`
- **Descripción:** Text objects mejorados con Treesitter
- **Keybindings:**
  - **Selección:**
    - `vif` - Seleccionar inner function
    - `vaf` - Seleccionar around function
    - `vic` - Seleccionar inner class
    - `vac` - Seleccionar around class
    - `via` - Seleccionar inner parameter
    - `vaa` - Seleccionar around parameter
    - `vib` - Seleccionar inner block
    - `vab` - Seleccionar around block
  - **Navegación:**
    - `]f` / `[f` - Next/Previous function start
    - `]c` / `[c` - Next/Previous class start
    - `]F` / `[F` - Next/Previous function end
    - `]C` / `[C` - Next/Previous class end
- **Beneficio:** Edición de código más eficiente y precisa

#### 11. **trouble.nvim**
- **Archivo:** `kickstart/plugins/trouble.lua`
- **Descripción:** Interfaz mejorada para diagnósticos, referencias, quickfix
- **Keybindings:**
  - `<leader>xx` - Toggle diagnostics (todos los archivos)
  - `<leader>xX` - Toggle diagnostics (buffer actual)
  - `<leader>xs` - Toggle symbols
  - `<leader>xl` - LSP definitions/references
  - `<leader>xL` - Location list
  - `<leader>xQ` - Quickfix list
- **Beneficio:** Navegación más eficiente de errores y referencias

#### 12. **flash.nvim**
- **Archivo:** `kickstart/plugins/flash.lua`
- **Descripción:** Navegación ultra-rápida por el archivo con labels
- **Keybindings:**
  - `s` - Flash jump (salta a cualquier ubicación visible)
  - `S` - Flash treesitter (salta por objetos de código)
  - `r` (operator mode) - Remote flash
  - `R` (visual/operator) - Treesitter search
  - `<c-s>` (command mode) - Toggle flash search
- **Beneficio:** Movimiento por el código 10x más rápido

#### 13. **nvim-ufo**
- **Archivo:** `kickstart/plugins/ufo.lua`
- **Descripción:** Folding inteligente con Treesitter
- **Keybindings:**
  - `zR` - Abrir todos los folds
  - `zM` - Cerrar todos los folds
  - `zr` - Abrir folds excepto tipos específicos
  - `zm` - Cerrar folds con criterio
  - `K` - Peek fold o hover (inteligente)
- **Beneficio:** Mejor gestión de código colapsado, peek sin abrir

---

## 🚀 Instalación de los Cambios

### 1. Limpiar Cache (Ya realizado)
```bash
# Cache limpiado completamente
rm -rf ~/.local/share/nvim-module
rm -rf ~/.cache/nvim-module
rm -rf ~/.local/state/nvim-module
```

### 2. Iniciar Neovim
```bash
NVIM_APPNAME=nvim-module nvim
```

### 3. Esperar Instalación Automática
Lazy.nvim instalará automáticamente todos los plugins nuevos y actualizados.

### 4. Comandos Útiles
- `:Lazy` - Ver estado de plugins
- `:Lazy sync` - Sincronizar/actualizar plugins
- `:checkhealth` - Verificar salud de la configuración
- `:TSUpdate` - Actualizar parsers de Treesitter
- `:Mason` - Gestionar LSP servers y herramientas

---

## 📊 Resumen de Cambios

### Archivos Modificados (8)
1. `init.lua` - Nerd Font habilitada, código duplicado removido
2. `lua/options.lua` - Folding mejorado, nuevas opciones
3. `lua/keymaps.lua` - Notificaciones mejoradas
4. `lua/lazy-plugins.lua` - Plugins habilitados y nuevos añadidos
5. `lua/kickstart/plugins/lspconfig.lua` - Símbolos de diagnóstico
6. `lua/kickstart/plugins/treesitter.lua` - Más parsers

### Archivos Creados (5)
7. `lua/kickstart/plugins/treesitter-context.lua` - Nuevo plugin
8. `lua/kickstart/plugins/treesitter-textobjects.lua` - Nuevo plugin
9. `lua/kickstart/plugins/trouble.lua` - Nuevo plugin
10. `lua/kickstart/plugins/flash.lua` - Nuevo plugin
11. `lua/kickstart/plugins/ufo.lua` - Nuevo plugin

### Plugins Totales
- **Antes:** 25 plugins
- **Después:** 30 plugins (+5 nuevos)
- **Habilitados:** 2 plugins que estaban comentados

---

## 🎯 Beneficios Clave

### Productividad
- ✅ Navegación 10x más rápida con flash.nvim
- ✅ Text objects inteligentes para edición precisa
- ✅ Mejor gestión de diagnósticos con Trouble
- ✅ Contexto siempre visible en archivos largos

### Experiencia Visual
- ✅ Iconos de diagnóstico claros (✘ ⚠  )
- ✅ Guías de indentación visuales
- ✅ Folding con iconos
- ✅ Auto-cierre de paréntesis y comillas

### Rendimiento
- ✅ Lazy loading optimizado para todos los plugins nuevos
- ✅ Folding más eficiente con nvim-ufo
- ✅ Cache limpio para instalación fresca

### Compatibilidad
- ✅ Soporte completo para Elixir/Phoenix (heex, eex)
- ✅ Soporte para TypeScript/React (tsx, jsx)
- ✅ Múltiples lenguajes con Treesitter

---

## 🔄 Cómo Revertir

Si necesitas volver a la configuración anterior:

```bash
# 1. Eliminar configuración nueva
rm -rf ~/.config/nvim-module

# 2. Restaurar desde respaldo
mv ~/.config/nvim-module-backup ~/.config/nvim-module

# 3. Limpiar cache
rm -rf ~/.local/share/nvim-module
rm -rf ~/.cache/nvim-module
rm -rf ~/.local/state/nvim-module
```

---

## 📝 Notas Importantes

### Requisitos
- ✅ **Nerd Font:** Asegúrate de tener una Nerd Font instalada en tu terminal
  - Recomendadas: JetBrainsMono Nerd Font, FiraCode Nerd Font
  - Descargar: https://www.nerdfonts.com/

### Configuración Específica

#### LSP Servers Configurados
- `lua_ls` - Lua (con soporte para Neovim)
- `tailwindcss` - Tailwind CSS (con soporte para Elixir/HeEx)
- `elixirls` - Elixir/Phoenix

#### Formatters Configurados
- `stylua` - Lua
- Tailwind CSS support
- Elixir support

#### Debuggers Configurados
- Go (Delve)
- Elixir (elixir-ls-debugger)

---

## 🎓 Recursos de Aprendizaje

### Nuevos Keybindings Importantes
```
# Buffer Management (ACTUALIZADO)
<leader>bc  - Cerrar buffer actual (antes era <leader>x)
<leader>Q   - Cerrar otros buffers

# Debug (sin cambios)
<leader>b   - Toggle breakpoint
<leader>B   - Set conditional breakpoint
<F5>        - Start/Continue debug

# Flash Navigation
s           - Flash jump (más usado)
S           - Flash treesitter

# Trouble (Diagnósticos)
<leader>xx  - Ver todos los diagnósticos
<leader>xX  - Ver diagnósticos del buffer actual
<leader>xs  - Ver símbolos
<leader>xl  - Ver definiciones/referencias LSP
<leader>xL  - Location list
<leader>xQ  - Quickfix list

# Treesitter Text Objects
vif         - Seleccionar función
]f / [f     - Navegar entre funciones
]c / [c     - Navegar entre clases

# Folding
zR          - Abrir todo
zM          - Cerrar todo
K           - Peek fold (sin abrir)
```

### Comandos Útiles
```vim
:Telescope keymaps    " Ver todos los keybindings
:checkhealth          " Verificar configuración
:Lazy                 " Gestionar plugins
:Mason                " Gestionar LSP/herramientas
:TSModuleInfo         " Ver módulos de Treesitter
```

---

## 🐛 Troubleshooting

### Si los iconos no se ven
1. Verifica que tengas Nerd Font instalada
2. Configura tu terminal para usar la Nerd Font
3. Reinicia tu terminal

### Si los plugins no se instalan
```vim
:Lazy sync
:Lazy restore
```

### Si Treesitter falla
```vim
:TSUpdate
:TSInstall elixir heex javascript typescript
```

### Si LSP no funciona
```vim
:Mason
:LspInfo
:checkhealth lsp
```

---

## 🙏 Créditos

- **Base:** Kickstart.nvim
- **Plugins:** Comunidad de Neovim
- **Mejoras:** Implementadas el 31 de Enero, 2026

---

**Disfruta tu configuración mejorada de Neovim!** 🚀
