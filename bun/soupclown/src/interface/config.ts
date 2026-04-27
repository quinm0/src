import z, { config } from "zod";

const DEFAULT_CONFIG_PATH = "../../config.soupclown.json";

const hostConfigSchema = z.object({
  services: z.map(z.string(), z.unknown()),
})

const CONFIG_SCHEMA = z.object({
  v: z.literal('v1'),
  config: z.union([
    hostConfigSchema,
  ]),
});
export type CONFIG_SCHEMA_T = z.infer<typeof CONFIG_SCHEMA>
const NEW_CONFIG: CONFIG_SCHEMA_T = {
  v: 'v1',
  config: {
    services: new Map()
  }
};

async function _initConfigFile(path: string){
  await Bun.write(path, JSON.stringify(NEW_CONFIG));
}

async function _loadConfig(path = DEFAULT_CONFIG_PATH){
  const configFile = Bun.file(path);
  let fileJsonData: any = null;
  
  try{
    fileJsonData = await configFile.json();
    console.log('json data', fileJsonData)
  }catch(e){
    console.error('failed to parse json IG')
    throw "failed"
  }

  const configParseJsonResult = CONFIG_SCHEMA.safeParse(fileJsonData);

  if(!configParseJsonResult.success){
    console.error('parsing error, overwrting config :3', configParseJsonResult.error)
    await _initConfigFile(path);
    return NEW_CONFIG;
  }

  return configParseJsonResult.data as CONFIG_SCHEMA_T;

}

async function methodWrapper(config: CONFIG_SCHEMA_T){
  const newConfig: CONFIG_SCHEMA_T & {

  } = config;
  
}

export const SC_CONFIG = await _loadConfig();