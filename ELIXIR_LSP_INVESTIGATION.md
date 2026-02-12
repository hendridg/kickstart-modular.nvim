# Investigación: Mejoras LSP para Elixir/HEEx y Tailwind

## Fecha
2026-02-12

## Problema Original

El usuario reportó que al trabajar en archivos HEEx (`.heex`) o dentro de sigils `~H"""`:
1. **No aparecen definiciones de componentes ni atributos** de Phoenix
2. **Solo se marcan errores** cuando hay uno, pero no hay autocompletado
3. **No funcionan las sugerencias de Tailwind CSS**

## Diagnóstico Realizado

### 1. Configuración Inicial
- Se encontró que estaba usando **Lexical** para Elixir (correcto para mejor soporte HEEx)
- **Tailwind LSP** estaba configurado pero con settings incorrectos
- Ambos LSP estaban en la configuración pero con funciones `root_dir` defectuosas

### 2. Problemas Encontrados

#### Error #1: Funciones `root_dir` con parámetro incorrecto
```lua
-- ❌ ANTES (causaba error)
root_dir = function(fname)
  return vim.fs.dirname(vim.fs.find({ 'mix.exs', '.git' }, { path = fname, upward = true })[1])
end
```

**Error:** `vim.fs.find` esperaba un string (path de archivo) pero recibía un número (buffer ID)

**Solución aplicada:**
```lua
-- ✅ DESPUÉS
root_dir = function(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local found = vim.fs.find({ 'mix.exs', '.git' }, { path = fname, upward = true })[1]
  return found and vim.fs.dirname(found) or nil
end
```

#### Error #2: Lexical no puede iniciar - Elixir no encontrado
**Logs relevantes:**
```
[ERROR] "rpc" "elixir-ls" "stderr" "unknown command: elixir. Perhaps you have to reshim?"
[ERROR] "/Users/trabajo/.local/share/nvim/mason/packages/elixir-ls/launch.sh:140: command not found: elixir"
```

Al ejecutar Lexical manualmente:
```bash
~/.local/share/nvim/mason/bin/lexical --version
# Output: elixir: command not found
```

**Causa raíz:** En este usuario de macOS no está instalado Elixir (ni vía asdf ni sistema)

#### Error #3: Tailwind con configuración desactualizada
- Los `includeLanguages` estaban mapeando a tipos incorrectos
- Faltaba `experimental.classRegex` para detectar clases en HEEx

### 3. Estado Actual del LSP (según `:LspInfo`)

**Active Clients:**
- ✅ `copilot` (funcionando)
- ✅ `tailwindcss` (activo pero con settings antiguos - necesita restart)

**Enabled Configurations (pero NO activos):**
- ⚠️ `lexical` - Configurado correctamente pero NO puede iniciar por falta de Elixir

## Cambios Aplicados

### Archivo modificado: `lua/kickstart/plugins/lspconfig.lua`

#### 1. Lexical - Líneas 227-247
```lua
lexical = {
  cmd = { 'lexical' },
  filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
  root_dir = function(bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local found = vim.fs.find({ 'mix.exs', '.git' }, { path = fname, upward = true })[1]
    return found and vim.fs.dirname(found) or nil
  end,
  settings = {
    lexical = {
      dialyzer = {
        enabled = true,
      },
      experimental = {
        -- Habilita completado de atributos de Phoenix.Component
        enableComponentCompletion = true,
      },
    },
  },
},
```

**Mejoras:**
- ✅ Corregida función `root_dir` para recibir bufnr
- ✅ Agregado `dialyzer.enabled = true`
- ✅ Agregado `experimental.enableComponentCompletion = true` para completado de componentes

#### 2. Tailwind CSS - Líneas 265-304
```lua
tailwindcss = {
  filetypes = { 'html', 'javascript', 'typescript', 'css', 'elixir', 'eelixir', 'heex', 'surface' },
  root_dir = function(bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local found = vim.fs.find({ 'tailwind.config.js', 'tailwind.config.ts', 'mix.exs', '.git' }, { path = fname, upward = true })[1]
    return found and vim.fs.dirname(found) or nil
  end,
  settings = {
    tailwindCSS = {
      classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass' },
      includeLanguages = {
        eelixir = 'html',      -- Cambiado de 'html-eex'
        elixir = 'html',       -- Cambiado de 'phoenix-heex'
        eruby = 'html',
        heex = 'html',         -- Cambiado de 'phoenix-heex'
        surface = 'html',
      },
      experimental = {
        classRegex = {
          -- Atributos class: en HEEx
          'class[:]\\s*"([^"]*)"',
          'class[:]\\s*\'([^\']*)\'',
          -- Atributos class= normales
          'class="([^"]*)"',
          'class=\'([^\']*)\'',
          -- Interpolaciones (class={@class})
          'class[=:]\\s*[{]([^}]*)[}]',
        },
      },
      lint = { ... },
      validate = true,
    },
  },
},
```

