+++
title = "Chapter 3: JavaScript Essentials"
description = "Core JavaScript concepts every developer should know."
weight = 3
+++

# Chapter 3: JavaScript Essentials

JavaScript is the programming language of the web. From simple interactions to complex single-page applications, JavaScript powers the dynamic experiences users expect.

## Variables and Data Types

JavaScript has three ways to declare variables:

```javascript
var legacy = "Avoid this in modern code";
let mutable = "Can be reassigned";
const immutable = "Cannot be reassigned";
```

### Primitive Types

```javascript
// String
const name = "Tanuki";

// Number (integers and floats)
const count = 42;
const price = 19.99;

// Boolean
const isActive = true;

// Null and Undefined
const empty = null;
let notAssigned; // undefined

// Symbol (unique identifiers)
const id = Symbol('id');

// BigInt (large integers)
const huge = 9007199254740991n;
```

## Functions

Functions are first-class citizens in JavaScript:

```javascript
// Function declaration
function greet(name) {
    return `Hello, ${name}!`;
}

// Function expression
const greet = function(name) {
    return `Hello, ${name}!`;
};

// Arrow function
const greet = (name) => `Hello, ${name}!`;

// Arrow function with body
const greet = (name) => {
    const greeting = `Hello, ${name}!`;
    console.log(greeting);
    return greeting;
};
```

### Higher-Order Functions

Functions that take or return other functions:

```javascript
const numbers = [1, 2, 3, 4, 5];

// map: transform each element
const doubled = numbers.map(n => n * 2);
// [2, 4, 6, 8, 10]

// filter: keep elements that pass a test
const evens = numbers.filter(n => n % 2 === 0);
// [2, 4]

// reduce: combine elements into a single value
const sum = numbers.reduce((acc, n) => acc + n, 0);
// 15
```

## Asynchronous JavaScript

The web is inherently asynchronous. JavaScript provides several patterns for handling async operations.

### Promises

```javascript
function fetchUser(id) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            if (id > 0) {
                resolve({ id, name: 'Tanuki' });
            } else {
                reject(new Error('Invalid ID'));
            }
        }, 1000);
    });
}

fetchUser(1)
    .then(user => console.log(user.name))
    .catch(error => console.error(error));
```

### Async/Await

A cleaner syntax for working with Promises:

```javascript
async function displayUser(id) {
    try {
        const user = await fetchUser(id);
        console.log(user.name);
    } catch (error) {
        console.error('Failed to fetch user:', error);
    }
}
```

## Modules

Modern JavaScript uses ES Modules for code organization:

```javascript
// math.js
export const PI = 3.14159;

export function add(a, b) {
    return a + b;
}

export default function multiply(a, b) {
    return a * b;
}
```

```javascript
// main.js
import multiply, { PI, add } from './math.js';

console.log(PI);           // 3.14159
console.log(add(2, 3));    // 5
console.log(multiply(4, 5)); // 20
```

## The DOM API

Interacting with the Document Object Model:

```javascript
// Selecting elements
const button = document.querySelector('.submit-btn');
const items = document.querySelectorAll('.item');

// Creating elements
const div = document.createElement('div');
div.className = 'card';
div.textContent = 'Hello!';

// Modifying elements
button.classList.add('active');
button.setAttribute('disabled', true);
button.style.backgroundColor = 'blue';

// Event handling
button.addEventListener('click', (event) => {
    event.preventDefault();
    console.log('Clicked!');
});

// Appending to DOM
document.body.appendChild(div);
```

## Error Handling

Robust error handling is crucial:

```javascript
try {
    const data = JSON.parse(invalidJson);
    processData(data);
} catch (error) {
    if (error instanceof SyntaxError) {
        console.error('Invalid JSON:', error.message);
    } else {
        throw error; // Re-throw unexpected errors
    }
} finally {
    cleanup();
}
```

## Summary

This chapter covered JavaScript fundamentals:

- Variables and data types
- Functions and higher-order functions
- Asynchronous programming with Promises and async/await
- ES Modules for code organization
- DOM manipulation
- Error handling

> **Remember**: JavaScript is a multi-paradigm language. You can write imperative, functional, or object-oriented code. Choose the style that best fits your problem.

In the next chapter, we'll explore performance optimization techniques.
