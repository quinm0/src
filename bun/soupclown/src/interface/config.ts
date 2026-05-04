import z from "zod";
import { HOST } from "./host";

const DEFAULT_CONFIG_PATH = "../../state.soupclown.json";

const hostConfigSchema = z.object({
  configurationPath: z.string(),
  services: z.array(z.object({
    name: z.string(),
    desiredState: z.enum(['up', 'down']),
  })),
})
export type HOST_CONFIG_SCHEMA_T = z.infer<typeof hostConfigSchema>;

const CONFIG_SCHEMA = z.object({
  v: z.literal('v1'),
  data: z.map(z.string(), hostConfigSchema)
});
export type CONFIG_SCHEMA_T = z.infer<typeof CONFIG_SCHEMA>

export class SC_CONFIG_C  {


  constructor(
    protected runningConfig = {
      v: 'v1',
      data: new Map([
      ]),
    } as CONFIG_SCHEMA_T,
  ){}

  public static async loadConfigFile(path = DEFAULT_CONFIG_PATH){
    const configFile = Bun.file(path);
    let fileJsonData: any = null;
    
    try{
      fileJsonData = await configFile.json();
    }catch(e){
      throw "FAILED_SCHEMA_JSON_PARSE"
    }

    const configParseJsonResult = CONFIG_SCHEMA.safeParse(fileJsonData);
    if(!configParseJsonResult.success){
      throw "FAILED_CONFIG_SCHEMA_PARSE"
    }

    return configParseJsonResult.data;
  }

  public static async init(path = DEFAULT_CONFIG_PATH){
    const newConfig = new SC_CONFIG_C();
    await newConfig._loadConfigFile(path);
    await newConfig._writeConfigFile(path);
    return newConfig;
  }

  private async _loadConfigFile(path = DEFAULT_CONFIG_PATH){
    try{
      this.runningConfig = await SC_CONFIG_C.loadConfigFile(path);
      const hostconfig = this.runningConfig.data.get(await HOST.getHostname());
      if(hostconfig){
        this.configurationPath = hostconfig.configurationPath;
        this.services = hostconfig.services;
      }
    }catch{
      console.error('Failed to load config, assuming you know what you\'re doing');
    }
  }

  private async _writeConfigFile(path = DEFAULT_CONFIG_PATH){
    await Bun.write(path, JSON.stringify(this.runningConfig, null, 2));
  }
}

export const SC_CONFIG = await SC_CONFIG_C.init();