#!/usr/bin/env bun
console.log("Welcome to DevDen - The secret lair where all development magic happens!");

/**
 * This is a sample file to demonstrate Bun functionality.
 * You can replace this with your actual application code.
 */

// Define server interface
interface ServerResponse {
  name: string;
  version: string;
  environment: string;
}

// Example of Bun's built-in features
const server = Bun.serve({
  port: 3000,
  fetch(req: Request): Response {
    const url = new URL(req.url);
    if (url.pathname === "/") {
      return new Response("Welcome to DevDen API!");
    }
    if (url.pathname === "/version") {
      const responseData: ServerResponse = {
        name: "DevDen",
        version: "1.0.0",
        environment: Bun.env.NODE_ENV || "development"
      };
      return Response.json(responseData);
    }
    return new Response("Not Found", { status: 404 });
  },
});

console.log(`DevDen server listening on http://localhost:${server.port}`);
