import {
    ConnectButton, useAutoConnectWallet, useConnectWallet, useCurrentWallet, useWallets,
    // useCurrentAccount,
    // useCurrentWallet,
    // useSignAndExecuteTransactionBlock,
} from "@mysten/dapp-kit";
import React, { useEffect } from "react";


function FlagIcon(props) {
  return (
      <svg
          {...props}
          xmlns="http://www.w3.org/2000/svg"
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
      >
        <path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z" />
        <line x1="4" x2="4" y1="22" y2="15" />
      </svg>
  )
}

export const Header = () => {
    const wallets = useWallets();
    const { mutate: connect } = useConnectWallet();
    const { connectionStatus }  = useCurrentWallet()


    useEffect(() => {
        // Check local storage for a previously connected wallet
        const previouslyConnected = localStorage.getItem('sui-walletConnected');
        if (connectionStatus !== 'connected' && previouslyConnected === 'true') {
            // Ensure that `wallets` is an array and we select the first wallet (or any appropriate wallet)
            if (wallets.length > 0) {
                const wallet = wallets[0]; // Select the first wallet from the array
                connect({ wallet },{
                    onSuccess: () => console.log('connected'),
                },)
            }
        }
    }, [connectionStatus, wallets]);

    useEffect(() => {
        // Update local storage based on connection status
        if (connectionStatus === 'connected') {
            localStorage.setItem('sui-walletConnected', 'true');
        } else {
            localStorage.removeItem('sui-walletConnected');
        }
    }, [connectionStatus]);

  return (
      <header className="absolute top-0 left-0 right-0 flex items-center justify-between p-4">
        <div className="flex items-center space-x-2">
          <FlagIcon className="h-8 w-8" />
          <span className="text-xl font-bold">tamagochi</span>
        </div>
        <div className="flex items-center space-x-4">
          <div className="flex items-center space-x-1">
            <ConnectButton />
          </div>
        </div>
      </header>
  );
};
