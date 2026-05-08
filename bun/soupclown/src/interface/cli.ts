import { Command } from "commander";
import { HOST } from "./host";
import { SC_CONFIG } from "./config";

export function RUN_CLI(){
  const c = new Command();

  c
    .name('soupclown')
    .description('Soupclown system')

  c
    .command('host <action>')
    .action(async (action, opts) => {
      console.log(opts)
      switch(action){
        case 'init':
          await HOST.initSystem()
          await SC_CONFIG.save()
          console.log('done!')
          break;

        default:
          console.log('fool!')
          break;
      }
    })

  c.parse();
}