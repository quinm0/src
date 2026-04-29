import { Command, program } from "commander";
import { SC_CONFIG } from "./src/interface/config";

const c = new Command();

export function RUN_CLI(){
  c
  .name('soupclown')
  .description('Soupclown system')
  .option('--showConfig', 'display the configured config')
  .parse();

  const options = c.opts();

  if(options.showConfig){
    console.log(JSON.stringify(SC_CONFIG, null, 2))
    return;
  }
}

RUN_CLI();
