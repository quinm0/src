import { $ } from "bun";
import { SC_CONFIG } from "./config";

async function getHostname(){
  const result = await $`hostname`.quiet().text();
  return result.trim();
}

async function initSystem(){
  await $`mkdir -p ${SC_CONFIG.config.configurationPath}`
}

export const HOST = {
  getHostname,
  initSystem,
}