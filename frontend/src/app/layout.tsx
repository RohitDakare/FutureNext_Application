import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Future Next | Career Guidance",
  description: "A premium career guidance app for students.",
};

import LayoutClient from "@/components/LayoutClient";

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800;900&family=Sora:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
      </head>
      <body>
        <LayoutClient>{children}</LayoutClient>
      </body>
    </html>
  );
}
