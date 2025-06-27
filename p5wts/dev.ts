import { serve } from "bun";
import type { BuildArtifact } from 'bun';
import { watch } from "fs";


// Data and configs
const SRC_DIR = "./src";
var latestBuildArtifacts: BuildArtifact[] = [];
var hashedArtifacts: Map<string, BuildArtifact> = new Map<string, BuildArtifact>();
const LOG_LEVEL: 'info' | 'error' | 'warn' | 'trace' = "info"; // Set to "debug" for more verbose logging

// methods
async function build(
{
  path = SRC_DIR, 
  clearCache = true
}:
{
  path?: string, 
  clearCache?: boolean
} = {}) {
  const result = await Bun.build({
    entrypoints: [`${path}/index.ts`],
  });

  if(clearCache) {
    // empty the latestBuildArtifacts array
    latestBuildArtifacts = [];
  }

  for (const res of result.outputs) {
    latestBuildArtifacts.push(res);

    const hash = Bun.hash(await res.arrayBuffer());
    hashedArtifacts.set(`${res.path.slice(2)}`, res); // remove leading "./" from path
    console.log(`Built: ${res.path}`, res.size, `Hash: ${hash}`);
  }

  console.log(`Build complete. ${result.outputs.length} artifacts generated.`);
  console.log(`All artifacts: ${latestBuildArtifacts.length}`);
  for (const [key, value] of Object.entries(hashedArtifacts)) {
    console.log(`Hashed Artifact: ${key}`);
  }
}

// Starting the app
const watcher = watch(
  SRC_DIR,
  { recursive: true },
  async (event, filename) => {
    console.log(`Detected ${event} in ${filename}`);
    void build({
      clearCache: true
    });
  }
);

// Start web server that returns index.html for root requests and maps files from hashedArtifacts to clients
const server = serve({
  port: 3000,
  async fetch(req) {
    const url = new URL(req.url);

    console.log(`Received request for ${url.pathname}`);

    if (url.pathname === "/") {
      return new Response(Bun.file("./index.html"), {
        headers: {
          "Content-Type": "text/html",
        },
      });
    }
    
    if (url.pathname.startsWith("/src/")) {
      // Serve files from the hashedArtifacts
       // Remove leading /src
      const artifactPath = url.pathname.slice(5); // "/src/" is 5 characters long
      console.log(`Looking for artifact: ${artifactPath}`);
      const artifact = hashedArtifacts.get(artifactPath);
      if (artifact) {
        return new Response(artifact, {
          headers: {
            "Content-Type": "application/javascript",
          },
        });
      } else {
        return new Response("File not found", { status: 404 });
      }
    } else {
      return new Response("Not Found", { status: 404 });
    }
  },
  error(err) {
    console.error("Server error:", err);
    return new Response("Internal Server Error", { status: 500 });
  },
});
console.info(`Listening on ${server.url}`);


// on process exit, close the watcher and server
process.on("SIGINT", () => {
  // close watcher when Ctrl-C is pressed
  console.info("Closing watcher...");
  watcher.close();
  console.info("Watcher closed.");
  console.info("Closing server...");
  server.stop();
  console.info("Server closed.");
  console.info("Exiting process...")
  process.exit(0);
});

await build();