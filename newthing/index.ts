import homepage from "./index.html";

const app = Bun.serve({
  routes: {
    "/": homepage,
  },
  development: {
    // Enable Hot Module Reloading
    hmr: true,

    // Echo console logs from the browser to the terminal
    console: true,
  },
  fetch: undefined,
});

console.log(`Server running at ${app.port}`);
