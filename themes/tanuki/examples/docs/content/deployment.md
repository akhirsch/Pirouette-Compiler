+++
title = "Deployment"
description = "Deploy applications using the Acme SDK."
weight = 5
+++

# Deployment

Best practices for deploying applications that use the Acme SDK.

## Environment Setup

### Production Checklist

Before deploying to production:

- [ ] Use production API keys (not sandbox)
- [ ] Set appropriate timeouts and retry limits
- [ ] Configure error monitoring
- [ ] Enable request logging
- [ ] Set up webhook endpoints

### Environment Variables

Required environment variables:

```bash
# Required
ACME_API_KEY=sk_live_xxxxx

# Optional
ACME_API_VERSION=v3
ACME_TIMEOUT=30000
ACME_RETRIES=3
ACME_WEBHOOK_SECRET=whsec_xxxxx
```

## Platform Guides

### Node.js

```javascript
// server.js
import { Acme } from '@acme/sdk';
import express from 'express';

const client = new Acme({
  apiKey: process.env.ACME_API_KEY,
  retries: 5,
  timeout: 60000,
});

const app = express();

app.get('/api/users/:id', async (req, res) => {
  try {
    const user = await client.users.get(req.params.id);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(3000);
```

### Serverless (AWS Lambda)

```javascript
// handler.js
import { Acme } from '@acme/sdk';

// Initialize outside handler for connection reuse
const client = new Acme({
  apiKey: process.env.ACME_API_KEY,
});

export const handler = async (event) => {
  const user = await client.users.get(event.userId);
  return {
    statusCode: 200,
    body: JSON.stringify(user),
  };
};
```

### Edge Functions (Cloudflare Workers)

```javascript
// worker.js
import { Acme } from '@acme/sdk/edge';

export default {
  async fetch(request, env) {
    const client = new Acme({
      apiKey: env.ACME_API_KEY,
    });

    const url = new URL(request.url);
    const userId = url.searchParams.get('id');
    const user = await client.users.get(userId);

    return new Response(JSON.stringify(user), {
      headers: { 'Content-Type': 'application/json' },
    });
  },
};
```

## Monitoring

### Health Checks

Implement health checks to monitor SDK connectivity:

```javascript
app.get('/health', async (req, res) => {
  try {
    await client.ping();
    res.json({ status: 'healthy', sdk: 'connected' });
  } catch (error) {
    res.status(503).json({ status: 'unhealthy', error: error.message });
  }
});
```

### Error Tracking

Integrate with error tracking services:

```javascript
import * as Sentry from '@sentry/node';
import { Acme, AcmeError } from '@acme/sdk';

const client = new Acme({
  apiKey: process.env.ACME_API_KEY,
  onError: (error) => {
    if (error instanceof AcmeError) {
      Sentry.captureException(error, {
        tags: { sdk: 'acme', version: '1.2.0' },
        extra: { requestId: error.requestId },
      });
    }
  },
});
```

## Rate Limiting

The Acme API has rate limits. Handle them gracefully:

| Plan | Requests/min | Burst |
|------|--------------|-------|
| Free | 60 | 10 |
| Pro | 600 | 100 |
| Enterprise | 6000 | 1000 |

```javascript
import { Acme, RateLimitError } from '@acme/sdk';

try {
  await client.users.list();
} catch (error) {
  if (error instanceof RateLimitError) {
    console.log(`Rate limited. Retry after ${error.retryAfter}s`);
    await sleep(error.retryAfter * 1000);
    // Retry request
  }
}
```

## Security

### API Key Rotation

Rotate API keys periodically:

1. Generate a new key in the [Dashboard](https://dashboard.acme.dev)
2. Update your environment variables
3. Deploy the update
4. Revoke the old key

### Webhook Security

Always verify webhook signatures:

```javascript
const isValid = Acme.webhooks.verify(
  payload,
  signature,
  process.env.ACME_WEBHOOK_SECRET
);

if (!isValid) {
  throw new Error('Invalid webhook signature');
}
```

## Support

- **Documentation**: You're here!
- **API Status**: [status.acme.dev](https://status.acme.dev)
- **Support**: support@acme.dev
- **Enterprise**: enterprise@acme.dev
