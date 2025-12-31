# Neovim Highlight Groups Reference

Complete reference for mapping JetBrains theme attributes to Neovim highlight groups.

---

## 1. Core Vim Highlight Groups

Editor chrome and legacy syntax groups inherited from Vim.

### Editor UI

| Group | Purpose |
|-------|---------|
| `Normal` | Default text and background |
| `NormalFloat` | Floating window text and background |
| `NormalNC` | Non-current window Normal |
| `Cursor` | Character under the cursor |
| `lCursor` | Language-specific cursor |
| `CursorIM` | Cursor in IME mode |
| `CursorLine` | Line the cursor is on |
| `CursorColumn` | Column the cursor is on |
| `ColorColumn` | Columns set with 'colorcolumn' |
| `Conceal` | Concealed text placeholder |
| `Directory` | Directory names in listings |
| `EndOfBuffer` | `~` lines after buffer end |
| `ErrorMsg` | Error messages on command line |
| `VertSplit` | Vertical split separator (deprecated, use WinSeparator) |
| `WinSeparator` | Window separators |
| `Folded` | Closed fold line |
| `FoldColumn` | Fold indicator column |
| `SignColumn` | Sign column |
| `IncSearch` | Incremental search highlighting |
| `Substitute` | `:substitute` replacement text |
| `LineNr` | Line numbers |
| `LineNrAbove` | Line numbers above cursor (relativenumber) |
| `LineNrBelow` | Line numbers below cursor (relativenumber) |
| `CursorLineNr` | Line number on cursor line |
| `CursorLineFold` | Fold column on cursor line |
| `CursorLineSign` | Sign column on cursor line |
| `MatchParen` | Matching bracket highlight |
| `ModeMsg` | Mode message (e.g., "-- INSERT --") |
| `MsgArea` | Command-line message area |
| `MsgSeparator` | Separator for scrolled messages |
| `MoreMsg` | More-prompt |
| `NonText` | '@' at end of window, etc. |
| `Pmenu` | Popup menu normal item |
| `PmenuSel` | Popup menu selected item |
| `PmenuKind` | Popup menu kind column |
| `PmenuKindSel` | Popup menu kind (selected) |
| `PmenuExtra` | Popup menu extra text |
| `PmenuExtraSel` | Popup menu extra text (selected) |
| `PmenuSbar` | Popup menu scrollbar |
| `PmenuThumb` | Popup menu scrollbar thumb |
| `Question` | Hit-enter prompt and yes/no questions |
| `QuickFixLine` | Current quickfix item |
| `Search` | Last search pattern highlighting |
| `CurSearch` | Current search match |
| `SpecialKey` | Unprintable characters |
| `SpellBad` | Misspelled word |
| `SpellCap` | Word should start with capital |
| `SpellLocal` | Word from another region |
| `SpellRare` | Rarely used word |
| `StatusLine` | Status line of current window |
| `StatusLineNC` | Status line of non-current windows |
| `TabLine` | Tab pages line (not selected) |
| `TabLineFill` | Tab pages line filler |
| `TabLineSel` | Tab pages line (selected) |
| `Title` | Titles from :set all, :autocmd, etc. |
| `Visual` | Visual mode selection |
| `VisualNOS` | Visual mode (not-owning-selection) |
| `WarningMsg` | Warning messages |
| `Whitespace` | Listchars whitespace |
| `WildMenu` | Wildmenu selection |
| `WinBar` | Window bar |
| `WinBarNC` | Window bar (non-current) |

### Diff Highlighting

| Group | Purpose |
|-------|---------|
| `DiffAdd` | Added line |
| `DiffChange` | Changed line |
| `DiffDelete` | Deleted line |
| `DiffText` | Changed text within changed line |
| `Added` | Added text (generic) |
| `Changed` | Changed text (generic) |
| `Removed` | Removed text (generic) |

### Legacy Syntax Groups

These are the classic Vim syntax groups. Most colorschemes define these, and language-specific syntax files link to them.

