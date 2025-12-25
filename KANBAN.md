# Vira Theme — Kanban

## Context

**Project:** Port Vira JetBrains theme (6 dark variants) to Neovim.

**Variants:** Carbon, Deepforest, Graphene, Ocean, Palenight, Teal

**Repository structure:**
```
vira.nvim/
├── KANBAN.md
├── jetbrains/              # Git repo (original/, intellij-community/ in .gitignore)
│   ├── CLAUDE.md
│   ├── analysis/
│   │   ├── attribute-schema.md      # Complete JetBrains theme schema
│   │   ├── appendix-xml-colors.md   # 157 editor chrome colors
│   │   ├── appendix-xml-attributes.md # 290 syntax highlighting attrs
│   │   ├── appendix-ui-components.md  # 102 UI components
│   │   ├── shared.json              # Values identical across variants
│   │   └── diff-matrix.json         # Per-variant differences
│   ├── extracted/          # Normalized JSON per variant (6 files)
│   └── extract.py          # Reproducible extraction
└── nvim/                   # (empty) Future Lua theme output
```

**Data flow:**
```
original/*.json + *.xml
        ↓ extract.py
extracted/{variant}.json
        ↓ mappings/jetbrains-to-nvim.json
nvim/lua/vira/palette/{variant}.lua
        ↓ groups/*.lua templates
nvim/lua/vira/init.lua (loadable theme)
```

---

## Done

### Phase 1: Data Extraction

- [x] **Create directory structure**
  - Created: `jetbrains/{original,extracted,analysis}/`, `nvim/`
  - Validation: `tree jetbrains/` shows 4 directories

