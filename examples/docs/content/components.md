+++
title = "API Reference"
description = "Complete API reference for the Acme SDK."
weight = 3
+++

# API Reference

Complete reference for all Acme SDK methods and types.

## Users

Manage user accounts and profiles.

### `users.get(id)`

Retrieve a user by ID.

```javascript
const user = await client.users.get('user_123');
// Returns: { id, email, name, createdAt, ... }
```

### `users.list(options?)`

List all users with optional filtering.

```javascript
const users = await client.users.list({
  limit: 20,
  offset: 0,
  status: 'active',
});
```

### `users.create(data)`

Create a new user.

```javascript
const user = await client.users.create({
  email: 'jane@example.com',
  name: 'Jane Doe',
  role: 'member',
});
```

### `users.update(id, data)`

Update an existing user.

```javascript
const user = await client.users.update('user_123', {
  name: 'Jane Smith',
});
```

### `users.delete(id)`

Delete a user.

```javascript
await client.users.delete('user_123');
```

---

## Widgets

> **New in v1.2.0** — Build custom UI components with the Widgets API.

### `widgets.create(config)`

Create a new widget instance.

```javascript
const widget = await client.widgets.create({
  type: 'payment-form',
  container: '#widget-container',
  theme: 'dark',
});
```

### `widgets.render()`

Render the widget to the DOM.

```javascript
await widget.render();
```

### `widgets.on(event, handler)`

Subscribe to widget events.

```javascript
widget.on('success', (data) => {
  console.log('Payment successful:', data);
});

widget.on('error', (error) => {
  console.error('Widget error:', error);
});
```

---

## Events

Real-time event subscriptions.

### `events.subscribe(channel)`

Subscribe to a channel for real-time updates.

```javascript
const subscription = client.events.subscribe('user_123');

subscription.on('user.updated', (event) => {
  console.log('User updated:', event.data);
});
```

### `events.unsubscribe(channel)`

Unsubscribe from a channel.

```javascript
client.events.unsubscribe('user_123');
```

---

## Error Handling

The SDK throws typed errors for different scenarios:

```javascript
import { AcmeError, RateLimitError, AuthError } from '@acme/sdk';

try {
  await client.users.get('user_123');
} catch (error) {
  if (error instanceof RateLimitError) {
    console.log('Rate limited, retry after:', error.retryAfter);
  } else if (error instanceof AuthError) {
    console.log('Invalid API key');
  } else if (error instanceof AcmeError) {
    console.log('API error:', error.message);
  }
}
```

## Next Steps

Learn about [Customization](/customization/) for advanced usage patterns.
