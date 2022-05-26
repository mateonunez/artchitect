import { Head } from 'components/common';
import { AuthProvider } from 'lib/contexts/auth';
import type { AppProps } from 'next/app';
import React from 'react';
import 'styles/global.css';

export default function App({ Component, pageProps }: AppProps) {
  return (
    <>
      <React.StrictMode>
        <AuthProvider>
          <Head />

          <Component {...pageProps} />
        </AuthProvider>
      </React.StrictMode>
    </>
  );
}
