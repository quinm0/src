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


async function _loadConfig(path = DEFAULT_CONFIG_PATH){
  const configFile = Bun.file(path);
  let fileJsonData: any = null;
  
  try{
    fileJsonData = await configFile.json();
  }catch(e){
    console.error('failed to parse json IG')
  }

  const configParseJsonResult = CONFIG_SCHEMA.safeParse(fileJsonData);

  if(!configParseJsonResult.success){
    throw "Fuck";
  }

  return configParseJsonResult.data as CONFIG_SCHEMA_T;

}

export const SC_CONFIG = _loadConfig();