# KDE Plasma ↔ JetBrains Theme Color Mapping

## Key Structural Differences

| Aspect | KDE Plasma | JetBrains |
|--------|-----------|-----------|
| Format | INI-style `.colors` file | JSON `.theme.json` |
| Organization | Color groups (`[Colors:Window]`, etc.) | Flat component keys (`Panel.background`) |
| Naming | `ForegroundNormal`, `BackgroundNormal` | `foreground`, `background` |
| States | Separate `[ColorEffects:*]` sections | Inline state prefixes (`hover`, `disabled`) |

## Core Color Mappings

### Default/Global Colors

| KDE Field | JetBrains Key | Notes |
|-----------|---------------|-------|
| `[Colors:Window]ForegroundNormal` | `*.foreground`, `Label.foreground` | Primary text color |
| `[Colors:Window]BackgroundNormal` | `*.background`, `Panel.background` | Default surface color |
| `[Colors:Window]DecorationHover` | `*.hoverBackground` | Hover highlight |
| `[Colors:View]ForegroundNormal` | `TextField.foreground`, `List.foreground` | Input/content text |
| `[Colors:View]BackgroundNormal` | `TextField.background`, `List.background` | Input/content background |
| `[Colors:View]DecorationFocus` | `Component.focusColor`, `*.focusedBorderColor` | Focus ring/outline |
| `[Colors:View]DecorationHover` | `Component.borderColor` (hover state) | Hover outline |

### Selection Colors

| KDE Field | JetBrains Key |
|-----------|---------------|
| `[Colors:Selection]ForegroundNormal` | `*.selectionForeground`, `Tree.selectionForeground` |
| `[Colors:Selection]BackgroundNormal` | `*.selectionBackground`, `Tree.selectionBackground` |
| — | `*.selectionInactiveBackground` (unfocused selection) |
| — | `*.selectionInactiveForeground` |

### Button Colors

| KDE Field | JetBrains Key |
|-----------|---------------|
| `[Colors:Button]ForegroundNormal` | `Button.foreground` |
| `[Colors:Button]BackgroundNormal` | `Button.startBackground`, `Button.endBackground` |
| `[Colors:Button]ForegroundActive` | `Button.default.foreground` |
| — | `Button.focusedBorderColor` |
| — | `Button.default.startBackground` (primary button) |

### Header/Titlebar

| KDE Field | JetBrains Key |
|-----------|---------------|
| `[Colors:Header]ForegroundNormal` | `MainWindow.Header.foreground`, `TitlePane.foreground` |
| `[Colors:Header]BackgroundNormal` | `MainWindow.Header.background`, `TitlePane.background` |
| — | `ToolWindow.Header.inactiveBackground` |

### Links

| KDE Field | JetBrains Key |
|-----------|---------------|
| `[Colors:View]ForegroundLink` | `Link.activeForeground` |
| `[Colors:View]ForegroundVisited` | `Link.visitedForeground` |
| — | `Link.hoverForeground` |
| — | `Link.pressedForeground` |

### Tooltips

| KDE Field | JetBrains Key |
|-----------|---------------|
| `[Colors:Tooltip]ForegroundNormal` | `ToolTip.foreground` |
| `[Colors:Tooltip]ForegroundInactive` | `ToolTip.infoForeground` |
| `[Colors:Tooltip]BackgroundNormal` | `ToolTip.background` |
| — | `ToolTip.borderColor` |

### Disabled States

| KDE Approach | JetBrains Key |
|--------------|---------------|
| `[ColorEffects:Disabled]` section | `*.disabledForeground`, `*.disabledBackground` |
| Color intensity/saturation changes | `Label.disabledForeground`, `Button.disabledText` |

### Semantic/Status Colors

