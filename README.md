# DevDen

The secret lair where all development magic happens. A repository containing development container configurations and other necessary development tools.

## 🚀 Features

- Pre-configured development containers
- GitHub templates for Pull Requests
- Predefined GitHub Actions for workflow automation
- Standardized project setup with Bun and TypeScript
- Comprehensive configurations for multiple development environments
- Type-safe development with TypeScript

## 📋 Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop) installed
- [VS Code](https://code.visualstudio.com/) with the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension
- [GitHub CLI](https://cli.github.com/) (optional, for GitHub-related features)
- [Bun](https://bun.sh/) (optional, for local development without containers)

## 🛠️ Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/devden.git
   cd devden
   ```

2. Open in VS Code with Dev Containers:
   ```bash
   code .
   ```
   Then click on "Reopen in Container" when prompted, or use the Command Palette (F1) and select "Remote-Containers: Reopen in Container".

3. Inside the container, set up the project:
   ```bash
   bun run setup
   ```

## 📁 Project Structure

```
devden/
├── .devcontainer/          # Development container configuration
├── .github/                # GitHub templates and workflow configurations
├── scripts/                # Utility scripts for project setup and maintenance
├── docs/                   # Documentation
├── templates/              # Reusable project templates
├── index.ts                # Main entry point for the project
├── index.test.ts           # Tests for the main entry point
├── tsconfig.json           # TypeScript configuration
└── types.d.ts              # Global type definitions
```

## 📄 Scripts

- `bun setup` - Install dependencies
- `bun start` - Run the project
- `bun test` - Run tests
- `bun format` - Format code using Prettier
- `bun lint` - Lint code using ESLint
- `bun dev` - Run the project in development mode with hot reloading
- `bun build` - Build the TypeScript project
- `bun typecheck` - Type check the TypeScript code without emitting output

## 🧪 Testing

The project includes a basic test setup using Bun's built-in test runner. Run tests with:

```bash
bun test
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This a private project. For private use ONLY.