| Group | Purpose |
|-------|---------|
| `Comment` | Any comment |
| `Constant` | Any constant |
| `String` | String literals |
| `Character` | Character literals |
| `Number` | Numeric literals |
| `Boolean` | Boolean literals |
| `Float` | Floating-point numbers |
| `Identifier` | Variable names |
| `Function` | Function names |
| `Statement` | Any statement |
| `Conditional` | if, then, else, switch |
| `Repeat` | for, do, while |
| `Label` | case, default |
| `Operator` | Operators (+, *, sizeof) |
| `Keyword` | Any other keyword |
| `Exception` | try, catch, throw |
| `PreProc` | Preprocessor directives |
| `Include` | #include |
| `Define` | #define |
| `Macro` | Macros (same as Define) |
| `PreCondit` | #if, #else, #endif |
| `Type` | int, long, char, etc. |
| `StorageClass` | static, register, volatile |
| `Structure` | struct, union, enum |
| `Typedef` | Typedef |
| `Special` | Special symbols |
| `SpecialChar` | Special characters in constants |
| `Tag` | CTRL-] targets |
| `Delimiter` | Characters needing attention |
| `SpecialComment` | Special things in comments |
| `Debug` | Debugging statements |
| `Underlined` | Text that stands out (links) |
| `Ignore` | Hidden text |
| `Error` | Erroneous constructs |
| `Todo` | TODO, FIXME, XXX |

---

## 2. Treesitter Capture Groups

Treesitter provides semantic syntax highlighting via "captures" — named patterns matched against the parse tree. These groups use the `@` prefix.

### Identifiers

| Capture | Purpose |
|---------|---------|
| `@variable` | Various variable names |
| `@variable.builtin` | Built-in variables (this, self) |
| `@variable.parameter` | Function parameters |
| `@variable.parameter.builtin` | Special parameters (_, it) |
| `@variable.member` | Object/struct fields |

### Constants

| Capture | Purpose |
|---------|---------|
| `@constant` | Constant identifiers |
| `@constant.builtin` | Built-in constants (nil, true) |
| `@constant.macro` | Preprocessor constants |

### Modules

| Capture | Purpose |
|---------|---------|
| `@module` | Modules or namespaces |
| `@module.builtin` | Built-in modules |
| `@label` | GOTO and other labels |

### Literals

| Capture | Purpose |
|---------|---------|
| `@string` | String literals |
| `@string.documentation` | Documentation strings |
| `@string.regexp` | Regular expressions |
| `@string.escape` | Escape sequences |
| `@string.special` | Special strings (dates) |
| `@string.special.symbol` | Symbols/atoms |
| `@string.special.path` | File paths |
| `@string.special.url` | URLs and hyperlinks |
| `@character` | Character literals |
| `@character.special` | Special characters |
| `@boolean` | Boolean literals |
| `@number` | Numeric literals |
| `@number.float` | Floating-point numbers |

### Types

| Capture | Purpose |
|---------|---------|
| `@type` | Type/class names |
| `@type.builtin` | Built-in types |
| `@type.definition` | Type definitions |
| `@attribute` | Annotations/decorators |
| `@attribute.builtin` | Built-in annotations |
| `@property` | Object properties/keys |

### Functions

| Capture | Purpose |
|---------|---------|
| `@function` | Function definitions |
| `@function.builtin` | Built-in functions |
| `@function.call` | Function calls |
| `@function.macro` | Preprocessor macros |
| `@function.method` | Method definitions |
| `@function.method.call` | Method calls |
| `@constructor` | Constructors |
| `@operator` | Symbolic operators |

### Keywords

| Capture | Purpose |
|---------|---------|
| `@keyword` | General keywords |
| `@keyword.coroutine` | Coroutine keywords (async, await) |
| `@keyword.function` | Function definition keywords |
| `@keyword.operator` | Word operators (and, or, not) |
| `@keyword.import` | Import/export keywords |
| `@keyword.type` | Type keywords (class, struct) |
| `@keyword.modifier` | Modifiers (public, static) |
| `@keyword.repeat` | Loop keywords |
| `@keyword.return` | Return/yield keywords |
| `@keyword.debug` | Debug keywords |
| `@keyword.exception` | Exception keywords |
| `@keyword.conditional` | Conditional keywords |
| `@keyword.conditional.ternary` | Ternary operator |
| `@keyword.directive` | Preprocessor directives |
| `@keyword.directive.define` | Preprocessor defines |

