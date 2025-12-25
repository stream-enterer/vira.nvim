#!/usr/bin/env python3
"""
Vira JetBrains Theme Extractor

Extracts theme data from JetBrains .theme.json and .xml files into
a normalized, LLM-queryable JSON format.

Usage: python extract.py
"""

import json
import re
import xml.etree.ElementTree as ET
from pathlib import Path


VARIANTS = ["Carbon", "Deepforest", "Graphene", "Ocean", "Palenight", "Teal"]

ORIGINAL_DIR = Path(__file__).parent / "original"
EXTRACTED_DIR = Path(__file__).parent / "extracted"
ANALYSIS_DIR = Path(__file__).parent / "analysis"


def normalize_color(color: str) -> str:
    """
    Normalize color values to consistent format.

    Input formats:
        - "RRGGBB" (XML style)
        - "RRGGBBAA" (XML style with alpha)
        - "#RRGGBB" (JSON style)
        - "#RRGGBBAA" (JSON style with alpha)
        - "" (empty)

    Output format:
        - "#rrggbb" or "#rrggbbaa" (lowercase, with hash)
        - "" for empty values
    """
    if not color or color.strip() == "":
        return ""

    color = color.strip()

    # Remove leading hash if present
    if color.startswith("#"):
        color = color[1:]

    # Validate hex characters
    if not re.match(r'^[0-9a-fA-F]+$', color):
        # Not a valid hex color, return as-is (might be a reference like "border")
        return color

    # Normalize to lowercase with hash
    return f"#{color.lower()}"


def parse_xml_colors(colors_elem) -> dict:
    """Parse the <colors> section of the XML."""
    result = {}
    if colors_elem is None:
        return result

    for option in colors_elem.findall("option"):
        name = option.get("name")
        value = option.get("value", "")
        if name:
            result[name] = normalize_color(value)

    return result


def parse_xml_attribute_value(value_elem) -> dict:
    """Parse a single attribute's <value> element."""
    result = {}
    if value_elem is None:
        return result

    for option in value_elem.findall("option"):
        name = option.get("name")
        value = option.get("value", "")
        if name:
            # Normalize color values for color-related attributes
            if name in ("FOREGROUND", "BACKGROUND", "EFFECT_COLOR", "ERROR_STRIPE_COLOR"):
                result[name] = normalize_color(value)
            else:
                # Keep other values as-is (FONT_TYPE, EFFECT_TYPE are integers)
                result[name] = value

    return result


def parse_xml_attributes(attributes_elem) -> dict:
    """Parse the <attributes> section of the XML."""
    result = {}
    if attributes_elem is None:
        return result

    for option in attributes_elem.findall("option"):
        name = option.get("name")
        if not name:
            continue

        # Check for baseAttributes reference
        base_attrs = option.get("baseAttributes")

        # Check for direct value attribute (simple case like DEFAULT_IDENTIFIER)
        direct_value = option.get("value")

        # Check for nested <value> element
        value_elem = option.find("value")

        if base_attrs is not None:
            # This attribute inherits from another
            result[name] = {"baseAttributes": base_attrs}
        elif direct_value is not None:
            # Simple value attribute - this is shorthand for FOREGROUND only
            # Normalize to standard format for consistency
            result[name] = {"FOREGROUND": normalize_color(direct_value)}
        elif value_elem is not None:
            # Complex value with nested options
            parsed_value = parse_xml_attribute_value(value_elem)
            result[name] = parsed_value if parsed_value else {}
        else:
            # Empty option
            result[name] = {}

    return result


def parse_xml_file(xml_path: Path) -> dict:
    """Parse a JetBrains color scheme XML file."""
    tree = ET.parse(xml_path)
    root = tree.getroot()

    result = {
        "scheme": {
            "name": root.get("name", ""),
            "version": root.get("version", ""),
            "parent_scheme": root.get("parent_scheme", "")
        },
        "settings": {},
        "colors": {},
        "attributes": {}
    }

    # Parse top-level options (LINE_SPACING, EDITOR_LIGATURES, etc.)
    for option in root.findall("option"):
        name = option.get("name")
        value = option.get("value", "")
        if name:
            # Try to parse as number if applicable
            if value.replace(".", "").isdigit():
                try:
                    result["settings"][name] = float(value) if "." in value else int(value)
                except ValueError:
                    result["settings"][name] = value
            elif value.lower() in ("true", "false"):
                result["settings"][name] = value.lower() == "true"
            else:
                result["settings"][name] = value

    # Parse colors section
    colors_elem = root.find("colors")
    result["colors"] = parse_xml_colors(colors_elem)

    # Parse attributes section
    attributes_elem = root.find("attributes")
    result["attributes"] = parse_xml_attributes(attributes_elem)

    return result


def normalize_json_colors(obj):
    """Recursively normalize color values in a JSON object."""
    if isinstance(obj, dict):
        result = {}
        for key, value in obj.items():
            if isinstance(value, str) and (
                value.startswith("#") or
                re.match(r'^[0-9a-fA-F]{6,8}$', value)
            ):
                result[key] = normalize_color(value)
            else:
                result[key] = normalize_json_colors(value)
        return result
    elif isinstance(obj, list):
        return [normalize_json_colors(item) for item in obj]
    else:
        return obj


