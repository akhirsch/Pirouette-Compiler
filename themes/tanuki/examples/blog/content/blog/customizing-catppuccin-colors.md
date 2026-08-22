+++
title = "Customizing Catppuccin Colors"
description = "Learn how to customize the Tanuki theme's color palette using CSS custom properties."
date = 2024-12-25
[taxonomies]
tags = ["tutorial", "css", "theming"]
+++

# Customizing Catppuccin Colors

Tanuki uses the [Catppuccin](https://github.com/catppuccin/catppuccin) color palette, a soothing pastel theme that's easy on the eyes. But what if you want to customize it?

## Understanding the Color System

Tanuki uses CSS custom properties (variables) for all colors. This makes customization straightforward—just override the variables you want to change.

### The Base Palette

Each Catppuccin flavor (Latte for light, Mocha for dark) includes:

| Variable | Purpose |
|----------|---------|
| `--ctp-base` | Main background |
| `--ctp-mantle` | Secondary background |
| `--ctp-crust` | Tertiary background |
| `--ctp-surface0/1/2` | Surface layers |
| `--ctp-overlay0/1/2` | Overlay layers |
| `--ctp-text` | Primary text |
| `--ctp-subtext0/1` | Secondary text |

### Accent Colors

The fun colors for highlights and accents:

- `--ctp-rosewater` - Soft pink
- `--ctp-flamingo` - Coral
- `--ctp-pink` - Vibrant pink
- `--ctp-mauve` - Purple (default accent)
- `--ctp-red` - Error/danger
- `--ctp-maroon` - Deep red
- `--ctp-peach` - Orange
- `--ctp-yellow` - Warning/highlight
- `--ctp-green` - Success
- `--ctp-teal` - Teal
- `--ctp-sky` - Light blue
- `--ctp-sapphire` - Blue
- `--ctp-blue` - Primary blue
- `--ctp-lavender` - Soft purple

## Changing the Accent Color

The simplest customization is changing the accent color. Create a custom CSS file:

```css
/* static/css/custom.css */
:root {
  --color-accent: var(--ctp-pink);
  --color-accent-hover: var(--ctp-pink);
}
```

Then include it in your `config.toml`:

```toml
[extra]
stylesheets = ["css/custom.css"]
```

## Creating a Custom Theme

Want something more dramatic? Override the entire palette:

```css
/* A "cyberpunk" variant */
[data-theme="dark"] {
  --ctp-base: #0a0a0f;
  --ctp-mantle: #12121a;
  --ctp-crust: #08080c;
  --ctp-text: #00ff9f;
  --ctp-subtext0: #00cc7f;
  --ctp-mauve: #ff00ff;
  --ctp-pink: #ff1493;
}
```

## Using Other Catppuccin Flavors

Catppuccin has four flavors: Latte, Frappé, Macchiato, and Mocha. Tanuki uses Latte (light) and Mocha (dark) by default, but you can switch to others.

### Using Macchiato for Dark Mode

```css
[data-theme="dark"] {
  /* Macchiato base colors */
  --ctp-rosewater: #f4dbd6;
  --ctp-flamingo: #f0c6c6;
  --ctp-pink: #f5bde6;
  --ctp-mauve: #c6a0f6;
  --ctp-red: #ed8796;
  --ctp-maroon: #ee99a0;
  --ctp-peach: #f5a97f;
  --ctp-yellow: #eed49f;
  --ctp-green: #a6da95;
  --ctp-teal: #8bd5ca;
  --ctp-sky: #91d7e3;
  --ctp-sapphire: #7dc4e4;
  --ctp-blue: #8aadf4;
  --ctp-lavender: #b7bdf8;
  --ctp-text: #cad3f5;
  --ctp-subtext1: #b8c0e0;
  --ctp-subtext0: #a5adcb;
  --ctp-overlay2: #939ab7;
  --ctp-overlay1: #8087a2;
  --ctp-overlay0: #6e738d;
  --ctp-surface2: #5b6078;
  --ctp-surface1: #494d64;
  --ctp-surface0: #363a4f;
  --ctp-base: #24273a;
  --ctp-mantle: #1e2030;
  --ctp-crust: #181926;
}
```

## Tips for Color Customization

1. **Maintain contrast** - Ensure text remains readable against backgrounds
2. **Test both modes** - Check your changes in both light and dark themes
3. **Use the palette** - Stick to Catppuccin colors for a cohesive look
4. **Consider accessibility** - WCAG recommends 4.5:1 contrast for normal text

## Resources

- [Catppuccin GitHub](https://github.com/catppuccin/catppuccin)
- [Catppuccin Palette](https://catppuccin.com/palette)
- [Contrast Checker](https://webaim.org/resources/contrastchecker/)

Happy theming!
