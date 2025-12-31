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

### Phase 2: Research & Mapping

- [x] **Research JetBrains attribute schema**
  - Output:
    - `jetbrains/analysis/attribute-schema.md` — Schema docs (file structure, inheritance, value types)
    - `jetbrains/analysis/appendix-xml-colors.md` — 157 editor chrome colors
    - `jetbrains/analysis/appendix-xml-attributes.md` — 290 syntax highlighting attributes
    - `jetbrains/analysis/appendix-ui-components.md` — 102 UI component properties
  - Source: `intellij-community/platform/editor-ui-ex/.../TextAttributesReader.java`
  - Validation: All claims verified against IntelliJ source code

- [x] **Research Nvim highlight groups**
  - Output: `nvim/docs/nvim-highlight-groups.md`
  - Content:
    - Core Vim groups (Normal, Comment, String, Keyword, etc.)
    - Treesitter captures (@keyword, @string, @function, etc.)
    - LSP semantic tokens (@lsp.type.*, @lsp.mod.*)
    - Diagnostic groups (DiagnosticError, DiagnosticWarn, etc.)
  - Validation: File lists 155 highlight groups with descriptions

- [x] **Create JetBrains → Nvim mapping**
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

- [x] **Create palette generator script**
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
  - Script: `nvim/generate.py`
  - Validation: `nvim -c "lua print(require('vira.palette.carbon').bg)"` outputs `#0a0a0a`

- [x] **Create highlight group definitions**
  - Input: `nvim/mappings/jetbrains-to-nvim.json`
  - Output: `nvim/lua/vira/groups/init.lua`
  - Content: Function that takes palette and returns highlight group table
  - Validation: No Lua syntax errors

- [x] **Create theme entry point**
  - Output: `nvim/lua/vira/init.lua`
  - Content: Setup function with variant selection, transparent bg, italic comments options
  - Extra: `nvim/colors/vira.lua` for `:colorscheme vira` support
  - Validation: `nvim --headless -c "lua require('vira').setup()" -c "q"` exits with code 0

- [x] **Generate all 6 variant palettes**
  - Run: `python nvim/generate.py`
  - Validation: All 6 palette files exist and load without error

---

### Phase 4: Iteration & Testing

- [x] **Basic load test**
  - Command: `nvim --headless -c "lua require('vira').setup()" -c "q"`
  - Validation: Exit code 0, no errors

- [x] **Visual comparison: Carbon**
  - Validated Normal bg=#0a0a0a fg=#d9d9d9 matches source
  - All 18 core highlight groups validated (Comment, String, Keyword, Function, etc.)
  - Treesitter groups (@keyword, @string, etc.) correctly linked

- [x] **Fix discrepancies (repeat as needed)**
  - No discrepancies found; all colors match JetBrains source data

- [x] **Test remaining variants**
  - All 6 variants load successfully with correct bg/fg colors
  - Deepforest: bg=#111816 fg=#cae5d5
  - Graphene: bg=#212121 fg=#d9d9d9
  - Ocean: bg=#0f111a fg=#ced1e3
  - Palenight: bg=#292d3e fg=#ced1e3
  - Teal: bg=#263238 fg=#d8dfdf

- [x] **Plugin integration**
  - Validated 12 plugin highlight groups (Telescope, NvimTree, GitSigns, Cmp, Lazy)
  - groups/init.lua includes 50+ plugin-specific groups

---

### Phase 5: Polish & Release

- [x] **Add configuration options**
  - Output: `nvim/lua/vira/init.lua`
  - Options: `variant`, `transparent`, `italic_comments`, `on_colors`, `on_highlights`
  - Validation: All options work as expected

- [x] **Write README.md**
  - Output: `README.md`
  - Content: Variant table, installation instructions, configuration, API, acknowledgments
  - Validation: README complete with all sections

- [x] **Add lazy.nvim spec**
  - Validated with: `{ "user/vira.nvim", config = function() require("vira").setup() end }`
  - All 6 variants load successfully, colorscheme command works

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
