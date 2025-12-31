# Vira.nvim

A Neovim colorscheme ported from the [Vira theme](https://vira.build/) for JetBrains IDEs.

## Variants

Six dark variants included:

| Variant | Background | Description |
|---------|------------|-------------|
| **Carbon** | `#0a0a0a` | Pure dark, high contrast |
| **Deepforest** | `#111816` | Dark with green undertones |
| **Graphene** | `#212121` | Material grey |
| **Ocean** | `#0f111a` | Deep blue-black |
| **Palenight** | `#292d3e` | Purple-grey |
| **Teal** | `#263238` | Blue-grey |

## Features

- Treesitter highlighting
- LSP semantic tokens
- Plugin support (Telescope, NvimTree, Neo-tree, GitSigns, Cmp, Lazy, Mason, Which-key, Trouble, DAP, Flash, Leap, Mini, and more)
- Terminal colors
- Customizable with callbacks

## Installation

### lazy.nvim

```lua
{
  "user/vira.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("vira").setup()
  end,
}
```

### packer.nvim

```lua
use {
  "user/vira.nvim",
  config = function()
    require("vira").setup()
  end
}
```

### vim-plug

```vim
Plug 'user/vira.nvim'
```

Then in your init.lua:
```lua
require("vira").setup()
```

### Manual

Clone to your pack directory:
```sh
git clone https://github.com/user/vira.nvim \
  ~/.local/share/nvim/site/pack/plugins/start/vira.nvim
```

## Configuration

```lua
require("vira").setup({
  -- Theme variant: "carbon" | "deepforest" | "graphene" | "ocean" | "palenight" | "teal"
  variant = "carbon",

  -- Transparent background
  transparent = false,

  -- Italic comments (default: true)
  italic_comments = true,

  -- Modify palette colors
  on_colors = function(colors)
    colors.accent = "#ff0000"
    return colors
  end,

  -- Modify highlight groups
  on_highlights = function(highlights, colors)
    highlights.Normal = { fg = colors.fg, bg = "#000000" }
    return highlights
  end,
})
```

### Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `variant` | string | `"carbon"` | Color variant to use |
| `transparent` | boolean | `false` | Transparent background |
| `italic_comments` | boolean | `true` | Italicize comments |
| `on_colors` | function | `nil` | Callback to modify palette |
| `on_highlights` | function | `nil` | Callback to modify highlights |

## API

```lua
-- Get available variants
require("vira").variants()  -- {"carbon", "deepforest", ...}

-- Get current variant
require("vira").current()   -- "carbon"

-- Switch variant at runtime
require("vira").switch("ocean")
```

## Acknowledgments

This is an independent port of the [Vira color theme](https://vira.build/) by Mattia Astorino ([@equinusocio](https://github.com/equinusocio)). Color values and design intent belong to the original author. This project is not affiliated with Vira Software.

## License

[MIT](LICENSE)
