"use client";

import { Button } from "@ui/components/ui/button";
import {
  BedIcon,
  CopyrightIcon,
  FishIcon,
  HeartIcon,
  PlayIcon,
  SandwichIcon,
  SmileIcon,
  TimerIcon,
} from "lucide-react";
import {
  loadMetadata,
  Obelisk,
  TransactionBlock,
  BCS,
  getSuiMoveConfig,
  DevInspectResults,
} from "@0xobelisk/sui-client";
import {
  NETWORK,
  PACKAGE_ID,
  WORLD_ID,
} from "../../../../../packages/tamagochi/src/chain/config";
import { toast } from "sonner";
import { useEffect, useState } from "react";
import { obeliskConfig } from "../../../../../packages/tamagochi/obelisk.config";
import {
  useCurrentAccount,
  useSignAndExecuteTransactionBlock,
} from "@mysten/dapp-kit";
import { type } from "os";

function autoFormatDryValue(result: DevInspectResults): any[] | undefined {
  let returnValue = [];

  // "success" | "failure";
  if (result.effects.status.status === "success") {
    const resultList = result.results![0].returnValues!;
    for (const res of resultList) {
      const bcs = new BCS(getSuiMoveConfig());
      const value = Uint8Array.from(res[0]);
      const bcsType = res[1].replace(/0x1::ascii::String/g, "string");
      const data = bcs.de(bcsType, value);
      returnValue.push(data);
    }
    return returnValue;
  } else {
    return undefined;
  }
}

