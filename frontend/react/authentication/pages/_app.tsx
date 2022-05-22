import { Head } from 'components/common';
import { AuthContext } from 'lib/contexts';
import { useProvider } from 'lib/hooks/auth';
import type { AppProps } from 'next/app';
import React from 'react';
import 'styles/global.css';

export default function App({ Component, pageProps }: AppProps) {
  const authProvider = useProvider() as any;

  return (
    <>
      <React.StrictMode>
        <AuthContext.Provider value={authProvider}>
          <Head />

          <Component {...pageProps} />
        </AuthContext.Provider>
      </React.StrictMode>
    </>
  );
}
