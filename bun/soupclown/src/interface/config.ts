import z, { config } from "zod";

const DEFAULT_CONFIG_PATH = "../../config.soupclown.json";

const hostConfigSchema = z.object({
  services: z.array(z.object({
    name: z.string(),
    desiredState: z.enum(['up', 'down']),
  })),
})

const CONFIG_SCHEMA = z.object({
  v: z.literal('v1'),
  data: z.union([
    hostConfigSchema,
  ]),
});
export type CONFIG_SCHEMA_T = z.infer<typeof CONFIG_SCHEMA>

export class SC_CONFIG_C {
  constructor(
    protected runningConfig = {
      v: 'v1',
      data: {
        services: [
          {name: 'test', desiredState: 'down'}
        ]
      },
    } as CONFIG_SCHEMA_T
  ){}

  public static async loadConfigFile(path = DEFAULT_CONFIG_PATH){
    const configFile = Bun.file(path);
    let fileJsonData: any = null;
    
    try{
      fileJsonData = await configFile.json();
    }catch(e){
      console.error('failed to parse json IG')
      throw "FAILED_SCHEMA_JSON_PARSE"
    }

    const configParseJsonResult = CONFIG_SCHEMA.safeParse(fileJsonData);
    if(!configParseJsonResult.success){
      console.error("Loaded config file but parsing failed")
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
    this.runningConfig = await SC_CONFIG_C.loadConfigFile(path);
  }

  private async _writeConfigFile(path = DEFAULT_CONFIG_PATH){
    await Bun.write(path, JSON.stringify(this.runningConfig));
  }
}

export const SC_CONFIG = await SC_CONFIG_C.init();