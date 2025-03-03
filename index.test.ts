import { describe, expect, test } from "bun:test";

// Utility function to create a server - add this to a separate file in a real application
async function fetchFromServer(path: string) {
  const response = await fetch(`http://localhost:3000${path}`);
  return response;
}

// Test the API endpoints
describe("DevDen API Server", () => {
  test("Root path returns welcome message", async () => {
    const response = await fetchFromServer("/");
    expect(response.status).toBe(200);

    const text = await response.text();
    expect(text).toContain("Welcome to DevDen API!");
  });

  test("Version endpoint returns JSON with version info", async () => {
    const response = await fetchFromServer("/version");
    expect(response.status).toBe(200);

    const data = await response.json();
    expect(data).toHaveProperty("name", "DevDen");
    expect(data).toHaveProperty("version");
    expect(data).toHaveProperty("environment");
  });

  test("Unknown path returns 404 Not Found", async () => {
    const response = await fetchFromServer("/unknown-path");
    expect(response.status).toBe(404);

    const text = await response.text();
    expect(text).toBe("Not Found");
  });
});
