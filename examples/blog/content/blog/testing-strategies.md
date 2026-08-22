+++
title = "Testing Strategies That Actually Work"
description = "Testing isn't about coverage percentages. It's about confidence. Here's how to test effectively."
date = 2024-12-26
[taxonomies]
tags = ["testing", "quality", "development"]
+++

# Testing Strategies That Actually Work

The goal of testing isn't 100% coverage. It's confidence to ship.

## The Testing Trophy

Forget the pyramid. Think trophy:

```
        ╱╲
       ╱  ╲      E2E (few)
      ╱────╲
     ╱      ╲    Integration (most)
    ╱────────╲
   ╱          ╲  Unit (some)
  ╱────────────╲
 │  Static Types │
 └──────────────┘
```

**Static analysis** catches the most bugs with the least effort.

## Unit Tests

Test pure functions and isolated logic:

```javascript
// utils.test.js
import { formatCurrency, calculateDiscount } from './utils';

describe('formatCurrency', () => {
    it('formats positive amounts', () => {
        expect(formatCurrency(1234.5)).toBe('$1,234.50');
    });

    it('handles zero', () => {
        expect(formatCurrency(0)).toBe('$0.00');
    });

    it('formats negative amounts', () => {
        expect(formatCurrency(-50)).toBe('-$50.00');
    });
});

describe('calculateDiscount', () => {
    it('applies percentage discount', () => {
        expect(calculateDiscount(100, 0.2)).toBe(80);
    });

    it('never goes below zero', () => {
        expect(calculateDiscount(10, 2)).toBe(0);
    });
});
```

### When to Unit Test

- Pure functions
- Complex business logic
- Utility functions
- State reducers
- Data transformations

### When NOT to Unit Test

- Simple getters/setters
- Framework code
- Implementation details
- One-liner functions

## Integration Tests

Test how pieces work together:

```javascript
// api.test.js
import { createServer } from '../server';
import { db } from '../database';

describe('POST /users', () => {
    let server;

    beforeAll(async () => {
        server = await createServer();
        await db.migrate();
    });

    afterAll(async () => {
        await db.close();
        await server.close();
    });

    beforeEach(async () => {
        await db.truncate('users');
    });

    it('creates a user and returns 201', async () => {
        const response = await server.inject({
            method: 'POST',
            url: '/users',
            payload: {
                email: 'test@example.com',
                name: 'Test User',
            },
        });

        expect(response.statusCode).toBe(201);
        expect(response.json()).toMatchObject({
            email: 'test@example.com',
            name: 'Test User',
        });

        // Verify database
        const user = await db.query('SELECT * FROM users WHERE email = $1', ['test@example.com']);
        expect(user).toBeDefined();
    });

    it('returns 400 for invalid email', async () => {
        const response = await server.inject({
            method: 'POST',
            url: '/users',
            payload: {
                email: 'not-an-email',
                name: 'Test',
            },
        });

        expect(response.statusCode).toBe(400);
        expect(response.json().error.code).toBe('VALIDATION_ERROR');
    });
});
```

## Component Tests (Frontend)

Test components with realistic interactions:

```javascript
// UserProfile.test.jsx
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { UserProfile } from './UserProfile';
import { server } from '../mocks/server';
import { rest } from 'msw';

describe('UserProfile', () => {
    it('displays user information', async () => {
        render(<UserProfile userId="123" />);

        await waitFor(() => {
            expect(screen.getByRole('heading')).toHaveTextContent('Jane Doe');
        });

        expect(screen.getByText('jane@example.com')).toBeInTheDocument();
    });

    it('handles edit mode', async () => {
        const user = userEvent.setup();
        render(<UserProfile userId="123" />);

        await user.click(screen.getByRole('button', { name: /edit/i }));

        const input = screen.getByLabelText(/name/i);
        await user.clear(input);
        await user.type(input, 'Jane Smith');
        await user.click(screen.getByRole('button', { name: /save/i }));

        await waitFor(() => {
            expect(screen.getByRole('heading')).toHaveTextContent('Jane Smith');
        });
    });

    it('shows error state', async () => {
        server.use(
            rest.get('/api/users/:id', (req, res, ctx) => {
                return res(ctx.status(500));
            })
        );

        render(<UserProfile userId="123" />);

        await waitFor(() => {
            expect(screen.getByRole('alert')).toHaveTextContent(/failed to load/i);
        });
    });
});
```

## E2E Tests

Test critical user journeys:

```javascript
// checkout.spec.js (Playwright)
import { test, expect } from '@playwright/test';

test.describe('Checkout Flow', () => {
    test('completes purchase successfully', async ({ page }) => {
        // Add item to cart
        await page.goto('/products/widget');
        await page.click('button:has-text("Add to Cart")');

        // Go to checkout
        await page.click('a:has-text("Checkout")');

        // Fill shipping
        await page.fill('[name="email"]', 'test@example.com');
        await page.fill('[name="address"]', '123 Main St');
        await page.fill('[name="city"]', 'Portland');
        await page.selectOption('[name="state"]', 'OR');
        await page.fill('[name="zip"]', '97201');

        // Fill payment (test card)
        await page.fill('[name="cardNumber"]', '4242424242424242');
        await page.fill('[name="expiry"]', '12/25');
        await page.fill('[name="cvc"]', '123');

        // Submit
        await page.click('button:has-text("Place Order")');

        // Verify success
        await expect(page.locator('h1')).toHaveText('Order Confirmed');
        await expect(page.locator('.order-number')).toBeVisible();
    });
});
```

### E2E Best Practices

- Test happy paths thoroughly
- Use realistic test data
- Run in CI on every PR
- Keep tests independent
- Use test IDs for stability

## What NOT to Test

- Third-party libraries
- Framework internals
- Private implementation details
- Simple pass-through code
- Autogenerated code

## Test Data Strategies

### Factories

```javascript
// factories/user.js
import { faker } from '@faker-js/faker';

export function createUser(overrides = {}) {
    return {
        id: faker.string.uuid(),
        email: faker.internet.email(),
        name: faker.person.fullName(),
        createdAt: faker.date.past(),
        ...overrides,
    };
}

// In tests
const user = createUser({ email: 'specific@test.com' });
```

### Fixtures

```javascript
// fixtures/users.json
{
    "admin": {
        "id": "admin-001",
        "email": "admin@example.com",
        "role": "admin"
    },
    "regular": {
        "id": "user-001",
        "email": "user@example.com",
        "role": "user"
    }
}
```

## Measuring Test Quality

Coverage is a **floor**, not a **ceiling**.

Better metrics:
- **Mutation score**: Do tests catch bugs?
- **Flakiness rate**: Are tests reliable?
- **Time to run**: Are tests fast enough?
- **Maintenance cost**: Are tests easy to update?

## Quick Guidelines

| Test Type | Speed | Confidence | Quantity |
|-----------|-------|------------|----------|
| Static | Instant | Medium | All code |
| Unit | Fast | Low-Medium | Some |
| Integration | Medium | High | Most |
| E2E | Slow | Highest | Few |

Write tests that give you confidence to ship, not tests that give you coverage badges.
