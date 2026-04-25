import { DockerSC } from "./src/interface/docker";

console.log("Hello via Bun!");

const containers = await DockerSC.PS();
containers.forEach(container => {
    console.log(`Name: ${container.Names}`)
});