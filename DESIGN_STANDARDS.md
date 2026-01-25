# Design Standards

Consistent values used across all matugen templates (rofi, eww, waybar, swaync).

## Border Radius
| Name | Value | Usage |
|------|-------|-------|
| radius-none | 0px | All containers, popups, buttons |
| radius-round | 50% | Circular elements only (e.g., calendar days) |

> **Note:** Square corners (0px) are used throughout to avoid GTK/Wayland transparency artifacts.

## Spacing / Padding
| Name | Value | Usage |
|------|-------|-------|
| space-xs | 4px | Tight spacing |
| space-sm | 8px | Small gaps |
| space-md | 12px | Medium gaps |
| space-lg | 16px | Large padding |
| space-xl | 20px | Container padding |

## Border Widths
| Name | Value | Usage |
|------|-------|-------|
| border-thin | 1px | Subtle borders |
| border-normal | 2px | Standard borders |
| border-thick | 3px | Accent borders |

## Font Sizes
| Name | Value | Usage |
|------|-------|-------|
| font-size-xs | 9px | Tiny labels |
| font-size-sm | 11px | Small text |
| font-size-md | 13px | Body text |
| font-size-lg | 15px | Titles |
| font-size-xl | 18px | Headers |

## Fonts
- Main: `"JetBrains Mono", "Noto Sans", monospace`
- Mono: `"JetBrains Mono", monospace`

## Shadows
| Name | Value |
|------|-------|
| shadow-sm | `0 4px 12px rgba(0, 0, 0, 0.3)` |
| shadow-md | `0 8px 24px rgba(0, 0, 0, 0.5)` |
| shadow-lg | `0 12px 40px rgba(0, 0, 0, 0.6)` |

## Opacity
| Name | Value | Usage |
|------|-------|-------|
| opacity-subtle | 0.4 | Faded elements |
| opacity-medium | 0.65 | Semi-transparent |
| opacity-strong | 0.85 | Nearly opaque |

## Template Files
- Rofi: `matugen/.config/matugen/templates/rofi-*.rasi`
- EWW: `matugen/.config/matugen/templates/eww.scss`
- Waybar: `matugen/.config/matugen/templates/waybar-style.css`
- SwayNC: `matugen/.config/matugen/templates/swaync-style.css`
