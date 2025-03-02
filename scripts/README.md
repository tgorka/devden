# DevDen Scripts

This directory contains utility scripts for the DevDen project.

## Available Scripts

### setup.ts

A utility script that helps initialize and configure a new development environment.

**Features:**
- Creates necessary directories if they don't exist
- Initializes git repository if not already initialized
- Installs dependencies with Bun

**Usage:**
```bash
# Run the setup script
bun scripts/setup.ts
```

## Adding New Scripts

When adding new scripts to this directory:

1. Use TypeScript for type safety
2. Make sure to add proper documentation
3. Make the script executable with `chmod +x scripts/your-script.ts`
4. Add the script to this README file

## Development Guidelines

- Keep scripts focused on a single responsibility
- Use consistent logging (use the log utility in setup.ts)
- Add proper error handling
- Include TypeScript type definitions
