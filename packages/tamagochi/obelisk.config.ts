import { ObeliskConfig } from '@0xobelisk/sui-common';

export const obeliskConfig = {
  name: 'tamagotchi',
  description: 'tamagotchi',
  systems: ['tamagotchi_system','tamagotchi_manager_system'],
  schemas: {
    tamagotchi: {
      valueType: {
        name: "string",
        date_of_birth: "u64",
        fed: "u64",
        fed_block: "u64",
        entertained: "u64",
        entertained_block: "u64",
        rested: "u64",
        rested_block: "u64"
      }
    },
    tamagotchi_manager:{
      valueType:"vector<address>"
    }
  },
} as ObeliskConfig;
