"use client";

import "@repo/ui/globals.css";
import { Inter } from "next/font/google";
import "@mysten/dapp-kit/dist/index.css";
import {
  createNetworkConfig,
} from "@mysten/dapp-kit";
import { getFullnodeUrl } from "@mysten/sui.js/client";
import { EnokiFlowProvider } from "@mysten/enoki/react";
const inter = Inter({ subsets: ["latin"] });

const { networkConfig } = createNetworkConfig({
  localnet: { url: getFullnodeUrl("localnet") },
  devnet: { url: getFullnodeUrl("devnet") },
  testnet: { url: getFullnodeUrl("testnet") },
  mainnet: { url: getFullnodeUrl("mainnet") },
});


export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}): JSX.Element {

  return (
    <html lang="en">
      <body className={inter.className}>
      <EnokiFlowProvider apiKey="enoki_public_c96f9ec5cf8c4dfd0a210ae0e605c8dd">
        {children}
      </EnokiFlowProvider>
      </body>
    </html>
  );
}
