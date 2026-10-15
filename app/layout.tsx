import type { Metadata } from "next";
import { Bricolage_Grotesque, Geist, Geist_Mono } from "next/font/google";
import "./globals.css";
import AppProvider from "@/context/app-context/provider";
import { isAuthenticated } from "@/features/profiles";

const bricolageGrotesque = Bricolage_Grotesque({
  variable: "--font-bricolage",
  subsets: ["latin"],
});

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "APPCITA — Chat en tiempo real",
  description: "Sala de chat en tiempo real con perfiles y avatares.",
};

export default async function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const isAuthData = await isAuthenticated();

  return (
    <html
      lang="es"
      className={`${bricolageGrotesque.variable} ${geistSans.variable} ${geistMono.variable} h-full antialiased`}
    >
      <body>
        <AppProvider isAuth={!isAuthData}>{children}</AppProvider>
      </body>
    </html>
  );
}
