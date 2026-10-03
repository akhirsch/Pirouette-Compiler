# Pirouette Compiler Documentation Site

Documentation site for the Pirouette Compiler, built with [Zola](https://www.getzola.org/).

## Prerequisites

Current Version: zola 0.22.1

This site requires **Zola 0.22.1** specifically. Newer versions (e.g. 0.23.x) break the `tanuki` theme's templates.

```sh
zola --version
```

## Building the Site with Changes

If you have made documentation changes/additions:

```sh
zola build
```

## Launch Zola Site

To serve the website:

```sh
zola serve
```