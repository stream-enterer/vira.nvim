#!/usr/bin/env python3
"""
Generate Neovim palette and highlight group files from JetBrains theme data.

Usage: python nvim/generate.py
"""

import json
import os
from pathlib import Path

ROOT = Path(__file__).parent.parent
EXTRACTED_DIR = ROOT / "jetbrains" / "extracted"
MAPPINGS_FILE = ROOT / "nvim" / "mappings" / "jetbrains-to-nvim.json"
PALETTE_DIR = ROOT / "nvim" / "lua" / "vira" / "palette"

VARIANTS = ["carbon", "deepforest", "graphene", "ocean", "palenight", "teal"]


def load_json(path: Path) -> dict:
    with open(path) as f:
        return json.load(f)


def normalize_color(color: str) -> str:
    """Normalize color to 6-digit hex (strip alpha if present)."""
    if not color or not isinstance(color, str):
        return color
    color = color.strip()
    if not color.startswith("#"):
        return color
    # 8-digit hex (#RRGGBBAA) -> 6-digit (#RRGGBB)
    if len(color) == 9:
        return color[:7]
    # 4-digit hex (#RGBA) -> 3-digit (#RGB)
    if len(color) == 5:
        return color[:4]
    return color


def blend_with_bg(color: str, bg: str, alpha: float) -> str:
    """Blend a color with background using alpha."""
    if not color or not bg:
        return color
    try:
        # Parse hex colors
        r1 = int(color[1:3], 16)
        g1 = int(color[3:5], 16)
        b1 = int(color[5:7], 16)
        r2 = int(bg[1:3], 16)
        g2 = int(bg[3:5], 16)
        b2 = int(bg[5:7], 16)
        # Blend
        r = int(r1 * alpha + r2 * (1 - alpha))
        g = int(g1 * alpha + g2 * (1 - alpha))
        b = int(b1 * alpha + b2 * (1 - alpha))
        return f"#{r:02x}{g:02x}{b:02x}"
    except (ValueError, TypeError):
        return color


