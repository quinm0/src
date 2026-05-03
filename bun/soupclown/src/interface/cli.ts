import { Command } from "commander";
import { HOST } from "./host";

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
          console.log('init action!')
          console.log(`HOSTNAME: ${await HOST.getHostname()}`)
          break;

        default:
          console.log('fool!')
          break;
      }
    })

  c.parse();
}