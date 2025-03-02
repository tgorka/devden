#!/usr/bin/env bun

/**
 * DevDen Project Setup Script
 *
 * This script helps initialize and configure a new development environment.
 */

import { existsSync, mkdirSync } from 'fs';
import { join } from 'path';
import { exec } from 'child_process';

// Log helpers
type LogFunction = (msg: string) => void;

interface LogHelpers {
  info: LogFunction;
  success: LogFunction;
  warning: LogFunction;
  error: LogFunction;
}

const log: LogHelpers = {
  info: (msg: string) => console.log(`\x1b[36mℹ️  ${msg}\x1b[0m`),
  success: (msg: string) => console.log(`\x1b[32m✅ ${msg}\x1b[0m`),
  warning: (msg: string) => console.log(`\x1b[33m⚠️  ${msg}\x1b[0m`),
  error: (msg: string) => console.log(`\x1b[31m❌ ${msg}\x1b[0m`)
};

// Main setup function
async function setup(): Promise<void> {
  log.info('Starting DevDen project setup...');

  // Ensure required directories exist
  const dirs: string[] = ['scripts', 'templates', 'docs'];
  for (const dir of dirs) {
    if (!existsSync(dir)) {
      mkdirSync(dir);
      log.success(`Created ${dir} directory`);
    }
  }

  // Check if git is initialized
  if (!existsSync('.git')) {
    log.warning('Git repository not found. Initializing...');
    await executeCommand('git init');
  } else {
    log.success('Git repository already initialized');
  }

  // Install dependencies
  log.info('Installing dependencies...');
  await executeCommand('bun install');

  log.success('DevDen setup completed successfully!');
  log.info('To start the development server, run: bun dev');
}

// Helper function to execute shell commands
function executeCommand(command: string): Promise<void> {
  return new Promise((resolve, reject) => {
    log.info(`Executing: ${command}`);
    exec(command, (error: any, stdout: any, stderr: any) => {
      if (error) {
        log.error(`Error executing command: ${error.message}`);
        return reject(error);
      }
      if (stderr) {
        log.warning(stderr);
      }
      if (stdout) {
        console.log(stdout);
      }
      resolve();
    });
  });
}

// Run setup
setup().catch(error => {
  log.error(`Setup failed: ${error.message}`);
  process.exit(1);
});
