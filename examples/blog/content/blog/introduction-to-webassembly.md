+++
title = "Introduction to WebAssembly"
description = "WebAssembly brings near-native performance to the browser. Here's what you need to know to get started."
date = 2024-12-18
[taxonomies]
tags = ["webassembly", "rust", "performance"]
+++

# Introduction to WebAssembly

WebAssembly (Wasm) is a binary instruction format that runs in browsers at near-native speed. It's not here to replace JavaScript—it's here to complement it.

## Why WebAssembly?

JavaScript is incredibly versatile, but some tasks need more performance:

- **Image/video processing**
- **Games and 3D graphics**
- **Compression/encryption**
- **Scientific computing**
- **CAD applications**

WebAssembly handles these without plugins or browser extensions.

## How It Works

```
Source Code → Compiler → .wasm binary → Browser Runtime
(Rust, C++)              (portable)      (sandboxed)
```

The browser downloads the `.wasm` file and executes it in a secure sandbox alongside JavaScript.

## Your First WebAssembly (with Rust)

### 1. Set Up

```bash
# Install the Wasm target
rustup target add wasm32-unknown-unknown

# Install wasm-pack
cargo install wasm-pack
```

### 2. Create a Project

```bash
cargo new --lib hello-wasm
cd hello-wasm
```

### 3. Configure Cargo.toml

```toml
[package]
name = "hello-wasm"
version = "0.1.0"
edition = "2021"

[lib]
crate-type = ["cdylib"]

[dependencies]
wasm-bindgen = "0.2"
```

### 4. Write Rust Code

```rust
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}

#[wasm_bindgen]
pub fn fibonacci(n: u32) -> u32 {
    match n {
        0 => 0,
        1 => 1,
        _ => fibonacci(n - 1) + fibonacci(n - 2),
    }
}
```

### 5. Build

```bash
wasm-pack build --target web
```

### 6. Use in JavaScript

```html
<script type="module">
    import init, { greet, fibonacci } from './pkg/hello_wasm.js';

    async function main() {
        await init();
        console.log(greet("World"));
        console.log(fibonacci(40)); // Much faster than JS
    }

    main();
</script>
```

## Performance Comparison

Computing Fibonacci(45):

| Language | Time |
|----------|------|
| JavaScript | ~8 seconds |
| WebAssembly (Rust) | ~4 seconds |
| Native Rust | ~3 seconds |

For compute-heavy tasks, Wasm can be 2-10x faster than JavaScript.

## Real-World Use Cases

### Figma
The design tool uses WebAssembly for its rendering engine, enabling smooth performance with complex designs.

### Photoshop Web
Adobe ported significant portions of Photoshop to Wasm for the web version.

### Google Earth
Complex 3D rendering runs smoothly thanks to WebAssembly.

### SQLite in the Browser
The entire SQLite database engine compiled to Wasm.

## Interacting with the DOM

WebAssembly can't directly access the DOM—it must go through JavaScript:

```rust
use wasm_bindgen::prelude::*;
use web_sys::console;

#[wasm_bindgen(start)]
pub fn main() {
    console::log_1(&"Hello from Wasm!".into());
}
```

```toml
# Add to Cargo.toml
[dependencies.web-sys]
version = "0.3"
features = ["console"]
```

## Memory Management

Wasm has its own linear memory that JavaScript can read:

```rust
#[wasm_bindgen]
pub fn process_image(data: &[u8]) -> Vec<u8> {
    // Process and return new data
    data.iter().map(|&x| 255 - x).collect()
}
```

## When NOT to Use WebAssembly

- **Simple DOM manipulation**: JavaScript is faster to develop
- **Small utilities**: The Wasm overhead isn't worth it
- **I/O-bound tasks**: Network/file operations are limited by the browser
- **When bundle size matters**: Wasm adds payload

## The Future

- **WASI**: WebAssembly System Interface for running outside browsers
- **Component Model**: Better interoperability between Wasm modules
- **Garbage Collection**: Native GC support coming soon
- **Threads**: Shared memory and threading support

WebAssembly isn't just for browsers anymore—it's becoming a universal runtime.
