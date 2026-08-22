+++
title = "Advanced Usage"
description = "Advanced patterns and customization for the Acme SDK."
weight = 4
+++

# Advanced Usage

Learn advanced patterns for getting the most out of the Acme SDK.

## Middleware

Add custom middleware to intercept requests and responses:

```javascript
import { Acme } from '@acme/sdk';

const client = new Acme({
  apiKey: process.env.ACME_API_KEY,
  middleware: [
    // Logging middleware
    async (request, next) => {
      console.log(`[Acme] ${request.method} ${request.url}`);
      const start = Date.now();
      const response = await next(request);
      console.log(`[Acme] Completed in ${Date.now() - start}ms`);
      return response;
    },
    // Auth refresh middleware
    async (request, next) => {
      try {
        return await next(request);
      } catch (error) {
        if (error.code === 'TOKEN_EXPIRED') {
          await refreshToken();
          return next(request);
        }
        throw error;
      }
    },
  ],
});
```

## Batching Requests

Batch multiple operations for better performance:

```javascript
const results = await client.batch([
  { method: 'users.get', params: { id: 'user_1' } },
  { method: 'users.get', params: { id: 'user_2' } },
  { method: 'users.get', params: { id: 'user_3' } },
]);

// results[0] = user_1 data
// results[1] = user_2 data
// results[2] = user_3 data
```

## Pagination

Handle paginated responses with built-in iterators:

```javascript
// Manual pagination
let page = await client.users.list({ limit: 100 });

while (page.hasMore) {
  for (const user of page.data) {
    console.log(user.name);
  }
  page = await page.next();
}

// Async iterator (recommended)
for await (const user of client.users.listAll()) {
  console.log(user.name);
}
```

## Custom HTTP Client

Use your own HTTP client for advanced networking needs:

```javascript
import { Acme } from '@acme/sdk';
import axios from 'axios';

const httpClient = {
  async request(config) {
    const response = await axios({
      url: config.url,
      method: config.method,
      headers: config.headers,
      data: config.body,
    });
    return {
      status: response.status,
      headers: response.headers,
      body: response.data,
    };
  },
};

const client = new Acme({
  apiKey: process.env.ACME_API_KEY,
  httpClient,
});
```

## Webhooks

Verify and handle incoming webhooks:

```javascript
import { Acme, WebhookError } from '@acme/sdk';
import express from 'express';

const app = express();

app.post('/webhooks/acme', express.raw({ type: '*/*' }), (req, res) => {
  const signature = req.headers['x-acme-signature'];

  try {
    const event = Acme.webhooks.verify(
      req.body,
      signature,
      process.env.ACME_WEBHOOK_SECRET
    );

    switch (event.type) {
      case 'user.created':
        handleUserCreated(event.data);
        break;
      case 'user.deleted':
        handleUserDeleted(event.data);
        break;
    }

    res.status(200).send('OK');
  } catch (error) {
    if (error instanceof WebhookError) {
      console.error('Invalid webhook signature');
      res.status(400).send('Invalid signature');
    }
  }
});
```

## Caching

Implement response caching for improved performance:

```javascript
import { Acme } from '@acme/sdk';

const cache = new Map();

const client = new Acme({
  apiKey: process.env.ACME_API_KEY,
  cache: {
    get: (key) => cache.get(key),
    set: (key, value, ttl) => {
      cache.set(key, value);
      setTimeout(() => cache.delete(key), ttl);
    },
  },
  cacheTTL: 60000, // 1 minute
});
```

## Migration from v1.1.x

> **Breaking Changes in v1.2.0**

### Async/Await

All methods now return Promises instead of using callbacks:

```javascript
// v1.1.x (deprecated)
client.users.get('user_123', (err, user) => {
  if (err) throw err;
  console.log(user);
});

// v1.2.x
const user = await client.users.get('user_123');
```

### Import Changes

```javascript
// v1.1.x
const Acme = require('@acme/sdk');

// v1.2.x
import { Acme } from '@acme/sdk';
// or
const { Acme } = require('@acme/sdk');
```
