import NextHead from 'next/head';

import seo from 'core/config/seo.json';
import { DefaultSeo } from 'next-seo';

export default function Head() {
  return (
    <>
      <DefaultSeo {...seo} />

      <NextHead>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="theme-color" content="#F59E0B" /> {/* My fav color */}
        <meta name="author" content="@mateonunez" />
      </NextHead>
    </>
  );
}
