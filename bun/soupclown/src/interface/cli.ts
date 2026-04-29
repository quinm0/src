import { Command, program } from "commander";
import { SC_CONFIG } from "./config";

export function RUN_CLI(){
  const c = new Command();

  c
    .name('soupclown')
    .description('Soupclown system')

  c
    .command('host <action>')
    .action((action, opts) => {
      console.log(opts)
      switch(action){

        case 'init':
          console.log('init action!')
          break;

        default:
          console.log('fool!')
          break;
      }
    })

  c.parse();
}