export default function Page({ params }: { params: { id: string } }) {
  const [hungerValue, setHungerValue] = useState(0);
  const [happyValue, setHappyValue] = useState(0);
  const [tiredValue, setTiredValue] = useState(0);

  const { mutate: signAndExecuteTransactionBlock } =
    useSignAndExecuteTransactionBlock();
  const address = useCurrentAccount()?.address;

  useEffect(() => {
    const previouslyConnected = localStorage.getItem("sui-walletConnected");
    console.log("11111111111");
    if (previouslyConnected === "true") {
      const query_tamagotchi = async () => {
        const metadata = await loadMetadata(NETWORK, PACKAGE_ID);
        const obelisk = new Obelisk({
          networkType: NETWORK,
          packageId: PACKAGE_ID,
          metadata: metadata,
        });
        // const schemaName =  Object.keys(obeliskConfig.schemas)[1]
        // let tamagotchi_vector = await obelisk.getEntity(
        //     WORLD_ID,
        //     schemaName,
        //     address
        // )
        // console.log(tamagotchi_vector)
        const tx = new TransactionBlock();
        const entity_key = await obelisk.entity_key_from_address_with_seed(
          address,
          params.id,
        );
        const calculateParams = [
          tx.pure(WORLD_ID),
          tx.pure(entity_key),
          tx.pure("0x6"),
        ];
        const hunger_value_res =
          await obelisk.query.tamagotchi_system.calculate_new_energy(
            tx,
            calculateParams,
          );
        // console.log(hunger_value_res);
        const hunger_value = autoFormatDryValue(hunger_value_res);
        // setHungerValue
        if (hunger_value != undefined) {
          setHungerValue(hunger_value[0]);
        }

        const happy_value_res =
          await obelisk.query.tamagotchi_system.calculate_new_boredom(
            tx,
            calculateParams,
          );
        const happy_value = autoFormatDryValue(happy_value_res);
        if (happy_value != undefined) {
          setHappyValue(happy_value[0]);
        }

        const tired_value_res =
          await obelisk.query.tamagotchi_system.calculate_new_boredom(
            tx,
            calculateParams,
          );
        const tired_value = autoFormatDryValue(tired_value_res);
        if (tired_value != undefined) {
          setTiredValue(tired_value[0]);
        }
      };
      query_tamagotchi();
    }
  }, [address]);

  const feed = async () => {
    const tamagotchi_name = params.id;
    const metadata = await loadMetadata(NETWORK, PACKAGE_ID);
    const obelisk = new Obelisk({
      networkType: NETWORK,
      packageId: PACKAGE_ID,
      metadata: metadata,
    });
    const tx = new TransactionBlock();
    const claimParams = [
      tx.pure(WORLD_ID),
      tx.pure(tamagotchi_name),
      tx.pure("0x6"),
    ];
    await obelisk.tx.tamagotchi_system.feed(
      tx,
      claimParams, // params
      undefined, // typeArguments
      true,
    );
    signAndExecuteTransactionBlock(
      {
        transactionBlock: tx,
      },
      {
        onSuccess: async (result) => {
          toast("Translation Successful", {
            description: new Date().toUTCString(),
            action: {
              label: "Check in Explorer ",
              onClick: () => {
                const hash = result.digest;
                window.open(
                  `https://explorer.polymedia.app/txblock/${hash}?network=local`,
                  "_blank",
                ); // 在新页面中打开链接
              },
            },
          });
        },
      },
    );
  };

  const play = async () => {
    const tamagotchi_name = params.id;
    const metadata = await loadMetadata(NETWORK, PACKAGE_ID);
    const obelisk = new Obelisk({
      networkType: NETWORK,
      packageId: PACKAGE_ID,
      metadata: metadata,
    });
    const tx = new TransactionBlock();
    const claimParams = [
      tx.pure(WORLD_ID),
      tx.pure(tamagotchi_name),
      tx.pure("0x6"),
    ];
    await obelisk.tx.tamagotchi_system.play(
      tx,
      claimParams, // params
      undefined, // typeArguments
      true,
    );
    signAndExecuteTransactionBlock(
      {
        transactionBlock: tx,
      },
      {
        onSuccess: async (result) => {
          toast("Translation Successful", {
            description: new Date().toUTCString(),
            action: {
              label: "Check in Explorer ",
              onClick: () => {
                const hash = result.digest;
                window.open(
                  `https://explorer.polymedia.app/txblock/${hash}?network=local`,
                  "_blank",
                ); // 在新页面中打开链接
              },
            },
          });
        },
      },
    );
  };

  const sleep = async () => {
    const tamagotchi_name = params.id;
    const metadata = await loadMetadata(NETWORK, PACKAGE_ID);
    const obelisk = new Obelisk({
      networkType: NETWORK,
      packageId: PACKAGE_ID,
      metadata: metadata,
    });
    const tx = new TransactionBlock();
    const claimParams = [
      tx.pure(WORLD_ID),
      tx.pure(tamagotchi_name),
      tx.pure("0x6"),
    ];

    await obelisk.tx.tamagotchi_system.sleep(
      tx,
      claimParams, // params
      undefined, // typeArguments
      true,
    );

    signAndExecuteTransactionBlock(
      {
        transactionBlock: tx,
      },
      {
        onSuccess: async (result) => {
          toast("Translation Successful", {
            description: new Date().toUTCString(),
            action: {
              label: "Check in Explorer ",
              onClick: () => {
                const hash = result.digest;
                window.open(
                  `https://explorer.polymedia.app/txblock/${hash}?network=local`,
                  "_blank",
                ); // 在新页面中打开链接
              },
            },
          });
        },
      },
    );
  };

  return (
    <>
      <div className="bg-black min-h-screen flex flex-col items-center justify-center">
        <div className="flex items-center mb-8">
          {/*<img src="/placeholder.svg" alt="Gear Logo" className="h-8 mr-2" />*/}
          {/*<h1 className="text-white text-2xl font-bold">gear</h1>*/}
          {/*<span className="text-white ml-2">76.6968</span>*/}
          {/*<span className="text-white ml-2">YVRA</span>*/}
          {/*<span className="text-white ml-4">test1</span>*/}
        </div>
        <div className="relative">
          {/*<img src="/placeholder.svg" alt="Bear Icon" className="h-48" />*/}
          {/*<div className="absolute top-0 right-0 bg-red-500 rounded-full h-6 w-6 flex items-center justify-center">*/}
          {/*  <HeartIcon className="text-white h-4 w-4" />*/}
          {/*</div>*/}
        </div>
        <div className="bg-gray-800 rounded-lg p-4 mt-8 flex flex-col items-start">
          <h2 className="text-white font-bold mb-2">Geary</h2>
          <div className="text-gray-400 mb-2">
            <span>Owner ID:</span>
            <span className="ml-2">test1</span>
          </div>
          <div className="text-gray-400 mb-4">
            <span>Age:</span>
            <span className="ml-2">2 days</span>
          </div>
          <div className="flex items-center mb-2">
            <SandwichIcon className="text-gray-400 h-5 w-5 mr-2" />
            <span className="text-gray-400">Hungry:</span>
            <span className="text-white ml-2">{hungerValue}</span>
          </div>
          <div className="flex items-center mb-2">
            <SmileIcon className="text-gray-400 h-5 w-5 mr-2" />
            <span className="text-gray-400">Happy:</span>
            <span className="text-white ml-2">{happyValue}</span>
          </div>
          <div className="flex items-center mb-4">
            <TimerIcon className="text-gray-400 h-5 w-5 mr-2" />
            <span className="text-gray-400">Tired:</span>
            <span className="text-white ml-2">{tiredValue}</span>
          </div>
          <div className="flex space-x-4">
            <Button
              onClick={feed}
              variant="secondary"
              className="bg-green-500 hover:bg-green-600"
            >
              <FishIcon className="h-5 w-5 mr-2" />
              Feed
            </Button>
            <Button
              onClick={play}
              variant="secondary"
              className="bg-blue-500 hover:bg-blue-600"
            >
              <PlayIcon className="h-5 w-5 mr-2" />
              Play
            </Button>
            <Button
              onClick={sleep}
              variant="secondary"
              className="bg-purple-500 hover:bg-purple-600"
            >
              <BedIcon className="h-5 w-5 mr-2" />
              Sleep
            </Button>
          </div>
        </div>
        <div className="flex items-center mt-4 text-gray-400">
          <CopyrightIcon className="h-5 w-5 mr-2" />
          <span>2024 tamagotchi, Inc. All Rights Reserved.</span>
          <Button variant="link" className="ml-4">
            VIEW IN BLOCKCHAIN EXPLORER
          </Button>
        </div>
      </div>
    </>
  );
}
