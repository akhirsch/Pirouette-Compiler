+++
title = "Getting Started with Zola"
description = "A quick introduction to Zola, the fast static site generator that powers Tanuki."
date = 2024-12-26
[taxonomies]
tags = ["tutorial", "zola"]
+++

# Getting Started with Zola

Zola is a fast static site generator written in Rust. It's what powers the Tanuki theme, and it's a joy to work with.

## Why Zola?

There are many static site generators out there—Jekyll, Hugo, Eleventy, Next.js—so why choose Zola?

### Speed

Zola is incredibly fast. A typical site builds in milliseconds, not seconds. This makes development pleasant and deployments quick.

### Single Binary

Unlike Jekyll (Ruby) or Eleventy (Node.js), Zola is a single binary with no dependencies. Download it, run it, done.

### Built-in Features

Zola includes everything you need out of the box:

- Sass compilation
- Syntax highlighting
- Search index generation
- Image processing
- Shortcodes
- Taxonomies (tags, categories)
- Multilingual support

No plugins to install, no configuration rabbit holes.

## Installation

### macOS (Homebrew)

```bash
brew install zola
```

### Linux

```bash
# Snap
snap install zola --edge

# Or download from GitHub releases
wget https://github.com/getzola/zola/releases/download/v0.19.2/zola-v0.19.2-x86_64-unknown-linux-gnu.tar.gz
tar xzf zola-*.tar.gz
sudo mv zola /usr/local/bin/
```

### Windows

```powershell
# Scoop
scoop install zola

# Or Chocolatey
choco install zola
```

## Creating a New Site

```bash
zola init my-site
cd my-site
```

Zola will ask a few questions about your site configuration. Answer them, and you'll have a basic structure:

```
my-site/
├── config.toml
├── content/
├── sass/
├── static/
├── templates/
└── themes/
```

## Adding Content

Content goes in the `content/` directory as Markdown files:

```markdown
+++
title = "My First Post"
date = 2024-12-27
+++

# Hello, World!

This is my first post using Zola.
```

The `+++` section is called front matter—it's TOML by default and contains metadata about your page.

## Development Server

Run the development server:

```bash
zola serve
```

Open http://127.0.0.1:1111 and you'll see your site. Changes trigger automatic rebuilds and browser refresh.

## Building for Production

```bash
zola build
```

Your complete site will be in the `public/` directory, ready to deploy anywhere.

## Next Steps

- Read the [Zola documentation](https://www.getzola.org/documentation/)
- Explore the [Tanuki theme documentation](/docs/)
- Join the [Zola Discord](https://discord.gg/WN8n6xqp)

Happy building!