### Punctuation

| Capture | Purpose |
|---------|---------|
| `@punctuation.delimiter` | Delimiters (;, ., ,) |
| `@punctuation.bracket` | Brackets ((), {}, []) |
| `@punctuation.special` | Special punctuation |

### Comments

| Capture | Purpose |
|---------|---------|
| `@comment` | Line/block comments |
| `@comment.documentation` | Doc comments |
| `@comment.error` | Error comments |
| `@comment.warning` | Warning comments |
| `@comment.todo` | TODO comments |
| `@comment.note` | NOTE comments |

### Markup (Markdown, etc.)

| Capture | Purpose |
|---------|---------|
| `@markup.strong` | Bold text |
| `@markup.italic` | Italic text |
| `@markup.strikethrough` | Strikethrough |
| `@markup.underline` | Underlined text |
| `@markup.heading` | Headings/titles |
| `@markup.heading.1` | Level 1 heading |
| `@markup.heading.2` | Level 2 heading |
| `@markup.heading.3` | Level 3 heading |
| `@markup.heading.4` | Level 4 heading |
| `@markup.heading.5` | Level 5 heading |
| `@markup.heading.6` | Level 6 heading |
| `@markup.quote` | Block quotes |
| `@markup.math` | Math expressions |
| `@markup.link` | Links/references |
| `@markup.link.label` | Link text |
| `@markup.link.url` | Link URL |
| `@markup.raw` | Inline code |
| `@markup.raw.block` | Code blocks |
| `@markup.list` | List markers |
| `@markup.list.checked` | Checked items |
| `@markup.list.unchecked` | Unchecked items |

### Diff

| Capture | Purpose |
|---------|---------|
| `@diff.plus` | Added lines |
| `@diff.minus` | Removed lines |
| `@diff.delta` | Changed lines |

### Tags (HTML/XML)

| Capture | Purpose |
|---------|---------|
| `@tag` | Tag names |
| `@tag.builtin` | Built-in tags |
| `@tag.attribute` | Tag attributes |
| `@tag.delimiter` | Tag delimiters (<, >, /) |

### Special

| Capture | Purpose |
|---------|---------|
| `@spell` | Spell-checkable regions |
| `@nospell` | Spell-check disabled |
| `@conceal` | Concealed content |

---

## 3. LSP Semantic Token Highlights

LSP servers provide semantic tokens that add language-aware highlighting on top of Treesitter.

### Naming Convention

```
@lsp.type.<type>           # Token type
@lsp.type.<type>.<ft>      # Type for specific filetype
@lsp.mod.<mod>             # Token modifier
@lsp.mod.<mod>.<ft>        # Modifier for specific filetype
@lsp.typemod.<type>.<mod>  # Combined type+modifier
```

### Standard Token Types

| Capture | Purpose |
|---------|---------|
| `@lsp.type.class` | Class names |
| `@lsp.type.comment` | Comments |
| `@lsp.type.decorator` | Decorators/annotations |
| `@lsp.type.enum` | Enum types |
| `@lsp.type.enumMember` | Enum members |
| `@lsp.type.event` | Events |
| `@lsp.type.function` | Functions |
| `@lsp.type.interface` | Interfaces |
| `@lsp.type.keyword` | Keywords |
| `@lsp.type.macro` | Macros |
| `@lsp.type.method` | Methods |
| `@lsp.type.modifier` | Modifiers |
| `@lsp.type.namespace` | Namespaces |
| `@lsp.type.number` | Numbers |
| `@lsp.type.operator` | Operators |
| `@lsp.type.parameter` | Parameters |
| `@lsp.type.property` | Properties |
| `@lsp.type.regexp` | Regular expressions |
| `@lsp.type.string` | Strings |
| `@lsp.type.struct` | Structs |
| `@lsp.type.type` | Types |
| `@lsp.type.typeParameter` | Type parameters |
| `@lsp.type.variable` | Variables |

### Standard Token Modifiers

