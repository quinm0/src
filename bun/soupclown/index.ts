import { DockerSC } from "./src/interface/docker";

const containers = await DockerSC.PS();
containers.forEach(container => {
    console.log(`Name: ${container.Names}`)
});