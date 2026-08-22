+++
title = "Chapter 2: Modern CSS"
description = "Exploring Flexbox, Grid, and modern CSS features."
weight = 2
+++

# Chapter 2: Modern CSS

CSS has evolved dramatically over the past decade. Gone are the days of float-based layouts and clearfix hacks. Today, we have powerful tools like Flexbox and Grid that make complex layouts straightforward.

## The Flexbox Revolution

Flexbox (Flexible Box Layout) is designed for one-dimensional layouts—either rows or columns. It excels at distributing space and aligning items.

```css
.container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 1rem;
}

.item {
    flex: 1;
}
```

### Flex Direction and Wrapping

Lorem ipsum dolor sit amet, consectetur adipiscing elit. The `flex-direction` property controls the main axis:

```css
.row { flex-direction: row; }        /* Default: left to right */
.column { flex-direction: column; }  /* Top to bottom */
.row-reverse { flex-direction: row-reverse; }
.column-reverse { flex-direction: column-reverse; }
```

Nulla facilisi. Sed euismod, nisl nec ultricies lacinia, nisl nisl aliquam nisl, eget aliquam nisl nisl sit amet nisl.

## CSS Grid: Two-Dimensional Layouts

Grid Layout is the answer to two-dimensional layouts. It handles both rows and columns simultaneously.

```css
.grid-container {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-template-rows: auto 1fr auto;
    gap: 2rem;
}

.header { grid-column: 1 / -1; }
.sidebar { grid-row: 2 / 3; }
.main { grid-column: 2 / 4; }
```

### Grid Template Areas

For complex layouts, named grid areas provide clarity:

```css
.layout {
    display: grid;
    grid-template-areas:
        "header header header"
        "sidebar main main"
        "footer footer footer";
    grid-template-columns: 200px 1fr 1fr;
}

.header { grid-area: header; }
.sidebar { grid-area: sidebar; }
.main { grid-area: main; }
.footer { grid-area: footer; }
```

## Custom Properties (CSS Variables)

CSS Custom Properties bring the power of variables to stylesheets:

```css
:root {
    --color-primary: #3b82f6;
    --color-secondary: #10b981;
    --spacing-unit: 8px;
    --border-radius: 4px;
}

.button {
    background: var(--color-primary);
    padding: calc(var(--spacing-unit) * 2);
    border-radius: var(--border-radius);
}
```

### Dynamic Theming

Variables can be changed at runtime with JavaScript:

```javascript
document.documentElement.style.setProperty('--color-primary', '#8b5cf6');
```

Or scoped to specific elements:

```css
.dark-theme {
    --color-background: #1a1a2e;
    --color-text: #eaeaea;
}
```

## Container Queries

The newest addition to responsive design—container queries let you style based on parent size, not viewport:

```css
.card-container {
    container-type: inline-size;
    container-name: card;
}

@container card (min-width: 400px) {
    .card {
        display: flex;
        flex-direction: row;
    }
}
```

## Summary

Modern CSS provides powerful tools for layout and styling:

- **Flexbox** for one-dimensional layouts
- **Grid** for two-dimensional layouts
- **Custom Properties** for maintainable, themeable CSS
- **Container Queries** for component-based responsive design

> **Pro Tip**: Don't choose between Flexbox and Grid—use both! Grid for page layouts, Flexbox for component internals.

Next, we'll explore JavaScript in depth and learn how to make our pages interactive.
