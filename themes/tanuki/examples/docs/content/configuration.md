+++
title = "Configuration"
description = "Configure the Acme SDK for your environment."
weight = 2
+++

# Configuration

Learn how to configure the Acme SDK for different environments and use cases.

## API Credentials

The SDK requires an API key for authentication. Get your key from the [Acme Dashboard](https://dashboard.acme.dev).

```javascript
import { Acme } from '@acme/sdk';

const client = new Acme({
  apiKey: 'your-api-key',
  // Optional: specify API version (defaults to v3 in SDK 1.2.0)
  apiVersion: 'v3',
});
```

## Environment Variables

We recommend using environment variables for sensitive configuration:

```bash
# .env
ACME_API_KEY=sk_live_xxxxx
ACME_API_VERSION=v3
ACME_TIMEOUT=30000
```

```javascript
const client = new Acme({
  apiKey: process.env.ACME_API_KEY,
  apiVersion: process.env.ACME_API_VERSION,
  timeout: parseInt(process.env.ACME_TIMEOUT),
});
```

## Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `apiKey` | string | required | Your Acme API key |
| `apiVersion` | string | `"v3"` | API version to use |
| `timeout` | number | `30000` | Request timeout in ms |
| `retries` | number | `3` | Number of retry attempts |
| `baseUrl` | string | `"https://api.acme.dev"` | API base URL |

## Environment-Specific Config

### Development

```javascript
const client = new Acme({
  apiKey: process.env.ACME_API_KEY,
  baseUrl: 'https://sandbox.acme.dev',
  debug: true,
});
```

### Production

```javascript
const client = new Acme({
  apiKey: process.env.ACME_API_KEY,
  retries: 5,
  timeout: 60000,
});
```

## TypeScript Support

The SDK includes full TypeScript definitions:

```typescript
import { Acme, AcmeConfig, User } from '@acme/sdk';

const config: AcmeConfig = {
  apiKey: process.env.ACME_API_KEY!,
  apiVersion: 'v3',
};

const client = new Acme(config);
const user: User = await client.users.get('user_123');
```

## Next Steps

See [API Reference](/components/) for available methods and types.
