+++
title = "Typography Fundamentals for Developers"
description = "Good typography makes your content readable and your site professional. Here are the basics every developer should know."
date = 2024-12-15
[taxonomies]
tags = ["design", "typography", "css"]
+++

# Typography Fundamentals for Developers

You don't need to be a designer to get typography right. These fundamentals will take you far.

## Choose Readable Fonts

For body text, prioritize readability:

- **Sans-serif** for screens: Geist, Inter, system-ui
- **Serif** for long-form: Georgia, Charter, Literata
- **Monospace** for code: Geist Mono, JetBrains Mono, Fira Code

Avoid decorative fonts for body text. Save them for headlines.

## Set a Comfortable Line Length

Lines that are too long or too short hurt readability. Aim for **45-75 characters** per line:

```css
.prose {
    max-width: 65ch;
}
```

The `ch` unit is based on the width of the "0" character, making it perfect for this.

## Use a Type Scale

Don't pick font sizes randomly. Use a scale:

```css
:root {
    --text-xs: 0.75rem;   /* 12px */
    --text-sm: 0.875rem;  /* 14px */
    --text-base: 1rem;    /* 16px */
    --text-lg: 1.125rem;  /* 18px */
    --text-xl: 1.25rem;   /* 20px */
    --text-2xl: 1.5rem;   /* 24px */
    --text-3xl: 1.875rem; /* 30px */
    --text-4xl: 2.25rem;  /* 36px */
}
```

## Line Height Matters

Tighter line height for headlines, looser for body text:

```css
h1, h2, h3 {
    line-height: 1.2;
}

p {
    line-height: 1.6;
}
```

## Vertical Rhythm

Consistent spacing creates visual harmony:

```css
.prose > * + * {
    margin-top: 1.5rem;
}

.prose h2 {
    margin-top: 3rem;
}
```

## Font Loading

Use `font-display: swap` to prevent invisible text:

```css
@font-face {
    font-family: 'Geist';
    src: url('/fonts/Geist-Variable.woff2') format('woff2');
    font-display: swap;
}
```

## Responsive Typography

Scale fonts based on viewport:

```css
html {
    font-size: clamp(16px, 1vw + 14px, 20px);
}
```

This creates fluid typography that adapts to screen size.

Good typography is invisible—readers don't notice it, they just enjoy the content.
