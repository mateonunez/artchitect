import { Head } from 'components/common';
import type { AppProps } from 'next/app';
import React from 'react';
import 'styles/global.css';

export default function App({ Component, pageProps }: AppProps) {
  return (
    <>
      <React.StrictMode>
        <Head />

        <Component {...pageProps} />
      </React.StrictMode>
    </>
  );
}
