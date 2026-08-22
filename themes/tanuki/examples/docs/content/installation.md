+++
title = "Installation"
description = "How to install the Acme SDK in your project."
weight = 1
+++

# Installation

Get started with the Acme SDK in your project.

## Requirements

- Node.js 18.0 or later
- npm, yarn, or pnpm

## Quick Start

Install the SDK using your preferred package manager:

```bash
# npm
npm install @acme/sdk@1.2.0

# yarn
yarn add @acme/sdk@1.2.0

# pnpm
pnpm add @acme/sdk@1.2.0
```

## Verify Installation

Create a simple test to verify the SDK is working:

```javascript
import { Acme } from '@acme/sdk';

const client = new Acme({
  apiKey: process.env.ACME_API_KEY,
});

// Test the connection
const status = await client.ping();
console.log('Acme SDK connected:', status);
```

## Version Compatibility

| SDK Version | Node.js | API Version |
|-------------|---------|-------------|
| 1.2.x       | ≥18.0   | v3          |
| 1.1.x       | ≥16.0   | v2          |
| 1.0.x       | ≥14.0   | v1          |

> **Upgrading?** See the [migration guide](/configuration/) for breaking changes between versions.

## Next Steps

Once installed, head to [Configuration](/configuration/) to set up your API credentials.
