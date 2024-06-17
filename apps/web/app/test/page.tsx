'use client'


import {registerStashedWallet} from '@mysten/zksend';
import { STASHED_WALLET_NAME } from '@mysten/zksend';
export default function Page() {

let stashed = registerStashedWallet('tamagotchi',{origin:"https://getstashed.com"});
    console.log(stashed.wallet)

    // console.log(STASHED_WALLET_NAME)
  return (
      <div>
        1
      </div>
  )
}