- [x] **Move source files to jetbrains/original/**
  - Input: `/*.theme.json`, `/*.xml` (12 files at repo root)
  - Output: `jetbrains/original/Vira-{Variant}.theme.json` + `.xml`
  - Validation: `ls jetbrains/original/ | wc -l` = 12

- [x] **Extract and normalize all variants**
  - Input: `jetbrains/original/*`
  - Output: `jetbrains/extracted/{variant}.json` (6 files, ~68KB each)
  - Script: `python jetbrains/extract.py`
  - Validation: `ls jetbrains/extracted/ | wc -l` = 6

- [x] **Generate analysis files**
  - Output: `jetbrains/analysis/shared.json` (common values)
  - Output: `jetbrains/analysis/diff-matrix.json` (variant differences)
  - Validation: Both files exist and are valid JSON

---

## To Do

### Phase 2: Research & Mapping

- [x] **Research JetBrains attribute schema**
  - Output:
    - `jetbrains/analysis/attribute-schema.md` — Schema docs (file structure, inheritance, value types)
    - `jetbrains/analysis/appendix-xml-colors.md` — 157 editor chrome colors
    - `jetbrains/analysis/appendix-xml-attributes.md` — 290 syntax highlighting attributes
    - `jetbrains/analysis/appendix-ui-components.md` — 102 UI component properties
  - Source: `intellij-community/platform/editor-ui-ex/.../TextAttributesReader.java`
  - Validation: All claims verified against IntelliJ source code

- [ ] **Research Nvim highlight groups**
  - Output: `nvim/docs/nvim-highlight-groups.md`
  - Content:
    - Core Vim groups (Normal, Comment, String, Keyword, etc.)
    - Treesitter captures (@keyword, @string, @function, etc.)
    - LSP semantic tokens (@lsp.type.*, @lsp.mod.*)
    - Diagnostic groups (DiagnosticError, DiagnosticWarn, etc.)
    - Common plugin groups (Telescope*, NvimTree*, GitSigns*, etc.)
  - Validation: File lists 100+ highlight groups with descriptions

- [ ] **Create JetBrains → Nvim mapping**
  - Input: `jetbrains/extracted/carbon.json`, `nvim/docs/nvim-highlight-groups.md`
  - Output: `nvim/mappings/jetbrains-to-nvim.json`
  - Format:
    ```json
    {
      "xml.colors": {
        "CARET_COLOR": ["Cursor", "lCursor"],
        "SELECTION_BACKGROUND": ["Visual"],
        "LINE_NUMBERS_COLOR": ["LineNr"]
      },
      "xml.attributes": {
        "DEFAULT_KEYWORD": ["Keyword", "@keyword"],
        "DEFAULT_STRING": ["String", "@string"],
        "DEFAULT_COMMENT": ["Comment", "@comment"]
      }
    }
    ```
  - Validation: JSON is valid, covers all syntax-relevant attributes

---

### Phase 3: Lua Generation

- [ ] **Create palette generator script**
  - Input: `jetbrains/extracted/{variant}.json`
  - Output: `nvim/lua/vira/palette/{variant}.lua` (6 files)
  - Format:
    ```lua
    return {
      bg = "#0a0a0a",
      fg = "#d9d9d9",
      keyword = "#6ebad7",
      string = "#a3c679",
      -- ... all colors used by this variant
    }
    ```
  - Script: `nvim/generate.py` or `nvim/generate.lua`
  - Validation: `lua -e "print(require('vira.palette.carbon').bg)"` outputs color

- [ ] **Create highlight group definitions**
  - Input: `nvim/mappings/jetbrains-to-nvim.json`
  - Output: `nvim/lua/vira/groups/init.lua`
  - Content: Function that takes palette and returns highlight group table
  - Validation: No Lua syntax errors

- [ ] **Create theme entry point**
  - Output: `nvim/lua/vira/init.lua`
  - Content:
    ```lua
    local M = {}
    function M.setup(opts)
      opts = opts or {}
      local variant = opts.variant or "carbon"
      local palette = require("vira.palette." .. variant)
      local groups = require("vira.groups").get(palette)
      for group, settings in pairs(groups) do
        vim.api.nvim_set_hl(0, group, settings)
      end
    end
    return M
    ```
  - Validation: `:lua require('vira').setup()` runs without error

- [ ] **Generate all 6 variant palettes**
  - Run generator script for each variant
  - Validation: All 6 palette files exist and load without error

---

### Phase 4: Iteration & Testing

- [ ] **Basic load test**
  - Command: `nvim --headless -c "lua require('vira').setup()" -c "q"`
  - Validation: Exit code 0, no errors

- [ ] **Visual comparison: Carbon**
  - Load Carbon variant in Nvim
  - Open test files: Lua, Python, JavaScript, Markdown
  - Compare against JetBrains screenshots
  - Document discrepancies in `nvim/docs/testing-notes.md`

- [ ] **Fix discrepancies (repeat as needed)**
  - Adjust mappings or palette values
  - Re-run generation
  - Re-test

- [ ] **Test remaining variants**
  - Repeat visual comparison for: Deepforest, Graphene, Ocean, Palenight, Teal
  - Validation: All 6 variants load and look correct

- [ ] **Plugin integration**
  - Test with: Telescope, NvimTree, Lualine, GitSigns
  - Add plugin-specific highlight groups as needed
  - Validation: No broken/missing colors in common plugins

---

### Phase 5: Polish & Release

- [ ] **Add configuration options**
  - Output: Update `nvim/lua/vira/init.lua`
  - Options:
    - `variant` (string): Which variant to use
    - `italic_comments` (bool): Use italic for comments
    - `transparent` (bool): Transparent background
  - Validation: Each option works as expected

- [ ] **Write README.md**
  - Output: `README.md`
  - Content:
    - Screenshots of each variant
    - Installation (lazy.nvim, packer, manual)
    - Configuration options
    - Acknowledgments (original JetBrains theme)
  - Validation: README renders correctly on GitHub

- [ ] **Add lazy.nvim spec**
  - Ensure theme works with:
    ```lua
    { "user/vira.nvim", config = function() require("vira").setup() end }
    ```
  - Validation: Fresh install via lazy.nvim works

---

## Backlog (Future)

- [ ] Light theme variants (if source exists)
- [ ] Lualine theme integration
- [ ] Terminal emulator themes (kitty, alacritty, wezterm)
- [ ] Export to other editors (VS Code, Sublime)

---

## Reference

### Variant Defining Colors

| Variant    | Background | Foreground | Accent   |
|------------|------------|------------|----------|
| Carbon     | `#0a0a0a`  | `#d9d9d9`  | `#80cbc4`|
| Deepforest | `#111816`  | `#cae5d5`  | `#80cbc4`|
| Graphene   | `#212121`  | `#d9d9d9`  | `#80cbc4`|
| Ocean      | `#0f111a`  | `#ced1e3`  | `#80cbc4`|
| Palenight  | `#292d3e`  | `#ced1e3`  | `#80cbc4`|
| Teal       | `#263238`  | `#d8dfdf`  | `#80cbc4`|

### Key Files

| File | Purpose |
|------|---------|
| `jetbrains/extract.py` | Re-run to update extracted data |
| `jetbrains/extracted/{variant}.json` | Normalized theme data |
| `jetbrains/analysis/shared.json` | Colors identical across variants |
| `jetbrains/analysis/diff-matrix.json` | Colors that differ per variant |
| `nvim/mappings/jetbrains-to-nvim.json` | Translation layer |
| `nvim/lua/vira/init.lua` | Theme entry point |