def parse_json_file(json_path: Path) -> dict:
    """Parse a JetBrains theme JSON file."""
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    # Normalize all color values
    return normalize_json_colors(data)


def extract_variant(variant: str) -> dict:
    """Extract a single variant's theme data."""
    json_path = ORIGINAL_DIR / f"Vira-{variant}.theme.json"
    xml_path = ORIGINAL_DIR / f"Vira-{variant}.xml"

    json_data = parse_json_file(json_path)
    xml_data = parse_xml_file(xml_path)

    return {
        "variant": variant.lower(),
        "meta": {
            "name": json_data.get("name", f"Vira {variant}"),
            "author": json_data.get("author", "vira"),
            "dark": json_data.get("dark", True),
            "name_key": json_data.get("nameKey", f"Vira-{variant}"),
            "editor_scheme": json_data.get("editorScheme", ""),
            "parent_scheme": xml_data["scheme"]["parent_scheme"],
            "line_spacing": xml_data["settings"].get("LINE_SPACING", 1.4),
            "ligatures": xml_data["settings"].get("EDITOR_LIGATURES", True)
        },
        "json": {
            "colors": json_data.get("colors", {}),
            "ui": json_data.get("ui", {}),
            "icons": json_data.get("icons", {})
        },
        "xml": {
            "colors": xml_data["colors"],
            "attributes": xml_data["attributes"]
        }
    }


def compute_shared(variants_data: list[dict]) -> dict:
    """Find values that are identical across all variants."""
    if not variants_data:
        return {}

    shared = {
        "json": {"colors": {}, "ui": {}, "icons": {}},
        "xml": {"colors": {}, "attributes": {}}
    }

    # Get reference from first variant
    first = variants_data[0]

    # Check JSON colors
    for key, value in first["json"]["colors"].items():
        if all(v["json"]["colors"].get(key) == value for v in variants_data):
            shared["json"]["colors"][key] = value

    # Check XML colors
    for key, value in first["xml"]["colors"].items():
        if all(v["xml"]["colors"].get(key) == value for v in variants_data):
            shared["xml"]["colors"][key] = value

    # Check XML attributes
    for key, value in first["xml"]["attributes"].items():
        if all(v["xml"]["attributes"].get(key) == value for v in variants_data):
            shared["xml"]["attributes"][key] = value

    return shared


def compute_diff_matrix(variants_data: list[dict]) -> dict:
    """Find values that differ between variants."""
    if not variants_data:
        return {}

    diff = {
        "json": {"colors": {}, "ui_background": {}},
        "xml": {"colors": {}, "attributes": {}}
    }

    # Collect all keys from all variants
    all_json_color_keys = set()
    all_xml_color_keys = set()
    all_xml_attr_keys = set()

    for v in variants_data:
        all_json_color_keys.update(v["json"]["colors"].keys())
        all_xml_color_keys.update(v["xml"]["colors"].keys())
        all_xml_attr_keys.update(v["xml"]["attributes"].keys())

    # Check JSON colors for differences
    for key in all_json_color_keys:
        values = {v["variant"]: v["json"]["colors"].get(key, None) for v in variants_data}
        unique_values = set(values.values())
        if len(unique_values) > 1:
            diff["json"]["colors"][key] = values

    # Check XML colors for differences
    for key in all_xml_color_keys:
        values = {v["variant"]: v["xml"]["colors"].get(key, None) for v in variants_data}
        unique_values = set(values.values())
        if len(unique_values) > 1:
            diff["xml"]["colors"][key] = values

    # Extract key UI background colors that define each variant
    for v in variants_data:
        ui = v["json"].get("ui", {})
        star = ui.get("*", {})
        diff["json"]["ui_background"][v["variant"]] = {
            "background": star.get("background", ""),
            "foreground": star.get("foreground", ""),
            "selectionBackground": star.get("selectionBackground", "")
        }

    return diff


def main():
    """Main extraction routine."""
    EXTRACTED_DIR.mkdir(exist_ok=True)
    ANALYSIS_DIR.mkdir(exist_ok=True)

    variants_data = []

    # Extract each variant
    for variant in VARIANTS:
        print(f"Extracting {variant}...")
        data = extract_variant(variant)
        variants_data.append(data)

        # Write individual variant file
        output_path = EXTRACTED_DIR / f"{variant.lower()}.json"
        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        print(f"  -> {output_path}")

    # Compute and write shared values
    print("Computing shared values...")
    shared = compute_shared(variants_data)
    shared_path = ANALYSIS_DIR / "shared.json"
    with open(shared_path, "w", encoding="utf-8") as f:
        json.dump(shared, f, indent=2, ensure_ascii=False)
    print(f"  -> {shared_path}")

    # Compute and write diff matrix
    print("Computing diff matrix...")
    diff = compute_diff_matrix(variants_data)
    diff_path = ANALYSIS_DIR / "diff-matrix.json"
    with open(diff_path, "w", encoding="utf-8") as f:
        json.dump(diff, f, indent=2, ensure_ascii=False)
    print(f"  -> {diff_path}")

    print("\nExtraction complete!")
    print(f"  - {len(variants_data)} variants extracted")
    print(f"  - {len(shared['xml']['colors'])} shared XML colors")
    print(f"  - {len(shared['xml']['attributes'])} shared XML attributes")
    print(f"  - {len(diff['xml']['colors'])} differing XML colors")


if __name__ == "__main__":
    main()
