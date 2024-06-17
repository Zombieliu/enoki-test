"use client";

import {Button} from "@ui/components/ui/button";
import { useEnokiFlow } from '@mysten/enoki/react';
import { useAuthCallback } from "@mysten/enoki/react";
import { useEffect } from "react";

export default function Page() {
  const enokiFlow = useEnokiFlow();
  const { handled } = useAuthCallback();
  const test = async () =>{
    const protocol = window.location.protocol;
    const host = window.location.host;
    console.log(protocol,host)
    // Set the redirect URL to the location that should
    // handle authorization callbacks in your app
    const redirectUrl = `${protocol}//${host}`;

    enokiFlow
      .createAuthorizationURL({
        provider: 'google',
        network: 'devnet',
        clientId: process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID!,
        redirectUrl,
        extraParams: {
          scope: ['openid', 'email', 'profile'],
        },
      })
      .then((url) => {
        window.location.href = url;
      })
      .catch((error) => {
        console.error(error);
      });
  }

  const signer = async () => {
    const signer = await enokiFlow.getKeypair();
    console.log(signer)
  }

  useEffect(() => {
    if (handled) {
      // Get access token, perform security checks,
      // manage user session, handle errors, and so on.
      console.log("1")
      window.location.href = "/";
    }
  }, [handled]);

  console.log()
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-black text-white">
      <main className="flex flex-col items-center space-y-8">
        {/*<img src="/placeholder.svg" alt="Character illustration" className="w-72 h-72" />*/}
        <p className="text-center text-lg">Insert Tamagotchi Name to claim</p>
        <div className="flex flex-col items-center space-y-4">
          <Button onClick={test} className="bg-blue-600 hover:bg-blue-700 text-white">Claim Tamagochi</Button>
          <Button onClick={signer} className="bg-blue-600 hover:bg-blue-700 text-white">Claim Tamagochi</Button>
        </div>
      </main>
      <footer className="absolute bottom-0 left-0 right-0 flex items-center justify-between p-4">
        <div className="flex items-center space-x-4">
        </div>
        <div className="text-sm">© 2024 Tamagochi, Inc. All Rights Reserved.</div>
      </footer>
    </div>
  );
}