def extract_palette(variant_data: dict) -> dict:
    """Extract a semantic color palette from JetBrains variant data."""
    xml = variant_data.get("xml", {})
    colors = xml.get("colors", {})
    attrs = xml.get("attributes", {})
    ui = variant_data.get("json", {}).get("ui", {}).get("*", {})

    # Get TEXT attribute for fg/bg base
    text = attrs.get("TEXT", {})

    palette = {
        # Base colors
        "bg": text.get("BACKGROUND", colors.get("CONSOLE_BACKGROUND_KEY", "#0a0a0a")),
        "fg": text.get("FOREGROUND", ui.get("foreground", "#d9d9d9")),
        # UI colors
        "cursor": colors.get("CARET_COLOR", "#ffcc00"),
        "cursorline": colors.get("CARET_ROW_COLOR", "#2f3237"),
        "selection": colors.get("SELECTION_BACKGROUND", "#474747"),
        "selection_fg": colors.get("SELECTION_FOREGROUND"),
        "linenr": colors.get("LINE_NUMBERS_COLOR", "#2f3237"),
        "linenr_cursor": colors.get("LINE_NUMBER_ON_CARET_ROW_COLOR", "#2f3237"),
        "gutter": colors.get("GUTTER_BACKGROUND"),
        "indent_guide": colors.get("INDENT_GUIDE", "#212121"),
        "whitespace": colors.get("WHITESPACES", "#2f3237"),
        "folded_border": colors.get("FOLDED_TEXT_BORDER_COLOR"),
        "colorcolumn": colors.get("RIGHT_MARGIN_COLOR", "#212121"),
        "separator": colors.get("TEARLINE_COLOR", "#212121"),
        "separator_selected": colors.get("SELECTED_TEARLINE_COLOR"),
        "nontext": colors.get("SOFT_WRAP_SIGN_COLOR", "#212121"),
        "winbar": colors.get("STICKY_LINES_BACKGROUND"),
        "float_bg": colors.get("NOTIFICATION_BACKGROUND"),
        "pmenu": colors.get("LOOKUP_COLOR"),
        "pmenu_sel": colors.get("RECENT_LOCATIONS_SELECTION"),
        "accent": colors.get("Adaptive.accent", "#80cbc4"),
        # Diff colors
        "diff_add": colors.get("ADDED_LINES_COLOR"),
        "diff_delete": colors.get("DELETED_LINES_COLOR"),
        "diff_change": colors.get("MODIFIED_LINES_COLOR"),
        "diff_text": colors.get("WHITESPACES_MODIFIED_LINES_COLOR"),
        # Git file status
        "git_add": colors.get("FILESTATUS_ADDED"),
        "git_change": colors.get("FILESTATUS_MODIFIED"),
        "git_delete": colors.get("FILESTATUS_DELETED"),
        # Rainbow/tag tree colors
        "rainbow_red": colors.get("HTML_TAG_TREE_LEVEL0"),
        "rainbow_yellow": colors.get("HTML_TAG_TREE_LEVEL1"),
        "rainbow_green": colors.get("HTML_TAG_TREE_LEVEL2"),
        "rainbow_cyan": colors.get("HTML_TAG_TREE_LEVEL3"),
        "rainbow_blue": colors.get("HTML_TAG_TREE_LEVEL4"),
        "rainbow_violet": colors.get("HTML_TAG_TREE_LEVEL5"),
        # VCS annotations
        "blame": colors.get("ANNOTATIONS_COLOR"),
        # Tab underline
        "tab_underline": colors.get("TAB_UNDERLINE"),
        "tab_underline_inactive": colors.get("TAB_UNDERLINE_INACTIVE"),
        # Bookmark
        "bookmark_bg": colors.get("Bookmark.iconBackground", colors.get("BookmarkIcon.background")),
        "bookmark_fg": colors.get("Bookmark.Mnemonic.iconForeground"),
    }

    # Syntax colors from attributes
    def get_attr(name: str, prop: str = "FOREGROUND"):
        attr = attrs.get(name, {})
        return attr.get(prop)

    palette.update({
        # Comments
        "comment": get_attr("DEFAULT_LINE_COMMENT"),
        "comment_doc": get_attr("DEFAULT_DOC_COMMENT"),
        "todo": get_attr("TODO_DEFAULT_ATTRIBUTES"),
        # Keywords
        "keyword": get_attr("DEFAULT_KEYWORD"),
        "keyword2": get_attr("CUSTOM_KEYWORD2_ATTRIBUTES"),
        "keyword3": get_attr("CUSTOM_KEYWORD3_ATTRIBUTES"),
        "keyword4": get_attr("CUSTOM_KEYWORD4_ATTRIBUTES"),
        # Literals
        "string": get_attr("DEFAULT_STRING"),
        "string_escape": get_attr("DEFAULT_VALID_STRING_ESCAPE") or get_attr("CUSTOM_VALID_STRING_ESCAPE_ATTRIBUTES"),
        "number": get_attr("DEFAULT_NUMBER"),
        "boolean": get_attr("BOOLEAN_LITERAL"),
        "constant": get_attr("DEFAULT_CONSTANT"),
        # Identifiers
        "identifier": get_attr("DEFAULT_IDENTIFIER"),
        "variable": get_attr("DEFAULT_LOCAL_VARIABLE"),
        "field": get_attr("DEFAULT_INSTANCE_FIELD"),
        "parameter": get_attr("DEFAULT_REASSIGNED_PARAMETER"),
        # Functions
        "func_decl": get_attr("DEFAULT_FUNCTION_DECLARATION"),
        "func_call": get_attr("DEFAULT_FUNCTION_CALL"),
        "method_static": get_attr("DEFAULT_STATIC_METHOD") or get_attr("STATIC_METHOD_IMPORTED_ATTRIBUTES"),
        # Types
        "type": get_attr("DEFAULT_CLASS_NAME"),
        "type_ref": get_attr("DEFAULT_CLASS_REFERENCE"),
        "interface": get_attr("DEFAULT_INTERFACE_NAME"),
        "type_param": get_attr("TYPE_PARAMETER_NAME_ATTRIBUTES"),
        "attribute": get_attr("DEFAULT_METADATA") or get_attr("ANNOTATION_NAME_ATTRIBUTES"),
        # Operators/punctuation
        "operator": get_attr("DEFAULT_OPERATION_SIGN"),
        "delimiter": get_attr("DEFAULT_DOT") or get_attr("DEFAULT_COMMA"),
        "bracket": get_attr("DEFAULT_BRACES") or get_attr("DEFAULT_BRACKETS") or get_attr("DEFAULT_PARENTHS"),
        # Tags (HTML/XML)
        "tag": get_attr("DEFAULT_TAG"),
        "tag_attr": get_attr("DEFAULT_ATTRIBUTE"),
        "entity": get_attr("DEFAULT_ENTITY"),
        # Errors/diagnostics
        "error": get_attr("ERRORS_ATTRIBUTES", "EFFECT_COLOR"),
        "error_stripe": get_attr("ERRORS_ATTRIBUTES", "ERROR_STRIPE_COLOR"),
        "warning": get_attr("WARNING_ATTRIBUTES", "EFFECT_COLOR"),
        "info": get_attr("INFO_ATTRIBUTES", "EFFECT_COLOR"),
        "hint": get_attr("GENERIC_SERVER_ERROR_OR_WARNING", "EFFECT_COLOR"),
        "unused": get_attr("NOT_USED_ELEMENT_ATTRIBUTES"),
        "deprecated": get_attr("MARKED_FOR_REMOVAL_ATTRIBUTES", "EFFECT_COLOR"),
        # Spelling
        "spell_bad": get_attr("GRAMMAR_ERROR", "EFFECT_COLOR"),
        "spell_cap": get_attr("TYPO", "EFFECT_COLOR"),
        # Search
        "search": get_attr("SEARCH_RESULT_ATTRIBUTES", "BACKGROUND"),
        "search_effect": get_attr("SEARCH_RESULT_ATTRIBUTES", "EFFECT_COLOR"),
        "incsearch": get_attr("TEXT_SEARCH_RESULT_ATTRIBUTES", "BACKGROUND"),
        # Links
        "link": get_attr("HYPERLINK_ATTRIBUTES"),
        "link_visited": get_attr("FOLLOWED_HYPERLINK_ATTRIBUTES"),
        # Misc
        "folded": get_attr("FOLDED_TEXT_ATTRIBUTES"),
        "template_var": get_attr("TEMPLATE_VARIABLE_ATTRIBUTES"),
        "inlay_hint": get_attr("INLAY_DEFAULT") or get_attr("INLINE_PARAMETER_HINT"),
        # Match brace
        "match_brace": get_attr("MATCHED_BRACE_ATTRIBUTES", "EFFECT_COLOR"),
        # LSP references
        "lsp_ref": get_attr("IDENTIFIER_UNDER_CARET_ATTRIBUTES", "BACKGROUND"),
        "lsp_ref_effect": get_attr("IDENTIFIER_UNDER_CARET_ATTRIBUTES", "EFFECT_COLOR"),
    })

    # Diff from attributes
    palette.update({
        "diff_add_attr": get_attr("DIFF_INSERTED", "BACKGROUND"),
        "diff_delete_attr": get_attr("DIFF_DELETED", "BACKGROUND"),
        "diff_change_attr": get_attr("DIFF_MODIFIED", "BACKGROUND"),
    })

    # Terminal colors
    terminal_map = {
        "term_black": "CONSOLE_BLACK_OUTPUT",
        "term_red": "CONSOLE_RED_OUTPUT",
        "term_green": "CONSOLE_GREEN_OUTPUT",
        "term_yellow": "CONSOLE_YELLOW_OUTPUT",
        "term_blue": "CONSOLE_BLUE_OUTPUT",
        "term_magenta": "CONSOLE_MAGENTA_OUTPUT",
        "term_cyan": "CONSOLE_CYAN_OUTPUT",
        "term_white": "CONSOLE_WHITE_OUTPUT",
        "term_bright_black": "CONSOLE_DARKGRAY_OUTPUT",
        "term_bright_red": "CONSOLE_RED_BRIGHT_OUTPUT",
        "term_bright_green": "CONSOLE_GREEN_BRIGHT_OUTPUT",
        "term_bright_yellow": "CONSOLE_YELLOW_BRIGHT_OUTPUT",
        "term_bright_blue": "CONSOLE_BLUE_BRIGHT_OUTPUT",
        "term_bright_magenta": "CONSOLE_MAGENTA_BRIGHT_OUTPUT",
        "term_bright_cyan": "CONSOLE_CYAN_BRIGHT_OUTPUT",
        "term_bright_white": "CONSOLE_GRAY_OUTPUT",
    }
    for key, attr_name in terminal_map.items():
        palette[key] = get_attr(attr_name)

    # Markdown
    md_headers = ["MARKDOWN_HEADER_LEVEL_1", "MARKDOWN_HEADER_LEVEL_2", "MARKDOWN_HEADER_LEVEL_3",
                  "MARKDOWN_HEADER_LEVEL_4", "MARKDOWN_HEADER_LEVEL_5", "MARKDOWN_HEADER_LEVEL_6"]
    for i, h in enumerate(md_headers, 1):
        palette[f"md_h{i}"] = get_attr(h)

    palette.update({
        "md_bold": get_attr("MARKDOWN_BOLD"),
        "md_italic": get_attr("MARKDOWN_ITALIC"),
        "md_code": get_attr("MARKDOWN_CODE_SPAN"),
        "md_code_block": get_attr("MARKDOWN_CODE_BLOCK"),
        "md_link": get_attr("MARKDOWN_LINK_TEXT"),
        "md_url": get_attr("MARKDOWN_LINK_DESTINATION"),
        "md_quote": get_attr("MARKDOWN_BLOCK_QUOTE"),
        "md_list": get_attr("MARKDOWN_LIST_ITEM"),
    })

    # Font types (for italic/bold detection)
    font_types = {}
    for attr_name in ["DEFAULT_LINE_COMMENT", "DEFAULT_KEYWORD", "TODO_DEFAULT_ATTRIBUTES",
                      "DEFAULT_CONSTANT", "DEFAULT_STATIC_FIELD", "STATIC_METHOD_IMPORTED_ATTRIBUTES",
                      "MARKDOWN_BOLD", "MARKDOWN_ITALIC"]:
        attr = attrs.get(attr_name, {})
        ft = attr.get("FONT_TYPE")
        if ft:
            font_types[attr_name] = int(ft)
    palette["_font_types"] = font_types

    # Get base bg for blending
    base_bg = text.get("BACKGROUND", colors.get("CONSOLE_BACKGROUND_KEY", "#0a0a0a"))
    base_bg = normalize_color(base_bg)

    # Remove None/empty values and normalize colors
    cleaned = {}
    for k, v in palette.items():
        if v is None or v == "":
            continue
        if k == "_font_types":
            cleaned[k] = v
            continue
        # Normalize color
        v = normalize_color(v)
        # Skip empty after normalization
        if not v or v == "#":
            continue
        cleaned[k] = v

    return cleaned


