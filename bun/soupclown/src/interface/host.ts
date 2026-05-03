import { $ } from "bun";

async function getHostname(){
  const result = await $`hostname`.quiet().text();
  return result.trim();
}

export const HOST = {
  getHostname,
}