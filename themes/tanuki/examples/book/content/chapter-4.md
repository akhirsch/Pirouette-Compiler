+++
title = "Chapter 4: Performance"
description = "Optimizing web application performance."
weight = 4
+++

# Chapter 4: Performance

Performance is a feature. Slow websites lose users, reduce conversions, and rank lower in search results. This chapter covers the key strategies for building fast web applications.

## Understanding Performance Metrics

Modern performance measurement focuses on user-centric metrics:

| Metric | What It Measures | Target |
|--------|------------------|--------|
| **LCP** (Largest Contentful Paint) | Loading performance | < 2.5s |
| **FID** (First Input Delay) | Interactivity | < 100ms |
| **CLS** (Cumulative Layout Shift) | Visual stability | < 0.1 |
| **TTFB** (Time to First Byte) | Server response | < 200ms |
| **FCP** (First Contentful Paint) | Initial render | < 1.8s |

## Optimizing Loading Performance

### Critical Rendering Path

The browser must complete several steps before rendering:

1. Parse HTML → Build DOM
2. Parse CSS → Build CSSOM
3. Combine → Render Tree
4. Layout → Paint → Composite

```html
<!-- Inline critical CSS -->
<style>
    /* Only what's needed for above-the-fold content */
    body { font-family: system-ui; }
    .hero { height: 100vh; }
</style>

<!-- Defer non-critical CSS -->
<link rel="preload" href="styles.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
```

### Resource Hints

Tell the browser about resources you'll need:

```html
<!-- DNS prefetch for external origins -->
<link rel="dns-prefetch" href="//api.example.com">

<!-- Preconnect for critical third parties -->
<link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>

<!-- Preload critical resources -->
<link rel="preload" href="/fonts/main.woff2" as="font" type="font/woff2" crossorigin>

<!-- Prefetch likely next pages -->
<link rel="prefetch" href="/about">
```

## Image Optimization

Images are often the largest assets on a page.

### Modern Formats

```html
<picture>
    <source srcset="image.avif" type="image/avif">
    <source srcset="image.webp" type="image/webp">
    <img src="image.jpg" alt="Description" loading="lazy">
</picture>
```

### Responsive Images

```html
<img
    srcset="small.jpg 400w, medium.jpg 800w, large.jpg 1200w"
    sizes="(max-width: 600px) 400px, (max-width: 1000px) 800px, 1200px"
    src="medium.jpg"
    alt="Description"
    loading="lazy"
    decoding="async"
>
```

## JavaScript Performance

### Code Splitting

Load only what's needed:

```javascript
// Dynamic imports
const module = await import('./heavy-module.js');

// Route-based splitting (framework example)
const routes = {
    '/': () => import('./pages/Home.js'),
    '/about': () => import('./pages/About.js'),
    '/dashboard': () => import('./pages/Dashboard.js'),
};
```

### Debouncing and Throttling

Control how often functions execute:

```javascript
// Debounce: wait until action stops
function debounce(fn, delay) {
    let timeout;
    return (...args) => {
        clearTimeout(timeout);
        timeout = setTimeout(() => fn(...args), delay);
    };
}

// Throttle: limit execution rate
function throttle(fn, limit) {
    let inThrottle;
    return (...args) => {
        if (!inThrottle) {
            fn(...args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    };
}

// Usage
const handleScroll = throttle(() => {
    console.log('Scroll position:', window.scrollY);
}, 100);

window.addEventListener('scroll', handleScroll);
```

### Web Workers

Offload heavy computation:

```javascript
// main.js
const worker = new Worker('worker.js');

worker.postMessage({ data: largeArray });

worker.onmessage = (event) => {
    console.log('Result:', event.data);
};

// worker.js
self.onmessage = (event) => {
    const result = heavyComputation(event.data);
    self.postMessage(result);
};
```

## Caching Strategies

### Service Worker Caching

```javascript
// sw.js
const CACHE_NAME = 'v1';
const ASSETS = [
    '/',
    '/styles.css',
    '/app.js',
    '/offline.html',
];

self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => cache.addAll(ASSETS))
    );
});

self.addEventListener('fetch', (event) => {
    event.respondWith(
        caches.match(event.request)
            .then(response => response || fetch(event.request))
    );
});
```

## Measuring Performance

Use the Performance API:

```javascript
// Measure custom timings
performance.mark('start-operation');

// ... do work ...

performance.mark('end-operation');
performance.measure('operation', 'start-operation', 'end-operation');

// Get measurements
const measures = performance.getEntriesByName('operation');
console.log(`Operation took ${measures[0].duration}ms`);
```

## Summary

Performance optimization requires attention to:

- Core Web Vitals (LCP, FID, CLS)
- Critical rendering path optimization
- Image optimization and modern formats
- JavaScript code splitting and async loading
- Effective caching strategies
- Continuous measurement and monitoring

> **Golden Rule**: Measure first, optimize second. Don't guess where performance problems are—use real data from real users.

In our final chapter, we'll cover accessibility and inclusive design.
