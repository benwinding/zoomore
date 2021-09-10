import "tailwindcss/tailwind.css";
import "../global.css";
import Head from "next/head";

function MyApp({ Component, pageProps }) {
  return <>
    <Head>
      <title>Zoomore - Turn photos into videos!</title>
      <link rel="shortcut icon" href="/icons/favicon.ico" sizes="32x32"/>
      <link rel="apple-touch-icon" sizes="152x152" href="/icons/apple-touch-icon-152x152.png"/>
      <link rel="apple-touch-icon" sizes="120x120" href="/icons/apple-touch-icon-120x120.png"/>
      <link rel="apple-touch-icon" sizes="76x76" href="/icons/apple-touch-icon-76x76.png"/>
      <link rel="apple-touch-icon" href="/icons/apple-touch-icon-60x60.png"/> 
    </Head>
    <Component {...pageProps} />
  </>;
}

export default MyApp;