| KDE (Theme::ColorRole) | JetBrains Key |
|------------------------|---------------|
| `PositiveTextColor` | `Banner.successBackground`, `ValidationTooltip.successForeground` |
| `NeutralTextColor` | `Banner.warningBackground`, `ValidationTooltip.warningForeground` |
| `NegativeTextColor` | `Banner.errorBackground`, `ValidationTooltip.errorForeground` |
| `DisabledTextColor` | `*.disabledForeground` |

## JetBrains Key Naming Pattern

```
Object[.SubObject].[state][Part]property
```

**States:** `hover`, `pressed`, `focused`, `selected`, `inactive`, `disabled`, `error`, `warning`, `success`

**Properties:** `foreground`, `background`, `borderColor`, `<part>Color`

**Examples:**
- `Tree.selectionInactiveBackground` = Tree + selection + Inactive + Background
- `Button.default.focusedBorderColor` = Button + Default (subobject) + focused + Border + Color
- `ToolWindow.HeaderTab.hoverInactiveBackground` = ToolWindow + HeaderTab + hover + Inactive + Background

## Component-Specific Mappings

### Menu System

| KDE | JetBrains |
|-----|-----------|
| `[Colors:Window]` colors | `Menu.background`, `Menu.foreground` |
| — | `MenuItem.acceleratorForeground` |
| — | `Menu.separatorColor` |
| Selection colors | `MenuItem.selectionBackground`, `MenuItem.selectionForeground` |

### Tree/List Views

| KDE | JetBrains |
|-----|-----------|
| `[Colors:View]ForegroundNormal` | `Tree.foreground`, `List.foreground` |
| `[Colors:View]BackgroundNormal` | `Tree.background`, `List.background` |
| `[Colors:Selection]*` | `Tree.selectionBackground`, `List.selectionBackground` |
| — | `Tree.hash` (tree lines) |

### Editor Tabs

| KDE | JetBrains |
|-----|-----------|
| Header colors | `EditorTabs.background` |
| Selection colors | `EditorTabs.underlineColor` (active indicator) |
| — | `EditorTabs.hoverBackground` |
| — | `EditorTabs.inactiveColoredFileBackground` |

### Scrollbars

| KDE | JetBrains |
|-----|-----------|
| Window/View colors | `ScrollBar.thumbColor`, `ScrollBar.trackColor` |
| Hover colors | `ScrollBar.hoverThumbColor`, `ScrollBar.hoverTrackColor` |
| — | `ScrollBar.Transparent.*` variants |

### Progress Indicators

| KDE | JetBrains |
|-----|-----------|
| Highlight color | `ProgressBar.progressColor` |
| Background color | `ProgressBar.trackColor` |
| — | `ProgressBar.indeterminateStartColor`, `ProgressBar.indeterminateEndColor` |
| Negative color | `ProgressBar.failedColor` |
| Positive color | `ProgressBar.passedColor` |

## Complementary/Special Areas

KDE's `[Colors:Complementary]` maps to JetBrains areas like:
- `WelcomeScreen.*`
- `Notification.*`
- `Popup.*`

## Notes

1. JetBrains uses `*.` wildcard for defaults that apply to all components unless overridden
2. JetBrains supports gradient backgrounds via `startBackground`/`endBackground` pairs
3. KDE separates color effects (disabled, inactive) into their own sections; JetBrains uses inline state prefixes
4. JetBrains has ~100+ component-specific key groups vs KDE's ~7 color groups
5. For named colors, JetBrains supports a `"colors": {}` block for reusable definitions

## Source Documentation

- KDE: [Plasma Style colors file documentation](https://develop.kde.org/docs/plasma/theme/colors/)
- JetBrains: [Theme Metadata](https://plugins.jetbrains.com/docs/intellij/themes-metadata.html)
- JetBrains: [Platform Theme Colors](https://plugins.jetbrains.com/docs/intellij/platform-theme-colors.html)
- Full key list: `IntelliJPlatform.themeMetadata.json` and `JDK.themeMetadata.json` in intellij-community repo
