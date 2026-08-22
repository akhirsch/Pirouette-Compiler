+++
title = "Building Accessible Websites: A Practical Guide"
description = "Accessibility isn't optional—it's essential. Learn the practical steps to make your website usable by everyone."
date = 2024-12-12
[taxonomies]
tags = ["accessibility", "html", "design"]
+++

# Building Accessible Websites: A Practical Guide

Web accessibility ensures your site works for everyone, including people with disabilities. Here's how to do it right.

## Semantic HTML

Use the right elements for the job:

```html
<!-- Bad -->
<div class="button" onclick="submit()">Submit</div>

<!-- Good -->
<button type="submit">Submit</button>
```

Semantic elements provide built-in accessibility features that `div`s don't have.

## Keyboard Navigation

Everything clickable should be keyboard accessible:

```css
/* Make focus visible */
:focus {
    outline: 2px solid var(--accent);
    outline-offset: 2px;
}

/* Don't hide focus outlines */
:focus:not(:focus-visible) {
    outline: none;
}
:focus-visible {
    outline: 2px solid var(--accent);
}
```

Test your site using only the keyboard: Tab, Shift+Tab, Enter, and Escape should work everywhere.

## Alt Text for Images

Every image needs alt text:

```html
<!-- Informative image -->
<img src="chart.png" alt="Sales increased 50% in Q4 2024">

<!-- Decorative image -->
<img src="divider.png" alt="" role="presentation">
```

If an image is decorative, use an empty alt attribute.

## Color Contrast

Ensure sufficient contrast between text and background:

- **4.5:1** minimum for normal text
- **3:1** minimum for large text (18px+ or 14px+ bold)

Don't rely on color alone to convey information:

```html
<!-- Bad: color only -->
<span class="error">Invalid email</span>

<!-- Good: color + icon + text -->
<span class="error">
    <svg aria-hidden="true"><!-- error icon --></svg>
    Invalid email address
</span>
```

## ARIA Labels

Use ARIA when HTML semantics aren't enough:

```html
<button aria-label="Close dialog">
    <svg><!-- X icon --></svg>
</button>

<nav aria-label="Main navigation">
    <!-- links -->
</nav>

<div role="alert" aria-live="polite">
    Your changes have been saved.
</div>
```

But remember: **no ARIA is better than bad ARIA**.

## Skip Links

Let keyboard users skip repetitive navigation:

```html
<a href="#main-content" class="skip-link">
    Skip to main content
</a>

<!-- ... navigation ... -->

<main id="main-content">
    <!-- content -->
</main>
```

```css
.skip-link {
    position: absolute;
    top: -100%;
}
.skip-link:focus {
    top: 0;
}
```

## Testing Accessibility

Use these tools:

- **axe DevTools**: Browser extension for automated testing
- **WAVE**: Web accessibility evaluation tool
- **Screen readers**: VoiceOver (Mac), NVDA (Windows)

Run `lighthouse` in Chrome DevTools for an accessibility audit.

## Quick Wins

1. Add `lang` attribute to `<html>`
2. Use descriptive link text (not "click here")
3. Ensure form inputs have labels
4. Add captions to videos
5. Test at 200% zoom

Accessibility benefits everyone—not just users with disabilities.