def generate_lua_palette(variant: str, palette: dict) -> str:
    """Generate Lua code for a palette."""
    lines = [f"-- Vira {variant.title()} palette", f"-- Auto-generated by generate.py", "", "return {"]

    # Separate font_types from colors
    font_types = palette.pop("_font_types", {})

    # Sort keys for consistent output
    for key in sorted(palette.keys()):
        value = palette[key]
        lines.append(f'  {key} = "{value}",')

    # Add font type info
    if font_types:
        lines.append("")
        lines.append("  -- Font types: 1=bold, 2=italic, 3=bold+italic")
        lines.append("  _font_types = {")
        for attr, ft in sorted(font_types.items()):
            lines.append(f'    {attr} = {ft},')
        lines.append("  },")

    lines.append("}")
    return "\n".join(lines)


def main():
    PALETTE_DIR.mkdir(parents=True, exist_ok=True)

    for variant in VARIANTS:
        variant_file = EXTRACTED_DIR / f"{variant}.json"
        if not variant_file.exists():
            print(f"Warning: {variant_file} not found, skipping")
            continue

        data = load_json(variant_file)
        palette = extract_palette(data)
        lua_code = generate_lua_palette(variant, palette)

        output_file = PALETTE_DIR / f"{variant}.lua"
        with open(output_file, "w") as f:
            f.write(lua_code + "\n")

        print(f"Generated {output_file}")


if __name__ == "__main__":
    main()
