import { $ } from "bun";
import z, { parse } from "zod";

const CLI_ContainerInfoSchema = z.object({
    ID: z.string(),
    Image: z.string(),
    CreatedAt: z.string(),
    State: z.string(),
    Names: z.string(),
})
type CLI_ContainerInfo = z.infer<typeof CLI_ContainerInfoSchema>;

const  SC_ContainerInfo = z.object({
    id: z.string(),
    name: z.string(),
    image: z.string(),
    state: z.unknown(),
    created: z.date(),
})
type SC_ContainerInfoT = typeof SC_ContainerInfo;

async function PS (){
    const result = $`docker ps -a --format json`
    const containerData: CLI_ContainerInfo[] = [];

    for await (let line of result.lines()){
        // containerData.push(JSON.parse(line));
        if(line.length < "{}".length){
            continue;
        }
        const parsedData = CLI_ContainerInfoSchema.parse(JSON.parse(line))
        containerData.push(parsedData);
    }
    return containerData;
}

export const DockerSC = {
    PS,
}