| Capture | Purpose |
|---------|---------|
| `@lsp.mod.abstract` | Abstract declarations |
| `@lsp.mod.async` | Async functions |
| `@lsp.mod.declaration` | Declarations |
| `@lsp.mod.defaultLibrary` | Standard library |
| `@lsp.mod.definition` | Definitions |
| `@lsp.mod.deprecated` | Deprecated symbols |
| `@lsp.mod.documentation` | Documentation |
| `@lsp.mod.modification` | Modified variables |
| `@lsp.mod.readonly` | Readonly/const |
| `@lsp.mod.static` | Static members |

### LSP Reference Highlights

| Group | Purpose |
|-------|---------|
| `LspReferenceText` | Text references |
| `LspReferenceRead` | Read references |
| `LspReferenceWrite` | Write references |
| `LspReferenceTarget` | Reference targets |

### LSP UI Highlights

| Group | Purpose |
|-------|---------|
| `LspInlayHint` | Inlay hints |
| `LspCodeLens` | Code lens virtual text |
| `LspCodeLensSeparator` | Code lens separators |
| `LspSignatureActiveParameter` | Active parameter in signature |

---

## 4. Diagnostic Highlights

Neovim's built-in diagnostic system uses these highlight groups.

### Base Groups

| Group | Purpose |
|-------|---------|
| `DiagnosticError` | Error severity base |
| `DiagnosticWarn` | Warning severity base |
| `DiagnosticInfo` | Info severity base |
| `DiagnosticHint` | Hint severity base |
| `DiagnosticOk` | Ok/success severity base |

### Virtual Text

| Group | Purpose |
|-------|---------|
| `DiagnosticVirtualTextError` | Error virtual text |
| `DiagnosticVirtualTextWarn` | Warning virtual text |
| `DiagnosticVirtualTextInfo` | Info virtual text |
| `DiagnosticVirtualTextHint` | Hint virtual text |
| `DiagnosticVirtualTextOk` | Ok virtual text |

### Underlines

| Group | Purpose |
|-------|---------|
| `DiagnosticUnderlineError` | Error underline |
| `DiagnosticUnderlineWarn` | Warning underline |
| `DiagnosticUnderlineInfo` | Info underline |
| `DiagnosticUnderlineHint` | Hint underline |
| `DiagnosticUnderlineOk` | Ok underline |

### Sign Column

| Group | Purpose |
|-------|---------|
| `DiagnosticSignError` | Error sign |
| `DiagnosticSignWarn` | Warning sign |
| `DiagnosticSignInfo` | Info sign |
| `DiagnosticSignHint` | Hint sign |
| `DiagnosticSignOk` | Ok sign |

### Floating Windows

| Group | Purpose |
|-------|---------|
| `DiagnosticFloatingError` | Error in float |
| `DiagnosticFloatingWarn` | Warning in float |
| `DiagnosticFloatingInfo` | Info in float |
| `DiagnosticFloatingHint` | Hint in float |
| `DiagnosticFloatingOk` | Ok in float |

### Special

| Group | Purpose |
|-------|---------|
| `DiagnosticDeprecated` | Deprecated code |
| `DiagnosticUnnecessary` | Unused/unnecessary code |

---

## 5. Fallback Hierarchy

Neovim uses fallback linking for highlight groups:

1. **Treesitter** captures fall back to Vim syntax groups:
   - `@keyword` → `Keyword` → `Statement`
   - `@string` → `String` → `Constant`
   - `@function` → `Function` → `Identifier`

2. **LSP semantic tokens** fall back to Treesitter:
   - `@lsp.type.function` → `@function`
   - `@lsp.type.variable` → `@variable`

3. **Filetype-specific** groups fall back to generic:
   - `@lsp.type.function.lua` → `@lsp.type.function`
   - `@keyword.lua` → `@keyword`

---

## Sources

- [Neovim Syntax Documentation](https://neovim.io/doc/user/syntax.html)
- [Neovim Treesitter Documentation](https://neovim.io/doc/user/treesitter.html)
- [Neovim LSP Documentation](https://neovim.io/doc/user/lsp.html)
- [Neovim Diagnostic Documentation](https://neovim.io/doc/user/diagnostic.html)
- [LSP Semantic Tokens Specification](https://microsoft.github.io/language-server-protocol/specification/#textDocument_semanticTokens)
