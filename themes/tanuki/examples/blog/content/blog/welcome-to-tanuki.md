+++
title = "Welcome to Tanuki"
description = "Introducing Tanuki, a whimsical Zola theme inspired by Nintendo's playful design philosophy."
date = 2024-12-27
[taxonomies]
tags = ["announcement", "release"]
+++

# Welcome to Tanuki

We're excited to introduce Tanuki, a new Zola theme that brings joy and whimsy to your documentation, books, and blogs.

## Why Tanuki?

The tanuki (Japanese raccoon dog) is a beloved creature in Japanese folklore, known for being playful, mischievous, and a little magical. We chose this name because our theme embodies those same qualities—it's fun to use, delightful to look at, and just a bit magical in how it transforms your content.

## Three Modes, One Theme

Tanuki supports three distinct modes:

1. **Documentation Mode** - Perfect for API docs and technical references
2. **E-Book Mode** - Ideal for tutorials, courses, and long-form content
3. **Blog Mode** - Great for personal sites, portfolios, and announcements

Each mode is optimized for its purpose while maintaining a consistent, cohesive design language.

## Features You'll Love

### Catppuccin Colors

We use the beautiful [Catppuccin](https://github.com/catppuccin/catppuccin) color palette, with Mocha for dark mode and Latte for light mode. The colors are warm, inviting, and easy on the eyes during long reading sessions.

### Nintendo-Inspired UX

Inspired by games like Animal Crossing and Super Mario Odyssey, we've added subtle animations and interactions that make using the theme feel delightful. Watch the theme toggle sparkle when you click it!

### Full-Text Search

Press `/` anywhere to search your entire site instantly. Powered by Elasticlunr, it's fast and works offline.

## Getting Started

Adding Tanuki to your project is simple:

```bash
git submodule add https://github.com/raskell-io/tanuki themes/tanuki
```

Then add to your `config.toml`:

```toml
theme = "tanuki"

[extra]
mode = "site"  # or "docs" or "book"
```

## What's Next?

We're just getting started! Upcoming features include:

- More theme color options
- Additional page templates
- Enhanced print stylesheets
- Improved accessibility features

Stay tuned for more updates, and happy building!
