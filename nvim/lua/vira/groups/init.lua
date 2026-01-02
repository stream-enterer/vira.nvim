-- Vira highlight groups
-- Maps palette colors to Neovim highlight groups

local M = {}

---@param p table Palette colors
---@param opts table Theme options
---@return table Highlight group definitions
function M.get(p, opts)
  opts = opts or {}
  local italic_comments = opts.italic_comments ~= false
  local transparent = opts.transparent or false

  local bg = transparent and "NONE" or p.bg
  local float_bg = transparent and "NONE" or (p.float_bg or p.bg)
  local gutter_bg = transparent and "NONE" or (p.gutter or p.bg)

  -- Determine font styles from _font_types
  local ft = p._font_types or {}
  local comment_style = italic_comments and { italic = true } or {}
  local keyword_style = ft.DEFAULT_KEYWORD == 1 and { bold = true } or {}
  local constant_style = ft.DEFAULT_CONSTANT == 2 and { italic = true } or {}
  local todo_style = ft.TODO_DEFAULT_ATTRIBUTES == 3 and { bold = true, italic = true } or { bold = true }

  local groups = {
    -- Base
    Normal = { fg = p.fg, bg = bg },
    NormalFloat = { fg = p.fg, bg = float_bg },
    NormalNC = { fg = p.fg, bg = bg },
    FloatBorder = { fg = p.separator, bg = float_bg },
    FloatTitle = { fg = p.accent, bg = float_bg, bold = true },

    -- Cursor
    Cursor = { fg = p.bg, bg = p.cursor },
    lCursor = { link = "Cursor" },
    CursorIM = { link = "Cursor" },
    CursorLine = { bg = p.cursorline },
    CursorColumn = { link = "CursorLine" },
    TermCursor = { link = "Cursor" },
    TermCursorNC = { bg = p.comment },

    -- Line numbers
    LineNr = { fg = p.linenr, bg = gutter_bg },
    LineNrAbove = { link = "LineNr" },
    LineNrBelow = { link = "LineNr" },
    CursorLineNr = { fg = p.linenr_cursor, bg = p.cursorline, bold = true },
    CursorLineFold = { link = "CursorLineNr" },
    CursorLineSign = { link = "CursorLine" },

    -- Sign/fold column
    SignColumn = { fg = p.fg, bg = gutter_bg },
    FoldColumn = { fg = p.comment, bg = gutter_bg },
    Folded = { fg = p.folded, bg = p.cursorline },

    -- Visual selection
    Visual = { bg = p.selection },
    VisualNOS = { link = "Visual" },

    -- Search
    -- Note: JetBrains uses a boxed effect (border) around search results which
    -- Neovim cannot replicate. We use selection color instead of the source's
    -- black background + teal border combination.
    Search = { bg = p.selection },
    IncSearch = { bg = p.selection, bold = true },
    CurSearch = { link = "IncSearch" },
    Substitute = { bg = p.diff_change, bold = true },

    -- Matching
    MatchParen = { fg = p.match_brace, bold = true },

    -- Popup menu
    Pmenu = { fg = p.fg, bg = p.pmenu or float_bg },
    PmenuSel = { bg = p.pmenu_sel or p.selection },
    PmenuSbar = { bg = p.pmenu or float_bg },
    PmenuThumb = { bg = p.comment },
    PmenuKind = { fg = p.type },
    PmenuKindSel = { fg = p.type, bg = p.pmenu_sel or p.selection },
    PmenuExtra = { fg = p.comment },
    PmenuExtraSel = { fg = p.comment, bg = p.pmenu_sel or p.selection },

    -- Messages
    ModeMsg = { fg = p.fg, bold = true },
    MsgArea = { fg = p.fg },
    MoreMsg = { fg = p.accent },
    Question = { fg = p.accent },
    ErrorMsg = { fg = p.error, bold = true },
    WarningMsg = { fg = p.warning, bold = true },

    -- Splits/windows
    WinSeparator = { fg = p.separator },
    VertSplit = { link = "WinSeparator" },
    WinBar = { fg = p.fg, bg = p.winbar or bg },
    WinBarNC = { fg = p.comment, bg = p.winbar or bg },

    -- Statusline/tabline
    StatusLine = { fg = p.fg, bg = p.cursorline },
    StatusLineNC = { fg = p.comment, bg = bg },
    TabLine = { fg = p.comment, bg = bg },
    TabLineFill = { bg = bg },
    TabLineSel = { fg = p.fg, bg = p.cursorline, sp = p.tab_underline, underline = true },

    -- Columns
    ColorColumn = { bg = p.colorcolumn },

    -- Whitespace/special
    Whitespace = { fg = p.whitespace },
    NonText = { fg = p.nontext },
    SpecialKey = { fg = p.nontext },
    EndOfBuffer = { fg = p.bg },

    -- Diff
    DiffAdd = { bg = p.diff_add_attr or p.diff_add },
    DiffChange = { bg = p.diff_change_attr or p.diff_change },
    DiffDelete = { bg = p.diff_delete_attr or p.diff_delete },
    DiffText = { bg = p.diff_text, bold = true },
    Added = { fg = p.git_add },
    Changed = { fg = p.git_change },
    Removed = { fg = p.git_delete },

    -- Spelling
    SpellBad = { sp = p.spell_bad, undercurl = true },
    SpellCap = { sp = p.spell_cap, undercurl = true },
    SpellLocal = { sp = p.info, undercurl = true },
    SpellRare = { sp = p.hint, undercurl = true },

    -- Diagnostics
    DiagnosticError = { fg = p.error },
    DiagnosticWarn = { fg = p.warning },
    DiagnosticInfo = { fg = p.info },
    DiagnosticHint = { fg = p.hint },
    DiagnosticOk = { fg = p.git_add },
    DiagnosticUnderlineError = { sp = p.error, undercurl = true },
    DiagnosticUnderlineWarn = { sp = p.warning, undercurl = true },
    DiagnosticUnderlineInfo = { sp = p.info, undercurl = true },
    DiagnosticUnderlineHint = { sp = p.hint, undercurl = true },
    DiagnosticUnderlineOk = { sp = p.git_add, undercurl = true },
    DiagnosticVirtualTextError = { fg = p.error, italic = true },
    DiagnosticVirtualTextWarn = { fg = p.warning, italic = true },
    DiagnosticVirtualTextInfo = { fg = p.info, italic = true },
    DiagnosticVirtualTextHint = { fg = p.hint, italic = true },
    DiagnosticVirtualTextOk = { fg = p.git_add, italic = true },
    DiagnosticFloatingError = { fg = p.error },
    DiagnosticFloatingWarn = { fg = p.warning },
    DiagnosticFloatingInfo = { fg = p.info },
    DiagnosticFloatingHint = { fg = p.hint },
    DiagnosticFloatingOk = { fg = p.git_add },
    DiagnosticSignError = { fg = p.error, bg = gutter_bg },
    DiagnosticSignWarn = { fg = p.warning, bg = gutter_bg },
    DiagnosticSignInfo = { fg = p.info, bg = gutter_bg },
    DiagnosticSignHint = { fg = p.hint, bg = gutter_bg },
    DiagnosticSignOk = { fg = p.git_add, bg = gutter_bg },
    DiagnosticUnnecessary = { fg = p.unused, italic = true },
    DiagnosticDeprecated = { sp = p.deprecated, strikethrough = true },

    -- Standard syntax groups
    Comment = vim.tbl_extend("force", { fg = p.comment }, comment_style),
    Constant = vim.tbl_extend("force", { fg = p.constant }, constant_style),
    String = { fg = p.string },
    Character = { fg = p.string },
    Number = { fg = p.number },
    Boolean = { fg = p.boolean },
    Float = { fg = p.number },

    Identifier = { fg = p.identifier or p.fg },
    Function = { fg = p.func_decl or p.func_call },

    Statement = vim.tbl_extend("force", { fg = p.keyword }, keyword_style),
    Conditional = { link = "Statement" },
    Repeat = { link = "Statement" },
    Label = { fg = p.keyword2 or p.keyword },
    Operator = { fg = p.operator },
    Keyword = vim.tbl_extend("force", { fg = p.keyword }, keyword_style),
    Exception = { fg = p.keyword4 or p.keyword },

    PreProc = { fg = p.attribute },
    Include = { fg = p.keyword },
    Define = { fg = p.keyword },
    Macro = { fg = p.attribute },
    PreCondit = { fg = p.keyword },

    Type = { fg = p.type },
    StorageClass = { fg = p.keyword },
    Structure = { fg = p.type },
    Typedef = { fg = p.type },

    Special = { fg = p.accent },
    SpecialChar = { fg = p.string_escape or p.entity },
    Tag = { fg = p.tag },
    Delimiter = { fg = p.delimiter or p.fg },
    SpecialComment = { fg = p.comment, bold = true },
    Debug = { fg = p.warning },

    Underlined = { fg = p.link, underline = true },
    Ignore = { fg = p.comment },
    Error = { fg = p.error },
    Todo = vim.tbl_extend("force", { fg = p.todo }, todo_style),

    -- LSP
    -- Note: JetBrains uses boxed effect for identifier under caret which
    -- Neovim cannot replicate. We use selection color instead.
    LspReferenceText = { bg = p.selection },
    LspReferenceRead = { bg = p.selection },
    LspReferenceWrite = { bg = p.selection, bold = true },
    LspSignatureActiveParameter = { bg = p.selection },
    LspCodeLens = { fg = p.comment },
    LspCodeLensSeparator = { fg = p.separator },
    LspInlayHint = { fg = p.inlay_hint or p.comment, italic = true },

    -- Treesitter
    ["@variable"] = { fg = p.variable or p.fg },
    ["@variable.builtin"] = { fg = p.keyword3 or p.keyword, italic = true },
    ["@variable.parameter"] = { fg = p.parameter or p.fg },
    ["@variable.member"] = { fg = p.field or p.fg },

    ["@constant"] = { link = "Constant" },
    ["@constant.builtin"] = { fg = p.constant, italic = true },
    ["@constant.macro"] = { link = "Macro" },

    ["@module"] = { fg = p.type },
    ["@label"] = { fg = p.keyword2 or p.keyword },

    ["@string"] = { link = "String" },
    ["@string.documentation"] = { fg = p.comment },
    ["@string.escape"] = { fg = p.string_escape or p.entity },
    ["@string.regexp"] = { fg = p.keyword3 or p.string },
    ["@string.special"] = { fg = p.entity },
    ["@string.special.symbol"] = { fg = p.constant },
    ["@string.special.url"] = { fg = p.link, underline = true },
    ["@string.special.path"] = { fg = p.string },

    ["@character"] = { link = "Character" },
    ["@character.special"] = { fg = p.entity },

    ["@boolean"] = { link = "Boolean" },
    ["@number"] = { link = "Number" },
    ["@number.float"] = { link = "Float" },

    ["@type"] = { link = "Type" },
    ["@type.builtin"] = { fg = p.type, italic = true },
    ["@type.definition"] = { fg = p.type },
    ["@type.qualifier"] = { fg = p.keyword },

    ["@attribute"] = { fg = p.attribute },
    ["@property"] = { fg = p.field or p.fg },

    ["@function"] = { link = "Function" },
    ["@function.builtin"] = { fg = p.func_call, italic = true },
    ["@function.call"] = { fg = p.func_call },
    ["@function.macro"] = { link = "Macro" },
    ["@function.method"] = { fg = p.func_call },
    ["@function.method.call"] = { fg = p.func_call },

    ["@constructor"] = { fg = p.type },

    ["@operator"] = { link = "Operator" },

    ["@keyword"] = { link = "Keyword" },
    ["@keyword.coroutine"] = { fg = p.keyword2 or p.keyword },
    ["@keyword.function"] = { link = "Keyword" },
    ["@keyword.operator"] = { fg = p.operator },
    ["@keyword.import"] = { link = "Include" },
    ["@keyword.storage"] = { link = "StorageClass" },
    ["@keyword.repeat"] = { link = "Repeat" },
    ["@keyword.return"] = { fg = p.keyword3 or p.keyword },
    ["@keyword.debug"] = { link = "Debug" },
    ["@keyword.exception"] = { link = "Exception" },
    ["@keyword.conditional"] = { link = "Conditional" },
    ["@keyword.conditional.ternary"] = { fg = p.operator },
    ["@keyword.directive"] = { link = "PreProc" },
    ["@keyword.directive.define"] = { link = "Define" },
    ["@keyword.modifier"] = { fg = p.keyword2 or p.keyword },

    ["@punctuation.delimiter"] = { fg = p.delimiter or p.fg },
    ["@punctuation.bracket"] = { fg = p.bracket or p.fg },
    ["@punctuation.special"] = { fg = p.operator },

    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { link = "Comment" },
    ["@comment.error"] = { fg = p.error, bold = true },
    ["@comment.warning"] = { fg = p.warning, bold = true },
    ["@comment.todo"] = { link = "Todo" },
    ["@comment.note"] = { fg = p.info, bold = true },

    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.heading"] = { fg = p.md_h1 or p.type, bold = true },
    ["@markup.heading.1"] = { fg = p.md_h1 or p.type, bold = true },
    ["@markup.heading.2"] = { fg = p.md_h2 or p.type, bold = true },
    ["@markup.heading.3"] = { fg = p.md_h3 or p.type, bold = true },
    ["@markup.heading.4"] = { fg = p.md_h4 or p.type, bold = true },
    ["@markup.heading.5"] = { fg = p.md_h5 or p.type, bold = true },
    ["@markup.heading.6"] = { fg = p.md_h6 or p.type, bold = true },
    ["@markup.quote"] = { fg = p.md_quote or p.comment, italic = true },
    ["@markup.math"] = { fg = p.number },
    ["@markup.environment"] = { fg = p.attribute },
    ["@markup.link"] = { fg = p.link, underline = true },
    ["@markup.link.label"] = { fg = p.md_link or p.link },
    ["@markup.link.url"] = { fg = p.md_url or p.link, underline = true },
    ["@markup.raw"] = { fg = p.md_code or p.string },
    ["@markup.raw.block"] = { fg = p.md_code_block or p.string },
    ["@markup.list"] = { fg = p.md_list or p.operator },
    ["@markup.list.checked"] = { fg = p.git_add },
    ["@markup.list.unchecked"] = { fg = p.comment },

    ["@tag"] = { fg = p.tag },
    ["@tag.attribute"] = { fg = p.tag_attr },
    ["@tag.delimiter"] = { fg = p.delimiter or p.fg },
    ["@tag.builtin"] = { fg = p.tag, italic = true },

    ["@diff.plus"] = { link = "DiffAdd" },
    ["@diff.minus"] = { link = "DiffDelete" },
    ["@diff.delta"] = { link = "DiffChange" },

    -- LSP semantic tokens
    ["@lsp.type.class"] = { link = "Type" },
    ["@lsp.type.comment"] = {},  -- Defer to treesitter
    ["@lsp.type.decorator"] = { link = "@attribute" },
    ["@lsp.type.enum"] = { link = "Type" },
    ["@lsp.type.enumMember"] = { link = "Constant" },
    ["@lsp.type.event"] = { link = "Type" },
    ["@lsp.type.function"] = { link = "Function" },
    ["@lsp.type.interface"] = { fg = p.interface or p.type },
    ["@lsp.type.keyword"] = { link = "Keyword" },
    ["@lsp.type.macro"] = { link = "Macro" },
    ["@lsp.type.method"] = { link = "Function" },
    ["@lsp.type.modifier"] = { link = "@keyword.modifier" },
    ["@lsp.type.namespace"] = { link = "@module" },
    ["@lsp.type.number"] = { link = "Number" },
    ["@lsp.type.operator"] = { link = "Operator" },
    ["@lsp.type.parameter"] = { link = "@variable.parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.regexp"] = { link = "@string.regexp" },
    ["@lsp.type.string"] = { link = "String" },
    ["@lsp.type.struct"] = { link = "Type" },
    ["@lsp.type.type"] = { link = "Type" },
    ["@lsp.type.typeParameter"] = { fg = p.type_param or p.type },
    ["@lsp.type.variable"] = {},  -- Defer to treesitter

    ["@lsp.mod.declaration"] = {},
    ["@lsp.mod.definition"] = {},
    ["@lsp.mod.readonly"] = { italic = true },
    ["@lsp.mod.static"] = { italic = true },
    ["@lsp.mod.deprecated"] = { strikethrough = true },
    ["@lsp.mod.abstract"] = { italic = true },
    ["@lsp.mod.async"] = { italic = true },
    ["@lsp.mod.modification"] = {},
    ["@lsp.mod.documentation"] = {},
    ["@lsp.mod.defaultLibrary"] = { italic = true },

    ["@lsp.typemod.function.declaration"] = { fg = p.func_decl },
    ["@lsp.typemod.function.defaultLibrary"] = { fg = p.func_call, italic = true },
    ["@lsp.typemod.variable.readonly"] = { link = "Constant" },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    ["@lsp.typemod.parameter.declaration"] = { link = "@variable.parameter" },

    -- Rainbow delimiters
    RainbowDelimiterRed = { fg = p.rainbow_red },
    RainbowDelimiterYellow = { fg = p.rainbow_yellow },
    RainbowDelimiterGreen = { fg = p.rainbow_green },
    RainbowDelimiterCyan = { fg = p.rainbow_cyan },
    RainbowDelimiterBlue = { fg = p.rainbow_blue },
    RainbowDelimiterViolet = { fg = p.rainbow_violet },
    RainbowDelimiterOrange = { fg = p.number },

    -- Indent-blankline
    IblIndent = { fg = p.indent_guide },
    IblScope = { fg = p.accent },
    IndentBlanklineChar = { fg = p.indent_guide },
    IndentBlanklineContextChar = { fg = p.accent },

    -- GitSigns
    GitSignsAdd = { fg = p.git_add, bg = gutter_bg },
    GitSignsChange = { fg = p.git_change, bg = gutter_bg },
    GitSignsDelete = { fg = p.git_delete, bg = gutter_bg },
    GitSignsCurrentLineBlame = { fg = p.blame or p.comment, italic = true },
    GitSignsAddNr = { fg = p.git_add },
    GitSignsChangeNr = { fg = p.git_change },
    GitSignsDeleteNr = { fg = p.git_delete },
    GitSignsAddLn = { bg = p.diff_add },
    GitSignsChangeLn = { bg = p.diff_change },
    GitSignsDeleteLn = { bg = p.diff_delete },
    GitSignsAddPreview = { link = "DiffAdd" },
    GitSignsDeletePreview = { link = "DiffDelete" },

    -- Telescope
    TelescopeNormal = { fg = p.fg, bg = float_bg },
    TelescopeBorder = { fg = p.separator, bg = float_bg },
    TelescopeTitle = { fg = p.accent, bold = true },
    TelescopePromptPrefix = { fg = p.accent },
    TelescopePromptCounter = { fg = p.comment },
    TelescopeSelection = { bg = p.selection },
    TelescopeSelectionCaret = { fg = p.accent, bg = p.selection },
    TelescopeMatching = { fg = p.accent, bold = true },
    TelescopeResultsTitle = { fg = p.accent },
    TelescopePreviewTitle = { fg = p.accent },
    TelescopeResultsNormal = { fg = p.fg, bg = float_bg },
    TelescopePreviewNormal = { fg = p.fg, bg = float_bg },

    -- NvimTree
    NvimTreeNormal = { fg = p.fg, bg = bg },
    NvimTreeNormalNC = { link = "NvimTreeNormal" },
    NvimTreeRootFolder = { fg = p.accent, bold = true },
    NvimTreeFolderName = { fg = p.fg },
    NvimTreeFolderIcon = { fg = p.accent },
    NvimTreeOpenedFolderName = { fg = p.accent },
    NvimTreeEmptyFolderName = { fg = p.comment },
    NvimTreeSymlink = { fg = p.link },
    NvimTreeSpecialFile = { fg = p.accent },
    NvimTreeImageFile = { fg = p.fg },
    NvimTreeIndentMarker = { fg = p.indent_guide },
    NvimTreeGitNew = { fg = p.git_add },
    NvimTreeGitDirty = { fg = p.git_change },
    NvimTreeGitDeleted = { fg = p.git_delete },
    NvimTreeGitStaged = { fg = p.git_add },

    -- Neo-tree
    NeoTreeNormal = { fg = p.fg, bg = bg },
    NeoTreeNormalNC = { link = "NeoTreeNormal" },
    NeoTreeDirectoryName = { fg = p.fg },
    NeoTreeDirectoryIcon = { fg = p.accent },
    NeoTreeRootName = { fg = p.accent, bold = true },
    NeoTreeFileName = { fg = p.fg },
    NeoTreeFileIcon = { fg = p.fg },
    NeoTreeSymbolicLinkTarget = { fg = p.link },
    NeoTreeIndentMarker = { fg = p.indent_guide },
    NeoTreeGitAdded = { fg = p.git_add },
    NeoTreeGitModified = { fg = p.git_change },
    NeoTreeGitDeleted = { fg = p.git_delete },
    NeoTreeGitUntracked = { fg = p.git_add },

    -- Lualine (inherits from base groups mostly)
    -- These provide a base; lualine themes can override

    -- Which-key
    WhichKey = { fg = p.accent },
    WhichKeyGroup = { fg = p.keyword },
    WhichKeyDesc = { fg = p.fg },
    WhichKeySeperator = { fg = p.comment },
    WhichKeySeparator = { fg = p.comment },
    WhichKeyFloat = { bg = float_bg },
    WhichKeyValue = { fg = p.comment },

    -- Lazy.nvim
    LazyH1 = { fg = p.bg, bg = p.accent, bold = true },
    LazyH2 = { fg = p.accent, bold = true },
    LazyReasonPlugin = { fg = p.accent },
    LazyReasonEvent = { fg = p.keyword },
    LazyReasonStart = { fg = p.git_add },
    LazyReasonCmd = { fg = p.type },
    LazyReasonFt = { fg = p.string },
    LazyReasonKeys = { fg = p.keyword2 or p.keyword },
    LazyButton = { bg = p.cursorline },
    LazyButtonActive = { bg = p.selection },

    -- Mason
    MasonHeader = { fg = p.bg, bg = p.accent, bold = true },
    MasonHighlight = { fg = p.accent },
    MasonHighlightSecondary = { fg = p.keyword },
    MasonMuted = { fg = p.comment },

    -- Notify
    NotifyERRORBorder = { fg = p.error },
    NotifyWARNBorder = { fg = p.warning },
    NotifyINFOBorder = { fg = p.info },
    NotifyDEBUGBorder = { fg = p.comment },
    NotifyTRACEBorder = { fg = p.hint },
    NotifyERRORIcon = { fg = p.error },
    NotifyWARNIcon = { fg = p.warning },
    NotifyINFOIcon = { fg = p.info },
    NotifyDEBUGIcon = { fg = p.comment },
    NotifyTRACEIcon = { fg = p.hint },
    NotifyERRORTitle = { fg = p.error },
    NotifyWARNTitle = { fg = p.warning },
    NotifyINFOTitle = { fg = p.info },
    NotifyDEBUGTitle = { fg = p.comment },
    NotifyTRACETitle = { fg = p.hint },
    NotifyBackground = { bg = float_bg },

    -- Noice
    NoiceCmdline = { fg = p.fg },
    NoiceCmdlineIcon = { fg = p.accent },
    NoiceCmdlinePopup = { fg = p.fg, bg = float_bg },
    NoiceCmdlinePopupBorder = { fg = p.separator },
    NoiceConfirm = { bg = float_bg },
    NoiceConfirmBorder = { fg = p.separator },

    -- Cmp
    CmpItemAbbr = { fg = p.fg },
    CmpItemAbbrDeprecated = { fg = p.unused, strikethrough = true },
    CmpItemAbbrMatch = { fg = p.accent, bold = true },
    CmpItemAbbrMatchFuzzy = { fg = p.accent },
    CmpItemKind = { fg = p.type },
    CmpItemKindClass = { fg = p.type },
    CmpItemKindColor = { fg = p.constant },
    CmpItemKindConstant = { fg = p.constant },
    CmpItemKindConstructor = { fg = p.type },
    CmpItemKindEnum = { fg = p.type },
    CmpItemKindEnumMember = { fg = p.constant },
    CmpItemKindEvent = { fg = p.type },
    CmpItemKindField = { fg = p.field or p.fg },
    CmpItemKindFile = { fg = p.fg },
    CmpItemKindFolder = { fg = p.accent },
    CmpItemKindFunction = { fg = p.func_call },
    CmpItemKindInterface = { fg = p.interface or p.type },
    CmpItemKindKeyword = { fg = p.keyword },
    CmpItemKindMethod = { fg = p.func_call },
    CmpItemKindModule = { fg = p.type },
    CmpItemKindOperator = { fg = p.operator },
    CmpItemKindProperty = { fg = p.field or p.fg },
    CmpItemKindReference = { fg = p.type },
    CmpItemKindSnippet = { fg = p.accent },
    CmpItemKindStruct = { fg = p.type },
    CmpItemKindText = { fg = p.fg },
    CmpItemKindTypeParameter = { fg = p.type_param or p.type },
    CmpItemKindUnit = { fg = p.number },
    CmpItemKindValue = { fg = p.constant },
    CmpItemKindVariable = { fg = p.variable or p.fg },
    CmpItemMenu = { fg = p.comment },

    -- Navic/breadcrumbs
    NavicText = { fg = p.fg },
    NavicSeparator = { fg = p.separator },
    NavicIconsFile = { fg = p.fg },
    NavicIconsModule = { fg = p.type },
    NavicIconsNamespace = { fg = p.type },
    NavicIconsPackage = { fg = p.type },
    NavicIconsClass = { fg = p.type },
    NavicIconsMethod = { fg = p.func_call },
    NavicIconsProperty = { fg = p.field or p.fg },
    NavicIconsField = { fg = p.field or p.fg },
    NavicIconsConstructor = { fg = p.type },
    NavicIconsEnum = { fg = p.type },
    NavicIconsInterface = { fg = p.interface or p.type },
    NavicIconsFunction = { fg = p.func_call },
    NavicIconsVariable = { fg = p.variable or p.fg },
    NavicIconsConstant = { fg = p.constant },
    NavicIconsString = { fg = p.string },
    NavicIconsNumber = { fg = p.number },
    NavicIconsBoolean = { fg = p.boolean },
    NavicIconsArray = { fg = p.type },
    NavicIconsObject = { fg = p.type },
    NavicIconsKey = { fg = p.keyword },
    NavicIconsNull = { fg = p.constant },
    NavicIconsEnumMember = { fg = p.constant },
    NavicIconsStruct = { fg = p.type },
    NavicIconsEvent = { fg = p.type },
    NavicIconsOperator = { fg = p.operator },
    NavicIconsTypeParameter = { fg = p.type_param or p.type },

    -- DAP
    DapBreakpoint = { fg = p.error },
    DapBreakpointCondition = { fg = p.warning },
    DapBreakpointRejected = { fg = p.comment },
    DapLogPoint = { fg = p.info },
    DapStopped = { fg = p.git_add },
    DapStoppedLine = { bg = p.cursorline },
    debugPC = { bg = p.cursorline },
    DapUIValue = { fg = p.number },
    DapUIVariable = { fg = p.variable or p.fg },
    DapUIScope = { fg = p.accent },
    DapUIType = { fg = p.type },
    DapUIModifiedValue = { fg = p.warning, bold = true },
    DapUIDecoration = { fg = p.accent },
    DapUIThread = { fg = p.git_add },
    DapUIStoppedThread = { fg = p.accent },
    DapUISource = { fg = p.string },
    DapUILineNumber = { fg = p.linenr },
    DapUIFloatBorder = { fg = p.separator },
    DapUIWatchesValue = { fg = p.git_add },
    DapUIWatchesEmpty = { fg = p.error },
    DapUIWatchesError = { fg = p.error },
    DapUIBreakpointsPath = { fg = p.accent },
    DapUIBreakpointsInfo = { fg = p.info },
    DapUIBreakpointsCurrentLine = { fg = p.accent, bold = true },
    DapUIBreakpointsDisabledLine = { fg = p.comment },

    -- Flash
    FlashLabel = { fg = p.bg, bg = p.accent, bold = true },
    FlashMatch = { bg = p.selection },
    FlashCurrent = { bg = p.selection, bold = true },
    FlashBackdrop = { fg = p.comment },

    -- Leap
    LeapMatch = { fg = p.accent, bold = true, underline = true },
    LeapLabelPrimary = { fg = p.bg, bg = p.accent, bold = true },
    LeapLabelSecondary = { fg = p.bg, bg = p.keyword2 or p.accent, bold = true },
    LeapBackdrop = { fg = p.comment },

    -- Trouble
    TroubleNormal = { fg = p.fg, bg = bg },
    TroubleText = { fg = p.fg },
    TroubleCount = { fg = p.accent, bold = true },
    TroubleFile = { fg = p.fg },
    TroubleFoldIcon = { fg = p.comment },
    TroubleLocation = { fg = p.comment },
    TroublePreview = { bg = p.cursorline },
    TroubleSignError = { fg = p.error },
    TroubleSignWarning = { fg = p.warning },
    TroubleSignInformation = { fg = p.info },
    TroubleSignHint = { fg = p.hint },

    -- Mini
    MiniCursorword = { bg = p.selection },
    MiniCursorwordCurrent = { bg = p.selection },
    MiniIndentscopeSymbol = { fg = p.accent },
    MiniIndentscopePrefix = { nocombine = true },
    MiniJump = { fg = p.bg, bg = p.accent },
    MiniJump2dSpot = { fg = p.accent, bold = true },
    MiniStatuslineDevinfo = { fg = p.fg, bg = p.cursorline },
    MiniStatuslineFileinfo = { fg = p.fg, bg = p.cursorline },
    MiniStatuslineFilename = { fg = p.comment, bg = bg },
    MiniStatuslineInactive = { fg = p.comment, bg = bg },
    MiniStatuslineModeCommand = { fg = p.bg, bg = p.warning, bold = true },
    MiniStatuslineModeInsert = { fg = p.bg, bg = p.git_add, bold = true },
    MiniStatuslineModeNormal = { fg = p.bg, bg = p.accent, bold = true },
    MiniStatuslineModeOther = { fg = p.bg, bg = p.keyword2, bold = true },
    MiniStatuslineModeReplace = { fg = p.bg, bg = p.error, bold = true },
    MiniStatuslineModeVisual = { fg = p.bg, bg = p.keyword, bold = true },
    MiniSurround = { fg = p.bg, bg = p.accent },
    MiniTablineCurrent = { fg = p.fg, bg = p.cursorline },
    MiniTablineFill = { bg = bg },
    MiniTablineHidden = { fg = p.comment, bg = bg },
    MiniTablineModifiedCurrent = { fg = p.accent, bg = p.cursorline },
    MiniTablineModifiedHidden = { fg = p.accent, bg = bg },
    MiniTablineModifiedVisible = { fg = p.accent, bg = bg },
    MiniTablineTabpagesection = { fg = p.fg, bg = p.cursorline },
    MiniTablineVisible = { fg = p.fg, bg = bg },
    MiniTestEmphasis = { bold = true },
    MiniTestFail = { fg = p.error, bold = true },
    MiniTestPass = { fg = p.git_add, bold = true },
    MiniTrailspace = { bg = p.error },

    -- Headlines (markdown)
    Headline1 = { bg = p.cursorline },
    Headline2 = { bg = p.cursorline },
    Headline3 = { bg = p.cursorline },
    Headline4 = { bg = p.cursorline },
    Headline5 = { bg = p.cursorline },
    Headline6 = { bg = p.cursorline },
    CodeBlock = { bg = p.cursorline },
    Dash = { fg = p.comment },
    Quote = { fg = p.md_quote or p.comment, italic = true },

    -- Illuminate
    IlluminatedWordText = { bg = p.selection },
    IlluminatedWordRead = { bg = p.selection },
    IlluminatedWordWrite = { bg = p.selection },
  }

  -- Terminal colors (g:terminal_color_X)
  -- These are set separately in the main init.lua

  return groups
end

---Get terminal colors from palette
---@param p table Palette
---@return table Terminal colors 0-15
function M.terminal_colors(p)
  return {
    p.term_black or p.comment,       -- 0: black
    p.term_red or p.error,           -- 1: red
    p.term_green or p.git_add,       -- 2: green
    p.term_yellow or p.warning,      -- 3: yellow
    p.term_blue or p.func_call,      -- 4: blue
    p.term_magenta or p.keyword2,    -- 5: magenta
    p.term_cyan or p.keyword,        -- 6: cyan
    p.term_white or p.fg,            -- 7: white
    p.term_bright_black or p.comment, -- 8: bright black
    p.term_bright_red or p.error,     -- 9: bright red
    p.term_bright_green or p.git_add, -- 10: bright green
    p.term_bright_yellow or p.warning, -- 11: bright yellow
    p.term_bright_blue or p.func_call, -- 12: bright blue
    p.term_bright_magenta or p.keyword2, -- 13: bright magenta
    p.term_bright_cyan or p.keyword,  -- 14: bright cyan
    p.term_bright_white or p.fg,      -- 15: bright white
  }
end

return M
