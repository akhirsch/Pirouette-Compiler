+++
title = "REST API Design Best Practices"
description = "Good API design makes the difference between a joy to use and a nightmare to integrate. Here's how to get it right."
date = 2024-12-22
[taxonomies]
tags = ["api", "rest", "backend"]
+++

# REST API Design Best Practices

Your API is a contract. Make it one developers actually want to sign.

## Use Nouns, Not Verbs

The HTTP method is the verb. The URL is the noun.

```
# Bad
GET /getUsers
POST /createUser
DELETE /deleteUser/123

# Good
GET /users
POST /users
DELETE /users/123
```

## Use Plural Resource Names

Consistency matters more than grammar debates:

```
GET /users        # List users
GET /users/123    # Get one user
POST /users       # Create user
PUT /users/123    # Update user
DELETE /users/123 # Delete user
```

## Nest Related Resources

Show relationships through URL structure:

```
GET /users/123/posts      # Posts by user 123
GET /posts/456/comments   # Comments on post 456
```

But don't nest too deeply:

```
# Too deep
GET /users/123/posts/456/comments/789/likes

# Better: use query params or separate endpoint
GET /likes?comment=789
```

## HTTP Status Codes

Use them correctly:

| Code | Meaning | When to Use |
|------|---------|-------------|
| 200 | OK | Successful GET, PUT, PATCH |
| 201 | Created | Successful POST |
| 204 | No Content | Successful DELETE |
| 400 | Bad Request | Invalid syntax, validation errors |
| 401 | Unauthorized | Missing/invalid authentication |
| 403 | Forbidden | Authenticated but not allowed |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Duplicate resource, version conflict |
| 422 | Unprocessable | Valid syntax but semantic errors |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Server Error | Something broke |

## Consistent Error Format

Always return errors in the same shape:

```json
{
    "error": {
        "code": "VALIDATION_ERROR",
        "message": "Invalid input data",
        "details": [
            {
                "field": "email",
                "message": "Must be a valid email address"
            },
            {
                "field": "age",
                "message": "Must be at least 18"
            }
        ]
    }
}
```

## Pagination

For any list endpoint, support pagination:

```
GET /posts?page=2&limit=20
```

Return pagination metadata:

```json
{
    "data": [...],
    "pagination": {
        "page": 2,
        "limit": 20,
        "total": 156,
        "pages": 8
    }
}
```

Or use cursor-based pagination for large datasets:

```
GET /posts?cursor=eyJpZCI6MTAwfQ&limit=20
```

## Filtering and Sorting

Use query parameters:

```
GET /posts?status=published&author=123
GET /posts?sort=-created_at,title
GET /posts?created_after=2024-01-01
```

The `-` prefix indicates descending order.

## Partial Responses

Let clients request only what they need:

```
GET /users/123?fields=id,name,email
```

Response:

```json
{
    "id": 123,
    "name": "Jane Doe",
    "email": "jane@example.com"
}
```

## Versioning

Version your API from day one:

```
# URL path (most common)
GET /v1/users

# Header
GET /users
Accept: application/vnd.api+json;version=1

# Query param (least preferred)
GET /users?version=1
```

## Rate Limiting Headers

Tell clients their limits:

```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1640995200
```

## HATEOAS (Hypermedia)

Include links for discoverability:

```json
{
    "id": 123,
    "title": "API Design",
    "links": {
        "self": "/posts/123",
        "author": "/users/456",
        "comments": "/posts/123/comments"
    }
}
```

## Idempotency

Make operations safe to retry:

```
# Idempotent (safe to retry)
GET /users/123
PUT /users/123  # Full replacement
DELETE /users/123

# Not idempotent
POST /users  # Creates new each time
```

For non-idempotent operations, accept an idempotency key:

```
POST /payments
Idempotency-Key: abc123

# Retrying with same key returns cached response
```

## Documentation

Good APIs have good docs:

- **OpenAPI/Swagger**: Machine-readable spec
- **Examples**: Show request/response pairs
- **Authentication**: Clear setup instructions
- **Errors**: Document all error codes
- **Changelog**: Track breaking changes

## Quick Checklist

- [ ] Consistent naming conventions
- [ ] Proper HTTP status codes
- [ ] Structured error responses
- [ ] Pagination for lists
- [ ] Rate limiting
- [ ] API versioning
- [ ] Authentication documented
- [ ] OpenAPI specification

Good API design is invisible—developers just get things working without friction.
