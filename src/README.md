# DevDen Source Code

This directory contains the TypeScript source code for the DevDen project.

## Directory Structure

- `utils/` - Utility functions and helpers
- Add more directories as the project grows (components, services, etc.)

## Development Guidelines

- Use TypeScript for all new code
- Follow the project's ESLint and Prettier configurations
- Keep modules small and focused on a single responsibility
- Add proper documentation using JSDoc comments
- Write tests for your code in `.test.ts` files alongside the source code

## Import Structure

Follow this pattern for imports:

1. External libraries
2. Project modules (from other directories)
3. Local modules (from the same directory)

Example:

```typescript
// 1. External libraries
import { join } from 'path';
import { existsSync } from 'fs';

// 2. Project modules
import { config } from '../config';

// 3. Local modules
import { formatOutput } from './helpers';
```
