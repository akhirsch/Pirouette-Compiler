+++
title = "Dark Mode Best Practices for Web Development"
description = "Learn the key principles for implementing dark mode that respects user preferences and looks great."
date = 2024-12-20
[taxonomies]
tags = ["design", "css", "accessibility"]
+++

# Dark Mode Best Practices for Web Development

Dark mode has become an essential feature for modern websites. Here's how to implement it properly.

## Respect System Preferences

The first rule of dark mode is to respect what the user has already chosen at the OS level:

```css
@media (prefers-color-scheme: dark) {
    :root {
        --bg: #1e1e2e;
        --text: #cdd6f4;
    }
}
```

## Use CSS Custom Properties

CSS custom properties make theme switching trivial:

```css
:root {
    --bg: #eff1f5;
    --text: #4c4f69;
}

[data-theme="dark"] {
    --bg: #1e1e2e;
    --text: #cdd6f4;
}

body {
    background: var(--bg);
    color: var(--text);
}
```

## Avoid Pure Black

Pure black (`#000000`) on screens can cause eye strain. Use a softer dark color like Catppuccin Mocha's base (`#1e1e2e`) instead.

## Consider Contrast Ratios

WCAG guidelines recommend:
- **4.5:1** for normal text
- **3:1** for large text and UI components

Tools like the [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/) can help verify your choices.

## Persist User Choice

Store the user's preference so it persists across sessions:

```javascript
const theme = localStorage.getItem('theme') || 'auto';
document.documentElement.setAttribute('data-theme', theme);
```

## Smooth Transitions

Add a subtle transition to prevent jarring switches:

```css
body {
    transition: background-color 0.2s ease, color 0.2s ease;
}
```

## Test Both Modes

Always test your site in both light and dark modes. Images, syntax highlighting, and embedded content can look different—or broken—in each mode.

Dark mode done right improves accessibility, reduces eye strain, and gives users control over their experience.
