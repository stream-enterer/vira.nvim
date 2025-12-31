-- Vira - A Neovim colorscheme
-- Ported from the Vira JetBrains theme

local M = {}

---@class ViraConfig
---@field variant? string Theme variant: "carbon" | "deepforest" | "graphene" | "ocean" | "palenight" | "teal"
---@field transparent? boolean Enable transparent background
---@field italic_comments? boolean Use italic for comments (default: true)
---@field on_colors? fun(colors: table): table Callback to modify palette colors
---@field on_highlights? fun(highlights: table, colors: table): table Callback to modify highlights

---@type ViraConfig
M.config = {
  variant = "carbon",
  transparent = false,
  italic_comments = true,
  on_colors = nil,
  on_highlights = nil,
}

local variants = {
  "carbon",
  "deepforest",
  "graphene",
  "ocean",
  "palenight",
  "teal",
}

---Check if variant is valid
---@param variant string
---@return boolean
local function is_valid_variant(variant)
  for _, v in ipairs(variants) do
    if v == variant then
      return true
    end
  end
  return false
end

---Load a palette
---@param variant string
---@return table
local function load_palette(variant)
  local ok, palette = pcall(require, "vira.palette." .. variant)
  if not ok then
    vim.notify("Vira: Failed to load palette '" .. variant .. "'", vim.log.levels.ERROR)
    return {}
  end
  return palette
end

---Apply highlight groups
---@param groups table<string, table>
local function apply_highlights(groups)
  for group, settings in pairs(groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

---Set terminal colors
---@param colors table
local function set_terminal_colors(colors)
  for i, color in ipairs(colors) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end
end

---Setup the colorscheme
---@param opts? ViraConfig
function M.setup(opts)
  opts = vim.tbl_deep_extend("force", M.config, opts or {})
  M.config = opts

  -- Validate variant
  if not is_valid_variant(opts.variant) then
    vim.notify(
      "Vira: Invalid variant '" .. opts.variant .. "'. Using 'carbon'.",
      vim.log.levels.WARN
    )
    opts.variant = "carbon"
  end

  -- Load palette
  local palette = load_palette(opts.variant)
  if vim.tbl_isempty(palette) then
    return
  end

  -- Allow user to modify colors
  if opts.on_colors then
    palette = opts.on_colors(palette) or palette
  end

  -- Get highlight groups
  local groups_module = require("vira.groups")
  local groups = groups_module.get(palette, opts)

  -- Allow user to modify highlights
  if opts.on_highlights then
    groups = opts.on_highlights(groups, palette) or groups
  end

  -- Clear existing highlights
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end

  -- Set vim options
  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "vira"
  vim.g.vira_variant = opts.variant

  -- Apply highlights
  apply_highlights(groups)

  -- Set terminal colors
  local term_colors = groups_module.terminal_colors(palette)
  set_terminal_colors(term_colors)
end

---Load theme (for use with :colorscheme)
function M.load()
  M.setup()
end

---Get available variants
---@return string[]
function M.variants()
  return vim.deepcopy(variants)
end

---Get current variant
---@return string
function M.current()
  return vim.g.vira_variant or M.config.variant
end

---Switch to a different variant
---@param variant string
function M.switch(variant)
  if not is_valid_variant(variant) then
    vim.notify("Vira: Invalid variant '" .. variant .. "'", vim.log.levels.ERROR)
    return
  end
  M.setup({ variant = variant })
end

return M
