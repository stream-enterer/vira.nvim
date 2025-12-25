# JetBrains Theme Schema

Complete documentation of JetBrains theme file format, verified against IntelliJ Community source code.

## Contents

1. [File Structure](#file-structure)
2. [File: *.theme.json](#file-themejson)
3. [File: *.xml](#file-xml-editor-scheme)
4. [Inheritance & Resolution](#inheritance--resolution)
5. [Indexed Patterns](#indexed-patterns)
6. [Statistics](#statistics-vira-carbon)

---

## File Structure

A JetBrains theme consists of two files:

| File | Format | Purpose |
|------|--------|---------|
| `*.theme.json` | JSON | UI chrome (colors, components, icons) |
| `*.xml` | XML | Editor scheme (syntax highlighting, editor colors) |

The `.theme.json` references the `.xml` via the `editorScheme` field.

### Color Format

**Verified:** Colors use **RRGGBBAA** format (alpha at end).

Source: `ColorHexUtil.java:33-35`

| Format | Example | Description |
|--------|---------|-------------|
| `#RRGGBB` | `#ff0000` | 6-digit opaque |
| `#RRGGBBAA` | `#ff000080` | 8-digit with alpha (50% opacity) |
| `RRGGBB` | `ff0000` | XML format (no `#` prefix) |

### Research Sources

- `platform/editor-ui-ex/src/com/intellij/openapi/editor/colors/impl/TextAttributesReader.java`
- `platform/editor-ui-ex/src/com/intellij/openapi/editor/colors/impl/EditorColorsSchemeImpl.java`
- `platform/editor-ui-ex/src/com/intellij/openapi/editor/colors/impl/AbstractColorsScheme.java`
- `platform/core-api/src/com/intellij/openapi/editor/markup/EffectType.java`
- `platform/util/src/com/intellij/ui/ColorHexUtil.java`

---

## File: *.theme.json

### Top-Level Structure

```json
{
  "name": "Vira Carbon",
  "dark": true,
  "author": "vira",
  "editorScheme": "/schemes/Vira-Carbon.xml",
  "colors": { },
  "ui": { },
  "icons": { }
}
```

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Display name |
| `dark` | boolean | Dark theme flag |
| `author` | string | Theme author |
| `editorScheme` | string | Path to .xml editor scheme |
| `colors` | object | Color variable definitions |
| `ui` | object | UI component styling |
| `icons` | object | Icon color palette |

---

### colors Section

Defines named color variables referenced elsewhere in `ui`.

```json
"colors": {
  "border": "#ffffff0f",
  "disabledForeground": "#45454a",
  "disabledBorder": "#45454a80",
  "disabledBackground": "#45454a80"
}
```

Referenced by name (without `#`) in `ui` values:

```json
"ui": {
  "*": {
    "borderColor": "border",
    "disabledText": "disabledForeground"
  }
}
```

---

### ui Section

UI component styling. 102 components in Vira.

#### Islands Flag

**Verified:** Enables modern card-based UI.

Source: `SearchReplaceComponent.java:114-119`

| Value | Effect |
|-------|--------|
| `"Islands": 0` | Classic UI (default) |
| `"Islands": 1` | Modern Islands UI with rounded cards |

#### Wildcard Defaults

The `*` key provides fallback values for all components:

```json
"*": {
  "background": "#0a0a0a",
  "foreground": "#d9d9d9",
  "selectionBackground": "#47474780"
}
```

#### Value Types

| Type | Example | Description |
|------|---------|-------------|
| Hex color | `"#0a0a0a"` | Color value |
| Variable | `"border"` | Reference to `colors.border` |
| Integer | `24` | Pixel value or flag |
| Float | `0.44` | Opacity/ratio |
| Dimension | `"72,28"` | Width,height in pixels |
| Padding | `"1,9,1,6"` | Top,right,bottom,left |
| Insets+color | `"1,1,1,1,0a0a0a"` | Insets with hex color |
| Class | `"com.intellij...Border"` | Java class reference |
| Boolean | `false` | Flag |

#### OS-Specific Values

Properties can vary by platform:

```json
"Island": {
  "inactiveAlphaInStatusBar": {
    "os.mac": 0.2,
    "os.windows": 0.2,
    "os.linux": 0.15
  }
}
```

#### Compact Mode Variants

Properties can have compact mode alternates:

```json
"Island": {
  "arc": 20,
  "arc.compact": 16
}
```

#### Common Properties

| Property | Description |
|----------|-------------|
| `background` | Background color |
| `foreground` | Text color |
| `borderColor` | Border color |
| `selectionBackground` | Selected item background |
| `selectionForeground` | Selected item text |
| `hoverBackground` | Hover state |
| `pressedBackground` | Pressed state |
| `disabledForeground` | Disabled state |

#### Numeric Properties

| Property | Example | Description |
|----------|---------|-------------|
| `arc` | `8` | Corner radius |
| `rowHeight` | `24` | List row height |
| `tabHeight` | `40` | Tab height |
| `iconSize` | `24` | Icon dimensions |
| `iconTextGap` | `4` | Icon-to-text spacing |

#### Alpha Properties

| Property | Example | Description |
|----------|---------|-------------|
| `inactiveAlpha` | `0.44` | Inactive opacity (0-1) |
| `backgroundOpacity` | `60` | Background opacity (0-100) |
| `saturation` | `0.6` | Color saturation |
| `brightness` | `0.6` | Color brightness |

See `appendix-ui-components.md` for complete component listing.

---

### icons Section

Icon color palette. 36 keys in Vira.

| Category | Keys | Description |
|----------|------|-------------|
| `Actions.*` | 6 | Action icon colors |
| `Objects.*` | 10 | Object icon colors |
| `Checkbox.*` | 13 | Checkbox state colors |
| `Tree.iconColor` | 1 | Tree view icons |
| Top-level colors | 6 | `Blue`, `Green`, `Yellow`, etc. |

---

## File: *.xml (Editor Scheme)

### Top-Level Structure

```xml
<scheme name="Vira Carbon" version="1" parent_scheme="Darcula">
  <option name="LINE_SPACING" value="1.4" />
  <option name="EDITOR_LIGATURES" value="true" />
  <colors>...</colors>
  <attributes>...</attributes>
</scheme>
```

| Attribute | Description |
|-----------|-------------|
| `name` | Display name |
| `version` | Schema version |
| `parent_scheme` | Inheritance parent |

---

### colors Section

Editor chrome colors. 157 keys in Vira. No `#` prefix in XML.

| Category | Count | Examples |
|----------|-------|----------|
| Core editor | 16 | `CARET_COLOR`, `SELECTION_BACKGROUND` |
| Terminal | 14 | `BLOCK_TERMINAL_*` |
| Diagram | 22 | `DIAGRAM_*` |
| File status | 16 | `FILESTATUS_*` |
| Scrollbar | 16 | `ScrollBar.*` |
| VCS | 6 | `VCS_ANNOTATIONS_COLOR_*` |
| Other | 67 | Various |

#### Core Editor Colors

| Key | Description |
|-----|-------------|
| `CARET_COLOR` | Cursor |
| `CARET_ROW_COLOR` | Current line highlight |
| `SELECTION_BACKGROUND` | Selected text |
| `LINE_NUMBERS_COLOR` | Line numbers |
| `GUTTER_BACKGROUND` | Gutter |
| `INDENT_GUIDE` | Indentation guides |
| `RIGHT_MARGIN_COLOR` | Column ruler |

See `appendix-xml-colors.md` for complete listing.

---

### attributes Section

Syntax highlighting. 290 keys in Vira.

#### Attribute Structure

```xml
<option name="DEFAULT_KEYWORD">
  <value>
    <option name="FOREGROUND" value="6ebad7" />
    <option name="FONT_TYPE" value="1" />
  </value>
</option>
```

| Property | Type | Description |
|----------|------|-------------|
| `FOREGROUND` | hex | Text color |
| `BACKGROUND` | hex | Background color |
| `EFFECT_COLOR` | hex | Underline/effect color |
| `ERROR_STRIPE_COLOR` | hex | Error stripe marker |
| `FONT_TYPE` | 0-3 | Font style |
| `EFFECT_TYPE` | 0-6 | Effect style |
| `baseAttributes` | string | Inherit from named attribute |

#### FONT_TYPE Values

**Verified:** `TextAttributesReader.java:120-136`

| Value | Style |
|-------|-------|
| 0 | Plain |
| 1 | Bold |
| 2 | Italic |
| 3 | Bold + Italic |

#### EFFECT_TYPE Values

**Verified:** `TextAttributesReader.java:99-117`

| Value | Effect |
|-------|--------|
| 0 | Box border |
| 1 | Underline |
| 2 | Wave underline |
| 3 | Strikethrough |
| 4 | Bold underline |
| 5 | Dotted underline |
| 6 | Faded |

#### EFFECT_TYPE Without EFFECT_COLOR

When `EFFECT_TYPE` is set without `EFFECT_COLOR`, the effect uses `FOREGROUND`:

```json
"DEFAULT_CLASS_NAME": {
  "FOREGROUND": "#d5b05f",
  "EFFECT_TYPE": "5"
}
```

Result: dotted underline in `#d5b05f`.

#### Attribute Categories

| Prefix | Count | Description |
|--------|-------|-------------|
| `DEFAULT_*` | 32 | Core language tokens |
| `CONSOLE_*` | 21 | Terminal ANSI colors |
| `BLOCK_TERMINAL_*` | 20 | Terminal blocks |
| `MARKDOWN_*` | 21 | Markdown |
| `CSS.*` | 13 | CSS |
| `CodeWithMe.*` | 12 | Collaborative editing |
| `GO_*` | 12 | Go |
| `KOTLIN_*` | 10 | Kotlin |
| `JS.*` | 9 | JavaScript |
| Other | 140 | Various |

See `appendix-xml-attributes.md` for complete listing.

---

## Inheritance & Resolution

### Three Value States

**Verified:** `AbstractColorsScheme.java:41-43`

| State | Representation | Meaning |
|-------|----------------|---------|
| Explicit value | `"#rrggbb"` | Use this value |
| Explicit null | `""` (empty string) | No value; don't inherit |
| Inherited | Key missing | Look up parent chain |

Important distinction:
- `""` (empty string) = "I want nothing here"
- Missing key = "Use whatever the parent has"
- `{}` (empty object) = Explicit empty, **not** inherited

### parent_scheme Resolution

**Verified:** `EditorColorsSchemeImpl.java:94-114`

Vira inherits from Darcula, which inherits from Default:

```
Vira → Darcula → Default → hardcoded defaults
```

Resolution order:
1. Check current scheme's directly defined value
2. Check `fallbackAttributeKey` (if defined in code)
3. Check parent scheme recursively

### baseAttributes vs fallbackAttributeKey

Two separate inheritance mechanisms:

| Mechanism | Defined In | Controlled By |
|-----------|------------|---------------|
| `baseAttributes` | XML theme file | Theme author |
| `fallbackAttributeKey` | Java source code | Plugin developer |

The XML `baseAttributes` takes precedence when present.

### Orphan Effects

**Verified:** Some attributes define only `EFFECT_TYPE` with no color source.

Source: `KotlinHighlightingColors.java:57,63`

| Attribute | Definition | Resolution |
|-----------|------------|------------|
| `KOTLIN_MUTABLE_VARIABLE` | `{EFFECT_TYPE: 1}` | Uses parent's foreground |
| `KOTLIN_BACKING_FIELD_VARIABLE` | `{FONT_TYPE: 1, EFFECT_TYPE: 1}` | Uses parent's foreground |
| `TERMINAL_CLASS_NAME_LOG_REFERENCE` | `{EFFECT_TYPE: 5}` | Uses parent's foreground |

These fall through to `parentScheme.getAttributes()` for color.

### Explicitly Empty Attributes

These define `<value/>` with no properties—explicitly no styling:

- `CONSOLE_RANGE_TO_EXECUTE`
- `LIVE_TEMPLATE_ATTRIBUTES`
- `LIVE_TEMPLATE_INACTIVE_SEGMENT`
- `DUPLICATE_FROM_SERVER`
- `HTTP_REQUEST_MESSAGE_BODY`
- `HTTP_REQUEST_SCRIPT`
- `KOTLIN_SMART_CAST_VALUE`
- `MARKDOWN_IMAGE`
- `TERMINAL_COMMAND_TO_RUN_USING_IDE`

These render with no special styling even if Darcula defines them.

### Missing baseAttributes References

Six `baseAttributes` in Vira reference keys not defined in Vira—resolved via Darcula:

| Vira Attribute | References | Darcula Provides |
|----------------|------------|------------------|
| `DEFAULT_REASSIGNED_PARAMETER` | `DEFAULT_PARAMETER` | `#ffc66d` bold |
| `BASH.SHEBANG` | `BASH.LINE_COMMENT` | gray |
| `Class` | `CLASS_NAME_ATTRIBUTES` | text color |
| `Closure braces` | `Braces` | text color |
| `Groovy method declaration` | `METHOD_DECLARATION_ATTRIBUTES` | `#ffc66d` |
| `JS.INSTANCE_MEMBER_FUNCTION` | `DEFAULT_INSTANCE_METHOD` | green |

---

## Indexed Patterns

### Rainbow Brackets (5 keys)

| Key | Color |
|-----|-------|
| `RAINBOW_COLOR0` | `#a3c679` |
| `RAINBOW_COLOR1` | `#d6808f` |
| `RAINBOW_COLOR2` | `#90a9bc` |
| `RAINBOW_COLOR3` | `#cd775c` |
| `RAINBOW_COLOR4` | `#9e6fa1` |

### Markdown Headers (6 keys)

All use `#d5b05f` italic: `MARKDOWN_HEADER_LEVEL_1` through `_6`.

### HTML Tag Tree (6 keys)

Rainbow for nested tag depth:

| Level | Color |
|-------|-------|
| 0 | `#c85e60` |
| 1 | `#d5b05f` |
| 2 | `#a3c679` |
| 3 | `#6ebad7` |
| 4 | `#6a90d0` |
| 5 | `#a178c4` |

### VCS Annotations (5 keys)

Age-based git blame coloring: `VCS_ANNOTATIONS_COLOR_1` through `_5`.

### CodeWithMe Users (12 keys)

6 users × 2 types (marker, selection):

| User | Marker | Selection |
|------|--------|-----------|
| 1 | `#a3c679` | `#375239` |
| 2 | `#c85e60` | `#5e3838` |
| 3 | `#a178c4` | `#653f6e` |
| 4 | `#cd775c` | `#614438` |
| 5 | `#6ebad7` | `#1d414d` |
| 6 | `#d5b05f` | `#5e4d33` |

### Terminal Colors (16 keys)

Standard + bright variants:

| Color | Normal | Bright |
|-------|--------|--------|
| BLACK | `#212121` | `#45454a` |
| RED | `#c85e60` | `#c85e60` |
| GREEN | `#a3c679` | `#a3c679` |
| YELLOW | `#d5b05f` | `#d5b05f` |
| BLUE | `#6a90d0` | `#6a90d0` |
| MAGENTA | `#a178c4` | `#a178c4` |
| CYAN | `#6ebad7` | `#6ebad7` |
| WHITE | `#d9d9d9` | `#d9d9d9` |

---

## Statistics (Vira Carbon)

| Section | Count |
|---------|-------|
| `json.colors` | 4 |
| `json.ui` components | 102 |
| `json.icons.ColorPalette` | 36 |
| `xml.colors` | 157 |
| `xml.attributes` | 290 |
| `baseAttributes` references | 50 |
| External refs (Darcula) | 6 |

---

## Appendices

- `appendix-xml-colors.md` — All 157 xml.colors keys
- `appendix-xml-attributes.md` — All 290 xml.attributes keys
- `appendix-ui-components.md` — All 102 json.ui components
