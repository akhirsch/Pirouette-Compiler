+++
title = "CSS Grid vs Flexbox: When to Use Each"
description = "Both CSS Grid and Flexbox solve layout problems, but they excel in different scenarios. Here's how to choose."
date = 2024-12-15
[taxonomies]
tags = ["css", "design", "frontend"]
+++

# CSS Grid vs Flexbox: When to Use Each

The age-old question: Grid or Flexbox? The answer is usually "both"—but knowing when to reach for each makes all the difference.

## The Mental Model

**Flexbox** is one-dimensional. It handles either a row *or* a column.

**Grid** is two-dimensional. It handles rows *and* columns simultaneously.

## Use Flexbox When...

### Aligning Items in a Single Direction

```css
.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
}
```

### Content Size Should Determine Layout

Flexbox lets items grow and shrink based on their content:

```css
.tags {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
}

.tag {
    /* Each tag sizes to its content */
    padding: 0.25rem 0.5rem;
}
```

### Centering Things

The classic centering trick:

```css
.centered {
    display: flex;
    justify-content: center;
    align-items: center;
}
```

## Use Grid When...

### Creating Page Layouts

```css
.page {
    display: grid;
    grid-template-columns: 250px 1fr;
    grid-template-rows: auto 1fr auto;
    grid-template-areas:
        "sidebar header"
        "sidebar main"
        "sidebar footer";
}
```

### Equal-Width Columns

```css
.card-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1.5rem;
}
```

### Overlapping Elements

Grid allows items to occupy the same cells:

```css
.hero {
    display: grid;
}

.hero > * {
    grid-area: 1 / 1;
}

.hero-image {
    z-index: 1;
}

.hero-text {
    z-index: 2;
}
```

## Use Both Together

The real power comes from combining them:

```css
/* Grid for the overall layout */
.dashboard {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 1rem;
}

/* Flexbox for card internals */
.card {
    display: flex;
    flex-direction: column;
}

.card-footer {
    margin-top: auto; /* Push to bottom */
    display: flex;
    justify-content: space-between;
}
```

## Quick Reference

| Scenario | Use |
|----------|-----|
| Navigation bars | Flexbox |
| Page layout | Grid |
| Card grids | Grid |
| Card contents | Flexbox |
| Centering | Either |
| Form layouts | Grid |
| Button groups | Flexbox |
| Image galleries | Grid |

## The Subgrid Game-Changer

CSS Subgrid (now widely supported) lets nested grids align with their parent:

```css
.card-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
}

.card {
    display: grid;
    grid-template-rows: subgrid;
    grid-row: span 3;
}
```

This ensures all card headers, bodies, and footers align across the row.

Stop asking "Grid or Flexbox?" Start asking "What problem am I solving?"