**Mejoras:**
- ✅ Corregida función `root_dir`
- ✅ Actualizado `includeLanguages` para mapear a `html` en lugar de tipos específicos
- ✅ Agregado `experimental.classRegex` para detectar clases en HEEx
- ✅ Agregados filetypes `eelixir` y `surface`

#### 3. Configuración manual de Lexical - Líneas 326-332
```lua
-- Manual setup for Lexical (not available via Mason)
-- Lexical must be installed separately (e.g., via asdf or manual installation)
if servers.lexical then
  local lexical_config = servers.lexical
  lexical_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, lexical_config.capabilities or {})
  vim.lsp.config('lexical', lexical_config)
end
```

**Razón:** Lexical no se instala completamente vía Mason, necesita setup manual adicional

## Pasos Siguientes (Para Usuario con Elixir)

### 1. Verificar Instalación de Elixir
```bash
# Verificar que Elixir esté disponible
which elixir
elixir --version

# Si no está instalado, instalar vía asdf:
asdf plugin add elixir
asdf install elixir latest
asdf global elixir latest

# O vía Homebrew:
brew install elixir
```

### 2. Verificar que Lexical Funcione
```bash
# Probar que Lexical puede ejecutarse
~/.local/share/nvim/mason/bin/lexical --version
# Debería mostrar versión de Lexical sin errores
```

### 3. Reiniciar Neovim y Verificar
```vim
# Abrir Neovim
nvim

# Abrir archivo .heex o .ex con ~H"""
:e lib/my_app_web/components/core_components.ex

# Verificar que los LSP estén activos
:LspInfo

# Deberías ver en "Active Clients":
# - lexical (id: X)
# - tailwindcss (id: Y)
```

### 4. Probar Funcionalidades

#### Test 1: Completado de componentes Phoenix
```heex
# Dentro de ~H""" o archivo .heex
<.button  # Debería autocompletar atributos como: variant, size, class, etc.
```

#### Test 2: Goto definition de componentes
```heex
# Posicionar cursor sobre <.button y presionar gd
<.button variant="primary">Click me</.button>
# Debería saltar a la definición del componente button
```

#### Test 3: Sugerencias de Tailwind
```heex
<div class="bg-  # Debería mostrar sugerencias: bg-red-500, bg-blue-100, etc.
```

### 5. Si Tailwind aún no funciona
```vim
# Forzar restart del LSP
:LspRestart tailwindcss

# O reiniciar completamente Neovim
```

## Archivos de Debug

### Ver logs de LSP
```vim
:lua vim.cmd('edit ' .. vim.lsp.get_log_path())
```

### Ejecutar Lexical manualmente para debug
```bash
cd /path/to/phoenix/project
~/.local/share/nvim/mason/bin/lexical
```

## Notas Adicionales

### ¿Por qué Lexical en lugar de elixir-ls?
- **Lexical** tiene mejor soporte para HEEx y componentes de Phoenix
- Mejor performance en proyectos grandes
- Completado más preciso de atributos de componentes

### Configuración de asdf (si es necesario)
Si usas asdf, asegúrate de que esté configurado en tu shell:

```bash
# En ~/.zshrc o ~/.bashrc
. "$HOME/.asdf/asdf.sh"
```

### Tailwind Config
Asegúrate de tener un `tailwind.config.js` o `tailwind.config.ts` en la raíz del proyecto Phoenix para que Tailwind LSP lo detecte correctamente.

## Referencias
- [Lexical LSP](https://github.com/lexical-lsp/lexical)
- [Tailwind CSS IntelliSense](https://github.com/tailwindlabs/tailwindcss-intellisense)
- [Phoenix HEEx](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html)
