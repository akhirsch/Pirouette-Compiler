+++
title = "Modern JavaScript Features You Should Be Using"
description = "ES2020+ brought powerful features that make JavaScript more expressive and less error-prone. Here are the ones worth adopting."
date = 2024-12-20
[taxonomies]
tags = ["javascript", "es2020", "frontend"]
+++

# Modern JavaScript Features You Should Be Using

JavaScript evolves yearly. Here are features from recent versions that genuinely improve code quality.

## Optional Chaining (?.)

Stop writing defensive chains:

```javascript
// Before
const city = user && user.address && user.address.city;

// After
const city = user?.address?.city;
```

Works with methods and arrays too:

```javascript
const result = obj.method?.();
const first = arr?.[0];
```

## Nullish Coalescing (??)

Default values that respect `0` and `''`:

```javascript
// Problem with ||
const count = response.count || 10; // 0 becomes 10!

// Solution with ??
const count = response.count ?? 10; // 0 stays 0
```

## Logical Assignment Operators

Combine logical operators with assignment:

```javascript
// ||= assigns if falsy
options.timeout ||= 3000;

// ??= assigns if nullish
user.name ??= 'Anonymous';

// &&= assigns if truthy
config.debug &&= validateDebugMode();
```

## Array Methods

### at() - Negative Indexing

```javascript
const arr = [1, 2, 3, 4, 5];

// Before
const last = arr[arr.length - 1];

// After
const last = arr.at(-1);
const secondLast = arr.at(-2);
```

### findLast() and findLastIndex()

```javascript
const transactions = [
    { type: 'credit', amount: 100 },
    { type: 'debit', amount: 50 },
    { type: 'credit', amount: 200 },
];

const lastCredit = transactions.findLast(t => t.type === 'credit');
// { type: 'credit', amount: 200 }
```

### toSorted(), toReversed(), toSpliced()

Non-mutating array operations:

```javascript
const original = [3, 1, 2];

const sorted = original.toSorted();
// sorted: [1, 2, 3]
// original: [3, 1, 2] - unchanged!

const reversed = original.toReversed();
const removed = original.toSpliced(1, 1);
```

## Object.groupBy()

Native grouping without lodash:

```javascript
const inventory = [
    { name: 'apples', type: 'fruit' },
    { name: 'bananas', type: 'fruit' },
    { name: 'carrots', type: 'vegetable' },
];

const grouped = Object.groupBy(inventory, item => item.type);
// {
//   fruit: [{ name: 'apples', ... }, { name: 'bananas', ... }],
//   vegetable: [{ name: 'carrots', ... }]
// }
```

## Promise.allSettled()

Wait for all promises regardless of rejection:

```javascript
const results = await Promise.allSettled([
    fetch('/api/users'),
    fetch('/api/posts'),
    fetch('/api/comments'),
]);

results.forEach(result => {
    if (result.status === 'fulfilled') {
        console.log(result.value);
    } else {
        console.error(result.reason);
    }
});
```

## Private Class Fields

True privacy with `#`:

```javascript
class Counter {
    #count = 0;

    increment() {
        this.#count++;
    }

    get value() {
        return this.#count;
    }
}

const counter = new Counter();
counter.increment();
console.log(counter.value); // 1
console.log(counter.#count); // SyntaxError!
```

## Static Blocks

Complex static initialization:

```javascript
class Config {
    static values;

    static {
        try {
            this.values = JSON.parse(localStorage.getItem('config'));
        } catch {
            this.values = { theme: 'dark' };
        }
    }
}
```

## Top-Level Await

Use `await` outside async functions in modules:

```javascript
// config.js
const response = await fetch('/api/config');
export const config = await response.json();

// main.js
import { config } from './config.js';
// config is already resolved
```

## Temporal API (Coming Soon)

Finally, a sane date/time API:

```javascript
// Current (painful)
const date = new Date();
date.setDate(date.getDate() + 7);

// Temporal (clear)
const date = Temporal.Now.plainDateISO();
const nextWeek = date.add({ days: 7 });
```

## Error Cause

Chain errors with context:

```javascript
try {
    await fetchUserData(userId);
} catch (error) {
    throw new Error('Failed to load user profile', {
        cause: error
    });
}
```

## Quick Adoption Guide

| Feature | Use When |
|---------|----------|
| `?.` | Accessing nested properties |
| `??` | Providing defaults (especially for 0/'') |
| `at(-1)` | Accessing from array end |
| `toSorted()` | Sorting without mutation |
| `Object.groupBy()` | Categorizing arrays |
| `#private` | Encapsulating class data |

Check [caniuse.com](https://caniuse.com) for browser support before using in production.
